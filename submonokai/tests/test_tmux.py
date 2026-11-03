"""Exercise the theme and reloads in disposable tmux servers."""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


class TmuxThemeTests(unittest.TestCase):
    def setUp(self):
        self.assertIsNotNone(shutil.which("tmux"), "tmux 3.8+ is required")
        self.temp = tempfile.TemporaryDirectory(prefix="tmux-theme-", dir="/tmp")
        self.addCleanup(self.temp.cleanup)
        self.socket = str(Path(self.temp.name) / "socket")
        self.env = dict(os.environ, HOME=self.temp.name)
        self.env.pop("TMUX", None)
        self.addCleanup(self.stop_server)
        self.tmux("-f", "/dev/null", "new-session", "-d", "-s", "test", "/bin/sh")

    def tmux(self, *args):
        result = subprocess.run(
            ["tmux", "-S", self.socket, *args], env=self.env, check=True,
            capture_output=True, text=True, timeout=10,
        )
        self.assertEqual(result.stderr, "")
        return result.stdout.strip()

    def stop_server(self):
        subprocess.run(
            ["tmux", "-S", self.socket, "kill-server"], env=self.env,
            capture_output=True, timeout=10,
        )

    def source_theme(self):
        self.tmux("source-file", str(ROOT / "SubMonokai.tmux.conf"))

    def test_focus_and_reload_use_current_backgrounds(self):
        self.source_theme()
        hooks = self.tmux("show-hooks", "-g")
        self.tmux("set-hook", "-R", "client-focus-out")
        self.tmux("set", "-g", "window-style", "bg=#101010")
        self.assertEqual(
            self.tmux("display-message", "-p", "#{E:window-active-style}"),
            "bg=#101010",
        )
        self.source_theme()
        self.assertEqual(
            self.tmux("display-message", "-p", "#{E:window-active-style}"),
            "bg=#1D1E19",
        )
        self.tmux("set-hook", "-R", "client-focus-in")
        self.assertEqual(
            self.tmux("display-message", "-p", "#{E:window-active-style}"),
            "bg=#272822",
        )
        self.assertEqual(self.tmux("show-hooks", "-g"), hooks)

    def test_native_palette_resolves_to_exact_rgb_values(self):
        self.assertTrue(self.tmux("show-options", "-sqv", "theme"), "tmux 3.8+ is required")
        expected = {
            "black": "#1D1E19", "white": "#F8F8F2",
            "dark-grey": "#272822", "light-grey": "#75715E",
            "red": "#ED3A2C", "green": "#B3E435", "yellow": "#FF9800",
            "blue": "#0097F3", "magenta": "#FB2B71", "cyan": "#00DFF3",
        }
        for marked in (False, True):
            if marked:
                self.tmux("select-pane", "-m")
            self.source_theme()
            for slot, rgb in expected.items():
                with self.subTest(slot=slot, marked=marked):
                    self.assertEqual(
                        self.tmux("display-message", "-p", "#{E:dark-theme-" + slot + "}"),
                        rgb,
                    )


if __name__ == "__main__":
    unittest.main()
