# The gate fails on length, only measures and reports width, and names every file no language or extension declares.
Describe 'Test-FileLimits' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Assert-SourceTree -ModuleName Catzc.Base.FileLimits {}
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.FileLimits {}
        $script:long = Join-Path $TestDrive 'widget.ps1'
        [System.IO.File]::WriteAllLines($script:long, [string[]](1..401 | ForEach-Object { 'x' * 130 }))
        $script:unknown = Join-Path $TestDrive 'gadget.unclassified'
        [System.IO.File]::WriteAllText($script:unknown, "a`n")
    }

    It 'fails a length breach and only reports a width breach' {
        $result = Test-FileLimits -Path $script:long -OutputFolder (Join-Path $TestDrive 'out1') -PassThru
        @($result.Issues).Count | Should -Be 1
        $result.Issues | Select-Object -First 1 | Should -BeLike '*401 lines*'
    }

    It 'never fails on width: a wide file within its length passes and its width is reported' {
        $wide = Join-Path $TestDrive 'wide.ps1'
        [System.IO.File]::WriteAllText($wide, ('x' * 300) + "`n")
        $result = Test-FileLimits -Path $wide -OutputFolder (Join-Path $TestDrive 'out5') -PassThru
        @($result.Issues).Count | Should -Be 0
        $result.Facts.WidthReported | Should -Be 1
    }

    It 'fails a file no language or extension declares, naming it' {
        $result = Test-FileLimits -Path $script:unknown -OutputFolder (Join-Path $TestDrive 'out2') -PassThru
        $result.Issues | Select-Object -First 1 | Should -BeLike '*gadget.unclassified: unclassified*'
    }

    It 'leaves a generated target out and measures an authored file beside it' {
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.FileLimits {
            [pscustomobject]@{ path = 'docs/gadgets/**'; generator = 'Build-Gadget' }
        }
        Mock Test-FileShape -ModuleName Catzc.Base.FileLimits { [pscustomobject]@{ Check = 'length'; Message = "${Path}: 401 lines" } }
        $result = Test-FileLimits -Path 'docs/references/widgets/gadget.ps1.md', 'docs/gadgets/sprocket.md' -OutputFolder (Join-Path $TestDrive 'out4') -PassThru
        @($result.Issues) | Should -Be @('docs/references/widgets/gadget.ps1.md: 401 lines')
    }

    It 'leaves the vendor folder out of scope' {
        $result = Test-FileLimits -Path ((Get-CatzcModulesFolder) + '/.vendor/widget/gadget.unclassified') -OutputFolder (Join-Path $TestDrive 'out3') -PassThru
        @($result.Issues).Count | Should -Be 0
    }
}

Describe 'Test-FileLimits — the real tree' -Tag 'L1', 'integrity', 'source-only' {
    It 'passes over every tracked file, inside its timeouts.yml roof' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $roof = Get-TimeoutSeconds -Command 'Test-FileLimits'
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        $result = Test-FileLimits -OutputFolder (Join-Path $TestDrive 'tree') -PassThru
        $watch.Stop()
        $result.Issues | Should -BeNullOrEmpty
        $watch.Elapsed.TotalSeconds | Should -BeLessThan $roof
    }
}
