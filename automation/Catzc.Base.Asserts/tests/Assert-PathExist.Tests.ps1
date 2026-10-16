<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/tests/Assert-PathExist.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder-module
    bundle: minimal
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
