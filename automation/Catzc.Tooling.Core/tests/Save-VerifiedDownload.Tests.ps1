<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Core/tests/Save-VerifiedDownload.Tests.ps1
    folder: tests
    name: save-verified-download-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-tooling-core/tests/Save-VerifiedDownload.Tests.ps1.md
---
#>

Describe 'Save-VerifiedDownload' -Tag 'L0', 'logic' {

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
