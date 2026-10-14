Describe 'New-GoWorkspace' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the seams (ADR-AUTO-TEST#6): a fixture config and a fixture repository root in $TestDrive.
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
        Mock Get-Config -ModuleName Catzc.Base.Languages {
            [Catzc.Base.Languages.GoConfig]::new([ordered]@{
                    go_version   = '1.23'
                    module_root  = 'acme/go/tests'
                    dependencies = [ordered]@{ 'example.com/widget' = 'v1.2.3'; 'example.com/assert' = 'v0.4.0' }
                })
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.Languages { throw 'rendering must not run a process' }
    }

    It 'renders go.work first, then one go.mod per Go test folder in ordinal folder order' {
        @(New-GoWorkspace).Target | Should -Be @('go.work', 'go/tests/catzc-gadget/go.mod', 'go/tests/catzc-widget/go.mod')
    }

    It 'renders go.work with the go directive and the sorted use entries' {
        $expected = @(
            '// GENERATED FILE — do not edit. Single source of truth:'
            '//   automation/Catzc.Base.Languages/configs/go.yml (rendered by New-GoWorkspace over the go/tests/*/ folders)'
            '// Regenerated on import by Build-RootConfig; edit the yml or the folders, not this file.'
            ''
            'go 1.23'
            ''
            'use ('
            "`t./go/tests/catzc-gadget"
            "`t./go/tests/catzc-widget"
            ')'
        ) -join "`n"
        (New-GoWorkspace -Target 'go.work').Content | Should -BeExactly ($expected + "`n")
    }

    It 'renders each go.mod with its module path, the go directive, and the sorted requires' {
        $expected = @(
            '// GENERATED FILE — do not edit. Single source of truth:'
            '//   automation/Catzc.Base.Languages/configs/go.yml (rendered by New-GoWorkspace over the go/tests/*/ folders)'
            '// Regenerated on import by Build-RootConfig; edit the yml or the folders, not this file.'
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
        $content | Should -Match ("`n" + 'module catzc/go/tests/catzc-gadget' + "`n`n" + 'go 1\.24' + "`n$")
        $content | Should -Not -Match 'require'
    }
}

Describe 'New-GoWorkspace — no Go test folders' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:emptyRoot = Join-Path $TestDrive 'empty'
        $null = New-Item -ItemType Directory -Path $script:emptyRoot -Force
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:emptyRoot }
        Mock Get-Config -ModuleName Catzc.Base.Languages { [Catzc.Base.Languages.GoConfig]::new([ordered]@{}) }
    }

    It 'renders only go.work, with no use block' {
        $files = @(New-GoWorkspace)
        $files.Target | Should -Be @('go.work')
        $files[0].Content | Should -Match "`ngo 1\.24`n$"
        $files[0].Content | Should -Not -Match 'use'
    }
}

Describe 'New-GoWorkspace — folder naming' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:badRoot = Join-Path $TestDrive 'bad'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:badRoot 'go/tests/Catzc.Widget') -Force
        Set-Content -LiteralPath (Join-Path $script:badRoot 'go/tests/Catzc.Widget/widget_test.go') -Value 'package widget'
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:badRoot }
        Mock Get-Config -ModuleName Catzc.Base.Languages { [Catzc.Base.Languages.GoConfig]::new([ordered]@{}) }
    }

    It 'throws on a folder not named in kebab case' {
        { New-GoWorkspace } | Should -Throw '*go/tests/Catzc.Widget/*kebab case*'
    }
}
