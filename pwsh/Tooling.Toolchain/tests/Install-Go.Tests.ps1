Describe 'Install-Go' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:goHome = Join-Path $TestDrive 'go-home'
        $script:binary = Join-Path $script:goHome ($IsWindows ? 'bin/go.exe' : 'bin/go')
        $script:goConfig = [Catzc.Base.Execution.ToolConfig]::new(@{
                version = '1.27'; command = 'go'; script_install = $true; version_command = 'go version'
                version_pattern = 'go version go(?<ver>[\d.]+)'
            })

        function New-GoHome {
            param([string] $Root)
            $file = Join-Path $Root ($IsWindows ? 'bin/go.exe' : 'bin/go')
            [System.IO.Directory]::CreateDirectory((Split-Path $file)) | Out-Null
            [System.IO.File]::WriteAllText($file, '')
        }

        function New-Probe {
            param([string] $Version, [string] $Path = $script:binary)
            $method = if ($Path) {
                'probe'
            }
            else {
                'none'
            }
            [Catzc.Base.Execution.ExecutableProbe]::new('go', $Path, $method, $Version, '1.27', [bool]$Version, 1, 1,
                'Person')
        }

        # A real archive holding the go/ tree, as the go.dev .zip does.
        $script:fixtureZip = Join-Path $TestDrive 'go-widget.zip'
        $tree = Join-Path $TestDrive 'zip-tree'
        New-GoHome (Join-Path $tree 'go')
        [System.IO.Compression.ZipFile]::CreateFromDirectory($tree, $script:fixtureZip)
    }
    BeforeEach {
        if (Test-Path $script:goHome) {
            Remove-Item $script:goHome -Recurse -Force
        }
        $script:homeVersion = '1.27.2'
        Mock Get-ToolConfig { $script:goConfig } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ScriptInstallDir { $script:goHome } -ModuleName Catzc.Tooling.Toolchain
        Mock Invoke-Executable { [pscustomobject]@{ Full = "go version go$($script:homeVersion) windows/amd64" } } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Command -like '*version' }
        Mock Invoke-Executable { New-GoHome (Join-Path "$($script:goHome).staging" 'go') } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Command -like 'tar *' }
        Mock Assert-Command { } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-GoRelease { [pscustomobject]@{ version = 'go1.27.2'; filename = 'go1.27.2.widget-amd64.zip'; sha256 = 'abc123' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Save-VerifiedDownload { Copy-Item -LiteralPath $script:fixtureZip -Destination $OutFile; $OutFile } -ModuleName Catzc.Tooling.Toolchain
        Mock Add-PermanentPath { } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-Tool { New-Probe '1.27.2' } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $PassThru }
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'installs the newest patch of the locked version into the managed home, verified, and puts its bin on PATH' {
        # Not found before the install, found at the locked version after it.
        $script:calls = 0
        Mock Test-Tool {
            $script:calls++
            if ($script:calls -eq 1) {
                New-Probe $null $null
            }
            else {
                New-Probe '1.27.2'
            }
        } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $PassThru }

        Install-Go

        Should -Invoke Get-GoRelease -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Version -eq '1.27' }
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Uri -eq 'https://go.dev/dl/go1.27.2.widget-amd64.zip' -and $Sha256 -eq 'abc123'
        }
        Test-Path $script:binary | Should -BeTrue
        Test-Path "$($script:goHome).staging" | Should -BeFalse
        Should -Invoke Add-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Path -eq (Join-Path $script:goHome 'bin') -and $Prepend
        }
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Message -like 'Go 1.27.2 installed successfully*' }
    }

    It 'extracts a .zip in-process, never through tar' {
        Mock Test-Tool { New-Probe $null $null } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $PassThru -and -not (Test-Path $script:binary) }
        Install-Go
        Test-Path $script:binary | Should -BeTrue
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 0 -Exactly -ParameterFilter { $Command -like 'tar *' }
        Should -Invoke Assert-Command -ModuleName Catzc.Tooling.Toolchain -Times 0 -Exactly
    }

    It 'extracts a .tar.gz with tar inside the staging folder, by its relative name' {
        Mock Get-GoRelease { [pscustomobject]@{ version = 'go1.27.2'; filename = 'go1.27.2.widget-amd64.tar.gz'; sha256 = 'abc123' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Save-VerifiedDownload { $OutFile } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-Tool { New-Probe $null $null } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $PassThru -and -not (Test-Path $script:binary) }
        Install-Go
        Test-Path $script:binary | Should -BeTrue
        Should -Invoke Assert-Command -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'tar -xzf "go1.27.2.widget-amd64.tar.gz"' -and $WorkingDirectory -eq "$($script:goHome).staging"
        }
    }

    It 'skips the download when the managed home holds the locked version, and still converges PATH' {
        New-GoHome $script:goHome
        Install-Go
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 0 -Exactly
        Should -Invoke Add-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Message -like 'Go 1.27 is already installed*' }
    }

    It 'refuses a wrong version in the managed home without -Force' {
        New-GoHome $script:goHome
        $script:homeVersion = '1.24.4'
        { Install-Go } | Should -Throw '*expected 1.27.x, found 1.24.4*Install-Go -Force*'
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 0 -Exactly
    }

    It 'replaces a wrong version in the managed home with -Force' {
        New-GoHome $script:goHome
        [System.IO.File]::WriteAllText((Join-Path $script:goHome 'stale.txt'), '')
        $script:homeVersion = '1.24.4'
        Install-Go -Force
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly
        Test-Path (Join-Path $script:goHome 'stale.txt') | Should -BeFalse
        Test-Path $script:binary | Should -BeTrue
    }

    It 'leaves a Go at the locked version elsewhere untouched' {
        Mock Test-Tool { New-Probe '1.27.1' '/opt/widget/go/bin/go' } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $PassThru }
        Install-Go
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 0 -Exactly
        Should -Invoke Add-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 0 -Exactly
    }

    It 'throws when the check does not find the locked version after the install' {
        Mock Test-Tool { New-Probe '1.24.4' '/usr/local/go/bin/go' } -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $PassThru }
        { Install-Go } | Should -Throw '*found 1.24.4*'
    }
}
