<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
    folder: private
    name: get-module-protection-identity
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
    page: docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-ModuleProtectionIdentity.Tests.ps1
    cites:
      - ADR-DSGN-ASPECT
      - ADR-FLOW-CD-GLOBS#5
      - ADR-REPO-PROTGLOB
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

    $names = [string[]]$constituents
    [System.Array]::Sort($names, [System.StringComparer]::Ordinal)
    $stringBuilder = [System.Text.StringBuilder]::new()
    foreach ($setName in $names) {
        [void]$stringBuilder.Append($setName).Append('|').Append((& $setHash $setName)).Append("`n")
    }
    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
