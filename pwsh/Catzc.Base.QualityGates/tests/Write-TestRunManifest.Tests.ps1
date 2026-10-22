Describe 'Write-TestRunManifest' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:runDirectory = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [void][System.IO.Directory]::CreateDirectory($script:runDirectory)
    }

    It 'writes run.json with the given content and returns its path' {
        $path = InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
            param($Dir)
            # A non-date-shaped fixture value: ConvertFrom-Json auto-parses ISO strings into [datetime].
            Write-TestRunManifest -RunDirectory $Dir -Manifest ([ordered]@{ status = 'running'; startedAt = 'stamp-001' })
        }
        $path | Should -Be (Join-Path $script:runDirectory 'run.json')
        $manifest = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
        $manifest.status | Should -Be 'running'
        $manifest.startedAt | Should -Be 'stamp-001'
    }

    It 'replaces an existing manifest in place (the terminal overwrite)' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
            param($Dir)
            Write-TestRunManifest -RunDirectory $Dir -Manifest ([ordered]@{ status = 'running' }) | Out-Null
            Write-TestRunManifest -RunDirectory $Dir -Manifest ([ordered]@{ status = 'passed'; failedCount = 0 }) | Out-Null
        }
        $manifest = Get-Content -LiteralPath (Join-Path $script:runDirectory 'run.json') -Raw | ConvertFrom-Json
        $manifest.status | Should -Be 'passed'
        $manifest.failedCount | Should -Be 0
    }

    It 'leaves no temp file behind (atomic swap)' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $script:runDirectory } {
            param($Dir)
            Write-TestRunManifest -RunDirectory $Dir -Manifest ([ordered]@{ status = 'running' }) | Out-Null
        }
        @([System.IO.Directory]::GetFiles($script:runDirectory, '*.tmp')) | Should -HaveCount 0
    }

    It 'throws on a missing run directory' {
        {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = (Join-Path $TestDrive 'absent') } {
                param($Dir)
                Write-TestRunManifest -RunDirectory $Dir -Manifest @{ status = 'running' }
            }
        } | Should -Throw
    }
}
