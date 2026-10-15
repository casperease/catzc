<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.KeyHandler/tests/types/KeyHandlerSupportedConfig.Tests.ps1
    kind: test
---
#>

Describe 'Catzc.Tooling.KeyHandler.KeyHandlerSupportedConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Tooling.KeyHandler.KeyHandlerSupportedConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the KeyHandlerSupportedConfig constructor to throw'
        }
    }

    It 'maps the functions allow-list, in file order' {
        $config = [Catzc.Tooling.KeyHandler.KeyHandlerSupportedConfig]::new([ordered]@{ functions = @('AcceptLine', 'AddLine') })
        $config.functions | Should -Be @('AcceptLine', 'AddLine')
    }

    It 'throws when the functions key is missing' {
        Get-ViolationMessage ([ordered]@{}) | Should -BeLike "*has no 'functions' key*"
    }

    It 'throws when functions is empty' {
        Get-ViolationMessage ([ordered]@{ functions = @() }) | Should -BeLike "*'functions' is empty*"
    }

    It 'reports a blank entry and an unknown key in one throw' {
        $message = Get-ViolationMessage ([ordered]@{ functions = @('AcceptLine', ' '); widget = 1 })
        $message | Should -BeLike '*contains a blank entry*'
        $message | Should -BeLike "*unknown top-level key 'widget'*"
    }
}
