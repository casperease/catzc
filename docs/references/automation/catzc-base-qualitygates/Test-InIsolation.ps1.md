---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-InIsolation.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "62f8d941bea4"
---

# automation/Catzc.Base.QualityGates/Test-InIsolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$pathLiteral = ($testPaths | ForEach-Object { "'$_'" }) -join ', '`, written with `#`.

```text
Generate a runner and execute it in a clean child pwsh via Invoke-Executable (mockable; honours
the unit-test tripwire). The child exits with the failed-test count.
```

## comment:2

Above `$savedRoot = $env:RepositoryRoot`, written with `#`.

```text
InProcess: run the sandbox's tests in THIS session against the already-loaded modules, with the
repository root pointed at the sandbox for the run (restored afterwards).
```
