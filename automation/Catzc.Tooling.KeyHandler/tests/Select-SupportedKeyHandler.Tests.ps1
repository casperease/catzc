# Neutral fixture function names (widget/gadget) — Select-SupportedKeyHandler is pure classification logic,
# so a logic fixture must not borrow real PSReadLine function names (ADR-TEST:3).
Describe 'Select-SupportedKeyHandler' -Tag 'L0', 'logic', 'ADR-TEST#22' {

    It 'marks a binding supported only when its function is in the allow-list' {
        $result = & (Get-Module Catzc.Tooling.KeyHandler) {
            $bindings = @(
                [ordered]@{ key = 'Ctrl+w'; function = 'Widget' }
                [ordered]@{ key = 'Alt+g'; function = 'Gadget' }
            )
            Select-SupportedKeyHandler -Binding $bindings -SupportedFunction @('Widget')
        }

        $result.Count | Should -Be 2
        ($result | Where-Object Function -EQ 'Widget').Supported | Should -BeTrue
        ($result | Where-Object Function -EQ 'Gadget').Supported | Should -BeFalse
    }

    It 'preserves the key for each binding' {
        $result = & (Get-Module Catzc.Tooling.KeyHandler) {
            Select-SupportedKeyHandler -Binding @([ordered]@{ key = 'Ctrl+w'; function = 'Widget' }) -SupportedFunction @('Widget')
        }
        $result[0].Key | Should -Be 'Ctrl+w'
    }

    It 'matches function names case-insensitively' {
        $result = & (Get-Module Catzc.Tooling.KeyHandler) {
            Select-SupportedKeyHandler -Binding @([ordered]@{ key = 'Alt+w'; function = 'Widget' }) -SupportedFunction @('widget')
        }
        $result[0].Supported | Should -BeTrue
    }

    It 'keeps repeated keys as separate classified records' {
        $result = & (Get-Module Catzc.Tooling.KeyHandler) {
            $bindings = @(
                [ordered]@{ key = 'Ctrl+w'; function = 'Widget' }
                [ordered]@{ key = 'Ctrl+w'; function = 'Gadget' }
            )
            Select-SupportedKeyHandler -Binding $bindings -SupportedFunction @('Widget')
        }
        $result.Count | Should -Be 2
    }

    It 'returns nothing for an empty binding set' {
        $result = & (Get-Module Catzc.Tooling.KeyHandler) {
            Select-SupportedKeyHandler -Binding @() -SupportedFunction @('Widget')
        }
        @($result).Count | Should -Be 0
    }

    It 'marks everything unsupported when the allow-list is empty' {
        $result = & (Get-Module Catzc.Tooling.KeyHandler) {
            Select-SupportedKeyHandler -Binding @([ordered]@{ key = 'Alt+w'; function = 'Widget' }) -SupportedFunction @()
        }
        $result[0].Supported | Should -BeFalse
    }
}
