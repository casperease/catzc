function Get-LogicTestIdentityFinding {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory, Position = 1)]
        [hashtable] $LiveToken
    )

    Assert-PathExist $Path

    $ret = [System.Collections.Generic.List[object]]::new()

    # A *.Integrity.Tests.ps1 file is integrity by convention — never scanned.
    if ($Path -like '*.Integrity.Tests.ps1') {
        return , $ret.ToArray()
    }

    $parseTokens = $null
    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$parseTokens, [ref]$parseErrors)

    $isCommandNode = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst]
    }
    $isStringLiteral = {
        param($node)
        $node -is [System.Management.Automation.Language.StringConstantExpressionAst]
    }
    $commands = $ast.FindAll($isCommandNode, $true)

    $hasLogic = $false
    $integrityRanges = [System.Collections.Generic.List[object]]::new()
    foreach ($command in $commands) {
        if ($command.GetCommandName() -notin 'Describe', 'Context', 'It') {
            continue
        }
        $elements = $command.CommandElements

        $tags = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $body = $null
        for ($i = 0; $i -lt $elements.Count; $i++) {
            $element = $elements[$i]
            if ($element -is [System.Management.Automation.Language.ScriptBlockExpressionAst]) {
                $body = $element
            }
            $isTagParam = $element -is [System.Management.Automation.Language.CommandParameterAst] -and
            ($element.ParameterName -eq 'Tag' -or $element.ParameterName -eq 'Tags')
            if (-not $isTagParam) {
                continue
            }
            $valueAst = if ($i + 1 -lt $elements.Count) {
                $elements[$i + 1]
            }
            else {
                $null
            }
            if ($valueAst) {
                $stringNodes = $valueAst.FindAll($isStringLiteral, $true)
                foreach ($stringNode in $stringNodes) {
                    [void] $tags.Add($stringNode.Value)
                }
            }
        }

        if ($tags.Contains('logic')) {
            $hasLogic = $true
        }
        if ($tags.Contains('integrity') -and $body) {
            $integrityRanges.Add([pscustomobject]@{ Start = $body.Extent.StartOffset; End = $body.Extent.EndOffset })
        }
    }

    # Only a logic-bearing test file is a logic surface; a pure-integrity file (all integrity, or none) is not.
    if (-not $hasLogic) {
        return , $ret.ToArray()
    }

    # A live identity is legitimate inside an integrity block — carve those extents out of every scan.
    $isInIntegrity = {
        param($offset)
        foreach ($range in $integrityRanges) {
            if ($offset -ge $range.Start -and $offset -lt $range.End) {
                return $true
            }
        }
        $false
    }

    $literals = $ast.FindAll($isStringLiteral, $true)
    foreach ($literal in $literals) {
        $value = $literal.Value
        if (-not $LiveToken.ContainsKey($value)) {
            continue
        }
        $record = $LiveToken[$value]
        if ($record.MatchMode -ne 'exact') {
            continue
        }
        # A hashtable key names a parameter or a property (a splat's `Discovery = …`), never a value, so it is no identity.
        $parent = $literal.Parent
        if ($parent -is [System.Management.Automation.Language.HashtableAst] -and
            @($parent.KeyValuePairs | Where-Object { [object]::ReferenceEquals($_.Item1, $literal) }).Count) {
            continue
        }
        if (& $isInIntegrity $literal.Extent.StartOffset) {
            continue
        }
        $ret.Add([pscustomobject]@{
                File    = $Path
                Line    = $literal.Extent.StartLineNumber
                Token   = $value
                Kind    = $record.Kind
                Source  = $record.Source
                Suggest = $record.Suggest
                Message = "logic test uses live identity '$value' ($($record.Kind), from $($record.Source)) — use $($record.Suggest)"
            })
    }

    $identityParameters = 'Environment', 'Env', 'Shortcode'
    foreach ($command in $commands) {
        $elements = $command.CommandElements
        for ($i = 0; $i -lt $elements.Count - 1; $i++) {
            $element = $elements[$i]
            $isIdentityParam = $element -is [System.Management.Automation.Language.CommandParameterAst] -and
            $element.ParameterName -in $identityParameters
            if (-not $isIdentityParam) {
                continue
            }
            $argument = $elements[$i + 1]
            if ($argument -isnot [System.Management.Automation.Language.StringConstantExpressionAst]) {
                continue
            }
            $value = $argument.Value
            if (-not $LiveToken.ContainsKey($value)) {
                continue
            }
            $record = $LiveToken[$value]
            if ($record.MatchMode -ne 'position') {
                continue
            }
            if (& $isInIntegrity $argument.Extent.StartOffset) {
                continue
            }
            $ret.Add([pscustomobject]@{
                    File    = $Path
                    Line    = $argument.Extent.StartLineNumber
                    Token   = $value
                    Kind    = $record.Kind
                    Source  = $record.Source
                    Suggest = $record.Suggest
                    Message = "logic test binds live $($record.Kind) '$value' to -$($element.ParameterName) — use $($record.Suggest)"
                })
        }
    }

    , $ret.ToArray()
}
