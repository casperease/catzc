function Test-TestTitles {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $repositoryRoot = Get-RepositoryRoot
    # Test files reach four levels below pwsh/ (module, tests, types, file); vendored modules are pruned by the walk.
    $testFiles = @(Get-ChildPath (Join-Path $repositoryRoot (Get-CatzcModulesFolder)) -File -Filter '*.Tests.ps1' -Depth 4 -PruneVendor $true |
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
