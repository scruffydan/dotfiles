"""Exercise the theme and reloads in disposable tmux servers."""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless(shutil.which("tmux"), "tmux is not installed")
class TmuxThemeTests(unittest.TestCase):
    def setUp(self):
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

    def test_native_defaults_replace_previous_overrides(self):
        if not self.tmux("show-options", "-sqv", "theme"):
            self.skipTest("native theme palette requires tmux 3.8+")
        options = (
            "popup-style", "popup-border-style", "menu-style",
            "menu-border-style", "tree-mode-border-style",
            "tree-mode-preview-style", "copy-mode-mark-style",
            "display-panes-border-style", "pane-border-style",
            "pane-active-border-style", "window-status-current-style",
        )
        defaults = {name: self.tmux("show-options", "-gv", name) for name in options}
        self.tmux("set", "-s", "theme", "terminal")
        for name in options:
            self.tmux("set", "-g", name, "fg=#123456,bg=#654321")
        self.source_theme()
        self.assertEqual(self.tmux("show-options", "-sv", "theme"), "dark")
        self.assertEqual(self.tmux("show-options", "-sv", "dark-theme-green"), "#B3E435")
        self.assertEqual(self.tmux("show-options", "-sv", "dark-theme-yellow"), "#FF9800")
        for name, expected in defaults.items():
            with self.subTest(option=name):
                self.assertEqual(self.tmux("show-options", "-gv", name), expected)
        self.source_theme()
        self.assertEqual(self.tmux("show-options", "-sv", "theme"), "dark")

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


if __name__ == "__main__":
    unittest.main()
