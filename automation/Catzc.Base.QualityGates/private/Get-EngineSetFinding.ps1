<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-EngineSetFinding.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1
    adrs:
      - ADR-AUTO-ENGINE#1
  config:
    synopsis: Lists every place one file restates the engine set instead of reading it from the model.
    description: |-
      The engine-set check of Test-SourceConventions
      ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)): the execution engines are
      declared once, in [Catzc.Base.Engines.ExecutionEngines], and every other list is read from it. The engine names
      and their count come from the caller, read from that model, so nothing here names an engine.

      In prose — a markdown file's text, and the comments (help included) of a code file (CommentLexer) — a phrase from
      engine_set's count_phrases or name_phrases that miscounts the engines or names some but not all of them
      (EngineSetCheck.FindProse). In code:
        - PowerShell (from its syntax tree): a ValidateSet, an array literal, or a switch with no default whose string
          values name two or more engines;
        - C#: two or more engine names as string literals on one line (EngineSetCheck.FindCSharpLists).
    parameters:
      Path: The file's repository-relative, '/'-separated path, which leads each finding.
      Text: The file's text.
      Ast: The file's PowerShell syntax tree, when it is a PowerShell file (parsed once by the caller).
      EngineName: The model's engine names ([Catzc.Base.Engines.ExecutionEngines]::Names).
      Check: The engine-set check's settings (source-conventions.yml engine_set).
    outputs: '[string[]] One ''<path>:<line>: <message>'' per finding, in line order.'
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
