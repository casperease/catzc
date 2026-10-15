---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-InIsolation.ps1.md
    kind: comment-page
    body_sha: "08036103c377"
---

# automation/Catzc.Base.QualityGates/Test-InIsolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$pathLiteral = ($testPaths | ForEach-Object { "'$_'" }) -join ', '`.

```text
Generate a runner and execute it in a clean child pwsh via Invoke-Executable (mockable; honours
the unit-test tripwire). The child exits with the failed-test count.
```

## comment:6

Above `$savedRoot = $env:RepositoryRoot`.

```text
InProcess: run the sandbox's tests in THIS session against the already-loaded modules, with the
repository root pointed at the sandbox for the run (restored afterwards).
```
