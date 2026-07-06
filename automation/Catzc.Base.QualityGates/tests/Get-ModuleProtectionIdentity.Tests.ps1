# The composite protection identity (ADR-PROTGLOB:8): own set + declared dependency closure + infra scopes
# + the runner; widened to the repository-wide set for integrity tests, unconstrained modules, and the infra
# test units. Memoized per run.
Describe 'Get-ModuleProtectionIdentity' -Tag 'L0', 'logic' {
    BeforeEach {
        # a small declared graph: Base group {Alpha <- Beta}; Gamma declared against the Base group;
        # 'Catzc.Unknown' appears nowhere (unconstrained).
        $script:dependencies = [ordered]@{
            groups  = [ordered]@{
                Base = [ordered]@{
                    'Catzc.Base.Alpha' = @()
                    'Catzc.Base.Beta'  = @('Catzc.Base.Alpha')
                }
            }
            modules = [ordered]@{
                'Catzc.Gamma' = @('Base')
            }
        }
        # per-set hashes keyed by name; a test flips one entry to prove it re-keys (or not) the composite
        $script:setHashes = @{}
        foreach ($setName in @('catzc-base-alpha', 'catzc-base-beta', 'catzc-gamma', 'internal', 'vendor',
                'compiled', 'scriptanalyzer', 'catzc-base-qualitygates', 'automation', 'catzc-unknown')) {
            $script:setHashes[$setName] = ($setName + ('0' * 64)).Substring(0, 64)
        }

        Mock Get-Config { $script:dependencies } -ModuleName Catzc.Base.QualityGates
        Mock Get-ModuleGlobSet {
            [Catzc.Base.Globs.GlobSet]::new($Name.ToLowerInvariant().Replace('.', '-'), 'd', 'module', @('x/**'), @(), @(), @(), -1, $null)
        } -ModuleName Catzc.Base.QualityGates
        Mock Get-GlobSetHash {
            # StrictMode-safe: read the bound auto-variable without referencing an unset $Name/$GlobSet
            # (the -Name path and the -GlobSet path each set only one of them).
            $byName = Get-Variable -Name Name -ValueOnly -ErrorAction Ignore
            $setName = if ($byName) { $byName } else { (Get-Variable -Name GlobSet -ValueOnly -ErrorAction Ignore).Name }
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
        $script:setHashes['catzc-base-qualitygates'] = 'f' * 64
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
        @{ why = 'an unconstrained module'; module = 'Catzc.Unknown'; integrity = $false }
        @{ why = 'a module with integrity tests'; module = 'Catzc.Base.Alpha'; integrity = $true }
        @{ why = 'an infra test unit'; module = '.internal'; integrity = $false }
    ) {
        $params = @{ Module = $module; HasIntegrityTests = $integrity }
        $before = InModuleScope Catzc.Base.QualityGates -Parameters $params {
            param($Module, $HasIntegrityTests)
            Get-ModuleProtectionIdentity -Module $Module -HasIntegrityTests:$HasIntegrityTests -HashCache @{}
        }
        $script:setHashes['automation'] = 'f' * 64
        $after = InModuleScope Catzc.Base.QualityGates -Parameters $params {
            param($Module, $HasIntegrityTests)
            Get-ModuleProtectionIdentity -Module $Module -HasIntegrityTests:$HasIntegrityTests -HashCache @{}
        }
        $after | Should -Not -Be $before
    }

    It 'does not widen a constrained, logic-only module' {
        $before = InModuleScope Catzc.Base.QualityGates {
            Get-ModuleProtectionIdentity -Module 'Catzc.Base.Alpha' -HashCache @{}
        }
        $script:setHashes['automation'] = 'f' * 64
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
}
