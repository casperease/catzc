function Get-ModuleProtectionIdentity {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'HashCache',
        Justification = 'Read and written inside the $setHash closure — the analyzer cannot see through the scriptblock.')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [switch] $HasIntegrityTests,

        [switch] $OutsideModulesFolder,

        [Parameter(Mandatory)]
        [hashtable] $HashCache
    )

    $setHash = {
        param([string] $setName)
        if (-not $HashCache.ContainsKey($setName)) {
            # The tracked list rides the caller's cache under a key no set name takes, so one listing serves every module of the run.
            if (-not $HashCache.ContainsKey('<tracked>')) {
                $HashCache['<tracked>'] = [string[]] @(Get-TrackedFile)
            }
            $tracked = $HashCache['<tracked>']
            $HashCache[$setName] = if ($setName -eq 'repository') {
                Get-GlobSetHash -Name repository -TrackedFile $tracked
            }
            else {
                # A module folds its aspect sets' hashes, ordinal by name.
                $sets = @(Get-ModuleGlobSet -Name $setName) | Sort-Object Name
                $fold = [System.Text.StringBuilder]::new()
                foreach ($set in $sets) {
                    [void]$fold.Append($set.Name).Append('|').Append((Get-GlobSetHash -GlobSet $set -TrackedFile $tracked)).Append("`n")
                }
                [Catzc.Base.Globs.DurableHash]::HashFold($fold.ToString())
            }
        }
        $HashCache[$setName]
    }

    # ---- the constituent set names ----
    $constituents = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    [void]$constituents.Add('internal')
    [void]$constituents.Add('vendor')
    [void]$constituents.Add('compiled')
    [void]$constituents.Add('scriptanalyzer')
    [void]$constituents.Add('catzc-base-quality-gates')   # the runner: Test-Automation + the shard machinery

    $widen = [bool]$HasIntegrityTests

    if ($Module -in @('.internal', '.scriptanalyzer')) {
        # infra test units: own scope is already among the reserved sets; their true read set is the repo
        $widen = $true
    }
    elseif ($OutsideModulesFolder) {
        # An unconstrained read set is unknown, so widen: skip less, never wrongly.
        $widen = $true
    }
    else {
        [void]$constituents.Add([Catzc.Base.Objects.NameCase]::Render($Module, 'kebab'))

        # The declared closure; a group reference permits any member, so it expands to all.
        $dependencies = Get-Config -Config dependencies
        $moduleDeclarations = $dependencies.modules

        $groupMembers = @{}
        $memberIntraDependencies = @{}
        foreach ($group in $dependencies.groups.Values) {
            $groupMembers[$group.name] = @($group.members.Keys)
            foreach ($member in $group.members.Keys) {
                $memberIntraDependencies[$member] = @($group.members[$member])
            }
        }

        $isKnown = $moduleDeclarations.Contains($Module) -or $memberIntraDependencies.ContainsKey($Module)
        if (-not $isKnown) {
            $widen = $true
        }
        else {
            $queue = [System.Collections.Generic.Queue[string]]::new()
            $queue.Enqueue($Module)
            $visited = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
            [void]$visited.Add($Module)
            while ($queue.Count -gt 0) {
                $current = $queue.Dequeue()
                $targets = @()
                if ($moduleDeclarations.Contains($current)) {
                    $targets += @($moduleDeclarations[$current])
                }
                if ($memberIntraDependencies.ContainsKey($current)) {
                    $targets += $memberIntraDependencies[$current]
                }
                foreach ($target in $targets) {
                    $expanded = @(if ($groupMembers.ContainsKey($target)) {
                            $groupMembers[$target]
                        }
                        else {
                            @($target)
                        })
                    foreach ($dependencyModule in $expanded) {
                        if ($visited.Add($dependencyModule)) {
                            [void]$constituents.Add([Catzc.Base.Objects.NameCase]::Render($dependencyModule, 'kebab'))
                            $queue.Enqueue($dependencyModule)
                        }
                    }
                }
            }
        }
    }

    if ($widen) {
        [void]$constituents.Add('repository')
    }

    # The durable-sha fold: name|hash lines, ordinal by name.
    $names = [string[]]$constituents
    [System.Array]::Sort($names, [System.StringComparer]::Ordinal)
    $stringBuilder = [System.Text.StringBuilder]::new()
    foreach ($setName in $names) {
        [void]$stringBuilder.Append($setName).Append('|').Append((& $setHash $setName)).Append("`n")
    }
    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
