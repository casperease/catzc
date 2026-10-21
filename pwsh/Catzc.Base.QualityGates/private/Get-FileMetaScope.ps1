<#
---
catzc:
  immutable:
    with_body_sha: "6a970436deb3"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-FileMetaScope.Tests.ps1
    docs: "[Get-FileMetaScope.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-FileMetaScope.ps1.md)"
---
#>

function Get-FileMetaScope {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaConfig] $Config,

        [Catzc.Base.QualityGates.FileCarrierResolver] $Resolver = [Catzc.Base.QualityGates.FileCarrierResolver]::new((Get-Config -Config file-carriers), (Get-Config -Config languages))
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $lookup = Get-ScopeLookup -RepositoryRoot $root -Path $Path -Command Get-FileMetaScope
    $languages = Get-Config -Config languages
    $fileKinds = Get-Config -Config file-kinds

    # A file named in -Path is taken as given, tracked or new, unless git ignores it; a folder lists its tracked files.
    $given = @($lookup | Where-Object { $_ -ne '.' -and [System.IO.File]::Exists((Join-Path $root $_)) })
    $folders = @($lookup | Where-Object { $_ -notin $given })
    if ($given.Count -gt 0) {
        $ignored = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        # Batches keep each command line short: one call with hundreds of paths overflows the OS command-line limit.
        $batchSize = 50
        for ($start = 0; $start -lt $given.Count; $start += $batchSize) {
            $quoted = foreach ($file in $given[$start..([Math]::Min($start + $batchSize, $given.Count) - 1)]) {
                "`"$file`""
            }
            # Exit 0: some paths are ignored, 1: none are; anything else is a git failure.
            $ignoredRun = Invoke-Executable "git -C `"$root`" -c core.quotepath=off check-ignore --no-index -- $($quoted -join ' ')" -PassThru -Silent -NoAssert
            Assert-True ($ignoredRun.ExitCode -le 1) -ErrorText "Get-FileMetaScope: git check-ignore failed ($($ignoredRun.ExitCode)): $($ignoredRun.Errors)"
            foreach ($line in @($ignoredRun.Output -split "`r?`n" | Where-Object { $_ })) {
                [void] $ignored.Add($line.Trim())
            }
        }
        $given = @($given | Where-Object { -not $ignored.Contains($_) })
    }
    $paths = @($given) + @(if ($folders.Count -gt 0) {
            Get-GitTrackedPath ([string[]] $folders)
        })

    $candidates = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($tracked in $paths) {
        $carrier = $Resolver.For($tracked)
        if ($null -eq $carrier) {
            continue
        }
        if ($carrier.carrier -eq [Catzc.Base.Languages.CarrierKind]::None) {
            continue
        }
        if ($Resolver.IsExcluded($carrier, $tracked)) {
            continue
        }
        $language = $languages.ForPath($tracked)
        $languageName = if ($language) {
            $language.name
        }
        else {
            $null
        }
        if ($Config.SelectsAny($fileKinds.Resolve($tracked).Class, $languageName)) {
            $candidates.Add([pscustomobject]@{ Path = $tracked; Carrier = $carrier })
        }
    }
    if ($candidates.Count -eq 0) {
        return
    }

    # Get-ContentExemptPath returns one array, so it is assigned first and the set holds paths, not the array.
    $paths = [string[]] @($candidates | ForEach-Object Path)
    $exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $paths
    $exempt = [System.Collections.Generic.HashSet[string]]::new([string[]] @($exemptPaths))
    $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path $paths -Attribute catzc-meta
    foreach ($candidate in $candidates) {
        $classes = $attributes[$candidate.Path]
        if (-not $exempt.Contains($candidate.Path) -and -not ($classes -and $classes['catzc-meta'] -eq 'unset')) {
            $candidate
        }
    }
}
