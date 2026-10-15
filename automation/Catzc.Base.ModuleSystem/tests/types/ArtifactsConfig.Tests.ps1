<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/types/ArtifactsConfig.Tests.ps1
    kind: pester-test
---
#>

# The artifacts.yml type: constructing it maps and validates the parsed YAML, so a malformed publish-target map
# never loads through Get-Config -Config artifacts.
Describe 'Catzc.Base.ModuleSystem.ArtifactsConfig' -Tag 'L0' {
    BeforeAll {
        $script:valid = {
            [ordered]@{
                ado         = [ordered]@{ enabled = $false; organization = ''; project = ''; feed = '' }
                github      = [ordered]@{ enabled = $true; owner = 'widget'; repository = 'gadget'; feed = 'tst' }
                artifactory = [ordered]@{ enabled = $false; url = ''; repository = '' }
            }
        }

        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.ModuleSystem.ArtifactsConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the ArtifactsConfig constructor to throw'
        }
    }

    Context 'logic' -Tag 'logic' {
        It 'maps every publish target' {
            $config = [Catzc.Base.ModuleSystem.ArtifactsConfig]::new((& $script:valid))
            $config.ado.enabled | Should -BeFalse
            $config.ado.feed | Should -Be ''
            $config.github.enabled | Should -BeTrue
            $config.github.owner | Should -Be 'widget'
            $config.github['repository'] | Should -Be 'gadget'
            $config.artifactory.url | Should -Be ''
        }

        It 'throws when a target is missing' {
            $raw = & $script:valid
            $raw.Remove('artifactory')
            Get-ViolationMessage $raw | Should -BeLike "*Missing required top-level key: 'artifactory'*"
        }

        It 'throws when an enabled target has an empty coordinate' {
            $raw = & $script:valid
            $raw['ado']['enabled'] = $true
            Get-ViolationMessage $raw | Should -BeLike "*'ado.organization' must be non-empty while 'ado' is enabled*"
        }

        It 'throws when enabled is not a boolean' {
            $raw = & $script:valid
            $raw['artifactory']['enabled'] = 'yes'
            Get-ViolationMessage $raw | Should -BeLike "*'artifactory.enabled' must be true or false*"
        }

        It 'reports every violation in one throw: unknown keys, a missing coordinate, and a non-mapping target' {
            $raw = & $script:valid
            $raw['widget'] = 1
            $raw['github'].Remove('feed')
            $raw['github']['gadget'] = 'x'
            $raw['artifactory'] = 'tst'
            $message = Get-ViolationMessage $raw
            $message | Should -BeLike "*unknown top-level key 'widget'*"
            $message | Should -BeLike "*'github' has unknown key 'gadget'*"
            $message | Should -BeLike "*'github' is missing required key 'feed'*"
            $message | Should -BeLike "*'artifactory' must be a mapping*"
        }
    }

    Context 'integrity (shipped config)' -Tag 'integrity' {
        It 'the shipped artifacts.yml loads and validates' {
            $config = Get-Config -Config artifacts
            $config | Should -BeOfType ([Catzc.Base.ModuleSystem.ArtifactsConfig])
            @($config.Keys) | Should -Be @('ado', 'github', 'artifactory')
        }
    }
}
