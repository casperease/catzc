Describe 'Measure-NoRawInformationStream' -Tag 'L2', 'logic' {
    BeforeAll {
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }
        $script:rulePath = Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoRawInformationStream.psm1'

        function Test-RawInfo {
            param([string] $Code)
            Invoke-ScriptAnalyzer -ScriptDefinition $Code -CustomRulePath $script:rulePath |
                Where-Object RuleName -EQ 'Measure-NoRawInformationStream'
        }
    }

    It 'flags a direct Write-Information call: <Desc>' -ForEach @(
        @{ Desc = 'bare string'; Code = "Write-Information 'a.md: 2'" }
        @{ Desc = 'expandable string'; Code = 'Write-Information "$x done"' }
        @{ Desc = 'empty line'; Code = "Write-Information ''" }
    ) {
        Test-RawInfo $Code | Should -Not -BeNullOrEmpty
    }

    It 'flags Write-Information inside a function other than the chokepoint' {
        $code = @'
function Write-Thing {
    Write-Information 'hello'
}
'@
        Test-RawInfo $code | Should -Not -BeNullOrEmpty
    }

    It 'exempts the chokepoint Write-InformationColored (the one sanctioned caller)' {
        $code = @'
function Write-InformationColored {
    param($MessageData)
    Write-Information $MessageData
}
'@
        Test-RawInfo $code | Should -BeNullOrEmpty
    }

    It 'passes clean code that uses Write-Message' {
        Test-RawInfo "Write-Message 'a.md: 2' -NoHeader" | Should -BeNullOrEmpty
    }

    It 'does not flag Write-Information named as a string argument to Mock/Should' {
        # 'Write-Information' here is an argument, not the invoked command, so GetCommandName() is Mock/Should.
        Test-RawInfo 'Mock Write-Information { }' | Should -BeNullOrEmpty
    }
}
