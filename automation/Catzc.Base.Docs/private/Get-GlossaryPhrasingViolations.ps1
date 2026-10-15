<#
.SYNOPSIS
    Lists the uses of avoided phrasings within each glossary source's scope (check G4) — one message per use.
.DESCRIPTION
    An avoided phrasing blurs a defined term, so prose within its source's scope never uses it.
    [ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5),
    [ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-GlossaryPhrasingViolations.ps1.md#comment1)
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER TrackedFile
    The repo-relative, '/'-separated tracked files to consider. Defaults to every file git tracks.
.PARAMETER Root
    The directory the tracked files are relative to. Defaults to the repository root.
.PARAMETER SurfaceCache
    The text surfaces already read, keyed by tracked file, each value the file's Catzc.Base.Docs.GlossarySegment...
    [comment:2](/docs/references/automation/catzc-base-docs/private/Get-GlossaryPhrasingViolations.ps1.md#comment2)
.OUTPUTS
    [string[]] One message per use — `<file>:<line> says "<phrase>" — say "<say>" (<defined_by>)` — in file then
    line order; empty when prose avoids every avoided phrasing.
.EXAMPLE
    Get-GlossaryPhrasingViolations
#>
function Get-GlossaryPhrasingViolations {
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

    # The scan runs compiled (Catzc.Base.Docs.GlossaryScan): it reads each file's prose through GlossaryProse into...
    # [comment:3](/docs/references/automation/catzc-base-docs/private/Get-GlossaryPhrasingViolations.ps1.md#comment3)
    [string[]] [Catzc.Base.Docs.GlossaryScan]::Phrasing([Catzc.Base.Docs.GlossaryEntry[]] @($Entry), [string[]] @($TrackedFile), $Root, $SurfaceCache)
}
