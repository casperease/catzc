Describe 'Test-ShippedTypes' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive 'widget-modules'
        foreach ($path in 'System/types/String.cs', 'TstWidget/types/Gadget.cs', 'TstWidget/README.md',
            '.internal/types/Hidden.cs') {
            $full = Join-Path $root $path
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, '')
        }
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.TypesSystem { Join-Path $TestDrive 'widget-modules' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'throws once naming each type that does not resolve, skipping dot-folders' {
        $thrown = { Test-ShippedTypes -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-ShippedTypes failed: 1 issue(s)*'
        $thrown.Exception.Message |
            Should -BeLike "*TstWidget/types/Gadget.cs: type 'TstWidget.Gadget' does not resolve after import*"
    }

    It 'returns the result and counts every type file under -PassThru' {
        $result = Test-ShippedTypes -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'shipped-types'
        $result.Facts['Types'] | Should -Be 2
        $result.IssueCount | Should -Be 1
    }
}
