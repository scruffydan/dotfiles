"""Compare emitted tmux UI colours using isolated attached clients and real PTYs."""

import fcntl
import os
from pathlib import Path
import pty
import select
import struct
import subprocess
import tempfile
import termios
import time
import unittest


ROOT = Path(__file__).resolve().parents[1]
PALETTE = {}
for line in (ROOT / "SubMonokai.ghostty").read_text().splitlines():
    if line.startswith("palette = "):
        index, value = line.removeprefix("palette = ").split("=", 1)
        PALETTE[int(index)] = value.upper()


def indexed_colour(index):
    if index < 16:
        return PALETTE[index]
    if index < 232:
        index -= 16
        levels = (0, 95, 135, 175, 215, 255)
        return "#%02X%02X%02X" % (
            levels[index // 36], levels[index // 6 % 6], levels[index % 6],
        )
    level = 8 + (index - 232) * 10
    return "#%02X%02X%02X" % (level, level, level)


class ColourStream:
    """Read SGR state at emitted glyphs; cursor layout is irrelevant to markers."""

    def __init__(self):
        self.fg, self.bg, self.reverse = "#F8F8F2", "#272822", False
        self.saved = None
        self.records = []

    def sgr(self, parameters):
        values = [int(value or 0) for value in parameters.replace(":", ";").split(";")]
        index = 0
        while index < len(values):
            value = values[index]
            if value == 0:
                self.fg, self.bg, self.reverse = "#F8F8F2", "#272822", False
            elif value == 7:
                self.reverse = True
            elif value == 27:
                self.reverse = False
            elif value == 39:
                self.fg = "#F8F8F2"
            elif value == 49:
                self.bg = "#272822"
            elif 30 <= value <= 37:
                self.fg = indexed_colour(value - 30)
            elif 40 <= value <= 47:
                self.bg = indexed_colour(value - 40)
            elif 90 <= value <= 97:
                self.fg = indexed_colour(value - 90 + 8)
            elif 100 <= value <= 107:
                self.bg = indexed_colour(value - 100 + 8)
            elif value in (38, 48):
                mode = values[index + 1]
                if mode == 5:
                    colour = indexed_colour(values[index + 2])
                    index += 2
                elif mode == 2:
                    colour = "#%02X%02X%02X" % tuple(values[index + 2:index + 5])
                    index += 4
                else:
                    raise AssertionError(("unknown colour mode", values))
                if value == 38:
                    self.fg = colour
                else:
                    self.bg = colour
            index += 1

    def feed(self, raw):
        text = raw.decode("utf-8", errors="replace")
        index = 0
        while index < len(text):
            char = text[index]
            if char != "\x1b":
                if char.isprintable():
                    fg, bg = (self.bg, self.fg) if self.reverse else (self.fg, self.bg)
                    self.records.append((char, fg, bg))
                index += 1
                continue
            assert index + 1 < len(text), "truncated escape"
            kind = text[index + 1]
            if kind == "[":
                end = index + 2
                while end < len(text) and not "@" <= text[end] <= "~":
                    end += 1
                assert end < len(text), "truncated CSI"
                if text[end] == "m":
                    self.sgr(text[index + 2:end])
                index = end + 1
            elif kind in "]P_^":
                ends = [position for position in (text.find("\x07", index + 2), text.find("\x1b\\", index + 2)) if position >= 0]
                assert ends, "truncated control string"
                end = min(ends)
                index = end + (1 if text[end] == "\x07" else 2)
            elif kind in "()*+":
                index += 3
            else:
                if kind == "7":
                    self.saved = self.fg, self.bg, self.reverse
                elif kind == "8" and self.saved:
                    self.fg, self.bg, self.reverse = self.saved
                index += 2

    def marker(self, marker, first=False):
        text = "".join(record[0] for record in self.records)
        start = text.find(marker) if first else text.rfind(marker)
        assert start >= 0, ("marker missing", marker, text[-500:])
        colours = {record[1:] for record in self.records[start:start + len(marker)]}
        assert len(colours) == 1, (marker, colours)
        fg, bg = colours.pop()
        return {"fg": fg, "bg": bg}


def capture(theme_text, directory):
    directory.mkdir()
    theme = directory / "theme.conf"
    theme.write_text(theme_text)
    config = directory / "tmux.conf"
    config.write_text(
        "set -sq theme terminal\n"
        f"source-file {theme}\n"
        "set -g default-shell /bin/sh\n"
        "set -g status-position top\n"
        "set -g status-left 'KEEPSTATUS '\n"
        "set -g status-left-length 20\n"
        "set -g status-right ''\n"
        "set -g status-interval 0\n"
        "set -g focus-events on\n"
        "set -s terminal-overrides[100] 'xterm-256color:RGB'\n"
    )
    base = ["tmux", "-S", str(directory / "socket")]
    env = dict(os.environ, HOME=str(directory), TERM="xterm-256color")
    env.pop("TMUX", None)
    def run(*args):
        result = subprocess.run(base + list(args), env=env, capture_output=True, text=True, check=True, timeout=10)
        assert not result.stderr, result.stderr
        return result.stdout.strip()

    client_pid, master = None, None
    pending = []
    stream = ColourStream()
    def drain():
        chunks = []
        deadline = time.monotonic() + 3
        quiet = 0.35
        while time.monotonic() < deadline:
            ready, _, _ = select.select([master], [], [], quiet)
            if not ready:
                break
            chunks.append(os.read(master, 65536))
        raw = b"".join(chunks)
        stream.feed(raw)
        return raw

    try:
        command = "printf 'KEEPACTIVE\\n\\033[38;2;237;58;44m\\033[48;2;0;151;243mKEEPAPP\\033[0m\\n'; exec /bin/sleep 3600"
        first = run("-f", str(config), "new-session", "-d", "-P", "-F", "#{pane_id}", "-s", "colours", "-n", "KEEPTAB", "/bin/sh", "-c", command)
        run("split-window", "-h", "/bin/sh", "-c", "printf 'KEEPINACTIVE\\n'; exec /bin/sleep 3600")
        run("new-window", "-d", "-n", "KEEPOFF", "/bin/sleep", "3600")
        run("select-pane", "-t", first)
        client_pid, master = pty.fork()
        if client_pid == 0:
            os.execvpe("tmux", base + ["-u", "-T", "RGB,256", "attach-session", "-t", "colours"], env)
        fcntl.ioctl(master, termios.TIOCSWINSZ, struct.pack("HHHH", 24, 100, 0, 0))
        drain()

        def snapshot():
            stream.records.clear()
            run("refresh-client")
            drain()
            colours = {name: stream.marker(marker) for name, marker in {
                "status": "KEEPSTATUS", "active_tab": "KEEPTAB",
                "inactive_tab": "KEEPOFF", "active_pane": "KEEPACTIVE",
                "inactive_pane": "KEEPINACTIVE", "application_rgb": "KEEPAPP",
            }.items()}
            colours["active_border"] = stream.marker("│", first=True)
            return colours

        result = {"initial": snapshot()}
        for _ in range(3):
            run("source-file", str(theme))
            assert snapshot() == result["initial"]
        run("set-hook", "-R", "client-focus-out")
        result["unfocused"] = snapshot()["active_pane"]
        run("source-file", str(theme))
        assert snapshot()["active_pane"] == result["unfocused"]
        run("set-hook", "-R", "client-focus-in")
        assert snapshot() == result["initial"]

        run("copy-mode", "-t", first)
        run("send-keys", "-t", first, "-X", "history-top")
        run("send-keys", "-t", first, "-X", "start-of-line")
        run("send-keys", "-t", first, "-X", "begin-selection")
        run("send-keys", "-t", first, "-X", "cursor-down")
        stream.records.clear()
        run("refresh-client")
        drain()
        result["copy_selection"] = stream.marker("KEEPACTIVE")
        run("send-keys", "-t", first, "-X", "cancel")
        drain()

        stream.records.clear()
        menu = subprocess.Popen(base + ["display-menu", "-C", "0", "-x", "2", "-y", "3", "KEEPSELECT", "a", "", "KEEPMENU", "b", ""], env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        pending.append(menu)
        drain()
        result["menu_border"] = stream.marker("┌")
        result["menu_selected"] = stream.marker("KEEPSELECT")
        result["menu"] = stream.marker("KEEPMENU")
        os.write(master, b"\x1b")
        drain()
        stream.records.clear()
        popup = subprocess.Popen(base + ["display-popup", "-b", "single", "-E", "-w", "40", "-h", "8", "-x", "2", "-y", "3", "/bin/sh", "-c", "printf KEEPOPUP; exec /bin/sleep 3600"], env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        pending.append(popup)
        drain()
        result["popup"] = stream.marker("KEEPOPUP")
        result["popup_border"] = stream.marker("┌")
        run("display-popup", "-C")
        drain()
        return result
    finally:
        subprocess.run(base + ["kill-server"], env=env, capture_output=True, timeout=10)
        for process in pending:
            process.communicate(timeout=10)
        if master is not None:
            os.close(master)
        if client_pid:
            os.waitpid(client_pid, 0)


class RenderedColourTests(unittest.TestCase):
    def test_original_colours_survive_native_theme_and_reloads(self):
        with tempfile.TemporaryDirectory(prefix="tmux-render-", dir="/tmp") as directory:
            result = capture((ROOT / "SubMonokai.tmux.conf").read_text(), Path(directory) / "native")
        def colour(fg, bg):
            return {"fg": fg, "bg": bg}
        self.assertEqual(result["initial"], {
            "status": colour("#E6DC6D", "#49483E"),
            "active_tab": colour("#1D1E19", "#FF9800"),
            "inactive_tab": colour("#E6DC6D", "#49483E"),
            "active_pane": colour("#F8F8F2", "#272822"),
            "inactive_pane": colour("#F8F8F2", "#1D1E19"),
            "application_rgb": colour("#ED3A2C", "#0097F3"),
            "active_border": colour("#E6DC6D", "#272822"),
        })
        self.assertEqual(result["unfocused"], colour("#F8F8F2", "#1D1E19"))
        for role in ("menu_selected", "copy_selection"):
            self.assertEqual(result[role], colour("#1D1E19", "#FF9800"), role)
        for role in ("menu", "menu_border", "popup", "popup_border"):
            self.assertEqual(result[role], colour("#F8F8F2", "#1D1E19"), role)


if __name__ == "__main__":
    unittest.main()
