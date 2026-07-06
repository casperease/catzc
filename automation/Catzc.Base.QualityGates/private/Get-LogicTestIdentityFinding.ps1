<#
.SYNOPSIS
    Scans one Pester test file's AST for a live production identity used as a code string literal OUTSIDE an
    integrity-tagged block — the comment-blind, tag-aware check cspell cannot do (ADR-LANG).
.DESCRIPTION
    The PowerShell AST omits comments, here-doc trivia, and help entirely, so this reads only real code string
    literals — a config comment illustrating `[acme, globex]`, a `.EXAMPLE` help block, or demo data in a
    comment never reaches it.

    A live identity is legitimate ONLY inside an `integrity`-tagged block (binding the real config is an
    integrity test's job, ADR-TEST:1); anywhere else in a logic-bearing test file it is a leak. So the scan
    EXCLUDES the script-block extent of every Describe/Context/It tagged `integrity`, and reports a match
    everywhere else — the shared setup, the logic Contexts, the unit tests. This makes a MIXED logic+integrity
    file work with no file split: the integrity Context's identities are carved out, the logic body is checked.

    Classification and exclusion are read from the AST `-Tag` values, never by running Pester. A file with no
    `logic` tag at all is not a logic surface and is skipped; a `*.Integrity.Tests.ps1` file is skipped by
    convention. Matching is EXACT (a literal that IS 'apex', not the segment inside 'apex/…' or a path), so
    false positives stay near zero (Phase 1).
.PARAMETER Path
    The test file to scan.
.PARAMETER LiveToken
    A hashtable token -> record (@{ Token; Kind; Source; Suggest }) from Get-LiveIdentityTokens.
.OUTPUTS
    [object[]] findings: @{ File; Line; Token; Kind; Source; Suggest; Message }.
#>
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

    # Predicates bound to locals (never inlined in a .FindAll(...) call) — ADR-PSFORMAT:6.
    $isCommandNode = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst]
    }
    $isStringLiteral = {
        param($node)
        $node -is [System.Management.Automation.Language.StringConstantExpressionAst]
    }
    $commands = $ast.FindAll($isCommandNode, $true)

    # Walk the Pester block commands once: note whether the file carries a `logic` tag anywhere, and collect
    # the script-block offset range of every `integrity`-tagged block (its literals are carved out of the scan).
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

    $literals = $ast.FindAll($isStringLiteral, $true)
    foreach ($literal in $literals) {
        $value = $literal.Value
        if (-not $LiveToken.ContainsKey($value)) {
            continue
        }

        # Carve out literals inside an integrity block — a live identity is legitimate there.
        $start = $literal.Extent.StartOffset
        $inIntegrity = $false
        foreach ($range in $integrityRanges) {
            if ($start -ge $range.Start -and $start -lt $range.End) {
                $inIntegrity = $true
                break
            }
        }
        if ($inIntegrity) {
            continue
        }

        $record = $LiveToken[$value]
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

    , $ret.ToArray()
}
