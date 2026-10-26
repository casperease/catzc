# pwsh/Base.QualityGates/Test-InIsolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Copies a module profile into a temporary sandbox and runs its tests in isolation, in a clean child pwsh or the current session, so a
subset of the toolset is verified deterministically.

### description

Front half (both modes): resolve the module set with Get-ModuleProfile (a named profile from configs/profiles.yml, or an explicit -Modules
seed → dependency closure + infrastructure), then Copy-CatzcModule it into a fresh sandbox (-EmptyDestination). Back half depends on
-Isolation:

```text
Process   (default, TRUE isolation) — run Pester in a child `pwsh -NoProfile`:
          `. <sandbox>/importer.ps1 -SkipJanitors` (the optimized initializer — janitors skipped, the
          committed .compiled reused) then Invoke-Pester over the sandbox's tests. A clean session, so
          no residue from an earlier run is present in it by construction. Launched via Invoke-Executable.
```

```text
InProcess (fast) — point $env:RepositoryRoot at the sandbox and Invoke-Pester the sandbox's test files in
          THIS session, using the already-loaded modules (no re-import, no process spin-up). The dev
          session's loaded code is what runs (residue), and $env:RepositoryRoot is restored afterwards.
```

Integrity tests bind to the whole real repo and are meaningless in a subset sandbox, so -Category defaults to Logic (hermetic). Tiers
default to L0+L1 (the unit tiers). Excluded tags are computed by Get-TestExcludeTag.

### parameter `ModuleProfile`

A profile from configs/profiles.yml (minimal, base, azure, tooling, full). Default: minimal.

### parameter `Modules`

An explicit seed list instead of a named profile — resolved through the same closure logic.

### parameter `Isolation`

Process (child pwsh, true isolation — default) or InProcess (current session, fast).

### parameter `Category`

Logic (default), Integrity, or Both. Integrity assumes the full real repo — use only with the full profile.

### parameter `MaxLevel`

Highest tier to run (0-4). Default 1 (L0+L1 — the hermetic unit tiers). Alias -Level.

### parameter `MinLevel`

Lowest tier to run (0-4). Default 0.

### parameter `Destination`

Sandbox directory. Default: a fresh tmp dir (removed after, unless -KeepSandbox). A given -Destination is never auto-removed.

### parameter `KeepSandbox`

Keep the sandbox (and its results.xml) after the run instead of deleting it.

### parameter `PassThru`

Return the run summary object instead of throwing on failure.

### outputs

`[Catzc.Base.Reports.IsolationRunResult]` with Isolation, ModuleProfile, Sandbox, Modules, Total, Failed, Success, ResultsPath (under
-PassThru).

### example 1

```powershell
Test-InIsolation -ModuleProfile azure
```

### example 2

```powershell
Test-InIsolation -Modules Catzc.Base.Config -Isolation InProcess -PassThru
```

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
