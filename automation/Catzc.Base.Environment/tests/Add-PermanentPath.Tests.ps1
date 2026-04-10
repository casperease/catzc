Describe 'Add-PermanentPath' -Tag 'L0', 'logic' {
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
        # of Add-PermanentPath hits this branch (not just the persistence context), so the mocks are global.
        $script:fakeUserPath = $null
        Mock Get-EnvironmentPath { $script:fakeUserPath } -ModuleName Catzc.Base.Environment
        Mock Set-EnvironmentPath { $script:fakeUserPath = $Value } -ModuleName Catzc.Base.Environment
    }

    AfterEach {
        $env:PATH = $originalPath
    }

    It 'adds path to session PATH' {
        Add-PermanentPath $tempDir

        $env:PATH | Should -Match ([regex]::Escape($tempDir))
    }

    It 'appends by default' {
        Add-PermanentPath $tempDir

        $env:PATH | Should -Match "$([regex]::Escape($tempDir))$"
    }

    It 'prepends when -Prepend is set' {
        Add-PermanentPath $tempDir -Prepend

        $env:PATH | Should -Match "^$([regex]::Escape($tempDir))"
    }

    It 'is idempotent — does not duplicate' {
        Add-PermanentPath $tempDir
        $pathAfterFirst = $env:PATH

        Add-PermanentPath $tempDir
        $env:PATH | Should -Be $pathAfterFirst
    }

    It 'throws when path does not exist' {
        { Add-PermanentPath (Join-Path $tempDir 'nonexistent') } | Should -Throw
    }

    if ($IsWindows) {
        Context 'Windows persistence' {
            BeforeEach {
                # Seed the in-memory User PATH with an existing entry (the outer BeforeEach mocks the seam).
                $script:fakeUserPath = 'C:\existing\tool'
            }

            It 'writes the new entry to the persistent User PATH via the registry seam' {
                Add-PermanentPath $tempDir

                $script:fakeUserPath | Should -Match ([regex]::Escape($tempDir))
                $script:fakeUserPath | Should -Match ([regex]::Escape('C:\existing\tool'))   # existing preserved
                Should -Invoke Set-EnvironmentPath -ModuleName Catzc.Base.Environment -Times 1 -Exactly
            }

            It 'does not write the persistent PATH when the entry is already present' {
                # Seed with the entry already there → Add must detect it and skip the registry write entirely.
                # (Asserting on Set-EnvironmentPath invocation avoids relying on mock-to-mock state round-tripping,
                # which hits a Pester $script: scope surprise — see docs/adr test-automation Gotchas.)
                $script:fakeUserPath = "C:\existing\tool;$tempDir"

                Add-PermanentPath $tempDir

                Should -Invoke Set-EnvironmentPath -ModuleName Catzc.Base.Environment -Times 0 -Exactly
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

            It 'writes marker block to profile' {
                # Temporarily override $PROFILE to point at our test file
                $originalProfile = $PROFILE.CurrentUserCurrentHost
                try {
                    $PROFILE | Add-Member -NotePropertyName CurrentUserCurrentHost -NotePropertyValue $testProfile -Force
                    Add-PermanentPath $tempDir -Label 'TestTool'
                    $content = Get-Content $testProfile -Raw
                    $content | Should -Match '>>> catzc PATH TestTool >>>'
                    $content | Should -Match ([regex]::Escape($tempDir))
                    $content | Should -Match '<<< catzc PATH TestTool <<<'
                }
                finally {
                    $PROFILE | Add-Member -NotePropertyName CurrentUserCurrentHost -NotePropertyValue $originalProfile -Force
                }
            }
        }
    }
}
