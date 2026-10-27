Describe 'Test-SecretScan' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repo = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:out = Join-Path $TestDrive 'secret-scan'
        $script:tracked = @()
        function Set-WidgetFile {
            param([string] $Relative, [string] $Text)
            $path = Join-Path $script:repo $Relative
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
            [System.IO.File]::WriteAllText($path, $Text)
            $script:tracked += $Relative
        }
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { $script:tracked }
        $script:config = [Catzc.Base.QualityGates.SecretPatternsConfig]::new(@{})
        # Assembled at run time, so the tracked test file never carries a secret shape for the real-tree scan to find.
        $script:plantedKey = 'AKIA' + 'WIDGETGADGET1234'
    }

    It 'fails on a planted key, naming the shape and the line, never the matched text' {
        Set-WidgetFile 'widgets/gadget.ps1' "`$name = 'gadget'`n`$key = '$script:plantedKey'`n"
        $result = Test-SecretScan -Config $script:config -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeLike 'widgets/gadget.ps1:2: a aws-access-key*'
        $result.Issues[0] | Should -Not -BeLike "*$script:plantedKey*"
        { Test-SecretScan -Config $script:config -OutputFolder $script:out } | Should -Throw '*Test-SecretScan failed: 1 issue(s)*'
    }

    It 'passes a documented placeholder and a clean file' {
        Set-WidgetFile 'widgets/README.md' "Server=widget;Password=<password>;`nPwd=`$(secret)`n"
        Set-WidgetFile 'widgets/gadget.ps1' "Write-Output 'gadget'`n"
        (Test-SecretScan -Config $script:config -OutputFolder $script:out -PassThru).IssueCount | Should -Be 0
    }

    It 'leaves a declared skip path and a binary file unread' {
        Set-WidgetFile 'widgets/tests/x/assets/sample.pem' ('-----BEGIN ' + "PRIVATE KEY-----`n")
        $binary = Join-Path $script:repo 'widgets/gadget.bin'
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($binary))
        [System.IO.File]::WriteAllBytes($binary, [byte[]] @(0, 65, 75, 73, 65))
        $script:tracked += 'widgets/gadget.bin'
        $result = Test-SecretScan -Config $script:config -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts.Scanned | Should -Be 0
    }

    It 'refuses a pattern that is not a regular expression' {
        { [Catzc.Base.QualityGates.SecretPatternsConfig]::new(@{ patterns = @{ widget = '(' } }) } |
            Should -Throw '*widget*is not a regular expression*'
    }
}

Describe 'Test-SecretScan (real tree)' -Tag 'L1', 'integrity' {
    It 'finds no secret in the tracked tree' {
        (Test-SecretScan -PassThru -OutputFolder (Join-Path $TestDrive 'secret-scan')).Issues | Should -BeNullOrEmpty
    }
}
