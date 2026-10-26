<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-quality-gates/tests/types/SourceConventionScan.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'SourceConventionScan' -Tag 'L0', 'logic' {
    It 'collects the list nodes, the block commands, and every string, nested ones too, in tree order' {
        $source = @'
param([ValidateSet('widget', 'gadget')] [string] $Kind)
Describe 'Widget' -Tag 'L0' {
    It "reads $(@('gadget', 'sprocket'))" {
        switch ($Kind) { 'widget' { 1 } }
    }
}
'@
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($source, [ref] $null, [ref] $null)
        $scan = [Catzc.Base.QualityGates.SourceConventionScan]::Scan($ast)
        @($scan.ListNodes | ForEach-Object { $_.GetType().Name }) | Should -Be @('AttributeAst', 'ArrayLiteralAst', 'SwitchStatementAst')
        @($scan.BlockCommands | ForEach-Object { $_.GetCommandName() }) | Should -Be @('Describe', 'It')
        @($scan.Strings | Where-Object { $_ -is [System.Management.Automation.Language.ExpandableStringExpressionAst] }) | Should -HaveCount 1
        @($scan.Strings | ForEach-Object { $_.Extent.Text }) | Should -Contain "'sprocket'"
    }

    It 'throws on a null tree' {
        { [Catzc.Base.QualityGates.SourceConventionScan]::Scan($null) } | Should -Throw '*root*'
    }
}

Describe 'SourceConventionScan over the repository' -Tag 'L1', 'integrity' {
    It 'collects exactly the nodes Ast.FindAll finds, by extent, in every PowerShell file of the tree' {
        $files = @(Get-ChildPath (Get-CatzcModulesRoot) -File -Filter '*.ps1', '*.psm1', '*.psd1' -Depth 8 -PruneVendor $false)
        $isList = [System.Func[System.Management.Automation.Language.Ast, bool]] {
            param($node)
            $node -is [System.Management.Automation.Language.AttributeAst] -or
            $node -is [System.Management.Automation.Language.ArrayLiteralAst] -or
            $node -is [System.Management.Automation.Language.SwitchStatementAst]
        }
        $isBlock = [System.Func[System.Management.Automation.Language.Ast, bool]] {
            param($node)
            $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -in 'Describe', 'Context', 'It'
        }
        $isString = [System.Func[System.Management.Automation.Language.Ast, bool]] {
            param($node)
            $node -is [System.Management.Automation.Language.StringConstantExpressionAst] -or
            $node -is [System.Management.Automation.Language.ExpandableStringExpressionAst]
        }
        $key = { param($Nodes) (@($Nodes | ForEach-Object { "$($_.Extent.StartOffset):$($_.Extent.EndOffset):$($_.GetType().Name)" }) -join ',') }
        $differ = [System.Collections.Generic.List[string]]::new()
        foreach ($file in $files) {
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref] $null, [ref] $null)
            $scan = [Catzc.Base.QualityGates.SourceConventionScan]::Scan($ast)
            if ((& $key $scan.ListNodes) -cne (& $key $ast.FindAll($isList, $true)) -or
                (& $key $scan.BlockCommands) -cne (& $key $ast.FindAll($isBlock, $true)) -or
                (& $key $scan.Strings) -cne (& $key $ast.FindAll($isString, $true))) {
                $differ.Add($file)
            }
        }
        $files.Count | Should -BeGreaterThan 1000
        $differ | Should -BeNullOrEmpty -Because 'the scan must collect what the FindAll predicates collect, file by file'
    }
}
