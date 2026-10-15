<#
.SYNOPSIS
    Composes a module's protection identity — the durable SHA of everything its test results depend on.
.DESCRIPTION
    The composite: a hash-of-hashes fold over (1) the module's own derived globset, (2) the derived sets of its...
    [ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment1)
.PARAMETER Module
    The unit's folder name under automation/ — a module ('Catzc.Base.Globs') or the infra test units '.internal' /...
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment2)
.PARAMETER HasIntegrityTests
    Whether the unit's test files contain any 'integrity'-tagged test (from the run's discovery pass) — folds in the...
    [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment3)
.PARAMETER HashCache
    A caller-owned hashtable memoizing set-name -> durable SHA across one Test-Automation run.
#>
function Get-ModuleProtectionIdentity {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'HashCache', Justification = 'Read and written inside the $setHash closure — the analyzer cannot see through the scriptblock.')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [switch] $HasIntegrityTests,

        [Parameter(Mandatory)]
        [hashtable] $HashCache
    )

    # The tracked-file universe, fetched once for this call on the first set that is not memoized yet (a holder,...
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment4)
    $universe = @{}
    $setHash = {
        param([string] $setName)
        if (-not $HashCache.ContainsKey($setName)) {
            if (-not $universe.ContainsKey('tracked')) {
                $universe['tracked'] = [string[]] @(Get-TrackedFile)
            }
            $tracked = $universe['tracked']
            $HashCache[$setName] = if ($setName -eq 'repository') {
                Get-GlobSetHash -Name repository -TrackedFile $tracked
            }
            else {
                # A module name resolves to its live/tests aspect sets; a reserved/single set to one.
                # [ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)
                # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment5)
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
    [void]$constituents.Add('catzc-base-qualitygates')   # the runner: Test-Automation + the shard machinery

    $widen = [bool]$HasIntegrityTests

    if ($Module -in @('.internal', '.scriptanalyzer')) {
        # infra test units: own scope is already among the reserved sets; their true read set is the repo
        $widen = $true
    }
    else {
        [void]$constituents.Add($Module.ToLowerInvariant().Replace('.', '-'))

        # declared dependency closure from dependencies.yml (DependenciesConfig: groups: <g> -> ModuleGroup with...
        # [comment:6](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment6)
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
            # unconstrained (dependencies.yml: "A module NOT listed here is unconstrained") — its true dependency set...
            # [comment:7](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment7)
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
                    $expanded = if ($groupMembers.ContainsKey($target)) {
                        $groupMembers[$target]
                    }
                    else {
                        @($target)
                    }
                    foreach ($dependencyModule in $expanded) {
                        if ($visited.Add($dependencyModule)) {
                            [void]$constituents.Add($dependencyModule.ToLowerInvariant().Replace('.', '-'))
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

    # ---- fold: name|hash lines, ordinal by name — the recipe over set hashes ----
    # [ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)
    # [comment:8](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment8)
    $names = [string[]]$constituents
    [System.Array]::Sort($names, [System.StringComparer]::Ordinal)
    $stringBuilder = [System.Text.StringBuilder]::new()
    foreach ($setName in $names) {
        [void]$stringBuilder.Append($setName).Append('|').Append((& $setHash $setName)).Append("`n")
    }
    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
