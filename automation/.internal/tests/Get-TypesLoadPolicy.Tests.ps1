<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/.internal/tests/Get-TypesLoadPolicy.Tests.ps1
    name: get-types-load-policy-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Internal.Tests
    moduletype: pwsh-folder
    catzc_bundle: minimal
---
#>

Describe 'Get-TypesLoadPolicy' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:shipped = [System.IO.Path]::Combine((Split-Path $PSScriptRoot -Parent), 'assets', 'types-load.yml')
        $script:modes = foreach ($h in 'console', 'headless') {
            foreach ($o in 'windows', 'unix') {
                foreach ($r in 'source', 'build') {
                    "$h.$o.$r"
                }
            }
        }

        function script:New-PolicyConfig {
            param([string] $Body)
            $path = Join-Path $TestDrive ('types-load-{0}.yml' -f [guid]::NewGuid().ToString('N'))
            [System.IO.File]::WriteAllText($path, $Body)
            $path
        }
        function script:Get-ModePolicy {
            param([string] $Mode, [hashtable] $Extra = @{})
            $h, $o, $r = $Mode -split '\.'
            Get-TypesLoadPolicy -HostKind $h -Os $o -RunMode $r @Extra
        }
    }

    Context 'the shipped table' {
        It 'has exactly the eight modes and no other row' {
            $cells = (ConvertFrom-Yaml ([System.IO.File]::ReadAllText($shipped)))['cells']
            @($cells.Keys | Sort-Object) | Should -Be @($modes | Sort-Object)
        }

        It 'answers <Mode> with load <Load>, trigger <Trigger>, shadowCopy <Shadow>' -ForEach @(
            @{ Mode = 'console.windows.source'; Load = 'lazy'; Trigger = 'lookup-hook'; Shadow = $true }
            @{ Mode = 'console.windows.build'; Load = 'lazy'; Trigger = 'lookup-hook'; Shadow = $true }
            @{ Mode = 'console.unix.source'; Load = 'lazy'; Trigger = 'lookup-hook'; Shadow = $false }
            @{ Mode = 'console.unix.build'; Load = 'lazy'; Trigger = 'lookup-hook'; Shadow = $false }
            @{ Mode = 'headless.windows.source'; Load = 'eager'; Trigger = 'none'; Shadow = $true }
            @{ Mode = 'headless.windows.build'; Load = 'eager'; Trigger = 'none'; Shadow = $true }
            @{ Mode = 'headless.unix.source'; Load = 'eager'; Trigger = 'none'; Shadow = $false }
            @{ Mode = 'headless.unix.build'; Load = 'eager'; Trigger = 'none'; Shadow = $false }
        ) {
            $policy = Get-ModePolicy $Mode
            $policy.Cell | Should -Be $Mode
            $policy.Load | Should -Be $Load
            $policy.Trigger | Should -Be $Trigger
            $policy.ShadowCopy | Should -Be $Shadow
            $policy.EagerTypes.Count | Should -Be 0
        }

        It 'puts a shadow copy on every Windows mode and on no Unix mode' {
            foreach ($mode in $modes) {
                (Get-ModePolicy $mode).ShadowCopy | Should -Be ($mode -like '*.windows.*')
            }
        }

        It 'keeps every console mode lazy and every headless mode eager' {
            foreach ($mode in $modes) {
                (Get-ModePolicy $mode).Load | Should -Be $(if ($mode -like 'console.*') {
                        'lazy'
                    }
                    else {
                        'eager'
                    })
            }
        }
    }

    Context 'defaults declared once' {
        It 'gives every mode the default row when the config has no rows' {
            $empty = New-PolicyConfig "cells: {}`n"
            foreach ($mode in $modes) {
                $policy = Get-ModePolicy $mode @{ ConfigPath = $empty }
                $policy.Load | Should -Be 'lazy'
                $policy.Trigger | Should -Be 'lookup-hook'
                $policy.ShadowCopy | Should -BeTrue
                $policy.EagerTypes.Count | Should -Be 0
            }
        }

        It 'fills a key the row leaves out from the default, keeping the keys it states' {
            $partial = New-PolicyConfig "cells:`n  console.unix.source:`n    shadowCopy: false`n"
            $policy = Get-ModePolicy 'console.unix.source' @{ ConfigPath = $partial }
            $policy.ShadowCopy | Should -BeFalse
            $policy.Load | Should -Be 'lazy'
            $policy.Trigger | Should -Be 'lookup-hook'
        }
    }

    Context 'resolution order' {
        It 'lets an explicit value outrank the config row' {
            $policy = Get-ModePolicy 'headless.windows.source' @{ Load = 'lazy'; Trigger = 'lookup-hook'; ShadowCopy = $false; EagerType = @('widget.Gadget') }
            $policy.Load | Should -Be 'lazy'
            $policy.Trigger | Should -Be 'lookup-hook'
            $policy.ShadowCopy | Should -BeFalse
            $policy.EagerTypes | Should -Be @('widget.Gadget')
        }

        It 'lets the config row outrank the default' {
            $row = New-PolicyConfig "cells:`n  console.windows.source:`n    load: eager`n    trigger: none`n    shadowCopy: false`n    eagerTypes: [widget.Gadget]`n"
            $policy = Get-ModePolicy 'console.windows.source' @{ ConfigPath = $row }
            $policy.Load | Should -Be 'eager'
            $policy.ShadowCopy | Should -BeFalse
            $policy.EagerTypes | Should -Be @('widget.Gadget')
        }
    }

    Context 'invariants' {
        It 'throws for trigger none with load lazy' {
            $bad = New-PolicyConfig "cells:`n  console.unix.build:`n    load: lazy`n    trigger: none`n"
            { Get-ModePolicy 'console.unix.build' @{ ConfigPath = $bad } } | Should -Throw '*none*eager*'
        }

        It 'throws for a row that is no mode' {
            $bad = New-PolicyConfig "cells:`n  console.windows.nightly:`n    load: lazy`n"
            { Get-ModePolicy 'console.windows.source' @{ ConfigPath = $bad } } | Should -Throw '*console.windows.nightly*'
        }

        It 'throws for an unknown setting naming the valid ones' {
            $bad = New-PolicyConfig "cells:`n  console.windows.source:`n    loaad: lazy`n"
            { Get-ModePolicy 'console.windows.source' @{ ConfigPath = $bad } } | Should -Throw '*loaad*'
        }

        It 'throws for an unknown load value' {
            $bad = New-PolicyConfig "cells:`n  console.windows.source:`n    load: sometimes`n"
            { Get-ModePolicy 'console.windows.source' @{ ConfigPath = $bad } } | Should -Throw '*sometimes*'
        }

        It 'throws for a shadowCopy that is not a boolean' {
            $bad = New-PolicyConfig "cells:`n  console.windows.source:`n    shadowCopy: maybe`n"
            { Get-ModePolicy 'console.windows.source' @{ ConfigPath = $bad } } | Should -Throw '*true or false*'
        }

        It 'throws for a missing config file and for a config without cells' {
            { Get-ModePolicy 'console.windows.source' @{ ConfigPath = (Join-Path $TestDrive 'absent.yml') } } | Should -Throw '*does not exist*'
            $noCells = New-PolicyConfig "other: 1`n"
            { Get-ModePolicy 'console.windows.source' @{ ConfigPath = $noCells } } | Should -Throw "*no 'cells'*"
        }

        It 'rejects a host, os or run mode outside the closed sets' {
            { Get-TypesLoadPolicy -HostKind interactive } | Should -Throw
            { Get-TypesLoadPolicy -Os macos } | Should -Throw
            { Get-TypesLoadPolicy -RunMode nightly } | Should -Throw
        }
    }

    Context 'engines' {
        It 'answers never for <Engine> without reading the table' -ForEach @(@{ Engine = 'bash' }, @{ Engine = 'zsh' }) {
            $policy = Get-TypesLoadPolicy -Engine $Engine -ConfigPath (Join-Path $TestDrive 'not-read.yml')
            $policy.Load | Should -Be 'never'
            $policy.Trigger | Should -Be 'none'
            $policy.ShadowCopy | Should -BeFalse
            $policy.Cell | Should -BeNullOrEmpty
        }
    }

    Context 'mode detection' {
        It 'derives os from the running system when none is given' {
            (Get-TypesLoadPolicy -HostKind console -RunMode source).Cell | Should -Be $(if ($IsWindows) {
                    'console.windows.source'
                }
                else {
                    'console.unix.source'
                })
        }

        It 'derives host as headless inside a pipeline and console outside one' {
            $savedBuild, $savedActions = $env:TF_BUILD, $env:GITHUB_ACTIONS
            try {
                $env:TF_BUILD = $null; $env:GITHUB_ACTIONS = $null
                (Get-TypesLoadPolicy -Os windows -RunMode source).Cell | Should -Be 'console.windows.source'
                $env:TF_BUILD = 'True'
                (Get-TypesLoadPolicy -Os windows -RunMode source).Cell | Should -Be 'headless.windows.source'
            }
            finally {
                $env:TF_BUILD, $env:GITHUB_ACTIONS = $savedBuild, $savedActions
            }
        }

        It 'reaches all eight modes by injected inputs on any machine' {
            @($modes | ForEach-Object { (Get-ModePolicy $_).Cell } | Sort-Object -Unique).Count | Should -Be 8
        }
    }
}
