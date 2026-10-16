<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/Write-Message.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Writers
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-writers/Write-Message.ps1.md
      test: automation/Catzc.Base.Writers/tests/Write-Message.Tests.ps1
    adrs:
      - ADR-AUTO-CONSOLE#{7,8}
  config:
    synopsis: Writes a status message with calling function name prefix.
    description: |-
      Writes to the information stream via Write-InformationColored (which routes through
      Write-Information). Automatically prepends the calling function name as a header.

      Pass -Verbose to route the message (header included) to the verbose stream instead of the information
      stream — use it for detail that should appear only under -Verbose. Visibility follows the -Verbose value
      the caller supplies, so a caller forwards its own state, e.g. Write-Message '...' -Verbose:$emitVerbose;
      -Verbose:$false stays silent. -ForegroundColor does not apply on the verbose stream.

      Output is suppressed during a Pester run by the chokepoint guard in Write-InformationColored
      (this function has none of its own), so it stays silent in tests without per-function plumbing.
    parameters:
      Message: The message text to write.
      NoHeader: Omits the [caller] prefix.
      NoNewline: |-
        Render the text without a trailing line break, so the next write continues the same line — the inline
        liveness dot of
        (Write-Message '.' -NoHeader -NoNewline). Stays on the information
        stream. Does not apply on the verbose stream.
      ForegroundColor: |-
        Text color. When a header is shown, the color applies to the whole line (header included). Accepts a
        [System.ConsoleColor] (or its name), a 'rainbow' / '<base>-rainbow' bareword, or a
        [Catzc.Base.Writers.RainbowColor] profile — a status line is solid, so a rainbow input side-grades to its
        base colour rather than drawing a gradient (a gradient rule is a header/footer concern).
      Warning: |-
        Render the line yellow on the information stream
        ([ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7) yellow =
        warning) — a non-fatal, attention-drawing
        status line, NOT the terminating Write-Warning stream. The importer sets $WarningPreference = 'Stop', so a
        real warning would halt (NoWriteErrorOrWarning rule, error-handling ADR); use throw for something that must
        stop and -Warning for something worth noticing that must not. Implies yellow, so it is mutually exclusive
        with -ForegroundColor, and does not apply on the verbose stream. Aliased -Warn.
    examples:
      - Write-Message '.' -NoHeader -NoNewline
      - Write-Message 'Deployment complete'
      - Write-Message 'Done' -ForegroundColor Green -NoHeader
      - Write-Message -Warning 'Two builds present - is a console session locking the old DLL?'
---
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

    if ($PSBoundParameters.ContainsKey('Verbose')) {
        Write-Verbose $line
        return
    }

    if ($Warning) {
        Write-InformationColored $line -ForegroundColor Yellow -NoNewline:$NoNewline
    }
    elseif ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        $plan = Resolve-WriterColor -ForegroundColor $ForegroundColor -Bound
        Write-InformationColored $line -ForegroundColor $plan.Base -NoNewline:$NoNewline
    }
    else {
        Write-InformationColored $line -NoNewline:$NoNewline
    }
}
