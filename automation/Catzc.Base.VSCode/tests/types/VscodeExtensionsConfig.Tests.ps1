<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/tests/types/VscodeExtensionsConfig.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.VSCode
    relatives:
      source: automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
---
#>

Describe 'Catzc.Base.VSCode.VscodeExtensionsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.VSCode.VscodeExtensionsConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the VscodeExtensionsConfig constructor to throw'
        }
    }

    It 'accepts a well-formed registry' {
        $config = [Catzc.Base.VSCode.VscodeExtensionsConfig]::new([ordered]@{ recommendations = @('acme.tool-one', 'globex.tool-two') })
        $config.recommendations | Should -Be @('acme.tool-one', 'globex.tool-two')
    }

    It 'throws when recommendations is missing or empty' {
        Get-ViolationMessage ([ordered]@{}) | Should -BeLike '*non-empty list*'
        Get-ViolationMessage ([ordered]@{ recommendations = @() }) | Should -BeLike '*non-empty list*'
    }

    It 'throws on an id that is not publisher.name' {
        Get-ViolationMessage ([ordered]@{ recommendations = @('no-dot-here') }) | Should -BeLike '*not a publisher.name*'
    }

    It 'throws on a duplicate id, collecting every violation' {
        $message = Get-ViolationMessage ([ordered]@{ recommendations = @('acme.tool', 'acme.tool', 'bad id') })
        $message | Should -BeLike '*duplicate recommendation*'
        $message | Should -BeLike "*'bad id' is not a publisher.name*"
    }

    It 'throws on an unknown top-level key' {
        Get-ViolationMessage ([ordered]@{ recommendations = @('acme.tool'); widget = 1 }) | Should -BeLike "*unknown top-level key 'widget'*"
    }
}
