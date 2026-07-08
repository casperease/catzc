<#
.SYNOPSIS
    Writes a status message with calling function name prefix.
.DESCRIPTION
    Writes to the information stream via Write-InformationColored (which routes through
    Write-Information). Automatically prepends the calling function name as a header.

    Pass -Verbose to route the message (header included) to the verbose stream instead of the information
    stream — use it for detail that should appear only under -Verbose. Visibility follows the -Verbose value
    the caller supplies, so a caller forwards its own state, e.g. Write-Message '...' -Verbose:$emitVerbose;
    -Verbose:$false stays silent. -ForegroundColor does not apply on the verbose stream.

    Output is suppressed during a Pester run by the chokepoint guard in Write-InformationColored
    (this function has none of its own), so it stays silent in tests without per-function plumbing.
.PARAMETER Message
    The message text to write.
.PARAMETER NoHeader
    Omits the [caller] prefix.
.PARAMETER ForegroundColor
    Text color. When a header is shown, the color applies to the whole line (header included). Accepts a
    [System.ConsoleColor] (or its name), a 'rainbow' / '<base>-rainbow' bareword, or a
    [Catzc.Base.Writers.RainbowColor] profile — a status line is solid, so a rainbow input side-grades to its
    base colour rather than drawing a gradient (a gradient rule is a header/footer concern).
.PARAMETER Warning
    Render the line yellow on the information stream (ADR-CONSOLE:7 yellow = warning) — a non-fatal, attention-drawing
    status line, NOT the terminating Write-Warning stream. The importer sets $WarningPreference = 'Stop', so a
    real warning would halt (NoWriteErrorOrWarning rule, error-handling ADR); use throw for something that must
    stop and -Warning for something worth noticing that must not. Implies yellow, so it is mutually exclusive
    with -ForegroundColor, and does not apply on the verbose stream. Aliased -Warn.
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

    # A verbose message (an explicitly-bound -Verbose) routes to the verbose stream instead of the always-on
    # information stream; its visibility follows the -Verbose value the caller passed (an explicit -Verbose
    # sets this call's $VerbosePreference, which Write-Verbose honours, so -Verbose:$false stays silent).
    # Requiring an EXPLICIT -Verbose keeps ordinary messages on the info stream even when the session's
    # $VerbosePreference is Continue. -ForegroundColor does not apply to the verbose stream.
    if ($PSBoundParameters.ContainsKey('Verbose')) {
        Write-Verbose $line
        return
    }

    # -Warning is sugar for yellow (ADR-CONSOLE:7) on the information stream, NOT the terminating Write-Warning stream.
    # Parameter sets make it exclusive with -ForegroundColor, so at most one of these branches carries a colour.
    if ($Warning) {
        Write-InformationColored $line -ForegroundColor Yellow
    }
    elseif ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        # A status line is one solid line, not a rule, so a rainbow input side-grades to its base colour: the
        # shared resolver flattens a ConsoleColor, its name, a 'rainbow'/'<base>-rainbow' bareword, or a
        # RainbowColor profile to one ConsoleColor. Passing a rainbow to Write-Message therefore just works.
        $plan = Resolve-WriterColor -ForegroundColor $ForegroundColor -Bound
        Write-InformationColored $line -ForegroundColor $plan.Base
    }
    else {
        Write-InformationColored $line
    }
}
