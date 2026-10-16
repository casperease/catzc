<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Overlay/tests/Get-FunctionFileViolation.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Overlay
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Get-FunctionFileViolation' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:check = {
            param([string] $Name, [string] $Content)
            $path = Join-Path $TestDrive "$Name.ps1"
            Set-Content -Path $path -Value $Content
            @(Get-FunctionFileViolation -Path $path -RelativePath "widget/$Name.ps1")
        }
    }

    It 'passes one function named for the file' {
        & $check 'Get-Widget' "function Get-Widget {`n    param()`n}" | Should -BeNullOrEmpty
    }

    It 'reports <Case>' -ForEach @(
        @{ Case = 'two functions'; Content = "function Get-Widget { }`n" + 'function Get-Gadget { }'; Expected = '*widget/Get-Widget.ps1: must hold exactly one top-level statement*' }
        @{ Case = 'a function named apart from the file'; Content = 'function Get-Gadget { }'; Expected = "*defines function 'Get-Gadget', but the file is named for 'Get-Widget'*" }
        @{ Case = 'a top-level statement'; Content = "`$script:cache = 1`n" + 'function Get-Widget { }'; Expected = '*must hold exactly one top-level statement*' }
        @{ Case = 'a #requires'; Content = "#requires -Version 7.4`n" + 'function Get-Widget { }'; Expected = '*carries a #requires statement*' }
        @{ Case = 'a $PSScriptRoot read'; Content = "function Get-Widget {`n    `$PSScriptRoot`n}"; Expected = '*widget/Get-Widget.ps1:2: reads $PSScriptRoot*' }
        @{ Case = 'a file that does not parse'; Content = 'function Get-Widget {'; Expected = '*does not parse*' }
    ) {
        (& $check 'Get-Widget' $Content) -join "`n" | Should -BeLike $Expected
    }

    It 'parses a file once when two calls share one holder' {
        $path = Join-Path $TestDrive 'Get-Widget.ps1'
        Set-Content -Path $path -Value 'function Get-Widget { }'
        $parsed = [Catzc.Base.Repository.ParsedScripts]::new()
        $null = Get-FunctionFileViolation -Path $path -RelativePath 'widget/Get-Widget.ps1' -ParsedScripts $parsed
        $null = Get-FunctionFileViolation -Path $path -RelativePath 'widget/Get-Widget.ps1' -ParsedScripts $parsed
        $parsed.ParseCount | Should -Be 1
    }
}
