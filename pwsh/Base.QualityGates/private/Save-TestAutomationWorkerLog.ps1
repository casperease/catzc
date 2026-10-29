function Save-TestAutomationWorkerLog {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [AllowEmptyString()]
        [AllowNull()]
        [string] $StandardOutput = '',

        [AllowEmptyString()]
        [AllowNull()]
        [string] $StandardError = ''
    )

    # The worker's whole console, its output then its errors, so an error Pester only printed is read after the run.
    $text = "$StandardOutput"
    if ("$StandardError".Length -gt 0) {
        $text += "`n--- stderr ---`n$StandardError"
    }
    [System.IO.File]::WriteAllText($Path, $text, [System.Text.UTF8Encoding]::new($false))
}
