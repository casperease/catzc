Describe 'Save-VerifiedDownload' -Tag 'L0', 'logic' {

    # The mocked download writes exactly the three bytes of 'abc' with no newline, whose SHA-256 is the NIST test vector.
    It 'returns the path when the SHA-256 matches (tolerates a sha256: prefix)' {
        InModuleScope Catzc.Tooling.Core {
            Mock Invoke-WebRequest { Set-Content -Path $OutFile -Value 'abc' -NoNewline }
            $out = Join-Path ([System.IO.Path]::GetTempPath()) ('svd-' + [guid]::NewGuid().ToString('N') + '.bin')
            try {
                $result = Save-VerifiedDownload -Uri 'https://example.test/abc' -OutFile $out -Sha256 'sha256:ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'
                $result | Should -Be $out
                Test-Path $out | Should -BeTrue
                Should -Invoke Invoke-WebRequest -Times 1
            }
            finally {
                Remove-Item $out -Force -ErrorAction SilentlyContinue
            }
        }
    }

    Context 'credential variable' {
        BeforeEach {
            $env:WIDGET_TOKEN = 'widget-secret'
        }

        AfterEach {
            Remove-Item Env:\WIDGET_TOKEN -ErrorAction SilentlyContinue
        }

        It 'sends no authorization header without a credential variable' {
            InModuleScope Catzc.Tooling.Core {
                $script:seen = $null
                Mock Invoke-WebRequest { $script:seen = $Headers; Set-Content -Path $OutFile -Value 'abc' -NoNewline }
                $out = Join-Path ([System.IO.Path]::GetTempPath()) ('svd-' + [guid]::NewGuid().ToString('N') + '.bin')
                try {
                    $null = Save-VerifiedDownload -Uri 'https://widget.example/abc' -OutFile $out -Sha256 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'
                    @($script:seen.Keys).Count | Should -Be 0
                }
                finally {
                    Remove-Item $out -Force -ErrorAction SilentlyContinue
                }
            }
        }

        It 'sends the bearer header with the variable value when it is set' {
            InModuleScope Catzc.Tooling.Core {
                $script:seen = $null
                Mock Invoke-WebRequest { $script:seen = $Headers; Set-Content -Path $OutFile -Value 'abc' -NoNewline }
                $out = Join-Path ([System.IO.Path]::GetTempPath()) ('svd-' + [guid]::NewGuid().ToString('N') + '.bin')
                try {
                    $null = Save-VerifiedDownload -Uri 'https://widget.example/abc' -OutFile $out -Sha256 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad' -CredentialVariable 'WIDGET_TOKEN'
                    $script:seen['Authorization'] | Should -Be 'Bearer widget-secret'
                }
                finally {
                    Remove-Item $out -Force -ErrorAction SilentlyContinue
                }
            }
        }

        It 'throws naming the variable and the host, before any request, when the variable is unset' {
            Remove-Item Env:\WIDGET_TOKEN
            InModuleScope Catzc.Tooling.Core {
                Mock Invoke-WebRequest { }
                $out = Join-Path ([System.IO.Path]::GetTempPath()) ('svd-' + [guid]::NewGuid().ToString('N') + '.bin')
                { Save-VerifiedDownload -Uri 'https://widget.example/abc' -OutFile $out -Sha256 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad' -CredentialVariable 'WIDGET_TOKEN' } |
                    Should -Throw "*'WIDGET_TOKEN'*widget.example*"
                Should -Invoke Invoke-WebRequest -Times 0 -Exactly
            }
        }
    }

    It 'throws and deletes the file on a checksum mismatch' {
        InModuleScope Catzc.Tooling.Core {
            Mock Invoke-WebRequest { Set-Content -Path $OutFile -Value 'abc' -NoNewline }
            $out = Join-Path ([System.IO.Path]::GetTempPath()) ('svd-' + [guid]::NewGuid().ToString('N') + '.bin')
            try {
                { Save-VerifiedDownload -Uri 'https://example.test/abc' -OutFile $out -Sha256 'deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef0' } |
                    Should -Throw '*Checksum mismatch*'
                Test-Path $out | Should -BeFalse
            }
            finally {
                Remove-Item $out -Force -ErrorAction SilentlyContinue
            }
        }
    }
}
