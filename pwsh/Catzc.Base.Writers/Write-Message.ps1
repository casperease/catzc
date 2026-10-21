<#
---
catzc:
  immutable:
    with_body_sha: bf26c890810c
  edges:
    test: pwsh/Catzc.Base.Writers/tests/Write-Message.Tests.ps1
    docs: "[Write-Message.ps1.md](docs/references/pwsh/catzc-base-writers/Write-Message.ps1.md)"
    cites:
      - ADR-AUTO-CONSOLE-SPARINGCOLOUR
      - ADR-AUTO-CONSOLE-NOBOXDRAWING
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
