<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-toolchain/tests/Update-BatsVendor.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Update-BatsVendor' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path $TestDrive "repo-$([guid]::NewGuid().ToString('N'))"
        $script:target = Join-Path $script:root 'bash/.vendor/bats-core'
        $null = New-Item -ItemType File -Path (Join-Path $script:target 'stale/widget.txt') -Force
        $script:config = [Catzc.Base.Languages.BashConfig]::new([ordered]@{ bats_version = '1.2.3'; bats_sha256 = ('a' * 64) })
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Toolchain { $script:root }
        Mock Get-Config -ModuleName Catzc.Tooling.Toolchain -ParameterFilter { $Config -eq 'bash' } { $script:config }
        Mock Assert-Command -ModuleName Catzc.Tooling.Toolchain { }
        Mock Write-Message -ModuleName Catzc.Tooling.Toolchain { }
        Mock Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain { $OutFile }
        Mock Invoke-Executable -ModuleName Catzc.Tooling.Toolchain {
            $release = Join-Path $WorkingDirectory 'bats-core-1.2.3'
            foreach ($file in 'bin/bats', 'libexec/bats-core/bats', 'lib/bats-core/widget.bash', 'LICENSE.md', 'test/gadget.bats', 'docs/widget.md') {
                $null = New-Item -ItemType File -Path (Join-Path $release $file) -Force
            }
        }
    }

    It 'downloads the pinned release with its digest, and extracts it by relative name in a staging folder' {
        Update-BatsVendor
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Uri -eq 'https://github.com/bats-core/bats-core/archive/refs/tags/v1.2.3.tar.gz' -and $Sha256 -eq ('a' * 64)
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'tar -xzf "v1.2.3.tar.gz"' -and $WorkingDirectory -eq "$script:target.staging"
        }
    }

    It 'replaces the vendored folder with the runner''s files only, and removes the staging folder' {
        Update-BatsVendor
        $files = @(Get-ChildPath $script:target -File -Depth 64 -Exclude @() -PruneVendor $false | ForEach-Object {
                [System.IO.Path]::GetRelativePath($script:target, $_).Replace('\', '/')
            } | Sort-Object)
        $files | Should -Be @('bin/bats', 'lib/bats-core/widget.bash', 'libexec/bats-core/bats', 'LICENSE.md')
        Test-Path -LiteralPath "$script:target.staging" | Should -BeFalse
    }

    It 'leaves the vendored folder alone and removes the staging folder when the download is rejected' {
        Mock Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain { throw 'Checksum mismatch' }
        { Update-BatsVendor } | Should -Throw '*Checksum mismatch*'
        Test-Path -LiteralPath (Join-Path $script:target 'stale/widget.txt') | Should -BeTrue
        Test-Path -LiteralPath "$script:target.staging" | Should -BeFalse
    }
}
