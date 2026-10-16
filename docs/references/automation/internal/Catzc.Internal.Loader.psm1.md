---
catzc:
  immutable:
    with_body_sha: "47e98bc8fa99"
    repo_status: locked
    path: docs/references/automation/internal/Catzc.Internal.Loader.psm1.md
    folder: docs/references/automation/internal
    name: catzc-internal-loader-psm1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/.internal/Catzc.Internal.Loader.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`, written with `#`.

```text
Catzc.Internal.Loader — the always-loaded entry point for .internal shared code.

The .internal folder holds code that BOTH the bootstrap (which runs before any Catzc module exists) and the
Catzc modules (which run after) must call — the single home for what would otherwise be duplicated across the
two layers (see
[ADR-PRIN-ONELIVE](/docs/adr/principles/one-living-version.md)). This loader is the one thing the importer loads
unconditionally; it stays in the session (it is NOT removed with Bootstrap), so a post-import Catzc cover
function can ensure a shared module is present before delegating to it. Because it is loaded first in both run
modes, it also carries the one pipeline-detection function, Test-IsRunningInPipeline, which the bootstrap's
C#-types pre-pass and the Catzc modules both call.
```

## comment:2

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChan...`, written with `#`.

```text
.SYNOPSIS
    Loads a .internal shared module once into the global session (idempotent).
.DESCRIPTION
    Idempotent, so a hot-path cover function pays nothing; only the importer's first load passes -Force.
    [comment:2](/docs/references/automation/internal/Catzc.Internal.Loader.psm1.md#comment2)
.PARAMETER Name
    The bare area name of the shared module — 'Types' resolves to .internal/Catzc.Internal.Types.psm1.
.PARAMETER Force
    Reload even when the module is already loaded (the importer's initial load uses this).
.EXAMPLE
    Import-InternalModule Types
    Ensures Catzc.Internal.Types is loaded, then the caller can use Get-CombinedTypeHash.
```

## comment:3

Above `[CmdletBinding()]` (occurrence 2), written with `#`.

```text
.SYNOPSIS
    Returns true if the current session is running inside a CI/CD pipeline.
.DESCRIPTION
    It lives in the always-loaded loader so the bootstrap pre-pass and every module ask the same function.
    [comment:3](/docs/references/automation/internal/Catzc.Internal.Loader.psm1.md#comment3)
.EXAMPLE
    Test-IsRunningInPipeline
.EXAMPLE
    if (Test-IsRunningInPipeline) { Write-Verbose 'Running in CI' }
```

## comment:4

Above `[bool]$env:TF_BUILD -or [bool]$env:GITHUB_ACTIONS`, written with `#`.

```text
Azure DevOps sets TF_BUILD=True
GitHub Actions sets GITHUB_ACTIONS=true
```
