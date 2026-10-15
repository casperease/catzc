<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Save-ResultCache.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Save-ResultCache.ps1
---
#>

# L1: real files in TestDrive — the cache file another process saved, and one held open by another process.
Describe 'Save-ResultCache' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        $script:path = Join-Path $TestDrive "$([guid]::NewGuid().ToString('N'))/cache/format-code.json"
    }

    It 'writes the cache sorted by path, and creates its folder' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ P = $script:path } {
            param($P) Save-ResultCache -Path $P -Cache @{ 'widget/b.ps1' = 'B:s'; 'widget/a.ps1' = 'A:s' }
        }

        $text = [System.IO.File]::ReadAllText($script:path)
        $text.IndexOf('widget/a.ps1') | Should -BeLessThan $text.IndexOf('widget/b.ps1')
        $saved = $text | ConvertFrom-Json -AsHashtable
        $saved['widget/a.ps1'] | Should -Be 'A:s'
    }

    It 'keeps the entries another process saved meanwhile, and its own entries win' {
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($script:path)) | Out-Null
        [System.IO.File]::WriteAllText($script:path, (ConvertTo-Json -InputObject @{ 'gadget/other.ps1' = 'OTHER:s'; 'widget/a.ps1' = 'OLD:s' }))

        InModuleScope Catzc.Base.QualityGates -Parameters @{ P = $script:path } {
            param($P) Save-ResultCache -Path $P -Cache @{ 'widget/a.ps1' = 'NEW:s' }
        }

        $saved = [System.IO.File]::ReadAllText($script:path) | ConvertFrom-Json -AsHashtable
        $saved['gadget/other.ps1'] | Should -Be 'OTHER:s'
        $saved['widget/a.ps1'] | Should -Be 'NEW:s'
    }

    It 'replaces the file whole and leaves no staging file beside it' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ P = $script:path } {
            param($P) Save-ResultCache -Path $P -Cache @{ 'widget/a.ps1' = 'A:s' }
        }

        @([System.IO.Directory]::GetFiles([System.IO.Path]::GetDirectoryName($script:path))) | Should -HaveCount 1
    }

    It 'reports and skips a save it cannot make, rather than failing the check' {
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($script:path)) | Out-Null
        [System.IO.File]::WriteAllText($script:path, '{}')
        $held = [System.IO.File]::Open($script:path, 'Open', 'Read', 'None')
        try {
            { InModuleScope Catzc.Base.QualityGates -Parameters @{ P = $script:path } {
                    param($P) Save-ResultCache -Path $P -Cache @{ 'widget/a.ps1' = 'A:s' }
                } } | Should -Not -Throw
        }
        finally {
            $held.Dispose()
        }

        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -like 'Skipped saving the result cache at*' }
        @([System.IO.Directory]::GetFiles([System.IO.Path]::GetDirectoryName($script:path))) | Should -HaveCount 1
    }
}
