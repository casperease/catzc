<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Asserts/tests/Assert-PathExist.Tests.ps1
    folder: tests
    name: assert-path-exist-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
---
#>

Describe 'Assert-PathExist' -Tag 'L0', 'logic' {
    It 'passes for an existing path' {
        { Assert-PathExist $PSScriptRoot } | Should -Not -Throw
    }

    It 'throws for a non-existent path' {
        { Assert-PathExist '/no/such/path/xyz' } | Should -Throw
    }

    It 'passes for a file with -PathType Leaf' {
        $tempFile = New-TemporaryFile
        try {
            { Assert-PathExist $tempFile.FullName -PathType Leaf } | Should -Not -Throw
        }
        finally {
            Remove-Item $tempFile.FullName
        }
    }

    It 'throws for a file when expecting Container' {
        $tempFile = New-TemporaryFile
        try {
            { Assert-PathExist $tempFile.FullName -PathType Container } | Should -Throw
        }
        finally {
            Remove-Item $tempFile.FullName
        }
    }
}
