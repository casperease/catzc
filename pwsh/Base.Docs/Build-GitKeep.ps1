function Build-GitKeep {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $sourcePath = Get-CatzcModuleRoot 'assets/gitkeep'
    Assert-PathExist $sourcePath
    $text = [System.IO.File]::ReadAllText($sourcePath)

    $repositoryRoot = Get-RepositoryRoot

    # The bounded walker lists every .gitkeep below the root; out/ is pruned, so its own keep file is added by hand.
    $found = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($keepPath in Get-ChildPath $repositoryRoot -Depth 32 -File -Filter '.gitkeep' -Exclude @('.git', '.vendor',
            'out') -PruneVendor $true) {
        [void] $found.Add((ConvertTo-RepoRelativePath $keepPath))
    }
    $outputKeep = [System.IO.Path]::Combine($repositoryRoot, 'out', '.gitkeep')
    if ([System.IO.File]::Exists($outputKeep)) {
        [void] $found.Add((ConvertTo-RepoRelativePath $outputKeep))
    }
    # A tracked keep file gone from disk is written back too, so a restore after a roll-off brings the index's set back whole.
    foreach ($tracked in @(Get-GitTrackedPath -Path '.')) {
        $segments = $tracked.Split('/')
        if ($segments[-1] -ceq '.gitkeep' -and ($tracked -ceq 'out/.gitkeep' -or -not ($segments | Where-Object { $_ -in '.git', '.vendor', 'out' }))) {
            [void] $found.Add($tracked)
        }
    }

    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    $ret = foreach ($keep in $found) {
        $content = Format-GeneratedFileHead -Text $text -Path $keep -Writer Build-GitKeep
        $changed = Write-FileIfChanged (Resolve-RepoPath $keep) $content -DryRun:$DryRun

        if ($changed -and -not $Silent) {
            $verb = if ($DryRun) {
                'would write'
            }
            else {
                'wrote'
            }
            Write-Message "$verb $keep"
        }
        elseif ($emitVerbose -and -not $Silent) {
            Write-Verbose "unchanged: $keep"
        }

        if ($PassThru) {
            [pscustomobject]@{ Path = $keep; Changed = $changed; DryRun = [bool]$DryRun }
        }
        else {
            $keep
        }
    }

    $ret
}
