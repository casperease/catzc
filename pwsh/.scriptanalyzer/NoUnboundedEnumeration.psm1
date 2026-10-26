Set-StrictMode -Version Latest   # this module's scope: the rule runs strict inside the analyzer engine

<#
.SYNOPSIS
    Custom PSScriptAnalyzer rule: folders and files are listed through Get-ChildPath, never by a filesystem cmdlet or an unbounded walk.
.DESCRIPTION
    Flags Get-ChildItem and its aliases on a filesystem path, and [System.IO.SearchOption]::AllDirectories; test files are covered too.
#>

function Measure-NoUnboundedEnumeration {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst
    )

    $file = $ScriptBlockAst.Extent.File
    if (-not $file) {
        return @()
    }
    $results = [System.Collections.Generic.List[Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]]::new()
    $ruleName = 'Measure-NoUnboundedEnumeration'
    $listingCommands = 'Get-ChildItem', 'gci', 'dir', 'ls'
    $searchOptionTypes = 'System.IO.SearchOption', 'IO.SearchOption', 'SearchOption'

    # Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew.
    $isCommand = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst]
    }
    $isMember = {
        param($node)
        $node -is [System.Management.Automation.Language.MemberExpressionAst]
    }

    foreach ($command in $ScriptBlockAst.FindAll($isCommand, $true)) {
        $name = $command.GetCommandName()
        if (-not $name -or $name -notin $listingCommands) {
            continue
        }
        # A provider path (env:, function:, HKLM:) lists a provider, not the filesystem; a one-letter drive is a filesystem drive.
        $providerPath = $false
        foreach ($element in @($command.CommandElements | Select-Object -Skip 1)) {
            if ($element -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
                $element.Value -match '^[A-Za-z]{2,}:') {
                $providerPath = $true
                break
            }
        }
        if ($providerPath) {
            continue
        }
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = "List folders and files with Get-ChildPath, not $name (ADR-PWSH-ENUM-RAWDOTNETENUMERATION)."
                Extent   = $command.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    foreach ($member in $ScriptBlockAst.FindAll($isMember, $true)) {
        if (-not $member.Static -or
            $member.Member -isnot [System.Management.Automation.Language.StringConstantExpressionAst]) {
            continue
        }
        if ($member.Member.Value -ne 'AllDirectories' -or
            $member.Expression -isnot [System.Management.Automation.Language.TypeExpressionAst]) {
            continue
        }
        if ($member.Expression.TypeName.FullName -notin $searchOptionTypes) {
            continue
        }
        $results.Add([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                Message  = 'Walk below a folder with Get-ChildPath and an explicit -Depth, not SearchOption.AllDirectories (ADR-PWSH-ENUM-ALWAYSBOUNDED).'
                Extent   = $member.Extent
                RuleName = $ruleName
                Severity = 'Error'
            })
    }

    return $results.ToArray()
}

Export-ModuleMember -Function Measure-*
