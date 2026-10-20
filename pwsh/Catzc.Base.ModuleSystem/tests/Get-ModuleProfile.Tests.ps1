<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleProfile.Tests.ps1
    folder: tests
    name: get-module-profile-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Get-ModuleProfile.Tests.ps1.md](docs/references/pwsh/catzc-base-modulesystem/tests/Get-ModuleProfile.Tests.ps1.md)"
---
#>

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
        Mock Get-CatzcModule -ModuleName Catzc.Base.ModuleSystem {
            'Catzc.Alpha', 'Catzc.Beta' | ForEach-Object { [Catzc.Base.Modules.Module]::new($_, 'widgets', 'widget-folder', 'widgetry', "widgetry/$_", 'folder', $null, $null, $null, $null) }
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
        $allowed = @((Get-CatzcModule -EngineTrack).name) + @('.internal', '.compiled', '.vendor') | Select-Object -Unique
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
