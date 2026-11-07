function Add-ImportLedgerLine {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Line
    )

    # A ledger that cannot be written is skipped in silence: an import never fails for its own record.
    try {
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
        [System.IO.File]::AppendAllText($Path, $Line + "`n", [System.Text.UTF8Encoding]::new($false))
    }
    catch {
        $null = $_
    }
}
