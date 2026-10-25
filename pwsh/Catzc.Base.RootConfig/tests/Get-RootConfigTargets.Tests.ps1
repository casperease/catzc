Describe 'Get-RootConfigTargets' -Tag 'L0', 'logic' {
    It 'returns only the opted-in entries, in registry order' {
        $config = [pscustomobject]@{
            files = @(
                [pscustomobject]@{ target = 'a'; optIn = $true }
                [pscustomobject]@{ target = 'b'; optIn = $false }
                [pscustomobject]@{ target = 'c'; optIn = $true }
            )
        }
        $targets = InModuleScope Catzc.Base.RootConfig -Parameters @{ Config = $config } {
            param($Config) Get-RootConfigTargets -Config $Config
        }
        @($targets.target) | Should -Be @('a', 'c')
    }

    It 'returns an empty list when nothing is opted in' {
        $config = [pscustomobject]@{
            files = @([pscustomobject]@{ target = 'a'; optIn = $false })
        }
        $targets = InModuleScope Catzc.Base.RootConfig -Parameters @{ Config = $config } {
            param($Config) Get-RootConfigTargets -Config $Config
        }
        @($targets) | Should -HaveCount 0
    }

    Context 'an engine''s importer entry follows the mix' {
        BeforeAll {
            $script:entryConfig = [pscustomobject]@{
                files = @(
                    [pscustomobject]@{ target = 'importer.ps1'; optIn = $true }
                    [pscustomobject]@{ target = 'importer.sh'; optIn = $true }
                    [pscustomobject]@{ target = 'widget.json'; optIn = $true }
                )
            }
        }

        It '-FollowMix leaves out importer.sh when the mix holds only pwsh' -Tag 'ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX' {
            Mock Get-ImportMix -ModuleName Catzc.Base.RootConfig { [Catzc.Base.ModuleSystem.ImportMix]::new(@('powershell'), @('pwsh'), @(), [Catzc.Base.Engines.ExecutionEngines]::Names[1..2], @()) }
            $targets = InModuleScope Catzc.Base.RootConfig -Parameters @{ Config = $entryConfig } {
                param($Config) Get-RootConfigTargets -Config $Config -FollowMix
            }
            @($targets.target) | Should -Be @('importer.ps1', 'widget.json')
        }

        It '-FollowMix keeps importer.sh when a POSIX engine is in the mix' -Tag 'ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX' {
            Mock Get-ImportMix -ModuleName Catzc.Base.RootConfig { [Catzc.Base.ModuleSystem.ImportMix]::new(@('powershell'), [Catzc.Base.Engines.ExecutionEngines]::Names[0..1], @(), @('zsh'), @()) }
            $targets = InModuleScope Catzc.Base.RootConfig -Parameters @{ Config = $entryConfig } {
                param($Config) Get-RootConfigTargets -Config $Config -FollowMix
            }
            @($targets.target) | Should -Be @('importer.ps1', 'importer.sh', 'widget.json')
        }

        It '-FollowMix reads the mix only when an importer entry is opted in' {
            Mock Get-ImportMix -ModuleName Catzc.Base.RootConfig { throw 'not read' }
            $config = [pscustomobject]@{ files = @([pscustomobject]@{ target = 'widget.json'; optIn = $true }) }
            $targets = InModuleScope Catzc.Base.RootConfig -Parameters @{ Config = $config } {
                param($Config) Get-RootConfigTargets -Config $Config -FollowMix
            }
            @($targets.target) | Should -Be @('widget.json')
        }

        It 'without -FollowMix returns every opted-in entry and never reads the mix' -Tag 'ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX' {
            Mock Get-ImportMix -ModuleName Catzc.Base.RootConfig { throw 'not read' }
            $targets = InModuleScope Catzc.Base.RootConfig -Parameters @{ Config = $entryConfig } {
                param($Config) Get-RootConfigTargets -Config $Config
            }
            @($targets.target) | Should -Be @('importer.ps1', 'importer.sh', 'widget.json')
        }
    }
}
