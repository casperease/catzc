function Write-InformationColored {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
        Justification = '$global:__PesterRunning (set by Test-Automation) is read to suppress host output during test runs; Pester captures the information stream regardless of $InformationPreference, so a guard — not a preference — is what silences it; global is required to cross module session-state boundaries')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [object] $MessageData,

        [System.ConsoleColor] $ForegroundColor,

        [switch] $NoNewline
    )

    # Silent during a test run; read through Get-Variable, because strict mode rejects the flag where it is unset.
    if (Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore) {
        return
    }

    $text = [string]$MessageData

    if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        # One colour map for every writer, so plain and rainbow output never disagree on a code; empty means no escape.
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
