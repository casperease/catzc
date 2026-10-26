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

    # Compiled: each file's prose is read once into the surface cache, and every avoided phrasing matched over its source's scope.
    [string[]] [Catzc.Base.Docs.GlossaryScan]::Phrasing([Catzc.Base.Docs.GlossaryEntry[]] @($Entry),
        [string[]] @($TrackedFile), $Root, $SurfaceCache)
}
