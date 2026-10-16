<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.KeyHandler/tests/Save-PSReadLineKeyHandlerSet.Tests.ps1
    folder: tests
    name: save-ps-read-line-key-handler-set-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.KeyHandler
    moduletype: pwsh-folder
    catzc_bundle: full
---
#>

Describe 'Save-PSReadLineKeyHandlerSet' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-PsModule { } -ModuleName Catzc.Tooling.KeyHandler
        Mock Get-PSReadLineKeyHandler {
            [pscustomobject]@{ Key = 'Ctrl+w'; Function = 'WidgetBackward' }
            [pscustomobject]@{ Key = 'Ctrl+g'; Function = 'GadgetForward' }
            [pscustomobject]@{ Key = 'Ctrl+x'; Function = '' }
        } -ModuleName Catzc.Tooling.KeyHandler
        Mock Write-FileIfChanged { $true } -ModuleName Catzc.Tooling.KeyHandler
        Mock Write-Message { } -ModuleName Catzc.Tooling.KeyHandler
    }

    It 'writes the bound handlers (key + function) to an explicit path without the source-tree guard' {
        Mock Assert-SourceTree { throw 'widget operates on the catzc source tree' } -ModuleName Catzc.Tooling.KeyHandler
        $target = Join-Path $TestDrive 'widget-bindings.yml'

        Save-PSReadLineKeyHandlerSet -Path $target

        Should -Invoke Assert-SourceTree -ModuleName Catzc.Tooling.KeyHandler -Times 0
        Should -Invoke Write-FileIfChanged -ModuleName Catzc.Tooling.KeyHandler -Times 1 -Exactly -ParameterFilter {
            $Path -eq $target -and $Content -match 'WidgetBackward' -and $Content -match 'GadgetForward' -and $Content -notmatch 'Ctrl\+x'
        }
    }

    It 'defaults to the source tree''s config, never the loaded module''s folder' {
        Mock Assert-SourceTree { } -ModuleName Catzc.Tooling.KeyHandler
        Mock Get-RepositoryRoot { Join-Path $TestDrive 'acme-repository' } -ModuleName Catzc.Tooling.KeyHandler
        $expected = Join-Path (Join-Path $TestDrive 'acme-repository') 'automation/Catzc.Tooling.KeyHandler/configs/key-handler-bindings.yml'

        Save-PSReadLineKeyHandlerSet

        Should -Invoke Assert-SourceTree -ModuleName Catzc.Tooling.KeyHandler -Times 1 -Exactly
        Should -Invoke Write-FileIfChanged -ModuleName Catzc.Tooling.KeyHandler -Times 1 -Exactly -ParameterFilter { $Path -eq $expected }
    }

    It 'refuses the default target when the session runs a built package, writing nothing' {
        Mock Assert-SourceTree { throw 'Save-PSReadLineKeyHandlerSet operates on the catzc source tree' } -ModuleName Catzc.Tooling.KeyHandler

        { Save-PSReadLineKeyHandlerSet } | Should -Throw '*source tree*'

        Should -Invoke Write-FileIfChanged -ModuleName Catzc.Tooling.KeyHandler -Times 0
    }
}
