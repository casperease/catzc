<#
.SYNOPSIS
    Returns the prose of one PowerShell file as the comments, help, and messages surfaces of the avoided-phrasing
    gate (G4).
.DESCRIPTION
    Parses the file ([System.Management.Automation.Language.Parser]::ParseFile) and returns one segment per piece
    of prose, never a regex over the source text
    ([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)):
      - help — a block comment holding .SYNOPSIS or .DESCRIPTION (comment-based help);
      - comments — every other comment token;
      - messages — the strings passed to throw, Write-Message, Write-Warning, Write-Error, or Write-Host, and the
        value of any -ErrorText or -Because parameter. A constant string contributes its value; an expandable
        string contributes its value with every embedded variable or sub-expression removed.
    Each segment's mentions are blanked (Remove-GlossaryMentions) and it carries the line it starts on, so a match's
    offset maps to its line. A string is read once even when several of these contexts hold it.

    Private helper for the glossary gates; not exported.
.PARAMETER Path
    Absolute path to the .ps1 or .psm1 file.
.OUTPUTS
    [pscustomobject[]] One { Surface; Line; Text } per comment and message string, in source order.
.EXAMPLE
    Get-GlossaryPowerShellProse (Resolve-RepoPath 'importer.ps1')
#>
function Get-GlossaryPowerShellProse {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $tokens = $null
    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref] $tokens, [ref] $parseErrors)

    $segment = {
        param([string] $surface, [int] $line, [string] $text)
        [pscustomobject]@{
            Surface = $surface
            Line    = $line
            Text    = Remove-GlossaryMentions ($text -replace "`r", '')
        }
    }

    foreach ($token in $tokens) {
        if ($token.Kind -ne [System.Management.Automation.Language.TokenKind]::Comment) {
            continue
        }
        $isHelp = $token.Text.StartsWith('<#') -and $token.Text -match '(?im)^\s*\.(SYNOPSIS|DESCRIPTION)\b'
        $surface = if ($isHelp) {
            'help'
        }
        else {
            'comments'
        }
        & $segment $surface $token.Extent.StartLineNumber $token.Text
    }

    # The argument elements that carry a message: everything after the command name of a writer, the operand of
    # throw, and the value of -ErrorText / -Because on any command.
    $writers = @('Write-Message', 'Write-Warning', 'Write-Error', 'Write-Host')
    $carriers = [System.Collections.Generic.List[System.Management.Automation.Language.Ast]]::new()
    foreach ($node in $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.ThrowStatementAst] }, $true)) {
        if ($node.Pipeline) {
            $carriers.Add($node.Pipeline)
        }
    }
    foreach ($command in $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] }, $true)) {
        $elements = $command.CommandElements
        $isWriter = $command.GetCommandName() -in $writers
        for ($i = 1; $i -lt $elements.Count; $i++) {
            $element = $elements[$i]
            if ($element -is [System.Management.Automation.Language.CommandParameterAst]) {
                if ($element.ParameterName -notin 'ErrorText', 'Because') {
                    continue
                }
                if ($element.Argument) {
                    $carriers.Add($element.Argument)
                }
                elseif ($i + 1 -lt $elements.Count) {
                    $carriers.Add($elements[$i + 1])
                }
                continue
            }
            if ($isWriter) {
                $carriers.Add($element)
            }
        }
    }

    $isString = {
        param($n)
        $n -is [System.Management.Automation.Language.StringConstantExpressionAst] -or
        $n -is [System.Management.Automation.Language.ExpandableStringExpressionAst]
    }
    $seen = [System.Collections.Generic.HashSet[int]]::new()
    $strings = foreach ($carrier in $carriers) {
        foreach ($string in $carrier.FindAll($isString, $true)) {
            # A string inside an expandable string's sub-expression is code, not message text: its parent string
            # drops it with the rest of the sub-expression.
            $inExpandable = $false
            for ($parent = $string.Parent; $null -ne $parent; $parent = $parent.Parent) {
                if ($parent -is [System.Management.Automation.Language.ExpandableStringExpressionAst]) {
                    $inExpandable = $true
                    break
                }
            }
            if ($inExpandable -or -not $seen.Add($string.Extent.StartOffset)) {
                continue
            }
            $string
        }
    }
    foreach ($string in @($strings | Sort-Object { $_.Extent.StartOffset })) {
        $text = $string.Value
        if ($string -is [System.Management.Automation.Language.ExpandableStringExpressionAst]) {
            foreach ($nested in $string.NestedExpressions) {
                $text = $text.Replace($nested.Extent.Text, ' ')
            }
        }
        # A here-string's value starts on the line after its opening @" / @'.
        $line = $string.Extent.StartLineNumber
        if ($string.Extent.Text.StartsWith('@')) {
            $line++
        }
        & $segment 'messages' $line $text
    }
}
