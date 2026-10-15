---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-ShellScripts.ps1.md
    kind: comment-page
    body_sha: "02e50b1d7eab"
---

# automation/Catzc.Base.QualityGates/Test-ShellScripts.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `$shebang = $bytes.Length -ge 2 -and $bytes[0] -eq 35 -and $bytes[1] -eq 33`.

```text
A script with a shebang is meant to run directly, which on Unix needs the executable bit in git; a sourced file
(importer.sh, a shellcheck directive instead of a shebang) does not.
```

## comment:7

Above ``$check = Invoke-Executable "`"$($shellcheck.Path)`" --format=gcc...``.

```text
--format=gcc prints one '<file>:<line>:<column>: <severity>: <message> [SC<code>]' line per finding; exit 1
means findings, anything above it means ShellCheck itself failed.
```

## comment:8

Above `if ($zshScripts.Count -gt 0) {`.

```text
ShellCheck does not read zsh, so a *.zsh file takes zsh's own syntax check: -n parses without running (NO_EXEC), -f
skips the startup files. zsh checks one script per call; exit 1 means a parse error, anything above it means zsh
could not check the file.
```
