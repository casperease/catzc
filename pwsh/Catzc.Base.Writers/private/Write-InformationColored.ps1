<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Writers/private/Write-InformationColored.ps1
    folder: private
    name: write-information-colored
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Writers/tests/Write-InformationColored.Tests.ps1
    docs: "[Write-InformationColored.ps1.md](docs/references/pwsh/catzc-base-writers/private/Write-InformationColored.ps1.md)"
    cites:
      - ADR-AUTO-CONSOLE-NOBOXDRAWING
      - ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT
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

    if (Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore) {
        return
    }

    $text = [string]$MessageData

    if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
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
