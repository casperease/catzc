---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-Postman.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: cf5a82df3f23
---

# automation/Catzc.Tooling.Provisioning/tests/Uninstall-Postman.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
All filesystem/CLI boundaries are mocked: nothing is removed for real and no process launches (the L0
tripwire throws on a real Invoke-Executable). Platform branches self-skip off-platform.
```
