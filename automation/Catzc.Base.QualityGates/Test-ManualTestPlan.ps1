<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1
    name: test-manual-test-plan
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#{16,35}
  config:
    synopsis: 'Quality gate: the manual test plan lists every integrity check, once.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) keeping
      the manual test plan in step with the tests. The plan is the overview docs/how-to/automation/manual-test-plan.md
      plus one category file per category (at most 13) in docs/how-to/automation/manual-test-plan/; the index rows live
      in the category files. It finds every integrity-tagged Describe,
      Context, and It across the test files (except the vendored ones) by PARSING them — never by Pester discovery, as a
      nested Invoke-Pester inside a run is unsafe ([ADR-AUTO-TEST#16](/docs/adr/automation/test-automation.md#rule-adr-auto-test16)).
      A block is integrity when its own -Tag array holds the literal 'integrity'; its identity is the pair (repository-
      relative file, block name), as block names repeat across files.

      The plan's index rows are the category files' markdown table rows that name a .Tests.ps1 path. Issues:

        - the category folder is missing, or holds no category file;
        - the category folder holds more than 13 category files;
        - an integrity block has no row naming both its file and its block name;
        - the row count differs from the block count (a stale or duplicate row, or a renamed or removed block).

      It reads the repository's test files and the plan, which exist only in the source tree (Assert-SourceTree).
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-manual-test-plan/ (Write-QualityGateReport).
      PassThru: |-
        Return the result ({ Subject; IssueCount; Issues; ReportPath; IntegrityBlocks; PlanRows; CategoryFiles }) instead of throwing
        on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-ManualTestPlan
---
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
    $planRelative = 'docs/how-to/automation/manual-test-plan'
    $planPath = Join-Path $repositoryRoot $planRelative
    $maxCategories = 13
    $isCommand = { param($node) $node -is [System.Management.Automation.Language.CommandAst] }
    $isString = { param($node) $node -is [System.Management.Automation.Language.StringConstantExpressionAst] }

    $blocks = [System.Collections.Generic.List[object]]::new()
    # Test files reach four levels below automation (module, tests, types, file); vendored modules are pruned by the walk.
    $testFiles = Get-ChildPath $automationRoot -File -Filter '*.Tests.ps1' -Depth 4 -PruneVendor $true |
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
    $categoryFiles = @()
    if ([System.IO.Directory]::Exists($planPath)) {
        $categoryFiles = @([System.IO.Directory]::GetFiles($planPath, '*.md') | Sort-Object)
    }
    if ($categoryFiles.Count -eq 0) {
        $issues.Add("${planRelative}/: the manual test plan has no category files")
    }
    if ($categoryFiles.Count -gt $maxCategories) {
        $issues.Add("${planRelative}/: $($categoryFiles.Count) category files, at most $maxCategories — merge categories")
    }
    $rows = @(foreach ($categoryFile in $categoryFiles) {
            [System.IO.File]::ReadAllText($categoryFile) -split '\r?\n' |
                Where-Object { $_.TrimStart().StartsWith('|') -and $_ -match '\.Tests\.ps1' }
        })

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
        -Facts ([ordered]@{ IntegrityBlocks = $blocks.Count; PlanRows = $rows.Count; CategoryFiles = $categoryFiles.Count }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
