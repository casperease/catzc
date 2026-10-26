Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

function Measure-NoRawConsoleWrite {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoRawConsoleWrite'
    $advice = 'Write through the information stream instead: Write-Message (with -NoHeader / -ForegroundColor / -NoNewline as needed) — ADR-PWSH-ANNOUNCE-INFORMATIONCHOKEPOINT.'

    $rawCommands = @('Write-Host', 'Out-Host', 'Write-Progress', 'Clear-Host', 'clear', 'cls')
    $consoleTypes = @('Console', 'System.Console')
    $consoleWriteMembers = @(
        'Write', 'WriteLine', 'Clear', 'ResetColor', 'SetCursorPosition', 'Beep', 'SetWindowSize',
        'SetWindowPosition', 'SetBufferSize', 'MoveBufferArea', 'OpenStandardOutput', 'OpenStandardError'
    )
    # [Console]::Out and ::Error are raw writers only when written through; reading them to restore a SetOut capture is fine.
    $consoleWriterMembers = @('Out', 'Error')
    $writerMethods = @('Write', 'WriteLine', 'WriteAsync', 'WriteLineAsync', 'Flush')

    # Whether a node is a static member reference on [Console] — [Console]::Write(...) or [Console]::Out.
    $isConsoleMember = {
        param($node)
        $node -is [System.Management.Automation.Language.MemberExpressionAst] -and $node.Static -and
        $node.Expression -is [System.Management.Automation.Language.TypeExpressionAst] -and
        $node.Expression.TypeName.FullName -in $consoleTypes
    }

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
            if (($member -in $consoleWriteMembers -and
                    $parent -isnot [System.Management.Automation.Language.AssignmentStatementAst]) -or $writtenThrough) {
                $finding = "[Console]::$member writes to the console past the information stream."
            }
        }
        elseif ($node -is [System.Management.Automation.Language.InvokeMemberExpressionAst]) {
            $receiver = $node.Expression.Extent.Text
            $member = $node.Member.Extent.Text
            if (($receiver -match '^\$Host\.UI$' -and $member -like 'Write*') -or
                ($receiver -match '^\$Host\.UI\.RawUI$' -and ($member -like 'Set*' -or $member -like 'Flush*' -or
                    $member -like 'Scroll*'))) {
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
