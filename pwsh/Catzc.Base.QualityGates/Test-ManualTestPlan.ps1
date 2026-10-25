<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-ManualTestPlan.ps1.md"
  warning: "Generated Header"
---
#>

function Test-ManualTestPlan {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $repositoryRoot = Get-RepositoryRoot
    $modulesRoot = Join-Path $repositoryRoot (Get-CatzcModulesFolder)
    $planRelative = 'docs/how-to/pwsh/manual-test-plan'
    $planPath = Join-Path $repositoryRoot $planRelative
    $maxCategories = 13
    $isCommand = { param($node) $node -is [System.Management.Automation.Language.CommandAst] }
    $isString = { param($node) $node -is [System.Management.Automation.Language.StringConstantExpressionAst] }

    $blocks = [System.Collections.Generic.List[object]]::new()
    # Test files reach four levels below pwsh/ (module, tests, types, file); vendored modules are pruned by the walk.
    $testFiles = Get-ChildPath $modulesRoot -File -Filter '*.Tests.ps1' -Depth 4 -PruneVendor $true |
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
    $categoryFiles = @([Catzc.Base.Folders.PathSet]::new().AddPattern($planPath, '*.md', 1).ToArray())
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
