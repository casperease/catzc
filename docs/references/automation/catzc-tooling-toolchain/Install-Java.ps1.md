---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-Java.ps1.md
    kind: comment-page
    body_sha: "87f1d030ef73"
    adrs:
      - ADR-AUTO-CONSOLE#11
    links: []
---

# automation/Catzc.Tooling.Toolchain/Install-Java.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
After installation, sets JAVA_HOME for the current session and
persists it for future sessions (User registry on Windows, $PROFILE
on Unix). Modeled on Install-Dotnet / DOTNET_ROOT.
Idempotent — skips if already installed at the correct version.
```

## comment:2

Above `if ($env:JAVA_HOME -ne $javaHome) {`.

```text
Set for current session. Each change is announced where it happens, and only when it changes something
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)).
```
