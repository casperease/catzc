---
catzc:
  immutable:
    with_body_sha: "0152a66ffff2"
    repo_status: locked
    path: docs/references/automation/catzc-tooling-toolchain/tests/Get-GoRelease.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-toolchain/tests
    name: get-go-release-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Toolchain/tests/Get-GoRelease.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The go.dev release feed is mocked with a fixture shaped like the real one (version, stable, files[] with
filename/os/arch/kind/sha256).
```
