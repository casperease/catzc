<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-ImprintStepFile.ps1.md"
  header: "generated"
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
    $modulesFolder = [regex]::Escape((Get-CatzcModulesFolder))
    switch -CaseSensitive ($Step) {
        'file-meta' {
            $entries = @(Get-FileMetaScope -RepositoryRoot $root -Path $Path -Config (Get-Config -Config file-meta))
            return , [string[]] @($entries | ForEach-Object { [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $_.Path)) })
        }
        'bcl-namespace' {
            $lookup = Get-ScopeLookup -RepositoryRoot $root -Path $Path -Command Get-ImprintStepFile
            $types = @(Get-GitTrackedPath $lookup | Where-Object { $_ -match "^$modulesFolder/[^/]+/types/[^/]+\.cs$" })
            return , [string[]] @($types | ForEach-Object { [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $_)) })
        }
        'ps-help' {
            $lookup = Get-ScopeLookup -RepositoryRoot $root -Path $Path -Command Get-ImprintStepFile
            $functions = @(Get-GitTrackedPath $lookup | Where-Object { $_ -match "^$modulesFolder/[^/]+/(?:private/)?[^/]+\.ps1$" })
            return , [string[]] @($functions | ForEach-Object { [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $_)) })
        }
        'wrap-powershell' {
            # The formatter's own scope, so vendored code is never rewritten, narrowed to the PowerShell code files.
            $scope = @(Get-FormatScope -RepositoryRoot $root -Path $Path)
            return , [string[]] @($scope | Where-Object { $_ -match '\.(ps1|psm1)$' })
        }
        'comments' {
            $scope = @(Get-CommentScope -RepositoryRoot $root -Path $Path)
            return , [string[]] @($scope | ForEach-Object { [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $_.File)) })
        }
        'plan-counts' {
            # The step rewrites the master and the value overlay; it is in scope with no -Path, or one in, or above, the plans folder.
            $plans = Get-Config -Config plans
            $folder = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $plans.folder))
            $overlays = @(foreach ($name in $plans.master_file, $plans.value_file) {
                    $overlay = Join-Path $folder $name
                    if ([System.IO.File]::Exists($overlay)) {
                        $overlay
                    }
                })
            if ($Path) {
                $separator = [System.IO.Path]::DirectorySeparatorChar
                $touched = @($Path | Where-Object {
                        $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $_).ProviderPath).TrimEnd($separator)
                        $full -eq $folder -or $full.StartsWith($folder + $separator) -or $folder.StartsWith($full + $separator)
                    })
                if ($touched.Count -eq 0) {
                    return , [string[]] @()
                }
            }
            return , [string[]] $overlays
        }
        default {
            throw "Get-ImprintStepFile: no adapter for the imprint step '$Step' (declared: $([Catzc.Base.Languages.LanguagesConfig]::ImprintSteps -join ', '))."
        }
    }
}
