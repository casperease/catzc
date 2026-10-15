---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Get-GitChangedPath.ps1.md
    kind: comment-page
    body_sha: "127c2ea53efb"
    adrs: []
---

# automation/Catzc.Base.Files/Get-GitChangedPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The working-tree counterpart of Get-GitTrackedPath: every path at or under the given paths that git status
reports — staged or unstaged, modified, added, deleted, and untracked files that no .gitignore rule ignores — as a
repo-relative, '/'-separated path, sorted ordinally, each once. A rename counts as both of its paths (--no-renames),
like a committed range's changed files: a file moving into or out of a scope changes both. A deleted path is
listed too; a caller that reads files skips what no longer exists.

One read-only `git status --porcelain=v1 -z --untracked-files=all --no-renames` from the repository root (never
$PWD); -z keeps every path literal (no quoting, any character). Runs through Invoke-Executable -Silent, so a git
failure throws.
```
