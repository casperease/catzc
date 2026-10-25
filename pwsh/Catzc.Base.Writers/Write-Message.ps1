<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-writers/Write-Message.ps1.md"
  header: "generated"
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

    # Only an explicit -Verbose reaches the verbose stream, so a session's Continue preference never diverts a message.
    if ($PSBoundParameters.ContainsKey('Verbose')) {
        Write-Verbose $line
        return
    }

    # Yellow on the information stream, never the warning stream; the parameter sets keep it apart from -ForegroundColor.
    if ($Warning) {
        Write-InformationColored $line -ForegroundColor Yellow -NoNewline:$NoNewline
    }
    elseif ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        # A status line is one solid line, so a rainbow input flattens to its base colour.
        $plan = Resolve-WriterColor -ForegroundColor $ForegroundColor -Bound
        Write-InformationColored $line -ForegroundColor $plan.Base -NoNewline:$NoNewline
    }
    else {
        Write-InformationColored $line -NoNewline:$NoNewline
    }
}
