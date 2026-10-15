<#
.SYNOPSIS
    Writes colored messages to the information stream.
.DESCRIPTION
    Writes via Write-Information, carrying the color as ANSI escape sequences embedded in the message text rather...
    [ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1),
    [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)
    [comment:1](/docs/references/automation/catzc-base-writers/private/Write-InformationColored.ps1.md#comment1)
.PARAMETER MessageData
    The message to write.
.PARAMETER ForegroundColor
    Text color. Defaults to the host's current foreground color.
.PARAMETER NoNewline
    Render the text without a trailing line break, so the next write continues the same line.
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

        [System.ConsoleColor] $ForegroundColor,

        [switch] $NoNewline
    )

    # Suppress during Pester runs (flag set by Test-Automation).
    # [comment:2](/docs/references/automation/catzc-base-writers/private/Write-InformationColored.ps1.md#comment2)
    if (Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore) {
        return
    }

    $text = [string]$MessageData

    if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        # The ConsoleColor -> ANSI SGR map lives once, in the Ansi type (shared with the rainbow writer), so this...
        # [comment:3](/docs/references/automation/catzc-base-writers/private/Write-InformationColored.ps1.md#comment3)
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
