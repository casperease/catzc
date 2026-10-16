<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/tests/types/BashConfig.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Languages
    relatives:
      source: automation/Catzc.Base.Languages/types/BashConfig.cs
---
#>

Describe 'BashConfig' -Tag 'L0' {

    Context 'integrity (shipped bash.yml)' -Tag 'integrity' {
        It 'loads the shipped bash.yml as a BashConfig, pinning the vendored bats-core' {
            $config = Get-Config -Config bash
            $config | Should -BeOfType [Catzc.Base.Languages.BashConfig]
            $config.bats_version | Should -Match '^\d+\.\d+\.\d+$'
            $config.bats_sha256 | Should -Match '^[0-9a-f]{64}$'
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        BeforeAll {
            $script:pin = [ordered]@{ bats_version = '1.2.3'; bats_sha256 = ('a' * 64) }
        }

        It 'resolves the Bash root to bash when the repository has a bash/ folder, else to .bash' {
            $config = [Catzc.Base.Languages.BashConfig]::new($script:pin)
            $withFolder = Join-Path $TestDrive 'with-bash'
            $null = New-Item -ItemType Directory -Path (Join-Path $withFolder 'bash') -Force
            $config.ResolveRoot($withFolder) | Should -Be 'bash'
            $without = Join-Path $TestDrive 'without-bash'
            $null = New-Item -ItemType Directory -Path $without -Force
            $config.ResolveRoot($without) | Should -Be '.bash'
        }

        It 'resolves to the declared root whatever is on disk' {
            $raw = [ordered]@{ root = 'test/sh'; bats_version = '1.2.3'; bats_sha256 = ('a' * 64) }
            $config = [Catzc.Base.Languages.BashConfig]::new($raw)
            $config.root | Should -Be 'test/sh'
            $config.ResolveRoot($TestDrive) | Should -Be 'test/sh'
        }

        It 'rejects <Case>, naming it' -ForEach @(
            @{ Case = 'an unknown key'; Raw = [ordered]@{ bats_version = '1.2.3'; bats_sha256 = ('a' * 64); gadget = 1 }; Message = "*unknown key 'gadget'*" }
            @{ Case = 'an empty file'; Raw = $null; Message = '*bats_version must be*bats_sha256 must be*' }
            @{ Case = 'a version that is no release'; Raw = [ordered]@{ bats_version = 'v1.2'; bats_sha256 = ('a' * 64) }; Message = '*bats_version must be*' }
            @{ Case = 'an uppercase digest'; Raw = [ordered]@{ bats_version = '1.2.3'; bats_sha256 = ('A' * 64) }; Message = '*bats_sha256 must be*' }
            @{ Case = 'a root with a parent segment'; Raw = [ordered]@{ root = '../widget'; bats_version = '1.2.3'; bats_sha256 = ('a' * 64) }; Message = "*invalid root '../widget'*" }
            @{ Case = 'a root with a leading slash'; Raw = [ordered]@{ root = '/widget'; bats_version = '1.2.3'; bats_sha256 = ('a' * 64) }; Message = "*invalid root '/widget'*" }
        ) {
            { [Catzc.Base.Languages.BashConfig]::new($Raw) } | Should -Throw $Message
        }
    }
}
