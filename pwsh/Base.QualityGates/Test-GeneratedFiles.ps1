function Test-GeneratedFiles {
    [CmdletBinding(DefaultParameterSetName = 'Writers')]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [Parameter(ParameterSetName = 'Writers')]
        [string[]] $Generator,

        [switch] $Changed,

        [Parameter(ParameterSetName = 'Stamp')]
        [switch] $StampOnly,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $known = @(Get-GeneratedFileGenerator)
    foreach ($name in $Generator) {
        Assert-True ($name -in $known) `
            -ErrorText "Unknown generator '$name'. The generators are: $($known -join ', ') (each module's generated.yml lists its writers, rootconfig.yml the root-file generators)."
    }
    $writers = @(Get-GeneratedWriterOrder)
    # The generators Build-RootConfig renders: those with no row, and those whose row expands rootconfig and leaves the check to it.
    $ownChecks = @($writers | Where-Object { $_.expands -cne 'rootconfig' -or $_.check -cne 'none' } | ForEach-Object name)
    $rootConfigGenerators = @($known | Where-Object { $_ -cnotin $ownChecks })
    # @() around the whole if: a one-generator selection must stay an array (.Count under strict mode).
    $selected = @(if ($Generator) {
            $Generator
        }
        else {
            $known
        })

    # The tracked generated paths come from the writer registry alone, never from a head; -Changed narrows them to what git reports changed.
    $tracked = [string[]] @(Get-GitTrackedPath '.')
    if ($Changed) {
        $changedSet = [System.Collections.Generic.HashSet[string]]::new([string[]] @(Get-GitChangedPath), [System.StringComparer]::Ordinal)
        $tracked = [string[]] @($tracked | Where-Object { $changedSet.Contains($_) })
    }
    $generated = @(Get-GeneratedTrackedPath -Path $tracked)

    # The row whose dry run renders a path: its writer's own, or for an expanded root file the rootconfig expander's check.
    $rowOf = [System.Collections.Generic.Dictionary[string, object]]::new([System.StringComparer]::Ordinal)
    foreach ($writer in $writers) {
        $rowOf[$writer.name] = $writer
    }
    $rootChecker = $writers | Where-Object { $_.expands -ceq 'rootconfig' -and $_.check -cne 'none' } | Select-Object -First 1 | ForEach-Object name
    $skipped = [System.Collections.Generic.List[string]]::new()
    $pathsOf = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.List[string]]]::new([System.StringComparer]::Ordinal)
    foreach ($target in $generated) {
        $row = if ($rowOf.ContainsKey($target.generator)) {
            $rowOf[$target.generator]
        }
        $checker = if ($null -eq $row -or ($row.check -ceq 'none' -and $row.expands -ceq 'rootconfig')) {
            $rootChecker
        }
        elseif ($row.check -cne 'none') {
            $row.name
        }
        # A snapshot writer reads outside the tree and no other writer with no check has a dry run, so their files are skipped, never failed.
        if (-not $checker) {
            # An untracked writer's files are never committed, so no check is owed; a gate-checked writer has a checker, its gate runs elsewhere.
            if ($row -and $row.class -ceq 'untracked') {
                continue
            }
            $reason = if ($row -and $row.class -ceq 'snapshot') {
                'snapshot'
            }
            else {
                'no dry run'
            }
            $entry = "$($target.generator) ($reason)"
            if (-not $skipped.Contains($entry)) {
                $skipped.Add($entry)
            }
            continue
        }
        if (-not $pathsOf.ContainsKey($checker)) {
            $pathsOf[$checker] = [System.Collections.Generic.List[string]]::new()
        }
        $pathsOf[$checker].Add($target.path)
    }

    # The full run renders every writer; -Changed renders the due ones, and both render a writer one of whose files misses the stamp.
    $renderAll = -not $Changed -and -not $StampOnly
    $renderNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    if ($Changed -and -not $StampOnly) {
        foreach ($row in @(Get-GeneratedWriterDue | Where-Object Due)) {
            [void]$renderNames.Add($row.Name)
        }
    }
    if (-not $renderAll) {
        $root = Get-RepositoryRoot
        foreach ($checker in @($pathsOf.Keys)) {
            if (@(Get-GeneratedStampDrift -RepositoryRoot $root -Path $pathsOf[$checker].ToArray()).Count -gt 0) {
                [void]$renderNames.Add($checker)
            }
        }
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    # A writer reports absolute or repository-relative paths; an issue names the repository-relative one.
    $addStale = {
        param([string] $Path, [string] $Name, [string] $Command)
        $relative = if ([System.IO.Path]::IsPathRooted($Path)) {
            ConvertTo-RepoRelativePath $Path
        }
        else {
            $Path
        }
        $issues.Add("${relative}: stale — $Name would change it; regenerate with: $Command")
    }

    # Each writer runs by its registered check, and its dry run renders every file, head included, so a byte difference is a finding.
    foreach ($writer in $writers) {
        $writerName = $writer.name
        if (-not $renderAll -and -not $renderNames.Contains($writerName)) {
            continue
        }
        switch ($writer.check) {
            'file' {
                if ($writerName -in $selected) {
                    foreach ($result in @(& $writerName -DryRun -PassThru -Silent)) {
                        if ($result.Changed) {
                            & $addStale $result.($writer.result_path) $writerName $writerName
                        }
                    }
                }
            }
            'english-dictionary' {
                # The committed English list, from its stamp: the pin is tools.yml's, read by address (no Tooling edge).
                if ($writerName -in $selected) {
                    $assetsFolder = [Catzc.Base.QualityGates.SpellingOracle]::AssetsFolder((Get-CatzcModuleRoot -Module Catzc.Base.QualityGates))
                    $pinned = "$(Get-ConfigValue -Address 'global.tools.cspell.version')"
                    foreach ($reason in @(Get-EnglishDictionaryDrift -AssetsFolder $assetsFolder -PinnedCspell $pinned)) {
                        $issues.Add("$(ConvertTo-RepoRelativePath $assetsFolder)/english.txt.gz: stale — $reason; regenerate with: $writerName (commit the gz and its stamp)")
                    }
                }
            }
            'gate' {
                # The writer's row names the gate that proves it, which runs on its own; no render here.
            }
            'root-config' {
                # The managed root files: the writer selects them all, a generator only the files it renders.
                if ($writerName -in $selected -or
                    @($selected | Where-Object { $_ -in $rootConfigGenerators }).Count -gt 0) {
                    foreach ($result in @(& $writerName -DryRun -PassThru -Silent)) {
                        $name = if ($result.Generator) {
                            "$($result.Generator)"
                        }
                        else {
                            $writerName
                        }
                        if ($result.Changed -and ($writerName -in $selected -or $name -in $selected)) {
                            & $addStale $result.Target $name "$writerName '$($result.Target)'"
                        }
                    }
                }
            }
        }
    }

    Write-QualityGateReport -Subject generated-files -Title Test-GeneratedFiles -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Generators = $selected.Count; Tracked = $generated.Count; Skipped = [string[]] @($skipped) }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
