<#
.SYNOPSIS
    Quality gate: no test title carries an angle-bracket template token unless its block is data-driven.
.DESCRIPTION
    A quality gate over the titles of every It, Describe, and Context in the test files (except the vendored ones).
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-TestTitles.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-test-titles/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; TestFiles }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-TestTitles
#>
function Test-TestTitles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $repositoryRoot = Get-RepositoryRoot
    $testFiles = @([System.IO.Directory]::GetFiles((Join-Path $repositoryRoot 'automation'), '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories) |
            Where-Object { $_ -notmatch '[\\/]\.vendor[\\/]' } |
            Sort-Object)
    $isBlock = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -in 'It', 'Describe', 'Context'
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $testFiles) {
        $tokens = $null; $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref]$tokens, [ref]$parseErrors)
        if ($parseErrors) {
            continue
        }
        $relative = $file.Substring($repositoryRoot.Length + 1) -replace '\\', '/'

        foreach ($call in $ast.FindAll($isBlock, $true)) {
            # Element 0 is the command name itself (also a string constant), so the title is the first string after it.
            $title = $call.CommandElements |
                Select-Object -Skip 1 |
                Where-Object {
                    $_ -is [System.Management.Automation.Language.StringConstantExpressionAst] -or
                    $_ -is [System.Management.Automation.Language.ExpandableStringExpressionAst]
                } |
                Select-Object -First 1
            if (-not $title -or $title.Value -notmatch '<\w+>') {
                continue
            }
            $hasData = @($call.CommandElements | Where-Object {
                    $_ -is [System.Management.Automation.Language.CommandParameterAst] -and $_.ParameterName -in 'ForEach', 'TestCases'
                }).Count -gt 0
            if (-not $hasData) {
                $issues.Add("${relative}: $($call.GetCommandName()) '$($title.Value)' has a template token but no -ForEach data — rephrase it (or add -ForEach)")
            }
        }
    }

    Write-QualityGateReport -Subject 'test-titles' -Title 'Test-TestTitles' -Issues $issues `
        -Facts ([ordered]@{ TestFiles = $testFiles.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
