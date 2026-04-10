# Keeps docs/how-to/automation/manual-test-plan.md in sync with the suite. This is itself an integrity check
# (it reads the real repo), so per ADR-TEST:16 it derives its fact by PARSING the test files with the AST — never by
# booting Pester discovery (a nested Invoke-Pester inside a run is unsafe). It is self-referential: its own
# Describe is integrity-tagged, so the plan must list it too (row 34).
Describe 'Manual test plan covers every integrity check' -Tag 'L1', 'integrity' {
    BeforeAll {
        $repoRoot = $env:RepositoryRoot
        $automationRoot = Join-Path $repoRoot 'automation'
        $script:planPath = Join-Path $repoRoot 'docs/how-to/automation/manual-test-plan.md'

        # 1. Discover every integrity-tagged Describe/Context/It across the suite by AST (ADR-TEST:16). A block is
        # integrity when its own -Tag argument array contains the literal 'integrity'; the block name is the
        # command's first positional string. Key each block by (relativeFile, blockName) — block names are NOT
        # unique across files (e.g. 'integrity (shipped config + real code)' is in two files), so the pair is
        # the identity, never the name alone.
        $isCommand = { param($node) $node -is [System.Management.Automation.Language.CommandAst] }
        $isString = { param($node) $node -is [System.Management.Automation.Language.StringConstantExpressionAst] }

        $script:integrityBlocks = [System.Collections.Generic.List[object]]::new()
        $testFiles = [System.IO.Directory]::EnumerateFiles($automationRoot, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories)
        foreach ($file in $testFiles) {
            # Never the vendored Pester's own tests.
            if ($file -match '[\\/]\.vendor[\\/]') {
                continue
            }

            $tokens = $null
            $parseErrors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref]$tokens, [ref]$parseErrors)
            $relative = ($file.Substring($repoRoot.Length + 1)) -replace '\\', '/'

            foreach ($command in $ast.FindAll($isCommand, $true)) {
                if ($command.GetCommandName() -notin 'Describe', 'Context', 'It') {
                    continue
                }

                $elements = $command.CommandElements

                # Locate the -Tag value: its inline argument (-Tag:value) or the next element (-Tag value).
                $tagValue = $null
                for ($i = 1; $i -lt $elements.Count; $i++) {
                    $element = $elements[$i]
                    if ($element -isnot [System.Management.Automation.Language.CommandParameterAst]) {
                        continue
                    }
                    if ($element.ParameterName -ine 'Tag') {
                        continue
                    }
                    if ($element.Argument) {
                        $tagValue = $element.Argument
                    }
                    elseif ($i + 1 -lt $elements.Count) {
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

                # Block name = first positional argument (Pester always names the block first).
                if ($elements.Count -lt 2 -or $elements[1] -isnot [System.Management.Automation.Language.StringConstantExpressionAst]) {
                    continue
                }
                $blockName = $elements[1].Value

                $script:integrityBlocks.Add([pscustomobject]@{ File = $relative; Block = $blockName })
            }
        }

        # 2. The plan's index rows — markdown table rows that reference a .Tests.ps1 path.
        if (Test-Path $script:planPath) {
            $script:planText = [System.IO.File]::ReadAllText($script:planPath)
        }
        else {
            $script:planText = ''
        }
        $script:entryRows = @(
            $script:planText -split '\r?\n' |
                Where-Object { $_.TrimStart().StartsWith('|') -and $_ -match '\.Tests\.ps1' }
        )
    }

    It 'the plan exists and the AST scan found the integrity blocks (guards against a silent no-op)' {
        Test-Path $script:planPath | Should -BeTrue -Because 'the plan lives at docs/how-to/automation/manual-test-plan.md'
        $script:integrityBlocks.Count | Should -BeGreaterThan 30
    }

    It 'every integrity-tagged block has an index row (matched on file + FullNameFilter)' {
        $missing = foreach ($block in $script:integrityBlocks) {
            $matched = $script:entryRows | Where-Object { $_.Contains($block.File) -and $_.Contains($block.Block) }
            if (-not $matched) {
                "$($block.File)  ::  $($block.Block)"
            }
        }
        $missing | Should -BeNullOrEmpty -Because (
            "these integrity checks have no manual-test-plan row — add one (or remove the tag):`n$($missing -join "`n")"
        )
    }

    It 'the plan has no stale or duplicate index rows (row count equals discovered blocks)' {
        $script:entryRows.Count | Should -Be $script:integrityBlocks.Count -Because (
            "the plan has $($script:entryRows.Count) index rows but the suite has $($script:integrityBlocks.Count) integrity blocks — a stale/duplicate row, or a renamed/removed block"
        )
    }
}
