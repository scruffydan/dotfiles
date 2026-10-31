# Bundled SubMonokai with automatic updates

## Agreed workflow

Include the complete scruffydan/submonokai repository at `submonokai/` using
`git subtree --squash`. Make theme changes in the standalone theme repository.
Ordinary dotfiles clones and pulls include the committed snapshot without
another checkout or a theme symlink.

## Installation

Ghostty loads `~/dotfiles/submonokai/SubMonokai.ghostty` directly. The installer
only adds the existing dotfiles config include once, preserving local settings.
Leave the previous theme symlink and standalone checkout in place; migration
does not require deleting either. Rex and iTerm2 imports use the bundled files;
automatic synchronization inside those apps is unverified.

## Synchronization

The dotfiles GitHub Actions workflow checks upstream `master` hourly, at minute
23, and supports manual dispatch. This avoids maintaining a cross-repository
credential. It uses the dotfiles `GITHUB_TOKEN` with `contents: write` to push
subtree merge commits directly to dotfiles `master` after integration and colour
checks pass. PR verification has read-only permissions. Only the original
repository's default branch can run the writing job.

Runs are serialized. Dirty working trees, fetch errors, conflicts, failed checks,
and concurrent changes to remote `master` fail without a force push. The previous
remote snapshot remains usable. A later run starts from current remote `master`.
The sync script can also be run manually; it commits locally and never pushes.

Updates are eventual, not immediate. GitHub may delay schedules or disable them
after 60 days of repository inactivity. The workflow must be merged before it
can run on a schedule. Preserve subtree metadata by merging subtree PRs with a
merge commit rather than squashing or rebasing them.

## Verification

Use temporary Git repositories to exercise no-op syncs, upstream changes,
ordinary clones, dirty trees, unavailable upstreams, and merge conflicts. Test the
installer against isolated XDG config paths, existing settings, reruns, and the
previous symlink. Compare all 21 equivalent iTerm2/Ghostty colours and validate
the installed Ghostty version's resolved config against the previous config.
