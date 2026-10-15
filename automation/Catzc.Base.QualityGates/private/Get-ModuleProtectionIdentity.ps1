<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-DSGN-ASPECT
      - ADR-FLOW-CD-GLOBS#5
      - ADR-REPO-PROTGLOB
---
#>

<#
.SYNOPSIS
    Composes a module's protection identity — the durable SHA of everything its test results depend on.
.DESCRIPTION
    Fail-safe: an unconstrained module or one with integrity tests widens the fold to the whole repository.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment1)
.PARAMETER Module
    The dot-prefixed infra test units .internal and .scriptanalyzer are accepted too, and always widen the fold.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment2)
.PARAMETER HasIntegrityTests
    Integrity tests read the real repository beyond the module, so this folds in the repository-wide set.
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

    # The closure runs in its own scope, so a holder hashtable shares one tracked-file fetch across every set hashed.
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
                # Folding the aspect hashes covers the module's whole content, as the pre-aspect whole-module set did.
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

        # A group reference permits any member, so it expands to all members before the closure is walked.
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
            # An unlisted module has unknown dependencies, so widen to the whole repository: skip less, never wrongly.
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

    # Ordinal name order keeps the fold byte-identical on every machine and culture.
    # [comment:8](/docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md#comment8)
    $names = [string[]]$constituents
    [System.Array]::Sort($names, [System.StringComparer]::Ordinal)
    $stringBuilder = [System.Text.StringBuilder]::new()
    foreach ($setName in $names) {
        [void]$stringBuilder.Append($setName).Append('|').Append((& $setHash $setName)).Append("`n")
    }
    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
