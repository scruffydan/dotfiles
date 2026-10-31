"""Exercise the move-window menu with command stubs, never the user's server."""

import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


class MoveWindowTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="tmux move window ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / "dotfiles").symlink_to(ROOT, target_is_directory=True)
        self.fixture = self.root / "fixture.json"
        self.log = self.root / "calls.jsonl"
        self.env = {
            "HOME": str(self.root),
            "PATH": str(self.root) + os.pathsep + os.defpath,
            "FIXTURE": str(self.fixture),
            "CALL_LOG": str(self.log),
        }
        stub = self.root / "tmux"
        stub.write_text(f"#!{sys.executable}\n" + '''
import json
import os
from pathlib import Path
import sys

fixture = json.loads(Path(os.environ["FIXTURE"]).read_text())
args = sys.argv[1:]
tool = Path(sys.argv[0]).name
entry = {"tool": tool, "args": args}
if tool == "fzf":
    entry["input"] = sys.stdin.read().splitlines()
with open(os.environ["CALL_LOG"], "a") as log:
    log.write(json.dumps(entry) + "\\n")
if tool == "fzf":
    if fixture["cancel"]:
        sys.exit(130)
    selected = next((line for line in entry["input"]
                     if line.split(" ", 1)[1] == fixture["selected"]), None)
    if selected is None:
        sys.exit(1)
    print(selected)
elif args[0] == "list-sessions":
    assert args == ["list-sessions", "-F", "#{session_id} #{session_name}"], args
    print("\\n".join(f"${index} {name}"
                    for index, name in enumerate(fixture["sessions"])))
elif args[0] == "display-message":
    assert args == ["display-message", "-p", "#{session_id} #{session_name}"], args
    index = fixture["sessions"].index(fixture["current"])
    print(f"${index} {fixture['current']}")
elif args[0] == "move-window":
    sys.exit(fixture["move_status"])
elif args[0] != "switch-client":
    raise AssertionError(args)
''')
        stub.chmod(0o755)
        (self.root / "fzf").symlink_to(stub)

    def run_menu(self, selected="destination", current="current", sessions=None,
                 cancel=False, move_status=0):
        self.fixture.write_text(json.dumps({
            "selected": selected,
            "current": current,
            "sessions": sessions if sessions is not None else [current, selected],
            "cancel": cancel,
            "move_status": move_status,
        }))
        self.log.write_text("")
        line = next(line for line in (ROOT / "tmux.conf").read_text().splitlines()
                    if '"Move Window to Session"' in line)
        # Decode the two quoting layers of this menu's display-popup command.
        action = shlex.split(line.rstrip(" \\"))[2]
        popup = shlex.split(action)
        self.assertEqual(popup[:2], ["display-popup", "-E"])
        self.assertEqual(len(popup), 3)
        command = popup[2].replace("##", "#")
        result = subprocess.run(["sh", "-c", command], env=self.env,
                                cwd=self.root, text=True, capture_output=True,
                                timeout=10)
        calls = [json.loads(line) for line in self.log.read_text().splitlines()]
        mutations = [call["args"] for call in calls if call["tool"] == "tmux"
                     and call["args"][0] in ("move-window", "switch-client")]
        return result, calls, mutations

    def test_names_are_literal_and_move_precedes_switch(self):
        for name in (
            "destination", "two words", "  padded  ", "tab\tname",
            "single'quote", 'double"quote', "back\\slash", "semi;colon",
            "review$(printf INJECTED)", "review`printf INJECTED`",
            "glob*[abc]?", "-leading-dash", "$123", "=literal", "hash#{session_name}",
        ):
            with self.subTest(name=name):
                result, calls, mutations = self.run_menu(selected=name)
                self.assertEqual(result.returncode, 0, result.stderr)
                picker = next(call for call in calls if call["tool"] == "fzf")
                self.assertEqual(picker["input"], ["$1 " + name])
                self.assertEqual(mutations, [
                    ["move-window", "-t", "$1:"],
                    ["switch-client", "-t", "$1"],
                ])

    def test_current_session_filter_is_literal(self):
        for current, other in (("work[1]", "work1"), ("work.*", "work-other"),
                               ("-work", "other"), ("two words", "two  words"),
                               ("review$(printf INJECTED)", "reviewINJECTED")):
            with self.subTest(current=current):
                result, calls, _ = self.run_menu(current=current, selected=other)
                self.assertEqual(result.returncode, 0, result.stderr)
                picker = next(call for call in calls if call["tool"] == "fzf")
                self.assertEqual(picker["input"], ["$1 " + other])
                self.assertIn("--reverse", picker["args"])
                self.assertIn("--no-multi", picker["args"])
                self.assertIn("--with-nth=2..", picker["args"])
                self.assertIn("--delimiter= ", picker["args"])

    def test_selected_session_id_is_used(self):
        result, calls, mutations = self.run_menu(
            selected="chosen", sessions=["other", "current", "chosen"])
        self.assertEqual(result.returncode, 0, result.stderr)
        picker = next(call for call in calls if call["tool"] == "fzf")
        self.assertEqual(picker["input"], ["$0 other", "$2 chosen"])
        self.assertEqual(mutations, [["move-window", "-t", "$2:"],
                                     ["switch-client", "-t", "$2"]])

    def test_cancel_does_not_move_or_switch(self):
        _, _, mutations = self.run_menu(cancel=True)
        self.assertEqual(mutations, [])

    def test_no_other_sessions_does_not_move_or_switch(self):
        _, _, mutations = self.run_menu(sessions=["current"])
        self.assertEqual(mutations, [])

    def test_failed_move_does_not_switch(self):
        result, _, mutations = self.run_menu(move_status=1)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(mutations, [["move-window", "-t", "$1:"]])


if __name__ == "__main__":
    unittest.main()
