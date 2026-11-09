function Get-ImportLedgerLastSignature {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    # The last line's antivirus signature, or null: a ledger that cannot be read names no change, since an import never fails for its own record.
    try {
        if (-not [System.IO.File]::Exists($Path)) {
            return $null
        }
        $lines = [System.IO.File]::ReadAllLines($Path)
        for ($index = $lines.Length - 1; $index -ge 0; $index--) {
            if ($lines[$index].Trim().Length -eq 0) {
                continue
            }
            $match = [System.Text.RegularExpressions.Regex]::Match($lines[$index], '"antivirusSignature":"([^"]+)"')
            if ($match.Success) {
                return $match.Groups[1].Value
            }
            return $null
        }
        $null
    }
    catch {
        $null
    }
}
