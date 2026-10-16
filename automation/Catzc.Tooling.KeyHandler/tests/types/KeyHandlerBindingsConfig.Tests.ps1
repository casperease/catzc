<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.KeyHandler/tests/types/KeyHandlerBindingsConfig.Tests.ps1
    folder: tests/types
    name: key-handler-bindings-config-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.KeyHandler
    moduletype: pwsh-folder
    catzc_bundle: full
---
#>

Describe 'Catzc.Tooling.KeyHandler.KeyHandlerBindingsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Tooling.KeyHandler.KeyHandlerBindingsConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the KeyHandlerBindingsConfig constructor to throw'
        }

        # The parsed YAML of a top-level sequence: a List[object] (what ConvertFrom-Yaml -Ordered yields).
        function New-Sequence {
            param([object[]] $Item = @())
            $list = [System.Collections.Generic.List[object]]::new()
            foreach ($entry in $Item) {
                $list.Add($entry)
            }
            , $list
        }
    }

    It 'maps a sequence of key/function entries, in file order' {
        $raw = New-Sequence -Item @(
            [ordered]@{ key = 'Ctrl+w'; function = 'BackwardKillWord' }
            [ordered]@{ key = 'Enter'; function = 'AcceptLine' }
        )
        $config = [Catzc.Tooling.KeyHandler.KeyHandlerBindingsConfig]::new($raw)
        $config.bindings.Count | Should -Be 2
        $config.bindings[0].key | Should -Be 'Ctrl+w'
        $config.bindings[1]['function'] | Should -Be 'AcceptLine'
    }

    It 'throws when the config is not a sequence' {
        Get-ViolationMessage ([ordered]@{ key = 'Enter'; function = 'AcceptLine' }) | Should -BeLike '*must be a sequence*'
    }

    It 'throws when the sequence is empty' {
        Get-ViolationMessage (New-Sequence) | Should -BeLike '*is empty*'
    }

    It 'reports every malformed entry in one throw' {
        $raw = New-Sequence -Item @(
            'widget'
            [ordered]@{ key = ' '; function = 'AcceptLine' }
            [ordered]@{ key = 'Enter'; gadget = 1 }
        )
        $message = Get-ViolationMessage $raw
        $message | Should -BeLike '*entry 0 is not a key/function mapping*'
        $message | Should -BeLike "*entry 1 has no 'key'*"
        $message | Should -BeLike "*entry 2 has unknown key 'gadget'*"
        $message | Should -BeLike "*entry 2 has no 'function'*"
    }
}
