---
catzc:
  immutable:
    with_body_sha: a9174a567c9c
    repo_status: locked
    path: docs/references/automation/catzc-base-git/tests/Reset-GitCleanFxd.Tests.ps1.md
    folder: docs/references/automation/catzc-base-git/tests
    name: reset-git-clean-fxd-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Git/tests/Reset-GitCleanFxd.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
git's own dry-run listing is the one external boundary (plus the deleting clean calls); the
whitelist itself is mocked to a fixed set so these tests exercise pure classification logic.
```
