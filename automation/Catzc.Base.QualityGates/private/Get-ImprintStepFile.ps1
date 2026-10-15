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

    # Format-Code -Path also formats files outside the repository, which no step's scope covers: they are left out, not refused.
    if ($Path) {
        $Path = @($Path | Where-Object {
                $resolved = Resolve-Path -LiteralPath $_ -ErrorAction Ignore
                $relative = if ($resolved) {
                    [System.IO.Path]::GetRelativePath($root, $resolved.ProviderPath)
                }
                $relative -and $relative -ne '..' -and -not $relative.StartsWith('..' + [System.IO.Path]::DirectorySeparatorChar)
            })
        if ($Path.Count -eq 0) {
            return , [string[]] @()
        }
    }
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
        'comments' {
            $scope = @(Get-CommentScope -RepositoryRoot $root -Path $Path)
            return , [string[]] @($scope | ForEach-Object { [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $_.File)) })
        }
        default {
            throw "Get-ImprintStepFile: no adapter for the imprint step '$Step' (declared: $([Catzc.Base.Languages.LanguagesConfig]::ImprintSteps -join ', '))."
        }
    }
}
