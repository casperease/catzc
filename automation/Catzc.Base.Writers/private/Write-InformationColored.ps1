<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/private/Write-InformationColored.ps1
    kind: private-function
    module: Catzc.Base.Writers
    visibility: private
    adrs:
      - ADR-AUTO-CONSOLE#8
      - ADR-PWSH-ANNOUNCE#1
  config:
    synopsis: Writes colored messages to the information stream.
    description: |-
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

      It is also the one way to write to the console at all
      ([ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)): nothing
      in the toolset calls
      Write-Host, [Console]::Write or $Host.UI. -NoNewline covers the one thing those were used for — an inline
      liveness dot
      ([ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)). It wraps
      the text in a HostInformationMessage with NoNewLine set, the same
      record Write-Host emits internally, so the host renders it without a line break while it stays an ordinary
      information-stream record: it obeys $InformationPreference and 6> redirection, and never enters the pipeline.
    parameters:
      MessageData: The message to write.
      ForegroundColor: Text color. Defaults to the host's current foreground color.
      NoNewline: Render the text without a trailing line break, so the next write continues the same line.
    examples:
      - Write-InformationColored 'Build succeeded' -ForegroundColor Green
      - Write-InformationColored 'WARN' -ForegroundColor Yellow
---
#>

function Write-InformationColored {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__PesterRunning (set by Test-Automation) is read to suppress host output during test runs; Pester captures the information stream regardless of $InformationPreference, so a guard — not a preference — is what silences it; global is required to cross module session-state boundaries')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [object] $MessageData,

        [System.ConsoleColor] $ForegroundColor,

        [switch] $NoNewline
    )

    # Suppress during Pester runs (flag set by Test-Automation).
    # [comment:4](/docs/references/automation/catzc-base-writers/private/Write-InformationColored.ps1.md#comment4)
    if (Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore) {
        return
    }

    $text = [string]$MessageData

    if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        # The ConsoleColor -> ANSI SGR map lives once, in the Ansi type (shared with the rainbow writer), so this...
        # [comment:5](/docs/references/automation/catzc-base-writers/private/Write-InformationColored.ps1.md#comment5)
        $ansi = [Catzc.Base.Writers.Ansi]::Code($ForegroundColor)

        if ($ansi) {
            # Wrap each line individually — ADO/CI log renderers reset ANSI at newlines
            $reset = [Catzc.Base.Writers.Ansi]::Reset
            $lines = $text -split "`n"
            $text = ($lines | ForEach-Object { "${ansi}$_$reset" }) -join "`n"
        }
    }

    if ($NoNewline) {
        Write-Information ([System.Management.Automation.HostInformationMessage]@{ Message = $text; NoNewLine = $true })
        return
    }
    Write-Information $text
}
