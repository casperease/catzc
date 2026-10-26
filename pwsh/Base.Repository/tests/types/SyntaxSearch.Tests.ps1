# Each compiled search returns exactly what a PowerShell predicate over FindAll returns, so swapping one for the other changes nothing.
Describe 'SyntaxSearch' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:parse = {
            param([string] $Text)
            $tokens = $null
            $errors = $null
            [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref] $tokens, [ref] $errors)
        }
        $script:script = & $script:parse @'
function Get-Widget {
    $path = Join-Path $PSScriptRoot 'widget'
    Get-Gadget -Name 'cog'
    & $dynamicName
    $block = { Get-Gadget; $psscriptroot }
    function Get-Nested { Get-Cog }
}
function Get-Gizmo {
    Catzc.Base.Widget\Get-Gadget
    $PSScriptRoots
}
Get-Gadget
'@
    }

    Context 'Commands' {
        It 'lists every command call in document order, nested script blocks included' {
            $names = [Catzc.Base.Repository.SyntaxSearch]::Commands($script:script) |
                ForEach-Object { $_.GetCommandName() }
            $names | Should -Be @('Join-Path', 'Get-Gadget', $null, 'Get-Gadget', 'Get-Cog',
                'Catzc.Base.Widget\Get-Gadget', 'Get-Gadget')
        }
    }

    Context 'CommandsNamed' {
        It 'matches the exact name, ignoring case, and leaves a module-qualified call out' {
            $found = [Catzc.Base.Repository.SyntaxSearch]::CommandsNamed($script:script, 'get-GADGET', $false)
            @($found).Count | Should -Be 3
            $found | ForEach-Object { $_.GetCommandName() } | Should -Not -Contain 'Catzc.Base.Widget\Get-Gadget'
        }

        It 'also matches a module-qualified call when asked' {
            $found = [Catzc.Base.Repository.SyntaxSearch]::CommandsNamed($script:script, 'Get-Gadget', $true)
            @($found).Count | Should -Be 4
        }

        It 'never matches a call whose name is dynamic' {
            $found = [Catzc.Base.Repository.SyntaxSearch]::CommandsNamed($script:script, 'dynamicName', $true)
            @($found).Count | Should -Be 0
        }

        It 'refuses an empty name' {
            { [Catzc.Base.Repository.SyntaxSearch]::CommandsNamed($script:script, '', $false) } |
                Should -Throw '*a command name is required*'
        }
    }

    Context 'VariableReads' {
        It 'matches the bare name, ignoring case, and not a longer name' {
            $found = [Catzc.Base.Repository.SyntaxSearch]::VariableReads($script:script, 'PSScriptRoot')
            @($found).Count | Should -Be 2
            $found | ForEach-Object { $_.VariablePath.UserPath } | Should -Not -Contain 'PSScriptRoots'
        }

        It 'refuses an empty name' {
            { [Catzc.Base.Repository.SyntaxSearch]::VariableReads($script:script, '') } |
                Should -Throw '*a variable name is required*'
        }
    }

    Context 'TopLevelFunctions' {
        It 'lists the functions defined at the top level, not the one nested in another function' {
            $found = [Catzc.Base.Repository.SyntaxSearch]::TopLevelFunctions($script:script)
            @($found | ForEach-Object Name) | Should -Be @('Get-Widget', 'Get-Gizmo')
        }

        It 'lists nothing for a script with no function' {
            $found = [Catzc.Base.Repository.SyntaxSearch]::TopLevelFunctions((& $script:parse 'Get-Gadget'))
            @($found).Count | Should -Be 0
        }
    }

    Context 'BareName' {
        It 'strips the scope qualifier: <Text>' -ForEach @(
            @{ Text = 'function script:New-Widget {}' }
            @{ Text = 'function Global:New-Widget {}' }
            @{ Text = 'function local:New-Widget {}' }
            @{ Text = 'function private:New-Widget {}' }
            @{ Text = 'function New-Widget {}' }
        ) {
            $function = [Catzc.Base.Repository.SyntaxSearch]::TopLevelFunctions((& $script:parse $Text)) |
                Select-Object -First 1
            [Catzc.Base.Repository.SyntaxSearch]::BareName($function) | Should -BeExactly 'New-Widget'
        }

        It 'refuses a null function' {
            { [Catzc.Base.Repository.SyntaxSearch]::BareName($null) } | Should -Throw '*function*'
        }
    }

    It 'refuses a null root' {
        { [Catzc.Base.Repository.SyntaxSearch]::Commands($null) } | Should -Throw '*root*'
    }
}
