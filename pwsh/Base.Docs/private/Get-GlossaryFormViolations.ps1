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

    # Compiled: each file's prose is read once into the surface cache, and every concept's forms matched over its source's scope.
    [string[]] [Catzc.Base.Docs.GlossaryScan]::Forms([Catzc.Base.Docs.GlossaryEntry[]] @($Entry),
        [string[]] @($TrackedFile), $Root, $SurfaceCache)
}
