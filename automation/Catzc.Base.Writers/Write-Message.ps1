<#
.SYNOPSIS
    Writes a status message with calling function name prefix.
.DESCRIPTION
    Writes to the information stream via Write-InformationColored (which routes through Write-Information).
    [comment:1](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment1)
.PARAMETER Message
    The message text to write.
.PARAMETER NoHeader
    Omits the [caller] prefix.
.PARAMETER ForegroundColor
    Text color.
    [comment:2](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment2)
.PARAMETER Warning
    Render the line yellow on the information stream ( yellow = warning) — a non-fatal, attention-drawing status...
    [ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)
    [comment:3](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment3)
.PARAMETER NoNewline
    Render the text without a trailing line break, so the next write continues the same line — the inline liveness...
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

    # A verbose message (an explicitly-bound -Verbose) routes to the verbose stream instead of the always-on...
    # [comment:5](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment5)
    if ($PSBoundParameters.ContainsKey('Verbose')) {
        Write-Verbose $line
        return
    }

    # -Warning is sugar for yellow on the information stream, NOT the terminating Write-Warning stream.
    # [ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)
    # [comment:6](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment6)
    if ($Warning) {
        Write-InformationColored $line -ForegroundColor Yellow -NoNewline:$NoNewline
    }
    elseif ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        # A status line is one solid line, not a rule, so a rainbow input side-grades to its base colour: the shared...
        # [comment:7](/docs/references/automation/catzc-base-writers/Write-Message.ps1.md#comment7)
        $plan = Resolve-WriterColor -ForegroundColor $ForegroundColor -Bound
        Write-InformationColored $line -ForegroundColor $plan.Base -NoNewline:$NoNewline
    }
    else {
        Write-InformationColored $line -NoNewline:$NoNewline
    }
}
