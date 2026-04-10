<#
.SYNOPSIS
    Writes colored messages to the information stream.
.DESCRIPTION
    Writes via Write-Information, carrying the color as ANSI escape sequences embedded in
    the message text rather than via a console-API color parameter.

    Two reasons for embedded ANSI over Write-Host's -ForegroundColor:

    - Colors work in both interactive terminals and CI pipelines (ADO, GitHub Actions)
      because the message text contains ANSI escape sequences. Write-Host's -ForegroundColor
      uses the console API, which only works in interactive terminals — in CI stdout is a
      pipe and colors are lost. Embedding ANSI codes in the string survives redirection.

    - Output stays on the information stream, so in normal use it obeys $InformationPreference,
      -InformationAction, and 6> redirection — none of which Write-Host honours (it always renders).

    This is the single chokepoint every writer (Write-Message, Write-Object, Write-Header, …) routes
    through, so it is also where host output is suppressed during a Pester run. The suppression is a
    guard, not a stream preference: Pester captures the information stream around each test and replays
    it at Normal+ verbosity, so $InformationPreference = 'SilentlyContinue' does NOT stop the output —
    only not writing it does. Test-Automation sets $global:__PesterRunning, and this guard returns before
    writing. Tests that need to assert writer output lift the flag for their own scope.
.PARAMETER MessageData
    The message to write.
.PARAMETER ForegroundColor
    Text color. Defaults to the host's current foreground color.
.EXAMPLE
    Write-InformationColored 'Build succeeded' -ForegroundColor Green
.EXAMPLE
    Write-InformationColored 'WARN' -ForegroundColor Yellow
#>
function Write-InformationColored {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__PesterRunning (set by Test-Automation) is read to suppress host output during test runs; Pester captures the information stream regardless of $InformationPreference, so a guard — not a preference — is what silences it; global is required to cross module session-state boundaries')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [object] $MessageData,

        [System.ConsoleColor] $ForegroundColor
    )

    # Suppress during Pester runs (flag set by Test-Automation). The single chokepoint for all writers,
    # so nothing routed through here can leak into test output. See .DESCRIPTION for why a flag, not a stream.
    if ($global:__PesterRunning) {
        return
    }

    $text = [string]$MessageData

    if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        $ansi = switch ($ForegroundColor) {
            'Black' {
                "`e[30m"
            }
            'DarkRed' {
                "`e[31m"
            }
            'DarkGreen' {
                "`e[32m"
            }
            'DarkYellow' {
                "`e[33m"
            }
            'DarkBlue' {
                "`e[34m"
            }
            'DarkMagenta' {
                "`e[35m"
            }
            'DarkCyan' {
                "`e[36m"
            }
            'Gray' {
                "`e[37m"
            }
            'DarkGray' {
                "`e[90m"
            }
            'Red' {
                "`e[91m"
            }
            'Green' {
                "`e[92m"
            }
            'Yellow' {
                "`e[93m"
            }
            'Blue' {
                "`e[94m"
            }
            'Magenta' {
                "`e[95m"
            }
            'Cyan' {
                "`e[96m"
            }
            'White' {
                "`e[97m"
            }
            default {
                ''
            }
        }

        if ($ansi) {
            # Wrap each line individually — ADO/CI log renderers reset ANSI at newlines
            $lines = $text -split "`n"
            $text = ($lines | ForEach-Object { "${ansi}$_`e[0m" }) -join "`n"
        }
    }

    Write-Information $text
}
