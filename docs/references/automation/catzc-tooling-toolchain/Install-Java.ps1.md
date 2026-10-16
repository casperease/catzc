---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-Java.ps1.md
    folder: docs/references/automation/catzc-tooling-toolchain
    name: install-java-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "552beeb31318"
    adrs:
      - ADR-AUTO-CONSOLE#11
---

# automation/Catzc.Tooling.Toolchain/Install-Java.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($env:JAVA_HOME -ne $javaHome) {`, written with `#`.

```text
Set for current session. Each change is announced where it happens, and only when it changes something
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)).
```
