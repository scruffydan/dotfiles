"""Exercise cask cleanup in isolated zsh without invoking real Homebrew."""

from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
ZSH = shutil.which("zsh")


@unittest.skipUnless(ZSH, "zsh is required")
class BrewCleanupCasksTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="brew cleanup ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.bin = self.root / "mock bin"
        self.bin.mkdir()
        self.home = self.root / "home"
        self.home.mkdir()
        self.fixtures = self.root / "fixtures"
        self.fixtures.mkdir()
        self.calls = self.root / "calls"
        self.prompts = self.root / "prompts"
        brew = self.bin / "brew"
        brew.write_text("""#!/bin/sh
printf '%s\\n' "$*" >> "$TEST_CALLS"
case "$*" in
  'list --cask --versions') fixture="$TEST_FIXTURES/versions" ;;
  'list --cask '*) fixture="$TEST_FIXTURES/$3" ;;
  'uninstall --cask --force '*) exit 0 ;;
  *) exit 1 ;;
esac
while IFS= read -r entry; do
  printf '%s\\n' "$entry"
done < "$fixture"
""")
        brew.chmod(0o755)

    def cleanup_casks(self, casks, confirm=True):
        (self.fixtures / "versions").write_text(
            "".join(f"{cask} 1.0\n" for cask in casks)
        )
        for cask, files in casks.items():
            (self.fixtures / cask).write_text("".join(f"{file}\n" for file in files))
        result = subprocess.run(
            [ZSH, "-df", "-c", """
source "$1"
read() {
  if [[ "$1" == -q ]]; then
    print -r -- "$*" >> "$TEST_PROMPTS"
    return "$TEST_REPLY"
  fi
  builtin read "$@"
}
caller_path="$PATH"
caller_paths=("${path[@]}")
brew-cleanup-casks
cleanup_result=$?
[[ "$PATH" == "$caller_path" && "${path[*]}" == "${caller_paths[*]}" ]] || {
  print -u2 -- 'caller PATH/path changed'
  exit 1
}
[[ "$(command -v brew)" == "$TEST_BIN/brew" ]] || exit 1
exit "$cleanup_result"
""", "test", str(ROOT / "zsh/aliases")],
            cwd=self.root,
            env={
                "HOME": str(self.home),
                "ZDOTDIR": str(self.root),
                "PATH": str(self.bin),
                "TEST_BIN": str(self.bin),
                "TEST_CALLS": str(self.calls),
                "TEST_PROMPTS": str(self.prompts),
                "TEST_FIXTURES": str(self.fixtures),
                "TEST_REPLY": "0" if confirm else "1",
            },
            text=True, capture_output=True, timeout=10,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, "")
        calls = self.calls.read_text().splitlines() if self.calls.exists() else []
        self.assertEqual(calls[:1], ["list --cask --versions"])
        return result.stdout, calls

    def test_no_installed_casks(self):
        output, calls = self.cleanup_casks({})
        self.assertEqual(output, "No orphaned casks.\n")
        self.assertEqual(calls, ["list --cask --versions"])
        self.assertFalse(self.prompts.exists())

    def test_existing_app_and_cask_without_apps_are_kept(self):
        (self.home / "Applications/Present App.app").mkdir(parents=True)
        output, calls = self.cleanup_casks({
            "present": ["/mock/Missing App.app", "/mock/Present App.app"],
            "font": ["/mock/font.ttf", "/mock/Example.app/Contents/Info.plist"],
        })
        self.assertEqual(output, "No orphaned casks.\n")
        self.assertEqual(calls, [
            "list --cask --versions", "list --cask present", "list --cask font",
        ])
        self.assertFalse(self.prompts.exists())

    def test_confirmed_orphans_are_uninstalled(self):
        output, calls = self.cleanup_casks({
            "missing-one": ["/mock/Missing One.app"],
            "missing-two": ["/mock/Missing Two.app"],
            "font": ["/mock/font.ttf"],
        })
        self.assertEqual(output, "Orphaned: missing-one\nOrphaned: missing-two\n\n\n")
        self.assertEqual(calls, [
            "list --cask --versions", "list --cask missing-one",
            "list --cask missing-two", "list --cask font",
            "uninstall --cask --force missing-one missing-two",
        ])
        self.assertEqual(self.prompts.read_text(), "-q ?Remove all? \n")

    def test_declining_keeps_orphans(self):
        output, calls = self.cleanup_casks({
            "missing": ["/mock/Missing App.app"],
        }, confirm=False)
        self.assertEqual(output, "Orphaned: missing\n\n Skipped.\n")
        self.assertEqual(calls, ["list --cask --versions", "list --cask missing"])
        self.assertEqual(self.prompts.read_text(), "-q ?Remove all? \n")


if __name__ == "__main__":
    unittest.main()
