<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-GlossaryFormViolations.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-REPO-VOCAB#8
---
#>

<#
.SYNOPSIS
    Lists the uses of a term outside its declared forms within each glossary source's scope (check G6) — one message
    per use.
.DESCRIPTION
    Function words and a keyword after a dot never count as a qualifier; the bare head word is always allowed.
    [ADR-REPO-VOCAB#8](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab8)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-GlossaryFormViolations.ps1.md#comment1)
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER TrackedFile
    The repo-relative, '/'-separated tracked files to consider. Defaults to every file git tracks.
.PARAMETER Root
    The directory the tracked files are relative to. Defaults to the repository root.
.PARAMETER SurfaceCache
    Test-Glossary shares one table with the phrasing check, so a run reads each file's prose only once.
    [comment:2](/docs/references/automation/catzc-base-docs/private/Get-GlossaryFormViolations.ps1.md#comment2)
.OUTPUTS
    [string[]] One message per use — `<file>:<line> says "<use>" — "<term>" takes only: <forms> (<defined_by>)` — in
    file then line order; empty when every use is a declared form.
.EXAMPLE
    Get-GlossaryFormViolations
#>
function Get-GlossaryFormViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [Catzc.Base.Docs.GlossaryEntry[]] $Entry = (Get-Glossary),

        [AllowEmptyCollection()]
        [string[]] $TrackedFile = @(Get-GitTrackedPath '.'),

        [string] $Root = (Get-RepositoryRoot),

        [hashtable] $SurfaceCache = @{}
    )

    # The scan is compiled and fills the surface cache once, then matches every concept with forms over its scope.
    # [comment:3](/docs/references/automation/catzc-base-docs/private/Get-GlossaryFormViolations.ps1.md#comment3)
    [string[]] [Catzc.Base.Docs.GlossaryScan]::Forms([Catzc.Base.Docs.GlossaryEntry[]] @($Entry), [string[]] @($TrackedFile), $Root, $SurfaceCache)
}
