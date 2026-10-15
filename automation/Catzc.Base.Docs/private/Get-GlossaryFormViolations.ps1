<#
.SYNOPSIS
    Lists the uses of a term outside its declared forms within each glossary source's scope (check G6) — one message
    per use.
.DESCRIPTION
    A term that names a family declares the words allowed to qualify its head word (`forms:`), and any other...
    [ADR-REPO-VOCAB#8](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab8)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-GlossaryFormViolations.ps1.md#comment1)
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER TrackedFile
    The repo-relative, '/'-separated tracked files to consider. Defaults to every file git tracks.
.PARAMETER Root
    The directory the tracked files are relative to. Defaults to the repository root.
.PARAMETER SurfaceCache
    The text surfaces already read, keyed by tracked file, each value the file's Catzc.Base.Docs.GlossarySegment...
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

    # The scan runs compiled (Catzc.Base.Docs.GlossaryScan): it reads each file's prose through GlossaryProse into...
    # [comment:3](/docs/references/automation/catzc-base-docs/private/Get-GlossaryFormViolations.ps1.md#comment3)
    [string[]] [Catzc.Base.Docs.GlossaryScan]::Forms([Catzc.Base.Docs.GlossaryEntry[]] @($Entry), [string[]] @($TrackedFile), $Root, $SurfaceCache)
}
