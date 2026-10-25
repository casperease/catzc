<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-EngineSetFinding.ps1.md"
  warning: "Generated Header"
---
#>

function Get-EngineSetFinding {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [System.Management.Automation.Language.Ast] $Ast,

        [Parameter(Mandatory)]
        [string[]] $EngineName,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.EngineSetCheck] $Check
    )

    $extension = [Catzc.Base.QualityGates.CommentLexer]::ExtensionOf($Path)
    $findings = [System.Collections.Generic.List[object]]::new()
    $lineOf = {
        param([int] $Offset)
        $line = 1
        for ($index = $Text.IndexOf("`n"); $index -ge 0 -and $index -lt $Offset; $index = $Text.IndexOf("`n", $index + 1)) {
            $line++
        }
        $line
    }

    # Prose: the whole of a markdown file, the comments of a code file.
    $proseSpans = if ($extension -eq '.md') {
        , [System.ValueTuple[int, int]]::new(0, $Text.Length)
    }
    else {
        [Catzc.Base.QualityGates.CommentLexer]::Comments($Text, $extension)
    }
    foreach ($span in $proseSpans) {
        foreach ($hit in $Check.FindProse($Text.Substring($span.Item1, $span.Item2), $EngineName)) {
            $findings.Add([pscustomobject]@{ Line = (& $lineOf ($span.Item1 + $hit.Item1)); Message = $hit.Item3 })
        }
    }

    # Code: a literal engine list where the model's Names should be read.
    if ($extension -eq '.cs') {
        foreach ($hit in [Catzc.Base.QualityGates.EngineSetCheck]::FindCSharpLists($Text, $EngineName)) {
            $findings.Add([pscustomobject]@{ Line = (& $lineOf $hit.Item1); Message = $hit.Item2 })
        }
    }
    if ($Ast) {
        $engineValues = {
            param([object[]] $Nodes)
            $named = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
            foreach ($node in $Nodes) {
                if ($node -is [System.Management.Automation.Language.StringConstantExpressionAst] -and $node.Value -in $EngineName) {
                    [void] $named.Add($node.Value)
                }
            }
            , $named
        }
        $isListNode = {
            param($node)
            $node -is [System.Management.Automation.Language.AttributeAst] -or
            $node -is [System.Management.Automation.Language.ArrayLiteralAst] -or
            $node -is [System.Management.Automation.Language.SwitchStatementAst]
        }
        foreach ($node in $Ast.FindAll($isListNode, $true)) {
            $named = $null
            $what = $null
            if ($node -is [System.Management.Automation.Language.AttributeAst]) {
                if ($node.TypeName.Name -in 'ValidateSet', 'ValidateSetAttribute') {
                    $named = & $engineValues @($node.PositionalArguments)
                    $what = 'a ValidateSet'
                }
            }
            elseif ($node -is [System.Management.Automation.Language.ArrayLiteralAst]) {
                $named = & $engineValues @($node.Elements)
                $what = 'an array literal'
            }
            elseif (-not $node.Default) {
                $named = & $engineValues @(foreach ($clause in $node.Clauses) {
                        $clause.Item1
                    })
                $what = 'a switch with no default'
            }
            if ($named -and $named.Count -ge 2) {
                $findings.Add([pscustomobject]@{
                        Line    = $node.Extent.StartLineNumber
                        Message = "$what lists engine names ($(@($named) -join ', ')); read [Catzc.Base.Engines.ExecutionEngines]::Names instead"
                    })
            }
        }
    }

    [string[]] @(foreach ($finding in ($findings | Sort-Object Line)) {
            "${Path}:$($finding.Line): $($finding.Message)"
        })
}
