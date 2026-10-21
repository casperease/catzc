<#
---
catzc:
  immutable:
    with_body_sha: bb101a3b93fb
  edges:
    docs: "[Get-ModuleProtectionIdentity.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/tests/Get-ModuleProtectionIdentity.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
    cites:
      - ADR-REPO-PROTGLOB-COMPOSITEIDENTITY
---
#>

Describe 'Get-ModuleProtectionIdentity' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:dependencies = [Catzc.Base.ModuleSystem.DependenciesConfig]::new([ordered]@{
                groups  = [ordered]@{
                    Base = [ordered]@{
                        'Catzc.Base.Alpha' = @()
                        'Catzc.Base.Beta'  = @('Catzc.Base.Alpha')
                    }
                }
                modules = [ordered]@{
                    'Catzc.Gamma' = @('Base')
                }
            })
        # per-set hashes keyed by name; a test flips one entry to prove it re-keys (or not) the composite
        $script:setHashes = @{}
        foreach ($setName in @('catzc-base-alpha', 'catzc-base-beta', 'catzc-gamma', 'internal', 'vendor',
                'compiled', 'scriptanalyzer', 'catzc-base-quality-gates', 'repository', 'catzc-unknown')) {
            $script:setHashes[$setName] = ($setName + ('0' * 64)).Substring(0, 64)
        }

        Mock Get-Config { $script:dependencies } -ModuleName Catzc.Base.QualityGates
        Mock Get-TrackedFile { @('x/widget.ps1', 'x/gadget.ps1') } -ModuleName Catzc.Base.QualityGates
        Mock Get-ModuleGlobSet {
            [Catzc.Base.Globs.GlobSet]::new([Catzc.Base.Objects.NameCase]::Render($Name, 'kebab'), 'd', 'module', @('x/**'), @(), @(), @(), -1, $null)
        } -ModuleName Catzc.Base.QualityGates
        Mock Get-GlobSetHash {
            $byName = Get-Variable -Name Name -ValueOnly -ErrorAction Ignore
            $setName = if ($byName) {
                $byName
            }
            else {
                (Get-Variable -Name GlobSet -ValueOnly -ErrorAction Ignore).Name
            }
            $script:setHashes[$setName]
        } -ModuleName Catzc.Base.QualityGates
    }

    It 'is deterministic for the same inputs' {
        $first = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Beta' -HashCache @{}
        }
        $second = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Beta' -HashCache @{}
        }
        $first | Should -MatchExactly '^[0-9a-f]{64}$'
        $second | Should -Be $first
    }

    It 're-keys when a declared dependency''s set changes (the closure is in the fold)' {
        $before = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Beta' -HashCache @{}
        }
        $script:setHashes['catzc-base-alpha'] = 'f' * 64
        $after = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Beta' -HashCache @{}
        }
        $after | Should -Not -Be $before
    }

    It 'does not re-key on a module outside the closure' {
        $before = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Alpha' -HashCache @{}
        }
        $script:setHashes['catzc-base-beta'] = 'f' * 64   # Beta depends on Alpha, not the reverse
        $after = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Alpha' -HashCache @{}
        }
        $after | Should -Be $before
    }

    It 're-keys every module on a runner change' {
        $before = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Alpha' -HashCache @{}
        }
        $script:setHashes['catzc-base-quality-gates'] = 'f' * 64
        $after = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Alpha' -HashCache @{}
        }
        $after | Should -Not -Be $before
    }

    It 'expands a group reference to every member' {
        # Gamma declares [Base] — both Alpha and Beta are in its closure
        $before = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Gamma' -HashCache @{}
        }
        $script:setHashes['catzc-base-beta'] = 'f' * 64
        $after = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Gamma' -HashCache @{}
        }
        $after | Should -Not -Be $before
    }

    It 'widens to the repository-wide set: <why>' -ForEach @(
        @{ why = 'an unconstrained module'; module = 'Catzc.Unknown'; integrity = $false; outside = $false }
        @{ why = 'a module with integrity tests'; module = 'Catzc.Base.Alpha'; integrity = $true; outside = $false }
        @{ why = 'an infra test unit'; module = '.internal'; integrity = $false; outside = $false }
        @{ why = 'a module outside the modules folder'; module = 'Catzc.Widget'; integrity = $false; outside = $true }
    ) {
        $params = @{ Module = $module; HasIntegrityTests = $integrity; OutsideModulesFolder = $outside }
        $before = InModuleScope Catzc.Base.QualityGates -Parameters $params {
            param($Module, $HasIntegrityTests, $OutsideModulesFolder)
            Get-ModuleProtectionIdentity -Module $Module -HasIntegrityTests:$HasIntegrityTests -OutsideModulesFolder:$OutsideModulesFolder -HashCache @{}
        }
        $script:setHashes['repository'] = 'f' * 64
        $after = InModuleScope Catzc.Base.QualityGates -Parameters $params {
            param($Module, $HasIntegrityTests, $OutsideModulesFolder)
            Get-ModuleProtectionIdentity -Module $Module -HasIntegrityTests:$HasIntegrityTests -OutsideModulesFolder:$OutsideModulesFolder -HashCache @{}
        }
        $after | Should -Not -Be $before
    }

    It 'asks no globset of its own for a module outside the modules folder' {
        InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Widget' -OutsideModulesFolder -HashCache @{}
        } | Out-Null
        Should -Invoke Get-ModuleGlobSet -ModuleName Catzc.Base.QualityGates -Exactly -Times 0 -ParameterFilter { $Name -contains 'catzc-widget' }
    }

    It 'does not widen a constrained, logic-only module' {
        $before = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Alpha' -HashCache @{}
        }
        $script:setHashes['repository'] = 'f' * 64
        $after = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Alpha' -HashCache @{}
        }
        $after | Should -Be $before
    }

    It 'memoizes per-set hashes in the caller-owned cache' {
        InModuleScope Catzc.Base.QualityGates {
            $cache = @{}
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Alpha' -HashCache $cache | Out-Null
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Beta' -HashCache $cache | Out-Null
        } | Out-Null
        # Alpha's constituents: own + 4 infra + runner = 6; Beta adds only its own set (alpha etc. cached)
        Should -Invoke Get-GlobSetHash -ModuleName Catzc.Base.QualityGates -Exactly -Times 7
    }

    It 'fetches the tracked files once per call, hands them to every set hash, and not at all when all is cached' {
        InModuleScope Catzc.Base.QualityGates {
            $cache = @{}
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Alpha' -HashCache $cache | Out-Null
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Alpha' -HashCache $cache | Out-Null
        } | Out-Null
        Should -Invoke Get-TrackedFile -ModuleName Catzc.Base.QualityGates -Exactly -Times 1
        Should -Invoke Get-GlobSetHash -ModuleName Catzc.Base.QualityGates -Exactly -Times 6 -ParameterFilter {
            "$TrackedFile" -eq 'x/widget.ps1 x/gadget.ps1'
        }
    }
}
