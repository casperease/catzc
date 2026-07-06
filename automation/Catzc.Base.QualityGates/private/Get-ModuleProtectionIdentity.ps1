<#
.SYNOPSIS
    Composes a module's protection identity — the durable SHA of everything its test results depend on.
.DESCRIPTION
    The composite (ADR-PROTGLOB): a hash-of-hashes fold over (1) the module's own derived globset, (2) the
    derived sets of its declared dependency closure from dependencies.yml (transitive; a group reference
    permits any member, so it expands to all members), (3) the four reserved infra scopes (internal, vendor,
    compiled, scriptanalyzer), and (4) the runner's own set (catzc-base-qualitygates — an edit to the harness
    re-keys every module). Two fail-safe cases widen the fold with the repository-wide declared 'automation'
    set: a module that is UNCONSTRAINED in dependencies.yml (its true dependency set is unknown), and a module
    whose tests include the 'integrity' category (by definition they read the real repository beyond the
    module). The dot-prefixed infra test units ('.internal', '.scriptanalyzer') key on their reserved scope
    and are always widened. Per-set hashes are memoized in the caller-owned -HashCache, so one run hashes
    each named set at most once.
.PARAMETER Module
    The unit's folder name under automation/ — a module ('Catzc.Base.Globs') or the infra test units
    '.internal' / '.scriptanalyzer'.
.PARAMETER HasIntegrityTests
    Whether the unit's test files contain any 'integrity'-tagged test (from the run's discovery pass) — folds
    in the repository-wide set.
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

    $setHash = {
        param([string] $setName)
        if (-not $HashCache.ContainsKey($setName)) {
            $HashCache[$setName] = if ($setName -eq 'automation') {
                Get-GlobSetHash -Name automation
            }
            else {
                Get-GlobSetHash -GlobSet (Get-ModuleGlobSet -Name $setName)
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

        # declared dependency closure from dependencies.yml (raw shape: groups: <g>: <member>: [deps];
        # modules: <m>: [group-or-module]). A group reference permits ANY member, so it expands to all.
        $dependencies = Get-Config -Config dependencies
        $groups = $dependencies['groups']
        $moduleDeclarations = $dependencies['modules']

        $groupMembers = @{}
        $memberIntraDependencies = @{}
        foreach ($groupName in $groups.Keys) {
            $groupMembers[$groupName] = @($groups[$groupName].Keys)
            foreach ($member in $groups[$groupName].Keys) {
                $memberIntraDependencies[$member] = @($groups[$groupName][$member])
            }
        }

        $isKnown = $moduleDeclarations.Contains($Module) -or $memberIntraDependencies.ContainsKey($Module)
        if (-not $isKnown) {
            # unconstrained (dependencies.yml: "A module NOT listed here is unconstrained") — its true
            # dependency set is unknown, so widen to the repository-wide set: skip less, never wrongly.
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
        [void]$constituents.Add('automation')
    }

    # ---- fold: name|hash lines, ordinal by name — the ADR-GLOBS:5 recipe over set hashes ----
    $names = [string[]]$constituents
    [System.Array]::Sort($names, [System.StringComparer]::Ordinal)
    $stringBuilder = [System.Text.StringBuilder]::new()
    foreach ($setName in $names) {
        [void]$stringBuilder.Append($setName).Append('|').Append((& $setHash $setName)).Append("`n")
    }
    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
