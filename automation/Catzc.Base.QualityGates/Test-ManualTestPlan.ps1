<#
.SYNOPSIS
    Quality gate: the manual test plan lists every integrity check, once.
.DESCRIPTION
    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) keeping
    docs/how-to/automation/manual-test-plan.md in step with the tests. It finds every integrity-tagged Describe,
    Context, and It across the test files (except the vendored ones) by PARSING them — never by Pester discovery, as a
    nested Invoke-Pester inside a run is unsafe ([ADR-AUTO-TEST#16](/docs/adr/automation/test-automation.md#rule-adr-auto-test16)).
    A block is integrity when its own -Tag array holds the literal 'integrity'; its identity is the pair (repository-
    relative file, block name), as block names repeat across files.

    The plan's index rows are its markdown table rows that name a .Tests.ps1 path. Issues:

      - the plan file is missing;
      - an integrity block has no row naming both its file and its block name;
      - the row count differs from the block count (a stale or duplicate row, or a renamed or removed block).

    It reads the repository's test files and the plan, which exist only in the source tree (Assert-SourceTree).
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-manual-test-plan/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; IntegrityBlocks; PlanRows }) instead of throwing
    on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ManualTestPlan
#>
function Test-ManualTestPlan {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $repositoryRoot = Get-RepositoryRoot
    $automationRoot = Join-Path $repositoryRoot 'automation'
    $planRelative = 'docs/how-to/automation/manual-test-plan.md'
    $planPath = Join-Path $repositoryRoot $planRelative
    $isCommand = { param($node) $node -is [System.Management.Automation.Language.CommandAst] }
    $isString = { param($node) $node -is [System.Management.Automation.Language.StringConstantExpressionAst] }

    $blocks = [System.Collections.Generic.List[object]]::new()
    $testFiles = [System.IO.Directory]::EnumerateFiles($automationRoot, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories) |
        Where-Object { $_ -notmatch '[\\/]\.vendor[\\/]' } |
        Sort-Object
    foreach ($file in $testFiles) {
        $tokens = $null; $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref]$tokens, [ref]$parseErrors)
        $relative = $file.Substring($repositoryRoot.Length + 1) -replace '\\', '/'

        foreach ($command in $ast.FindAll($isCommand, $true)) {
            if ($command.GetCommandName() -notin 'Describe', 'Context', 'It') {
                continue
            }
            $elements = $command.CommandElements

            # The -Tag value: its inline argument (-Tag:value) or the next element (-Tag value).
            $tagValue = $null
            for ($i = 1; $i -lt $elements.Count; $i++) {
                $element = $elements[$i]
                if ($element -isnot [System.Management.Automation.Language.CommandParameterAst] -or $element.ParameterName -ine 'Tag') {
                    continue
                }
                $tagValue = $element.Argument
                if (-not $tagValue -and $i + 1 -lt $elements.Count) {
                    $tagValue = $elements[$i + 1]
                }
                break
            }
            if (-not $tagValue) {
                continue
            }
            $tags = @($tagValue.FindAll($isString, $true) | ForEach-Object { $_.Value })
            if ($tags -notcontains 'integrity') {
                continue
            }

            # The block name is the first positional argument (Pester always names the block first).
            if ($elements.Count -lt 2 -or $elements[1] -isnot [System.Management.Automation.Language.StringConstantExpressionAst]) {
                continue
            }
            $blocks.Add([pscustomobject]@{ File = $relative; Block = $elements[1].Value })
        }
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    $rows = @()
    if ([System.IO.File]::Exists($planPath)) {
        $rows = @([System.IO.File]::ReadAllText($planPath) -split '\r?\n' |
                Where-Object { $_.TrimStart().StartsWith('|') -and $_ -match '\.Tests\.ps1' })
    }
    else {
        $issues.Add("${planRelative}: the manual test plan is missing")
    }

    foreach ($block in $blocks) {
        $matched = @($rows | Where-Object { $_.Contains($block.File) -and $_.Contains($block.Block) })
        if ($matched.Count -eq 0) {
            $issues.Add("$($block.File) :: $($block.Block): no manual-test-plan row — add one (or remove the integrity tag)")
        }
    }
    if ($rows.Count -ne $blocks.Count) {
        $issues.Add("${planRelative}: $($rows.Count) index rows for $($blocks.Count) integrity blocks — a stale or duplicate row, or a renamed or removed block")
    }

    Write-QualityGateReport -Subject 'manual-test-plan' -Title 'Test-ManualTestPlan' -Issues $issues `
        -Facts ([ordered]@{ IntegrityBlocks = $blocks.Count; PlanRows = $rows.Count }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
