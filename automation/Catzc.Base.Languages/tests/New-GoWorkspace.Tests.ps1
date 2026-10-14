BeforeAll {
    # The generated-file header every rendered file starts with, naming the tests folder of the Go root.
    $script:headerFor = {
        param([string] $TestsFolder)
        @(
            '// GENERATED FILE — do not edit. Single source of truth:'
            "//   automation/Catzc.Base.Languages/configs/go.yml (rendered by New-GoWorkspace over the $TestsFolder/*/ folders)"
            '//   the go directive: the go pin in automation/Catzc.Tooling.Core/configs/tools.yml'
            '// Regenerated on import by Build-RootConfig; edit the yml or the folders, not this file.'
        )
    }
    $script:header = & $script:headerFor 'go/tests'
}

Describe 'New-GoWorkspace' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the seams (ADR-AUTO-TEST#6): a fixture config, a fixture tools.yml pin, and a fixture
        # repository root in $TestDrive.
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($file in 'go/tests/catzc-widget/widget_test.go', 'go/tests/catzc-gadget/inner/gadget_test.go', 'go/tests/.hidden/hidden_test.go') {
            $path = Join-Path $script:root $file
            $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
            Set-Content -LiteralPath $path -Value 'package widget'
        }
        # A folder holding only generated files is not a Go module.
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'go/tests/catzc-leftover') -Force
        Set-Content -LiteralPath (Join-Path $script:root 'go/tests/catzc-leftover/go.mod') -Value 'module stale'

        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.go.version' } { '1.23' }
        Mock Get-Config -ModuleName Catzc.Base.Languages {
            [Catzc.Base.Languages.GoConfig]::new([ordered]@{
                    module_root  = 'acme/go/tests'
                    dependencies = [ordered]@{ 'example.com/widget' = 'v1.2.3'; 'example.com/assert' = 'v0.4.0' }
                })
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.Languages { throw 'rendering must not run a process' }
    }

    It 'renders go.work first, then one go.mod per Go test folder in ordinal folder order' {
        @(New-GoWorkspace).Target | Should -Be @('go.work', 'go/tests/catzc-gadget/go.mod', 'go/tests/catzc-widget/go.mod')
    }

    It 'renders go.work with the go directive from the tools.yml pin and the sorted use entries' {
        $expected = @(
            $script:header
            ''
            'go 1.23'
            ''
            'use ('
            "`t./go/tests/catzc-gadget"
            "`t./go/tests/catzc-widget"
            ')'
        ) -join "`n"
        (New-GoWorkspace -Target 'go.work').Content | Should -BeExactly ($expected + "`n")
        Should -Invoke Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.go.version' }
    }

    It 'renders each go.mod with its module path, the go directive, and the sorted requires' {
        $expected = @(
            $script:header
            ''
            'module acme/go/tests/catzc-widget'
            ''
            'go 1.23'
            ''
            'require ('
            "`t" + 'example.com/assert v0.4.0'
            "`t" + 'example.com/widget v1.2.3'
            ')'
        ) -join "`n"
        (New-GoWorkspace -Target 'go/tests/catzc-widget/go.mod').Content | Should -BeExactly ($expected + "`n")
    }

    It 'selects files with a wildcard -Target' {
        @(New-GoWorkspace -Target 'go/tests/*/go.mod').Target | Should -Be @('go/tests/catzc-gadget/go.mod', 'go/tests/catzc-widget/go.mod')
        @(New-GoWorkspace -Target 'nothing').Count | Should -Be 0
    }

    It 'is byte-stable: LF only, one trailing newline, identical on every call' {
        $first = @(New-GoWorkspace)
        $second = @(New-GoWorkspace)
        foreach ($i in 0..($first.Count - 1)) {
            $first[$i].Content | Should -BeExactly $second[$i].Content
            $first[$i].Content | Should -Not -Match "`r"
            $first[$i].Content | Should -Match "[^`n]`n$"
        }
    }

    It 'renders offline, without running the go tool' {
        $null = New-GoWorkspace
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Languages -Times 0 -Exactly
    }

    It 'omits the require block when no dependency is declared' {
        Mock Get-Config -ModuleName Catzc.Base.Languages { [Catzc.Base.Languages.GoConfig]::new([ordered]@{}) }
        $content = (New-GoWorkspace -Target 'go/tests/catzc-gadget/go.mod').Content
        $content | Should -Match ("`n" + 'module catzc/go/tests/catzc-gadget' + "`n`n" + 'go 1\.23' + "`n$")
        $content | Should -Not -Match 'require'
    }

    It 'takes a full 1.N.P pin as it is' {
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.go.version' } { '1.23.4' }
        (New-GoWorkspace -Target 'go.work').Content | Should -Match "`ngo 1\.23\.4`n"
    }

    It 'throws on a pin that is not a go directive version' -ForEach @('2.0', '1', 'v1.27', '1.27rc1', '') {
        $script:pin = $_
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.go.version' } { $script:pin }
        { New-GoWorkspace } | Should -Throw "*tools.yml go.version '$($script:pin)' is not a Go language version*"
    }
}

Describe 'New-GoWorkspace — a go/tests/widget/ fixture tree' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'widget-repo'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:widgetRoot 'go/tests/widget') -Force
        Set-Content -LiteralPath (Join-Path $script:widgetRoot 'go/tests/widget/widget_test.go') -Value 'package widget'
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:widgetRoot }
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.go.version' } { '1.27' }
        Mock Get-Config -ModuleName Catzc.Base.Languages { [Catzc.Base.Languages.GoConfig]::new([ordered]@{}) }
    }

    It 'renders the exact bytes of go.work and go/tests/widget/go.mod, with the pin as the go directive' {
        $files = @(New-GoWorkspace)
        $files.Target | Should -Be @('go.work', 'go/tests/widget/go.mod')
        $files[0].Content | Should -BeExactly ((@($script:header; ''; 'go 1.27'; ''; 'use ('; "`t./go/tests/widget"; ')') -join "`n") + "`n")
        $files[1].Content | Should -BeExactly ((@($script:header; ''; 'module catzc/go/tests/widget'; ''; 'go 1.27') -join "`n") + "`n")
    }

    It 'renders the same bytes on every call' {
        $first = [System.Text.Encoding]::UTF8.GetBytes((@(New-GoWorkspace).Content -join ''))
        $second = [System.Text.Encoding]::UTF8.GetBytes((@(New-GoWorkspace).Content -join ''))
        [System.Convert]::ToHexString($second) | Should -BeExactly ([System.Convert]::ToHexString($first))
    }
}

Describe 'New-GoWorkspace — the Go root' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:layoutRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:layoutRoot }
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.go.version' } { '1.27' }
        Mock Get-Config -ModuleName Catzc.Base.Languages { [Catzc.Base.Languages.GoConfig]::new([ordered]@{}) }
        $script:addWidget = {
            param([string] $TestsFolder)
            $path = Join-Path $script:layoutRoot "$TestsFolder/widget/widget_test.go"
            $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
            Set-Content -LiteralPath $path -Value 'package widget'
        }
    }

    It 'defaults to .go/ when the repository has no go/ folder, with go.work still at the repository root' {
        & $script:addWidget '.go/tests'
        $files = @(New-GoWorkspace)
        $files.Target | Should -Be @('go.work', '.go/tests/widget/go.mod')
        $files[0].Content | Should -BeExactly ((@((& $script:headerFor '.go/tests'); ''; 'go 1.27'; ''; 'use ('; "`t./.go/tests/widget"; ')') -join "`n") + "`n")
        $files[1].Content | Should -BeExactly ((@((& $script:headerFor '.go/tests'); ''; 'module catzc/go/tests/widget'; ''; 'go 1.27') -join "`n") + "`n")
    }

    It 'defaults to go/ when the repository has a go/ folder, and ignores a .go/ beside it' {
        & $script:addWidget 'go/tests'
        & $script:addWidget '.go/tests'
        $files = @(New-GoWorkspace)
        $files.Target | Should -Be @('go.work', 'go/tests/widget/go.mod')
        $files[0].Content | Should -Match "`n`t\./go/tests/widget`n"
    }

    It 'takes a declared root over both defaults' {
        & $script:addWidget 'go/tests'
        & $script:addWidget 'test/gadget-go/tests'
        Mock Get-Config -ModuleName Catzc.Base.Languages { [Catzc.Base.Languages.GoConfig]::new([ordered]@{ root = 'test/gadget-go' }) }
        $files = @(New-GoWorkspace)
        $files.Target | Should -Be @('go.work', 'test/gadget-go/tests/widget/go.mod')
        $files[0].Content | Should -Match "`n`t\./test/gadget-go/tests/widget`n"
    }

    It 'matches both layouts with the one registry pattern */tests/*/go.mod' {
        & $script:addWidget '.go/tests'
        @(New-GoWorkspace -Target '*/tests/*/go.mod').Target | Should -Be @('.go/tests/widget/go.mod')
        & $script:addWidget 'go/tests'
        @(New-GoWorkspace -Target '*/tests/*/go.mod').Target | Should -Be @('go/tests/widget/go.mod')
    }
}

Describe 'New-GoWorkspace — no Go test folders' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:emptyRoot = Join-Path $TestDrive 'empty'
        $null = New-Item -ItemType Directory -Path $script:emptyRoot -Force
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:emptyRoot }
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.go.version' } { '1.27' }
        Mock Get-Config -ModuleName Catzc.Base.Languages { [Catzc.Base.Languages.GoConfig]::new([ordered]@{}) }
    }

    It 'renders only go.work, with no use block' {
        $files = @(New-GoWorkspace)
        $files.Target | Should -Be @('go.work')
        $files[0].Content | Should -Match "`ngo 1\.27`n$"
        $files[0].Content | Should -Not -Match 'use'
    }
}

Describe 'New-GoWorkspace — folder naming' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:badRoot = Join-Path $TestDrive 'bad'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:badRoot 'go/tests/Catzc.Widget') -Force
        Set-Content -LiteralPath (Join-Path $script:badRoot 'go/tests/Catzc.Widget/widget_test.go') -Value 'package widget'
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:badRoot }
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.go.version' } { '1.27' }
        Mock Get-Config -ModuleName Catzc.Base.Languages { [Catzc.Base.Languages.GoConfig]::new([ordered]@{}) }
    }

    It 'throws on a folder not named in kebab case' {
        { New-GoWorkspace } | Should -Throw '*go/tests/Catzc.Widget/*kebab case*'
    }
}

Describe 'New-GoWorkspace — the shipped tools.yml pin' -Tag 'L1', 'integrity' {
    It 'writes the go tool''s tools.yml pin as the go directive of go.work' {
        $pin = "$(Get-ConfigValue -Address 'global.tools.go.version')"
        $pin | Should -Not -BeNullOrEmpty
        (New-GoWorkspace -Target 'go.work').Content | Should -Match ("`ngo " + [regex]::Escape($pin) + "`n")
    }
}
