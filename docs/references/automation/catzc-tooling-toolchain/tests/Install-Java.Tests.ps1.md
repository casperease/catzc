---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Install-Java.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "153a0c001554"
---

# automation/Catzc.Tooling.Toolchain/tests/Install-Java.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Install-Java' -Tag 'L1', 'logic' {`, written with `#`.

```text
Hermetic logic (L1): the tool manager (Install-Tool), the installed-version probe, command resolution and the
persistent user environment (Set-PermanentEnvironmentVariable) are mocked; the JDK layout is a fixture under
$TestDrive. The real registry round trip is the seam's own L3 system test
(Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1).
```
