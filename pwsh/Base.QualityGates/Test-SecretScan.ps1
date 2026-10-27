function Test-SecretScan {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string[]] $Path = @('.'),

        [Catzc.Base.QualityGates.SecretPatternsConfig] $Config = (Get-Config -Config secret-patterns),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $repositoryRoot = Get-RepositoryRoot
    $files = [string[]] @(@(foreach ($folder in $Path) {
                Get-GitTrackedPath $folder
            }) | Sort-Object -Unique)

    $issues = [System.Collections.Generic.List[string]]::new()
    $scanned = 0
    foreach ($file in $files) {
        if (@($Config.skip | Where-Object { $file -like $_ }).Count) {
            continue
        }
        $full = Join-Path $repositoryRoot $file
        if (-not [System.IO.File]::Exists($full)) {
            continue
        }
        # A file with a NUL byte in its head is binary and holds no text to read.
        $bytes = [System.IO.File]::ReadAllBytes($full)
        if ([System.Array]::IndexOf($bytes, [byte] 0, 0, [System.Math]::Min($bytes.Length, 8000)) -ge 0) {
            continue
        }
        $scanned++
        $number = 0
        foreach ($line in [System.Text.Encoding]::UTF8.GetString($bytes) -split '\r?\n') {
            $number++
            foreach ($name in $Config.Matches($line)) {
                # The finding names the shape and the place, never the matched text.
                $issues.Add("${file}:${number}: a $name — remove it and rotate it; a secret is a Key Vault reference, never a literal")
            }
        }
    }

    Write-QualityGateReport -Subject secret-scan -Title Test-SecretScan -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Files = $files.Count; Scanned = $scanned }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
