---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-github/private/Assert-RemoteMatchesBranch.ps1.md
    kind: comment-page
    body_sha: "1d05d98a2ad9"
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Github/private/Assert-RemoteMatchesBranch.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The post-push verification behind Publish-CleanHistory and Reset-GitHubRepository. Git names every commit by
the hash of its content and history, so a remote ref at the same commit as the local branch carries the same
history, object for object. Comparing the advertised refs (`git ls-remote`, a few hundred bytes) against the
local commit therefore proves what the server stored without downloading it, and the token scan runs on the
local branch instead of a mirror clone. A ref at any other commit is history the local scan never covered, so
it fails the check.
```
