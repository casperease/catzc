Describe 'Resolve-SessionToolHint' -Tag 'L0', 'logic' {
    # Fixture uses a .cmd shim + PATHEXT resolution — a Windows shape. The Unix path is analogous.
    BeforeAll {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_paths'
        }
    }

    BeforeEach {
        $script:origPath = $env:PATH
    }
    AfterEach {
        $env:PATH = $script:origPath
    }

    It 'prepends the hint dir and resolves when the command is present there' {
        $dir = Join-Path $TestDrive 'hintbin'
        [System.IO.Directory]::CreateDirectory($dir) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $dir 'faketool.cmd'), "@echo hi`r`n")
        InModuleScope Catzc.Tooling.Core -Parameters @{ dir = $dir } {
            param($dir)
            $config = [pscustomobject]@{ command = 'faketool'; session_path_hints = @($dir) }
            $cmd = Resolve-SessionToolHint -Config $config
            $cmd | Should -Not -BeNullOrEmpty
            ($env:PATH -split [System.IO.Path]::PathSeparator) | Should -Contain $dir
        }
    }

    It 'returns null and leaves PATH untouched when no hint contains the command' {
        $dir = Join-Path $TestDrive 'emptybin'
        [System.IO.Directory]::CreateDirectory($dir) | Out-Null
        InModuleScope Catzc.Tooling.Core -Parameters @{ dir = $dir } {
            param($dir)
            $before = $env:PATH
            $config = [pscustomobject]@{ command = 'faketool'; session_path_hints = @($dir) }
            Resolve-SessionToolHint -Config $config | Should -BeNullOrEmpty
            $env:PATH | Should -Be $before
        }
    }

    It 'returns null when the tool has no hints' {
        InModuleScope Catzc.Tooling.Core {
            $config = [pscustomobject]@{ command = 'faketool'; session_path_hints = @() }
            Resolve-SessionToolHint -Config $config | Should -BeNullOrEmpty
        }
    }

    It 'skips a hint dir that does not exist and falls through to null' {
        InModuleScope Catzc.Tooling.Core {
            $config = [pscustomobject]@{ command = 'faketool'; session_path_hints = @('C:\does\not\exist\anywhere') }
            Resolve-SessionToolHint -Config $config | Should -BeNullOrEmpty
        }
    }
}
