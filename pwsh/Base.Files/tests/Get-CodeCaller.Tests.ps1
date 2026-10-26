Describe 'Get-CodeCaller' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $files = [ordered]@{
            'widgets/Get-Widget.ps1'     = '[Catzc.Widget.WidgetConfig]::new()'
            'widgets/configs/widget.yml' = 'gadget_key: true'
            'docs/widget.md'             = 'The widgetconfig type is read once.'
            'docs/untracked.md'          = 'WidgetConfig'
            'assets/widget.bin'          = "WidgetConfig`0"
        }
        foreach ($relative in $files.Keys) {
            $full = Join-Path $script:root $relative
            $null = New-Item -ItemType File -Path $full -Force
            [System.IO.File]::WriteAllText($full, $files[$relative])
        }
        $script:tracked = @('widgets/Get-Widget.ps1', 'widgets/configs/widget.yml', 'docs/widget.md', 'docs/deleted.md',
            'assets/widget.bin')
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Files { $script:root }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Files { $script:tracked }
    }

    It 'lists every tracked text file that names the type, sorted, in any case' {
        Get-CodeCaller 'WidgetConfig' | Should -Be @('docs/widget.md', 'widgets/Get-Widget.ps1')
    }

    It 'lists a file once when it names any of several names' {
        Get-CodeCaller 'WidgetConfig', 'gadget_key' | Should -Be @('docs/widget.md', 'widgets/Get-Widget.ps1',
            'widgets/configs/widget.yml')
    }

    It 'skips an untracked, a deleted and a binary file' {
        $callers = @(Get-CodeCaller 'WidgetConfig')
        $callers | Should -Not -Contain 'docs/untracked.md'
        $callers | Should -Not -Contain 'docs/deleted.md'
        $callers | Should -Not -Contain 'assets/widget.bin'
    }

    It 'passes -Path to the tracked set, and returns nothing for a name no file holds' {
        @(Get-CodeCaller 'Gizmo' -Path 'widgets') | Should -HaveCount 0
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter { $Path -eq 'widgets' }
    }
}
