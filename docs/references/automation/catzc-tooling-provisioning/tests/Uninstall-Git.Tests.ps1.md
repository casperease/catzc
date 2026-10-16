---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-Git.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning/tests
    name: uninstall-git-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0bc324bddb8f"
---

# automation/Catzc.Tooling.Provisioning/tests/Uninstall-Git.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
Every filesystem/PATH/CLI boundary is mocked so nothing is removed for real and no process launches
(the L0 tripwire would throw on a real Invoke-Executable). Platform branches self-skip off-platform.
```
