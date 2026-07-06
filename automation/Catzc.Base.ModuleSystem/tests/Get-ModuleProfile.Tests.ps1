Describe 'Get-ModuleProfile' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.ModuleSystem {
            [pscustomobject]@{ profiles = [ordered]@{
                    azure = @('Catzc.Azure.Cli')
                    full  = @()
                }
            }
        }
        # Closure of the azure seed (mocked): the seed plus a Base dependency.
        Mock Get-ModuleDependencyClosure -ModuleName Catzc.Base.ModuleSystem {
            @('Catzc.Azure.Cli', 'Catzc.Base.Asserts')
        }
        # Used only for the empty-seed (full) path: every named module.
        Mock Get-BaseModule -ModuleName Catzc.Base.ModuleSystem {
            @(
                [pscustomobject]@{ Name = 'Catzc.Alpha' }
                [pscustomobject]@{ Name = 'Catzc.Beta' }
            )
        }
    }

    It 'resolves a named profile to its dependency closure plus fixed infrastructure' {
        $result = Get-ModuleProfile -Name azure
        $result | Should -Contain 'Catzc.Azure.Cli'
        $result | Should -Contain 'Catzc.Base.Asserts'   # from the closure
        $result | Should -Contain '.internal'
        $result | Should -Contain '.compiled'
        $result | Should -Contain '.vendor'
    }

    It 'an empty seed (full) resolves to every named module plus infrastructure' {
        $result = Get-ModuleProfile -Name full
        $result | Should -Contain 'Catzc.Alpha'
        $result | Should -Contain 'Catzc.Beta'
        $result | Should -Contain '.internal'
    }

    It '-NoInfrastructure omits the infrastructure modules' {
        $result = Get-ModuleProfile -Name azure -NoInfrastructure
        $result | Should -Not -Contain '.vendor'
        $result | Should -Contain 'Catzc.Azure.Cli'
    }

    It 'resolves an explicit -Modules seed through the same closure logic' {
        Get-ModuleProfile -Modules Catzc.Azure.Cli | Should -Contain 'Catzc.Base.Asserts'
    }

    It 'throws on an unknown profile name (ValidateScript)' {
        { Get-ModuleProfile -Name nope } | Should -Throw
    }
}

Describe 'Get-ModuleProfile — real profiles.yml' -Tag 'L2', 'integrity' {
    It 'every shipped profile resolves to a non-empty, on-disk module set' {
        $names = @((Get-Config -Config profiles).profiles.Keys)
        $names.Count | Should -BeGreaterThan 0
        $allowed = @((Get-BaseModule).Name) + @('.internal', '.compiled', '.vendor') | Select-Object -Unique
        # One Should over the violating set — a Should per profile × module pays Pester's
        # per-assertion cost times the whole shipped registry.
        $violations = foreach ($name in $names) {
            $resolved = Get-ModuleProfile -Name $name
            if (@($resolved).Count -eq 0) {
                "profile '$name' resolved to no modules"
            }
            foreach ($module in $resolved) {
                if ($module -notin $allowed) {
                    "profile '$name' resolved '$module', which is not an on-disk module"
                }
            }
        }
        @($violations) | Should -BeNullOrEmpty
    }
}
