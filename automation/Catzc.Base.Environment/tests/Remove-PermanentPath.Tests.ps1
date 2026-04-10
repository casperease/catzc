Describe 'Remove-PermanentPath' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:tempDir = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-test-path-$([guid]::NewGuid().ToString('N').Substring(0,8))"
        New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
    }

    AfterAll {
        Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    BeforeEach {
        $script:originalPath = $env:PATH

        # Keep the persistent (Windows User-registry) PATH entirely IN-MEMORY via the Get-EnvironmentPath/Set-EnvironmentPath
        # seam, so NOTHING here mutates the real machine PATH or broadcasts WM_SETTINGCHANGE. Every Windows run
        # of Remove-PermanentPath hits this branch (not just the persistence context), so the mocks are global.
        $script:fakeUserPath = $null
        Mock Get-EnvironmentPath { $script:fakeUserPath } -ModuleName Catzc.Base.Environment
        Mock Set-EnvironmentPath { $script:fakeUserPath = $Value } -ModuleName Catzc.Base.Environment
    }

    AfterEach {
        $env:PATH = $originalPath
    }

    It 'removes path from session PATH' {
        $separator = [System.IO.Path]::PathSeparator
        $env:PATH = "$tempDir$separator$env:PATH"

        Remove-PermanentPath $tempDir

        $env:PATH | Should -Not -Match ([regex]::Escape($tempDir))
    }

    It 'is idempotent — no error when path is absent' {
        Remove-PermanentPath (Join-Path $tempDir 'not-there')
        $env:PATH | Should -Not -BeNullOrEmpty
    }

    It 'preserves other entries' {
        $separator = [System.IO.Path]::PathSeparator
        $env:PATH = "$tempDir${separator}/keep/this${separator}/also/keep"

        Remove-PermanentPath $tempDir

        $env:PATH | Should -Match ([regex]::Escape('/keep/this'))
        $env:PATH | Should -Match ([regex]::Escape('/also/keep'))
    }

    if ($IsWindows) {
        Context 'Windows persistence' {
            BeforeEach {
                # Seed the in-memory User PATH with our temp dir present (the outer BeforeEach mocks the seam).
                $script:fakeUserPath = "$tempDir;C:\Windows;C:\existing\tool"
            }

            It 'removes from the persistent User PATH via the registry seam' {
                Remove-PermanentPath $tempDir

                $script:fakeUserPath | Should -Not -Match ([regex]::Escape($tempDir))
                # Other entries survive, and the write went through the seam (never the real registry).
                $script:fakeUserPath | Should -Match ([regex]::Escape('C:\existing\tool'))
                Should -Invoke Set-EnvironmentPath -ModuleName Catzc.Base.Environment -Times 1 -Exactly
            }

            It 'does not write the registry when the entry is already absent' {
                $script:fakeUserPath = 'C:\Windows;C:\existing\tool'   # tempDir not present

                Remove-PermanentPath $tempDir

                $script:fakeUserPath | Should -Be 'C:\Windows;C:\existing\tool'
            }
        }
    }

    if (-not $IsWindows) {
        Context 'Unix persistence' {
            BeforeAll {
                $script:testProfile = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-test-profile-$([guid]::NewGuid().ToString('N').Substring(0,8)).ps1"
            }

            AfterAll {
                Remove-Item $testProfile -Force -ErrorAction SilentlyContinue
            }

            It 'removes marker block from profile' {
                $originalProfile = $PROFILE.CurrentUserCurrentHost
                try {
                    $PROFILE | Add-Member -NotePropertyName CurrentUserCurrentHost -NotePropertyValue $testProfile -Force

                    # Set up: add a block first
                    Add-PermanentPath $tempDir -Label 'TestTool'
                    $content = Get-Content $testProfile -Raw
                    $content | Should -Match '>>> catzc PATH TestTool >>>'

                    # Act: remove it
                    Remove-PermanentPath $tempDir -Label 'TestTool'
                    $content = Get-Content $testProfile -Raw
                    $content | Should -Not -Match '>>> catzc PATH TestTool >>>'
                }
                finally {
                    $PROFILE | Add-Member -NotePropertyName CurrentUserCurrentHost -NotePropertyValue $originalProfile -Force
                }
            }
        }
    }
}
