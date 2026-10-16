<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-TestTitles.ps1
    name: test-test-titles
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
      test: automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#{25,35}
  config:
    synopsis: 'Quality gate: no test title carries an angle-bracket template token unless its block is data-driven.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the titles of
      every It, Describe, and Context in the test files (except the vendored ones). Pester treats an angle-bracket word
      in a title as its name template and expands it as a variable in the test's scope. With -ForEach or -TestCases data
      that is the intended feature; without data the token is almost always prose (a placeholder path), which expands
      to empty in a non-strict scope and THROWS in a strict one — and the tests run strict
      ([ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)), so such a title fails its file at
      name expansion, far from the cause. Each such title is an issue: rephrase it, or add -ForEach data.

      The title is a block's first string argument (single- or double-quoted). A file that does not parse is another
      gate's problem and is skipped. It parses the repository's test files, which exist only in the source tree
      (Assert-SourceTree).
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-test-titles/ (Write-QualityGateReport).
      PassThru: Return the result ({ Subject; IssueCount; Issues; ReportPath; TestFiles }) instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-TestTitles
---
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
    # Test files reach four levels below automation (module, tests, types, file); vendored modules are pruned by the walk.
    $testFiles = @(Get-ChildPath (Join-Path $repositoryRoot 'automation') -File -Filter '*.Tests.ps1' -Depth 4 -PruneVendor $true |
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
