# The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
# ScriptBlockAst. The engine-wiring proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath)
# lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
Describe 'Measure-AnnounceStateChange' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/AnnounceStateChange.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
        # once for the type — we never invoke the analyzer engine (that is the L2 wiring test).
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        function Test-StateChange {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-AnnounceStateChange -ScriptBlockAst $ast
        }
    }

    Context 'an unannounced state change is flagged' {
        It 'flags <Desc>' -ForEach @(
            @{ Desc = 'a session env var'; Code = "function Set-Widget { `$env:WIDGET_HOME = 'C:\widget' }" }
            @{ Desc = 'a PATH rewrite'; Code = "function Set-Widget { `$env:PATH = 'C:\widget;' + `$env:PATH }" }
            @{ Desc = 'a SetEnvironmentVariable call'; Code = "function Set-Widget { [Environment]::SetEnvironmentVariable('WIDGET', 'x', 'User') }" }
            @{ Desc = 'Set-Item on env:'; Code = "function Set-Widget { Set-Item env:WIDGET 'x' }" }
            @{ Desc = 'Remove-Item on env:'; Code = 'function Remove-Widget { Remove-Item -Path env:WIDGET }' }
            @{ Desc = 'a binary load (Add-Type -Path)'; Code = "function Import-Widget { Add-Type -Path 'C:\widget.dll' }" }
            @{ Desc = 'an assembly LoadFrom'; Code = "function Import-Widget { [System.Reflection.Assembly]::LoadFrom('C:\widget.dll') }" }
            @{ Desc = 'an AssemblyLoadContext load'; Code = "function Import-Widget { `$context.LoadFromAssemblyPath('C:\widget.dll') }" }
            @{ Desc = 'Import-Module'; Code = "function Import-Widget { Import-Module 'C:\widget' -Scope Global }" }
            @{ Desc = 'Remove-Module'; Code = 'function Remove-Widget { Remove-Module Widget }' }
            @{ Desc = 'a global preference'; Code = "function Set-Widget { `$global:ErrorActionPreference = 'Stop' }" }
            @{ Desc = 'Set-Variable -Scope Global'; Code = 'function Set-Widget { Set-Variable -Name Gadget -Value 1 -Scope Global }' }
            @{ Desc = 'Push-Location never popped'; Code = "function Enter-Widget { Push-Location 'C:\widget' }" }
            @{ Desc = 'a PSReadLine key handler'; Code = 'function Set-Widget { Set-PSReadLineKeyHandler -Key Tab -Function Complete }' }
            @{ Desc = 'Update-FormatData'; Code = "function Set-Widget { Update-FormatData -PrependPath 'C:\widget.ps1xml' }" }
            @{ Desc = 'a change in a script''s top-level code'; Code = "`$env:WIDGET = 'x'" }
        ) {
            Test-StateChange $Code | Should -Not -BeNullOrEmpty
        }

        It 'does not count a writer in an unrelated branch' {
            $code = @'
function Set-Widget {
    param([switch] $Diagnose)
    $env:WIDGET = 'x'
    if ($Diagnose) {
        Write-Message 'took 3ms'
    }
}
'@
            Test-StateChange $code | Should -Not -BeNullOrEmpty
        }

        It 'does not count a verbose-routed Write-Message' {
            Test-StateChange "function Set-Widget { `$env:WIDGET = 'x'; Write-Message 'set' -Verbose }" | Should -Not -BeNullOrEmpty
        }

        It 'does not count a writer in another function' {
            $code = @'
function Set-Widget { $env:WIDGET = 'x' }
function Write-Gadget { Write-Message 'gadget' }
'@
            Test-StateChange $code | Should -HaveCount 1
        }

        It 'names the target and the function in the finding' {
            $finding = Test-StateChange "function Set-Widget { `$env:WIDGET_HOME = 'x' }"
            $finding.Message | Should -Match 'env:widget_home'
            $finding.Message | Should -Match "function 'Set-Widget'"
        }
    }

    Context 'an announced or non-lasting change passes' {
        It 'passes <Desc>' -ForEach @(
            @{ Desc = 'a change announced in the same block'; Code = "function Set-Widget { `$env:WIDGET = 'x'; Write-Message `"WIDGET='x'`" }" }
            @{ Desc = 'a change announced from an enclosing block'; Code = "function Set-Widget { if (`$a) { `$env:WIDGET = 'x' }; Write-Message 'set' }" }
            @{ Desc = 'a change announced in its own conditional block'; Code = "function Set-Widget { if (`$a) { `$env:WIDGET = 'x'; Write-Message 'set' } }" }
            @{ Desc = 'a bootstrap chokepoint announcement'; Code = "function Import-Widget { Add-Type -Path 'C:\widget.dll'; Write-ImporterMessage 'Loaded widget.dll' }" }
            @{ Desc = 'Add-Type -OutputAssembly (writes a DLL, loads nothing)'; Code = "function Build-Widget { Add-Type -Path 'a.cs' -OutputAssembly 'widget.dll' }" }
            @{ Desc = 'a reading env access'; Code = 'function Get-Widget { $env:WIDGET }' }
            @{ Desc = 'a local variable'; Code = "function Set-Widget { `$widget = 'x' }" }
            @{ Desc = '$global:LASTEXITCODE'; Code = 'function Invoke-Widget { $global:LASTEXITCODE = 3 }' }
            @{ Desc = 'a $global:__ bookkeeping variable'; Code = 'function Import-Widget { $global:__WidgetRegistry = @{} }' }
            @{ Desc = 'Remove-Variable LASTEXITCODE -Scope Global'; Code = 'function Reset-Widget { Remove-Variable LASTEXITCODE -Scope Global }' }
        ) {
            Test-StateChange $Code | Should -BeNullOrEmpty
        }

        It 'passes a change restored in a finally block' {
            $code = @'
function Invoke-Widget {
    $saved = $env:WIDGET
    try {
        $env:WIDGET = 'x'
        & widget
    }
    finally {
        $env:WIDGET = $saved
    }
}
'@
            Test-StateChange $code | Should -BeNullOrEmpty
        }

        It 'passes a Push-Location popped in a finally block' {
            $code = @'
function Invoke-Widget {
    Push-Location 'C:\widget'
    try {
        & widget
    }
    finally {
        Pop-Location
    }
}
'@
            Test-StateChange $code | Should -BeNullOrEmpty
        }

        It 'passes a change inside a scriptblock handed to <Owner>' -ForEach @(
            @{ Owner = 'Start-ThreadJob'; Code = "function Start-Widget { Start-ThreadJob -ScriptBlock { Import-Module 'C:\widget' } }" }
            @{ Owner = 'Start-Job'; Code = "function Start-Widget { Start-Job { `$env:WIDGET = 'x' } }" }
            @{ Owner = 'ForEach-Object -Parallel'; Code = "function Start-Widget { 1..2 | ForEach-Object -Parallel { `$env:WIDGET = 'x' } }" }
        ) {
            Test-StateChange $Code | Should -BeNullOrEmpty
        }

        It 'still flags a change in a plain ForEach-Object scriptblock (same runspace)' {
            Test-StateChange "function Set-Widget { 1..2 | ForEach-Object { `$env:WIDGET = 'x' } }" | Should -Not -BeNullOrEmpty
        }

        It 'skips test files, whose state changes belong to Pester' {
            $path = Join-Path $TestDrive 'Widget.Tests.ps1'
            [System.IO.File]::WriteAllText($path, "`$env:WIDGET = 'x'")
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$null, [ref]$null)
            Measure-AnnounceStateChange -ScriptBlockAst $ast | Should -BeNullOrEmpty
        }
    }
}
