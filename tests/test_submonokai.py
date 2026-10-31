"""Exercise installation and real Git subtree updates without changing user config."""

import os
from pathlib import Path
import plistlib
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


def run(*args, cwd=None, env=None, check=True):
    return subprocess.run(
        args, cwd=cwd, env=env, check=check, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    )


class InstallerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="submonokai install ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.dotfiles = self.root / "dotfiles"
        self.dotfiles.mkdir()
        shutil.copy(ROOT / "ghostty-install.sh", self.dotfiles)
        (self.dotfiles / "submonokai").mkdir()
        (self.dotfiles / "submonokai/SubMonokai.ghostty").write_text(
            "background = #272822\n"
        )
        self.config = self.root / "config home/ghostty/config"
        self.env = dict(os.environ, XDG_CONFIG_HOME=str(self.config.parent.parent))

    def install(self, *args):
        return run("sh", str(self.dotfiles / "ghostty-install.sh"), *args,
                   cwd=self.root, env=self.env, check=False)

    def test_fresh_install_and_rerun_preserve_config(self):
        self.config.parent.mkdir(parents=True)
        original = "font-size = 18\n# Keep local settings\n"
        self.config.write_text(original)
        self.assertEqual(self.install().returncode, 0)
        installed = self.config.read_text()
        self.assertTrue(installed.startswith(original))
        self.assertEqual(installed.count("config-file = ~/dotfiles/ghostty"), 1)
        self.assertEqual(self.install().returncode, 0)
        self.assertEqual(self.config.read_text(), installed)
        self.assertFalse((self.config.parent / "themes").exists())

    def test_creates_config_without_an_existing_directory(self):
        self.assertEqual(self.install().returncode, 0)
        self.assertIn("config-file = ~/dotfiles/ghostty", self.config.read_text())

    def test_old_theme_symlink_is_preserved(self):
        themes = self.config.parent / "themes"
        themes.mkdir(parents=True)
        old_link = themes / "SubMonokai"
        old_link.symlink_to(self.root / "old checkout/SubMonokai.ghostty")
        self.assertEqual(self.install().returncode, 0)
        self.assertTrue(old_link.is_symlink())
        self.assertEqual(os.readlink(old_link),
                         str(self.root / "old checkout/SubMonokai.ghostty"))

    def test_missing_theme_fails_before_writing_config(self):
        (self.dotfiles / "submonokai/SubMonokai.ghostty").unlink()
        self.assertNotEqual(self.install().returncode, 0)
        self.assertFalse(self.config.exists())

    def test_obsolete_checkout_argument_is_rejected(self):
        self.assertNotEqual(self.install("/old/theme/checkout").returncode, 0)
        self.assertFalse(self.config.exists())


class SubtreeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="submonokai sync ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.upstream = self.root / "theme upstream"
        self.dotfiles = self.root / "dotfiles"
        for repo in (self.upstream, self.dotfiles):
            repo.mkdir()
            run("git", "init", "-b", "master", str(repo))
            for key, value in (("user.name", "Subtree Test"),
                               ("user.email", "test@example.invalid"),
                               ("commit.gpgsign", "false"),
                               ("core.hooksPath", str(self.root / "no-hooks"))):
                run("git", "config", key, value, cwd=repo)
        (self.upstream / "SubMonokai.ghostty").write_text("background = #272822\n")
        self.commit(self.upstream, "Initial theme")
        (self.dotfiles / "scripts").mkdir()
        shutil.copy(ROOT / "scripts/sync-submonokai.sh", self.dotfiles / "scripts")
        (self.dotfiles / "personal-config").write_text("keep this\n")
        self.commit(self.dotfiles, "Initial dotfiles")
        run("git", "subtree", "add", "--prefix=submonokai", str(self.upstream),
            "master", "--squash", cwd=self.dotfiles)

    @staticmethod
    def commit(repo, message):
        run("git", "add", ".", cwd=repo)
        run("git", "commit", "-m", message, cwd=repo)

    def sync(self, source=None):
        return run("sh", str(self.dotfiles / "scripts/sync-submonokai.sh"),
                   str(source or self.upstream), "master", cwd=self.root, check=False)

    def head(self):
        return run("git", "rev-parse", "HEAD", cwd=self.dotfiles).stdout.strip()

    def test_updates_repeat_and_normal_clone(self):
        before = self.head()
        self.assertEqual(self.sync().returncode, 0)
        self.assertEqual(self.head(), before)
        existing_clone = self.root / "existing machine"
        run("git", "clone", "--no-local", str(self.dotfiles), str(existing_clone))
        theme = "background = #171714\n"
        (self.upstream / "SubMonokai.ghostty").write_text(theme)
        (self.upstream / "another-app.theme").write_text("shared theme\n")
        self.commit(self.upstream, "Update theme and another app")
        result = self.sync()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotEqual(self.head(), before)
        self.assertEqual((self.dotfiles / "submonokai/SubMonokai.ghostty").read_text(), theme)
        self.assertTrue((self.dotfiles / "submonokai/another-app.theme").is_file())
        self.assertEqual((self.dotfiles / "personal-config").read_text(), "keep this\n")
        after = self.head()
        self.assertEqual(self.sync().returncode, 0)
        self.assertEqual(self.head(), after)
        run("git", "pull", "--ff-only", cwd=existing_clone)
        self.assertEqual((existing_clone / "submonokai/SubMonokai.ghostty").read_text(), theme)
        clone = self.root / "another machine"
        run("git", "clone", "--no-local", str(self.dotfiles), str(clone))
        self.assertEqual((clone / "submonokai/SubMonokai.ghostty").read_text(), theme)

    def test_dirty_tree_is_rejected(self):
        before = self.head()
        for path in (self.dotfiles / "personal-config", self.dotfiles / "untracked"):
            with self.subTest(path=path.name):
                original = path.read_text() if path.exists() else None
                path.write_text("local edit\n")
                result = self.sync()
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("local changes", result.stderr)
                self.assertEqual(path.read_text(), "local edit\n")
                self.assertEqual(self.head(), before)
                if original is None:
                    path.unlink()
                else:
                    path.write_text(original)

    def test_unavailable_upstream_leaves_head_unchanged(self):
        before = self.head()
        self.assertNotEqual(self.sync(self.root / "missing repo").returncode, 0)
        self.assertEqual(self.head(), before)
        self.assertEqual(run("git", "status", "--porcelain", cwd=self.dotfiles).stdout, "")

    def test_conflict_fails_without_overwriting_local_commit(self):
        (self.dotfiles / "submonokai/SubMonokai.ghostty").write_text("background = #111111\n")
        self.commit(self.dotfiles, "Local theme edit")
        before = self.head()
        (self.upstream / "SubMonokai.ghostty").write_text("background = #222222\n")
        self.commit(self.upstream, "Conflicting upstream edit")
        self.assertNotEqual(self.sync().returncode, 0)
        self.assertEqual(self.head(), before)
        conflicts = run("git", "diff", "--name-only", "--diff-filter=U",
                        cwd=self.dotfiles).stdout
        self.assertIn("submonokai/SubMonokai.ghostty", conflicts)


class ThemeTests(unittest.TestCase):
    def test_all_equivalent_iterm_colours_match(self):
        ghostty = {}
        for line in (ROOT / "submonokai/SubMonokai.ghostty").read_text().splitlines():
            if "=" not in line or line.lstrip().startswith("#"):
                continue
            key, value = (part.strip() for part in line.split("=", 1))
            if key == "palette":
                index, value = value.split("=", 1)
                key = "Ansi " + index + " Color"
            else:
                key = {"background": "Background Color", "foreground": "Foreground Color",
                       "cursor-color": "Cursor Color", "selection-background": "Selection Color",
                       "selection-foreground": "Selected Text Color"}[key]
            ghostty[key] = value.lstrip("#").lower()
        with (ROOT / "submonokai/Submonokai.itermcolors").open("rb") as stream:
            iterm = plistlib.load(stream)
        self.assertEqual(len(ghostty), 21)
        for key, value in ghostty.items():
            with self.subTest(colour=key):
                rgb = "".join(f"{round(iterm[key][component + ' Component'] * 255):02x}"
                              for component in ("Red", "Green", "Blue"))
                self.assertEqual(value, rgb)


if __name__ == "__main__":
    unittest.main()
