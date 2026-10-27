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
        # The FindAll predicates are compiled expression trees: a script block called per node of every tree costs seconds.
        $expression = [System.Linq.Expressions.Expression]
        $node = $expression::Parameter([System.Management.Automation.Language.Ast], 'node')
        $isA = { param([type] $Type) $expression::TypeIs($node, $Type) }
        $predicate = { param($Body) $expression::Lambda[System.Func[System.Management.Automation.Language.Ast, bool]]($Body, $node).Compile() }
        $isList = & $predicate $expression::OrElse($expression::OrElse((& $isA ([System.Management.Automation.Language.AttributeAst])),
                (& $isA ([System.Management.Automation.Language.ArrayLiteralAst]))), (& $isA ([System.Management.Automation.Language.SwitchStatementAst])))
        $name = $expression::Call($expression::Convert($node, [System.Management.Automation.Language.CommandAst]),
            [System.Management.Automation.Language.CommandAst].GetMethod('GetCommandName'))
        $named = { param([string] $Block) $expression::Call([string].GetMethod('Equals', [type[]] @([string], [string], [System.StringComparison])),
                $name, $expression::Constant($Block), $expression::Constant([System.StringComparison]::OrdinalIgnoreCase)) }
        $isBlock = & $predicate $expression::AndAlso((& $isA ([System.Management.Automation.Language.CommandAst])),
            $expression::OrElse($expression::OrElse((& $named 'Describe'), (& $named 'Context')), (& $named 'It')))
        $isString = & $predicate $expression::OrElse((& $isA ([System.Management.Automation.Language.StringConstantExpressionAst])),
            (& $isA ([System.Management.Automation.Language.ExpandableStringExpressionAst])))
        # The same nodes in the same order, by reference, which holds every extent equal too.
        $same = { param($Scanned, $Found) [System.Linq.Enumerable]::SequenceEqual[System.Management.Automation.Language.Ast]($Scanned, $Found) }
        $differ = [System.Collections.Generic.List[string]]::new()
        foreach ($file in $files) {
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref] $null, [ref] $null)
            $scan = [Catzc.Base.QualityGates.SourceConventionScan]::Scan($ast)
            if (-not (& $same $scan.ListNodes $ast.FindAll($isList, $true)) -or
                -not (& $same $scan.BlockCommands $ast.FindAll($isBlock, $true)) -or
                -not (& $same $scan.Strings $ast.FindAll($isString, $true))) {
                $differ.Add($file)
            }
        }
        $files.Count | Should -BeGreaterThan 1000
        $differ | Should -BeNullOrEmpty -Because 'the scan must collect what the FindAll predicates collect, file by file'
    }
}
