---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-ShellScripts.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0713bc71a4f2"
---

# automation/Catzc.Base.QualityGates/Test-ShellScripts.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$shebang = $bytes.Length -ge 2 -and $bytes[0] -eq 35 -and $bytes[1] -eq 33`, written with `#`.

```text
A script with a shebang is meant to run directly, which on Unix needs the executable bit in git; a sourced file
(importer.sh, a shellcheck directive instead of a shebang) does not.
```

## comment:2

Above ``$check = Invoke-Executable "`"$($shellcheck.Path)`" --format=gcc...``, written with `#`.

```text
--format=gcc prints one '<file>:<line>:<column>: <severity>: <message> [SC<code>]' line per finding; exit 1
means findings, anything above it means ShellCheck itself failed.
```

## comment:3

Above `if ($zshScripts.Count -gt 0) {`, written with `#`.

```text
ShellCheck does not read zsh, so a *.zsh file takes zsh's own syntax check: -n parses without running (NO_EXEC), -f
skips the startup files. zsh checks one script per call; exit 1 means a parse error, anything above it means zsh
could not check the file.
```
