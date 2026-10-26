Describe 'Find-ShadowingCommand' -Tag 'L0', 'logic' {
    BeforeEach {
        # Fresh folders per test: $TestDrive is shared by the whole Describe, so one test's copy would shadow the next's.
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:machineDir = Join-Path $root 'machine'
        $script:userDir = Join-Path $root 'user'
        [System.IO.Directory]::CreateDirectory($script:machineDir) | Out-Null
        [System.IO.Directory]::CreateDirectory($script:userDir) | Out-Null
        Mock Get-EnvironmentPath { $Scope -eq 'Machine' ? $script:machineDir : $script:userDir } -ModuleName Catzc.Tooling.Provisioning
    }

    It 'finds the machine copy ahead of the user one, the order a GUI app builds its PATH in' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_path_order'; return
        }
        New-Item -ItemType File -Path (Join-Path $script:machineDir 'widget.exe') | Out-Null
        New-Item -ItemType File -Path (Join-Path $script:userDir 'widget.exe') | Out-Null
        InModuleScope Catzc.Tooling.Provisioning { Find-ShadowingCommand 'widget' } | Should -Be (Join-Path $script:machineDir 'widget.exe')
    }

    It 'finds the user copy when the machine PATH holds none' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_path_order'; return
        }
        New-Item -ItemType File -Path (Join-Path $script:userDir 'widget.cmd') | Out-Null
        InModuleScope Catzc.Tooling.Provisioning { Find-ShadowingCommand 'widget' } | Should -Be (Join-Path $script:userDir 'widget.cmd')
    }

    It 'is null when neither PATH part holds the command' {
        InModuleScope Catzc.Tooling.Provisioning { Find-ShadowingCommand 'gadget' } | Should -BeNullOrEmpty
    }
}
