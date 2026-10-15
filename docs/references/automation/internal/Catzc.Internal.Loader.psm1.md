# automation/.internal/Catzc.Internal.Loader.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Set-StrictMode -Version Latest   # this module's scope: every function here...`.

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

Section `.DESCRIPTION` of the comment-based help.

```text
Trusts the importer has already cleared PSModulePath and set the error preferences, so it just imports
the module by path into the global scope. Idempotent: a no-op when the module is already loaded, so a
cover function on the hot path pays nothing. The importer passes -Force on its own initial load so a
devbox re-import (the cache-ADR invalidation boundary) picks up edits — the same "re-run the importer to
invalidate" contract the C# type cache follows.
```

## comment:3

Section `.DESCRIPTION` of the comment-based help.

```text
The one pipeline-detection function
([ADR-FLOW-CD-DETECT#1](/docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect1)). It detects Azure
DevOps Pipelines and GitHub Actions by the environment variables each platform's agent sets. It lives in
this loader, which both run modes import first and never remove, so the C#-types pre-pass in the bootstrap
and every Catzc module ask the same function.
```

## comment:4

Above `[bool]$env:TF_BUILD -or [bool]$env:GITHUB_ACTIONS`.

```text
Azure DevOps sets TF_BUILD=True
GitHub Actions sets GITHUB_ACTIONS=true
```
