<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-DSGN-ASPECT
      - ADR-FLOW-CD-GLOBS#5
      - ADR-REPO-PROTGLOB
  config:
    synopsis: Composes a module's protection identity — the durable SHA of everything its test results depend on.
    description: |-
      The composite ([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): a hash-of-hashes fold over (1) the
      module's own derived globset, (2) the
      derived sets of its declared dependency closure from dependencies.yml (transitive; a group reference
      permits any member, so it expands to all members), (3) the four reserved infra scopes (internal, vendor,
      compiled, scriptanalyzer), and (4) the runner's own set (catzc-base-qualitygates — an edit to the harness
      re-keys every module). Two fail-safe cases widen the fold with the declared whole-repository 'repository'
      set (every tracked file under every named root): a module that is UNCONSTRAINED in dependencies.yml (its true dependency set is unknown), and a module
      whose tests include the 'integrity' category (by definition they read the real repository beyond the
      module). The dot-prefixed infra test units ('.internal', '.scriptanalyzer') key on the scope reserved for
      them and are always widened. Per-set hashes are memoized in the caller-owned -HashCache, so one run hashes
      each named set at most once.
    parameters:
      Module: |-
        The unit's folder name under automation/ — a module ('Catzc.Base.Globs') or the infra test units
        '.internal' / '.scriptanalyzer'.
      HasIntegrityTests: |-
        Whether the unit's test files contain any 'integrity'-tagged test (from the run's discovery pass) — folds
        in the repository-wide set.
      HashCache: A caller-owned hashtable memoizing set-name -> durable SHA across one Test-Automation run.
---
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
    # [comment:9](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment9)
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
                # [comment:10](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment10)
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
        # [comment:11](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment11)
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
            # [comment:12](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment12)
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
    # [comment:13](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment13)
    $names = [string[]]$constituents
    [System.Array]::Sort($names, [System.StringComparer]::Ordinal)
    $stringBuilder = [System.Text.StringBuilder]::new()
    foreach ($setName in $names) {
        [void]$stringBuilder.Append($setName).Append('|').Append((& $setHash $setName)).Append("`n")
    }
    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
