Describe 'Test-BicepApiVersions' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:out = Join-Path $TestDrive 'out'
        $script:root = Join-Path $TestDrive 'repo'
        $script:modules = Join-Path $root 'widgets'
        $null = New-Item -ItemType Directory -Path $modules -Force
        $script:today = [datetime]::new(2026, 10, 26)
        $script:config = { param($Raw) [Catzc.Base.QualityGates.BicepApiVersionsConfig]::new($Raw) }
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $root }
        Mock ConvertTo-RepoRelativePath -ModuleName Catzc.Base.QualityGates { 'widgets/' + (Split-Path -Leaf $Path) }
        Get-ChildPath $modules -File | Remove-Item
    }

    It 'scans a template one folder down in every listed folder' {
        $template = New-Item -ItemType Directory -Path (Join-Path $modules 'gadget') -Force
        Set-Content (Join-Path $template 'main.bicep') "resource gadget 'Microsoft.Gadget/gadgets@2021-05-01-preview' existing = {}"
        { Test-BicepApiVersions -Config (& $config @{ folders = @('widgets') }) -Today $today -OutputFolder $out } |
            Should -Throw '*1 issue(s)*'
    }

    It 'passes a current stable version' {
        Set-Content (Join-Path $modules 'widget.bicep') "resource widget 'Microsoft.Widget/widgets@2025-01-01' = {}"
        $result = Test-BicepApiVersions -Config (& $config @{ folders = @('widgets') }) -Today $today -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['References'] | Should -Be 1
    }

    It 'reports a preview version and an outdated one, each by file and line' {
        Set-Content (Join-Path $modules 'gadget.bicep') @(
            "resource gadget 'Microsoft.Gadget/gadgets@2021-05-01-preview' = {}"
            "resource sprocket 'Microsoft.Gadget/sprockets@2018-06-01' = {}"
        )
        $thrown = { Test-BicepApiVersions -Config (& $config @{ folders = @('widgets') }) -Today $today -OutputFolder $out } |
            Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-BicepApiVersions failed: 2 issue(s)*'
    }

    It 'passes a version pinned in allowed, whatever its age' {
        Set-Content (Join-Path $modules 'gadget.bicep') "resource gadget 'Microsoft.Gadget/gadgets@2021-05-01-preview' = {}"
        $raw = @{ folders = @('widgets'); allowed = @{ 'Microsoft.Gadget/gadgets' = @('2021-05-01-preview') } }
        (Test-BicepApiVersions -Config (& $config $raw) -Today $today -OutputFolder $out -PassThru).IssueCount | Should -Be 0
    }

    It 'holds the outdated line at max_age_months' {
        Set-Content (Join-Path $modules 'widget.bicep') "resource widget 'Microsoft.Widget/widgets@2024-01-01' = {}"
        { Test-BicepApiVersions -Config (& $config @{ folders = @('widgets'); max_age_months = 12 }) -Today $today -OutputFolder $out } |
            Should -Throw '*1 issue(s)*'
    }

    It 'rejects a config with an unknown key or a malformed pin' {
        { & $config @{ widget = 1 } } | Should -Throw "*unknown top-level key 'widget'*"
        { & $config @{ allowed = @{ 'Microsoft.Widget/widgets' = @('latest') } } } | Should -Throw "*'latest' is not an API version*"
        { & $config @{ max_age_months = 0 } } | Should -Throw '*max_age_months must be a positive integer*'
        { & $config @{ folders = @() } } | Should -Throw '*folders must be a non-empty list*'
    }
}

Describe 'Test-BicepApiVersions (real modules)' -Tag 'L1', 'integrity' {
    It 'every API version the shipped Bicep modules reference is current, stable or pinned' {
        $result = Test-BicepApiVersions -PassThru -OutputFolder (Join-Path $TestDrive 'bicep-api-versions')
        $result.Facts['References'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
