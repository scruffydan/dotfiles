"""Run with: python3 tests/test_nvim_surround.py /path/to/lazy.nvim /path/to/mini.surround.

Use disposable dependency checkouts; no user Neovim configuration is loaded.
"""

import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
LAZY = MINI = None
NVIM = shutil.which("nvim")
INIT = """
vim.opt.rtp:prepend(vim.env.TEST_LAZY)
vim.g.test_events = {}
vim.api.nvim_create_autocmd({ "InsertEnter", "LspAttach" }, {
  callback = function(ev)
    vim.g.test_events = vim.tbl_extend("force", vim.g.test_events, { [ev.event] = true })
  end,
})
local spec = dofile(vim.env.TEST_SPEC)
spec.dir = vim.env.TEST_MINI
require("lazy").setup({ spec }, {
  local_spec = false,
  install = { missing = false },
  checker = { enabled = false },
  change_detection = { enabled = false },
  pkg = { enabled = false },
  readme = { enabled = false },
})
"""
CHECK = """
local ok, err = pcall(function()
  local case = vim.json.decode(vim.env.TEST_CASE)
  vim.bo.buftype = case.buftype
  vim.bo.filetype = case.filetype
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { case.before })
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  assert(vim.tbl_isempty(vim.g.test_events), "InsertEnter/LspAttach fired before keys")
  local keys = vim.api.nvim_replace_termcodes(case.keys, true, false, true)
  vim.api.nvim_feedkeys(keys, "xt", false)
  local actual = vim.api.nvim_get_current_line()
  assert(actual == case.after, string.format("%s: expected %q, got %q", case.keys, case.after, actual))
  assert(vim.tbl_isempty(vim.g.test_events), "Surround entered Insert mode or attached LSP")
  assert(vim.fn.mode() == "n", "Surround did not finish in Normal mode")
end)
if not ok then
  vim.api.nvim_err_writeln(tostring(err))
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
"""


class SurroundTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if NVIM is None or LAZY is None or MINI is None:
            raise unittest.SkipTest("Requires nvim and dependency paths; see module docstring")

    def test_actions_before_first_insert_without_lsp(self):
        cases = [
            ("word", 'saiw"', '"word"'),
            ('"word"', 'sd"', "word"),
            ('"word"', 'sr")', "(word)"),
            ("word", "saiwB", "**word**"),
            ("word", "saiwI", "*word*"),
            ("**word**", "sdB", "word"),
            ("*word*", "sdI", "word"),
            ("**word**", "srBI", "*word*"),
            ("word", 'viwsa"', '"word"'),
            ("word", "viw<C-b>", "**word**"),
            ("word", "viw<C-i>", "*word*"),
        ]
        for buftype, filetype in (("", "text"), ("nofile", "")):
            for before, keys, after in cases:
                with self.subTest(buftype=buftype, keys=keys):
                    with tempfile.TemporaryDirectory(prefix="nvim-surround-") as tmp:
                        home = Path(tmp)
                        init = home / "init.lua"
                        check = home / "check.lua"
                        init.write_text(INIT)
                        check.write_text(CHECK)
                        env = {
                            "PATH": os.environ.get("PATH", os.defpath),
                            "HOME": tmp,
                            "XDG_CONFIG_HOME": str(home / "config"),
                            "XDG_DATA_HOME": str(home / "data"),
                            "XDG_STATE_HOME": str(home / "state"),
                            "XDG_CACHE_HOME": str(home / "cache"),
                            "XDG_CONFIG_DIRS": str(home / "config-dirs"),
                            "XDG_DATA_DIRS": str(home / "data-dirs"),
                            "TEST_LAZY": str(LAZY),
                            "TEST_MINI": str(MINI),
                            "TEST_SPEC": str(ROOT / "nvim/lua/plugins/mini.lua"),
                            "TEST_CASE": json.dumps(dict(
                                buftype=buftype, filetype=filetype,
                                before=before, keys=keys, after=after,
                            )),
                        }
                        result = subprocess.run(
                            [NVIM, "--headless", "-i", "NONE", "-n", "-u", str(init),
                             "-c", "lua dofile('check.lua')"],
                            cwd=tmp, env=env, text=True, capture_output=True, timeout=15,
                        )
                        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    LAZY, MINI = (Path(arg).resolve(strict=True) for arg in sys.argv[1:])
    if NVIM is None:
        sys.exit("nvim is required")
    unittest.main(argv=[sys.argv[0]])
