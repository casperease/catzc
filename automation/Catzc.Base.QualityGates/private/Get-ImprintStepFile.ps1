<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-ImprintStepFile.ps1
    folder: private
    name: get-imprint-step-file
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-ImprintStepFile.Tests.ps1
    cites:
      - ADR-REPO-FORMAT#8
---
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
        'ps-help' {
            $lookup = Get-ScopeLookup -RepositoryRoot $root -Path $Path -Command Get-ImprintStepFile
            $functions = @(Get-GitTrackedPath $lookup | Where-Object { $_ -match '^automation/[^/]+/(?:private/)?[^/]+\.ps1$' })
            return , [string[]] @($functions | ForEach-Object { [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $_)) })
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
