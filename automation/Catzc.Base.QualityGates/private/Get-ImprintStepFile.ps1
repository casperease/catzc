<#
.SYNOPSIS
    Lists the files one imprint step may write, in its own scope
    ([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)).
.DESCRIPTION
    A step is never named by a language: which languages it covers is configuration, so this only answers which files the step reads.
.PARAMETER Step
    The step name, as languages.yml spells it.
.PARAMETER RepositoryRoot
    The repository root.
.PARAMETER Path
    Optional files or folders to limit the scope to.
.OUTPUTS
    [string[]] Absolute paths.
#>
function Get-ImprintStepFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Step,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    switch -CaseSensitive ($Step) {
        'file-meta' {
            $entries = @(Get-FileMetaScope -RepositoryRoot $root -Path $Path -Config (Get-Config -Config file-meta))
            return , [string[]] @($entries | ForEach-Object { [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $_.Path)) })
        }
        'csharp-namespace' {
            $lookup = Get-ScopeLookup -RepositoryRoot $root -Path $Path -Command Get-ImprintStepFile
            $types = @(Get-GitTrackedPath $lookup | Where-Object { $_ -match '^automation/[^/]+/types/[^/]+\.cs$' })
            return , [string[]] @($types | ForEach-Object { [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $_)) })
        }
        default {
            throw "Get-ImprintStepFile: no adapter for the imprint step '$Step' (declared: $([Catzc.Base.Languages.LanguagesConfig]::ImprintSteps -join ', '))."
        }
    }
}
