function Get-UncoveredInternalAssetDependency {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $AutomationRoot = (Join-Path (Get-RepositoryRoot) 'automation'),

        [object[]] $Dependency
    )

    if (-not $PSBoundParameters.ContainsKey('Dependency')) {
        $Dependency = @(Get-InternalAssetDependency -AutomationRoot $AutomationRoot)
    }

    $citation = 'ADR-AUTO-ASSETDEP#3'
    $blockNames = @('Describe', 'Context', 'It')

    # The literal tag values of one Pester block command (-Tag / -Tags, space or colon form).
    $getBlockTags = {
        param($command)
        $elements = $command.CommandElements
        for ($i = 1; $i -lt $elements.Count; $i++) {
            $element = $elements[$i]
            if ($element -isnot [System.Management.Automation.Language.CommandParameterAst] -or
                $element.ParameterName -notin 'Tag', 'Tags') {
                continue
            }
            $value = $element.Argument
            if (-not $value -and ($i + 1) -lt $elements.Count) {
                $value = $elements[$i + 1]
            }
            if ($value) {
                foreach ($constant in $value.FindAll({ param($node) $node -is [System.Management.Automation.Language.StringConstantExpressionAst] }, $true)) {
                    $constant.Value
                }
            }
        }
    }

    # Whether any It block in the file resolves, through its block chain, to the citation without 'source-only'.
    $testFileQualifies = {
        param([string] $Path)
        $tokens = $null
        $parseErrors = $null
        $syntaxTree = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref] $tokens, [ref] $parseErrors)
        $isItBlock = {
            param($node)
            $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -ieq 'It'
        }
        foreach ($itBlock in $syntaxTree.FindAll($isItBlock, $true)) {
            $chainTags = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
            $node = $itBlock
            while ($node) {
                if ($node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -in $blockNames) {
                    foreach ($tag in @(& $getBlockTags $node)) {
                        [void] $chainTags.Add($tag)
                    }
                }
                $node = $node.Parent
            }
            if ($chainTags.Contains($citation) -and -not $chainTags.Contains('source-only')) {
                return $true
            }
        }
        $false
    }

    # The defining module is the folder the calling file sits in (File = automation/<Module>/...).
    $byFunction = $Dependency | Group-Object { "$(($_.File -split '/')[1])|$($_.Function)" }

    $ret = foreach ($group in ($byFunction | Sort-Object Name)) {
        $definingModule, $functionName = $group.Name -split '\|', 2
        $testsDirectory = Join-Path $AutomationRoot "$definingModule/tests"
        $pattern = '^' + [regex]::Escape($functionName) + '(\.[^.]+)?\.Tests\.ps1$'
        $testFiles = @(
            if ([System.IO.Directory]::Exists($testsDirectory)) {
                [System.IO.Directory]::EnumerateFiles($testsDirectory, '*.Tests.ps1') |
                    Where-Object { [System.IO.Path]::GetFileName($_) -match $pattern } |
                    Sort-Object
            }
        )

        $covered = $false
        foreach ($testFile in $testFiles) {
            if (& $testFileQualifies $testFile) {
                $covered = $true
                break
            }
        }
        if ($covered) {
            continue
        }

        # '.' stands for a call that names the module folder itself (no child path).
        $readPaths = foreach ($record in $group.Group) {
            if ($record.ChildPath) {
                $record.ChildPath
            }
            else {
                '.'
            }
        }
        $childPaths = [string[]] @($readPaths | Sort-Object -Unique)
        $reason = if ($testFiles.Count -eq 0) {
            "no test file named $functionName.Tests.ps1 (or $functionName.<suffix>.Tests.ps1) in automation/$definingModule/tests"
        }
        else {
            "no It block tagged '$citation' without 'source-only'"
        }
        [pscustomobject]@{
            Module    = $definingModule
            Function  = $functionName
            ChildPath = $childPaths
            TestFile  = [string[]] @($testFiles | ForEach-Object { "automation/$definingModule/tests/$([System.IO.Path]::GetFileName($_))" })
            Reason    = $reason
        }
    }

    @($ret)
}
