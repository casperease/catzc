Describe 'Install-Uv' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'uv'; version = '0.11' } } -ModuleName Catzc.Tooling.Toolchain
        Mock Install-Tool { } -ModuleName Catzc.Tooling.Toolchain
        Mock Install-UvStandalone { } -ModuleName Catzc.Tooling.Toolchain
        Mock Invoke-Executable { } -ModuleName Catzc.Tooling.Toolchain
        Mock Sync-SessionPath { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolVersion { '0.11.26' } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'bootstraps the platform way when uv is absent — package manager, or the Linux standalone release' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Toolchain
        Install-Uv
        if ($IsLinux) {
            Should -Invoke Install-UvStandalone -ModuleName Catzc.Tooling.Toolchain -Times 1
            Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 0
        }
        else {
            Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1
            Should -Invoke Install-UvStandalone -ModuleName Catzc.Tooling.Toolchain -Times 0
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'is idempotent when already at the locked version' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Toolchain
        Install-Uv
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'upgrades an off-pin uv through its configured source, never a blanket self-update' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolVersion { '0.9.5' } -ModuleName Catzc.Tooling.Toolchain
        # A uv resolved outside the winget package root (on Windows, the receipt-backed Astral-script case).
        Mock Get-Command { [pscustomobject]@{ Source = Join-Path ([IO.Path]::GetTempPath()) 'local-bin/uv' } } -ParameterFilter { $Name -eq 'uv' } -ModuleName Catzc.Tooling.Toolchain
        Install-Uv
        if ($IsLinux) {
            # Tarball build has no self-update receipt — re-run the standalone install.
            Should -Invoke Install-UvStandalone -ModuleName Catzc.Tooling.Toolchain -Times 1
            Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 0 -ParameterFilter { $Command -eq 'uv self update' }
        }
        elseif ($IsMacOS) {
            # brew-managed — upgrade through brew, not self-update.
            Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1
            Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 0 -ParameterFilter { $Command -eq 'uv self update' }
        }
        else {
            # Windows, uv outside the winget root — receipt-backed self-update is the one valid case.
            Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Command -eq 'uv self update' }
            Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 0
        }
    }

    It 'routes a winget-installed uv through the winget upgrade path' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_winget'; return
        }
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-ToolVersion { '0.9.5' } -ModuleName Catzc.Tooling.Toolchain
        $wingetUv = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages\astral-sh.uv_x\uv.exe'
        Mock Get-Command { [pscustomobject]@{ Source = $wingetUv } } -ParameterFilter { $Name -eq 'uv' } -ModuleName Catzc.Tooling.Toolchain
        Install-Uv -Force
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 0
    }
}

Describe 'Install-UvStandalone' -Tag 'L1', 'logic' {
    BeforeAll {
        # A release fixture the resolver walks: newest first (the GitHub API order), one release per line of
        # the matching logic — off-pin newer, two on-pin (newest wins), off-pin older. Both architectures
        # carry assets so the test is agnostic to the machine it runs on.
        $script:newAsset = {
            param($tag)
            foreach ($architecture in 'x86_64', 'aarch64') {
                [pscustomobject]@{
                    name                 = "uv-$architecture-unknown-linux-gnu.tar.gz"
                    digest               = "sha256:$('a' * 64)"
                    browser_download_url = "https://example.com/uv/$tag/uv-$architecture-unknown-linux-gnu.tar.gz"
                }
            }
        }
        $script:releases = @(
            [pscustomobject]@{ tag_name = '0.12.0'; assets = @(& $script:newAsset '0.12.0') }
            [pscustomobject]@{ tag_name = '0.11.7'; assets = @(& $script:newAsset '0.11.7') }
            [pscustomobject]@{ tag_name = '0.11.2'; assets = @(& $script:newAsset '0.11.2') }
            [pscustomobject]@{ tag_name = '0.10.9'; assets = @(& $script:newAsset '0.10.9') }
        )
    }

    BeforeEach {
        # The helper reads $env:HOME (the uv tool-bin anchor) and prepends to $env:PATH — snapshot both and
        # restore after each test (ADR-PSENV:4).
        $script:savedHome = $env:HOME
        $script:savedPath = $env:PATH
        $env:HOME = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))

        Mock Write-Message -ModuleName Catzc.Tooling.Toolchain { }
        Mock Invoke-RestMethod -ModuleName Catzc.Tooling.Toolchain { $script:releases }
        Mock Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain { }
        Mock Assert-Command -ModuleName Catzc.Tooling.Toolchain { }
        # The tar boundary: plant the extracted tree (a versioned folder holding uv and uvx) into the -C
        # directory the command names, as the real tar would.
        Mock Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Command -like 'tar *' } -MockWith {
            $null = $Command -match '-C "([^"]+)"'
            $extracted = Join-Path $Matches[1] 'uv-x86_64-unknown-linux-gnu'
            [System.IO.Directory]::CreateDirectory($extracted) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $extracted 'uv'), 'binary')
            [System.IO.File]::WriteAllText((Join-Path $extracted 'uvx'), 'binary')
        }
        Mock Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Command -like 'chmod *' } -MockWith { }
    }

    AfterEach {
        $env:HOME = $script:savedHome
        $env:PATH = $script:savedPath
    }

    It 'resolves the newest release matching the locked prefix and verifies its published digest' {
        InModuleScope Catzc.Tooling.Toolchain { Install-UvStandalone -Version '0.11' }
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter {
            $Uri -like '*/0.11.7/*' -and $Sha256 -eq "sha256:$('a' * 64)"
        }
    }

    It 'copies uv and uvx into the uv tool-bin and marks them executable' {
        InModuleScope Catzc.Tooling.Toolchain { Install-UvStandalone -Version '0.11' }
        Join-Path $env:HOME '.local/bin/uv' | Should -Exist
        Join-Path $env:HOME '.local/bin/uvx' | Should -Exist
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 2 -ParameterFilter { $Command -like 'chmod +x *' }
    }

    It 'prepends the tool-bin to the session PATH when it is missing' {
        InModuleScope Catzc.Tooling.Toolchain { Install-UvStandalone -Version '0.11' }
        ($env:PATH -split [System.IO.Path]::PathSeparator) | Should -Contain (Join-Path $env:HOME '.local/bin')
    }

    It 'throws when no release matches the locked prefix' {
        { InModuleScope Catzc.Tooling.Toolchain { Install-UvStandalone -Version '9.99' } } |
            Should -Throw '*No astral-sh/uv release matches*'
    }

    It 'refuses a release asset with no published digest' {
        Mock Invoke-RestMethod -ModuleName Catzc.Tooling.Toolchain {
            @([pscustomobject]@{
                    tag_name = '0.11.7'
                    assets   = @(foreach ($architecture in 'x86_64', 'aarch64') {
                            [pscustomobject]@{ name = "uv-$architecture-unknown-linux-gnu.tar.gz"; browser_download_url = 'https://example.com/x' }
                        })
                })
        }
        { InModuleScope Catzc.Tooling.Toolchain { Install-UvStandalone -Version '0.11' } } |
            Should -Throw '*no published SHA-256*'
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 0
    }
}
