---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-InIsolation.ps1.md
    kind: comment-page
    body_sha: "6190af078121"
---

# automation/Catzc.Base.QualityGates/Test-InIsolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Front half (both modes): resolve the module set with Get-ModuleProfile (a named profile from
configs/profiles.yml, or an explicit -Modules seed → dependency closure + infrastructure), then
Copy-Automation it into a fresh sandbox (-EmptyDestination). Back half depends on -Isolation:

  Process   (default, TRUE isolation) — run Pester in a child `pwsh -NoProfile`:
            `. <sandbox>/importer.ps1 -SkipJanitors` (the optimized initializer — janitors skipped, the
            committed .compiled reused) then Invoke-Pester over the sandbox's tests. A clean session, so
            Get-BaseModule -Kind residue inside it is empty by construction. Launched via Invoke-Executable.

  InProcess (fast) — point $env:RepositoryRoot at the sandbox and Invoke-Pester the sandbox's test files in
            THIS session, using the already-loaded modules (no re-import, no process spin-up). The dev
            session's loaded code is what runs (residue), and $env:RepositoryRoot is restored afterwards.

Integrity tests bind to the whole real repo and are meaningless in a subset sandbox, so -Category defaults
to Logic (hermetic). Tiers default to L0+L1 (the unit tiers). Excluded tags are computed by Get-TestExcludeTag.
```

## comment:2

Section `.PARAMETER Destination` of the comment-based help.

```text
Sandbox directory. Default: a fresh tmp dir (removed after, unless -KeepSandbox). A given -Destination is
never auto-removed.
```

## comment:3

Above `$pathLiteral = ($testPaths | ForEach-Object { "'$_'" }) -join ', '`.

```text
Generate a runner and execute it in a clean child pwsh via Invoke-Executable (mockable; honours
the unit-test tripwire). The child exits with the failed-test count.
```

## comment:4

Above `$savedRoot = $env:RepositoryRoot`.

```text
InProcess: run the sandbox's tests in THIS session against the already-loaded modules, with the
repository root pointed at the sandbox for the run (restored afterwards).
```

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
