Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: forbid writing to the console past the information stream.
.DESCRIPTION
    Every write to the console goes through the information stream, by way of the writer chokepoint
    (Write-Message -> Write-InformationColored -> Write-Information) — ADR-AUTO-ANNOUNCE:1. Only there is the
    output controllable ($InformationPreference, -InformationAction, 6> redirection), silenced during a Pester
    run (the chokepoint guard), and headed with its caller. A write that goes around the stream bypasses all
    three, so this rule flags every way to do it:

      - the commands Write-Host, Out-Host, Write-Progress and Clear-Host (and the clear / cls aliases);
      - the [Console] write methods (Write, WriteLine, Clear, ResetColor, SetCursorPosition, Beep, ...), a write
        through the raw writers ([Console]::Out.Write(...), [Console]::Error.WriteLine(...)), the raw streams
        OpenStandardOutput / OpenStandardError, and any assignment to a [Console] property (title, colours,
        cursor, encoding);
      - the host's write methods ($Host.UI.Write*), the raw-UI mutators ($Host.UI.RawUI.Set* / Flush* /
        Scroll*), and any assignment under $Host.UI.RawUI.

    Reading console state ([Console]::CursorLeft, $Host.UI.RawUI.WindowSize) is not a write and passes, and so is
    redirecting the console writer to capture output ([Console]::SetOut around a test). An inline dot without a
    line break is Write-Message '.' -NoHeader -NoNewline, so no case needs a raw write.

    This supersedes the built-in PSAvoidUsingWriteHost, which is excluded in PSScriptAnalyzerSettings.psd1: one
    rule owns the console bypass, and it covers every route, not only Write-Host.

    See ADR: docs/adr/automation/powershell/announce-state-changes.md (ADR-AUTO-ANNOUNCE:1).
#>

function Measure-NoRawConsoleWrite {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    # PSScriptAnalyzer invokes custom rules for every ScriptBlockAst in the parse tree; FindAll recurses, so
    # only process the root to avoid duplicate diagnostics.
    if ($ScriptBlockAst.Parent) {
        return @()
    }

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoRawConsoleWrite'
    $advice = 'Write through the information stream instead: Write-Message (with -NoHeader / -ForegroundColor / -NoNewline as needed) — ADR-AUTO-ANNOUNCE:1.'

    $rawCommands = @('Write-Host', 'Out-Host', 'Write-Progress', 'Clear-Host', 'clear', 'cls')
    $consoleTypes = @('Console', 'System.Console')
    $consoleWriteMembers = @(
        'Write', 'WriteLine', 'Clear', 'ResetColor', 'SetCursorPosition', 'Beep', 'SetWindowSize',
        'SetWindowPosition', 'SetBufferSize', 'MoveBufferArea', 'OpenStandardOutput', 'OpenStandardError'
    )
    # [Console]::Out / [Console]::Error are raw writers only when written through; reading them (to save and
    # restore around a SetOut capture) writes nothing.
    $consoleWriterMembers = @('Out', 'Error')
    $writerMethods = @('Write', 'WriteLine', 'WriteAsync', 'WriteLineAsync', 'Flush')

    # Whether a node is a static member reference on [Console] — [Console]::Write(...) or [Console]::Out.
    $isConsoleMember = {
        param($node)
        $node -is [System.Management.Automation.Language.MemberExpressionAst] -and $node.Static -and
        $node.Expression -is [System.Management.Automation.Language.TypeExpressionAst] -and
        $node.Expression.TypeName.FullName -in $consoleTypes
    }

    # Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew (ADR-AUTO-PSFORMAT:6).
    $isCandidate = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst] -or
        $node -is [System.Management.Automation.Language.MemberExpressionAst] -or
        $node -is [System.Management.Automation.Language.AssignmentStatementAst]
    }
    $nodes = $ScriptBlockAst.FindAll($isCandidate, $true)

    foreach ($node in $nodes) {
        $finding = $null

        if ($node -is [System.Management.Automation.Language.CommandAst]) {
            $name = $node.GetCommandName()
            if ($name -and $name -in $rawCommands) {
                $finding = "'$name' writes to the console past the information stream."
            }
        }
        elseif ($node -is [System.Management.Automation.Language.AssignmentStatementAst]) {
            $target = $node.Left
            if (& $isConsoleMember $target) {
                $finding = "Assigning [Console]::$($target.Member.Extent.Text) changes the console past the information stream."
            }
            elseif ($target.Extent.Text -match '^\$Host\.UI\.RawUI\.') {
                $finding = "Assigning $($target.Extent.Text) changes the console past the information stream."
            }
        }
        elseif (& $isConsoleMember $node) {
            $member = $node.Member.Extent.Text
            $parent = $node.Parent
            $writtenThrough = $member -in $consoleWriterMembers -and
            $parent -is [System.Management.Automation.Language.InvokeMemberExpressionAst] -and
            $parent.Expression -eq $node -and $parent.Member.Extent.Text -in $writerMethods
            if (($member -in $consoleWriteMembers -and $parent -isnot [System.Management.Automation.Language.AssignmentStatementAst]) -or $writtenThrough) {
                $finding = "[Console]::$member writes to the console past the information stream."
            }
        }
        elseif ($node -is [System.Management.Automation.Language.InvokeMemberExpressionAst]) {
            $receiver = $node.Expression.Extent.Text
            $member = $node.Member.Extent.Text
            if (($receiver -match '^\$Host\.UI$' -and $member -like 'Write*') -or
                ($receiver -match '^\$Host\.UI\.RawUI$' -and ($member -like 'Set*' -or $member -like 'Flush*' -or $member -like 'Scroll*'))) {
                $finding = "$receiver.$member() writes to the console past the information stream."
            }
        }

        if ($finding) {
            $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                    Message  = "$finding $advice"
                    Extent   = $node.Extent
                    RuleName = $ruleName
                    Severity = 'Warning'
                })
        }
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
