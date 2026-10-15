<#
.SYNOPSIS
    Writes a status message with calling function name prefix.
.DESCRIPTION
    Silent in Pester runs through the guard in Write-InformationColored, so this function needs no test plumbing.
    [comment:1](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment1)
.PARAMETER Message
    The message text to write.
.PARAMETER NoHeader
    Omits the [caller] prefix.
.PARAMETER ForegroundColor
    A rainbow value is flattened to its base colour, because a status line is solid and a gradient is for rules.
    [comment:2](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment2)
.PARAMETER Warning
    Not the Write-Warning stream: the importer makes a real warning halt, so use throw to stop and this to notify.
    [ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)
    [comment:3](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment3)
.PARAMETER NoNewline
    The next write continues the same line, so this serves the inline liveness dot; it has no effect on verbose output.
    [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)
    [comment:4](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment4)
.EXAMPLE
    Write-Message '.' -NoHeader -NoNewline
.EXAMPLE
    Write-Message 'Deployment complete'
.EXAMPLE
    Write-Message 'Done' -ForegroundColor Green -NoHeader
.EXAMPLE
    Write-Message -Warning 'Two builds present - is a console session locking the old DLL?'
#>
function Write-Message {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromRemainingArguments)]
        [AllowEmptyString()]
        [string] $Message,

        [switch] $NoHeader,

        [switch] $NoNewline,

        [Parameter(ParameterSetName = 'Color')]
        [object] $ForegroundColor,

        [Parameter(ParameterSetName = 'Warning')]
        [Alias('Warn')]
        [switch] $Warning
    )

    $line = $Message
    if (-not $NoHeader) {
        $callerName = ''
        $callStack = Get-PSCallStack
        if ($callStack.Count -gt 1) {
            $callerName = $callStack[1].Command
            $callerName = if ($callerName -eq '<ScriptBlock>') {
                'prompt'
            }
            else {
                $callerName
            }
        }

        $header = if ($env:CATZC_MESSAGE_TIMESTAMPS) {
            $ts = Get-Date -Format 'HH:mm:ss.fff'
            "[$ts $callerName]"
        }
        else {
            "[$callerName]"
        }

        $line = "$header $Message"
    }

    # Only an explicit -Verbose counts, so ordinary messages stay on the info stream even when the session is verbose.
    # [comment:5](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment5)
    if ($PSBoundParameters.ContainsKey('Verbose')) {
        Write-Verbose $line
        return
    }

    # Parameter sets keep -Warning and -ForegroundColor exclusive, so at most one branch here sets a colour.
    # [ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)
    # [comment:6](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment6)
    if ($Warning) {
        Write-InformationColored $line -ForegroundColor Yellow -NoNewline:$NoNewline
    }
    elseif ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        # The resolver flattens any accepted colour form to one ConsoleColor, so a rainbow argument works unchanged.
        # [comment:7](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment7)
        $plan = Resolve-WriterColor -ForegroundColor $ForegroundColor -Bound
        Write-InformationColored $line -ForegroundColor $plan.Base -NoNewline:$NoNewline
    }
    else {
        Write-InformationColored $line -NoNewline:$NoNewline
    }
}
