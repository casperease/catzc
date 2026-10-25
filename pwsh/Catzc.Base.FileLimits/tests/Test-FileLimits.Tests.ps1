# The gate fails on length now, reports width until a class flips to fail, and names every file no language or extension declares.
Describe 'Test-FileLimits' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Assert-SourceTree -ModuleName Catzc.Base.FileLimits {}
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.FileLimits {}
        $script:long = Join-Path $TestDrive 'widget.ps1'
        [System.IO.File]::WriteAllLines($script:long, [string[]](1..401 | ForEach-Object { 'x' * 130 }))
        $script:unknown = Join-Path $TestDrive 'gadget.nolanguage'
        [System.IO.File]::WriteAllText($script:unknown, "a`n")
    }

    It 'fails a length breach and only reports a width breach in report mode' {
        $result = Test-FileLimits -Path $script:long -OutputFolder (Join-Path $TestDrive 'out1') -PassThru
        @($result.Issues).Count | Should -Be 1
        @($result.Issues)[0] | Should -BeLike '*401 lines*'
    }

    It 'fails a file no language or extension declares, naming it' {
        $result = Test-FileLimits -Path $script:unknown -OutputFolder (Join-Path $TestDrive 'out2') -PassThru
        @($result.Issues)[0] | Should -BeLike '*gadget.nolanguage: unclassified*'
    }

    It 'leaves the vendor folder out of scope' {
        $result = Test-FileLimits -Path 'pwsh/.vendor/widget/gadget.nolanguage' -OutputFolder (Join-Path $TestDrive 'out3') -PassThru
        @($result.Issues).Count | Should -Be 0
    }
}
