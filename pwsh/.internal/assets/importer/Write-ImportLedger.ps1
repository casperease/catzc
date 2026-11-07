function Write-ImportLedger {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $ModulesRoot,

        [Parameter(Mandatory)]
        [datetime] $Started,

        [Parameter(Mandatory)]
        [double] $TotalSeconds,

        [Parameter(Mandatory)]
        [double] $InitializerSeconds,

        [Parameter(Mandatory)]
        [double] $VendorSeconds,

        # The module loop with the types step still inside it; the types seconds are taken off here.
        [Parameter(Mandatory)]
        [double] $LoopSeconds,

        [Parameter(Mandatory)]
        [double] $FinalizerSeconds,

        [Parameter(Mandatory)]
        [double] $CpuSeconds,

        [Parameter(Mandatory)]
        [double] $SinceProcessStartSeconds,

        [Parameter(Mandatory)]
        [string] $HostKind,

        # Null when the types step was not timed.
        [Nullable[double]] $TypesMs,

        [Nullable[int]] $ParseCompileMs,

        # Null without the load-time diagnostics, since only they read the files twice.
        [Nullable[int]] $FileReadMs,

        [Nullable[int]] $FileProbeMs
    )

    # The whole record is best effort: an import never fails or slows for its own ledger, and a miss names no CPU time.
    $suffix = ''
    try {
        $roofSeconds = $null
        if ('Catzc.Base.Timeouts.TimeoutsConfig' -as [type]) {
            $roofSeconds = (Get-Config -Config timeouts).ImportConsoleSeconds()
        }
        else {
            $timeoutsFile = [System.IO.Path]::Combine($ModulesRoot, 'Base.Timeouts', 'configs', 'timeouts.yml')
            $roofLine = [System.Text.RegularExpressions.Regex]::Match([System.IO.File]::ReadAllText($timeoutsFile),
                '(?m)^import:[ \t]*\r?\n[ \t]+console_seconds:[ \t]*(\d+)')
            if ($roofLine.Success) {
                $roofSeconds = [int] $roofLine.Groups[1].Value
            }
        }
        $suffix = Get-ImportCpuSuffix -TotalSeconds $TotalSeconds -RoofSeconds $roofSeconds -CpuSeconds $CpuSeconds
    }
    catch {
        $suffix = ''
    }

    try {
        $typesSeconds = $null
        $modulesSeconds = $LoopSeconds
        if ($null -ne $TypesMs) {
            $typesSeconds = [math]::Round($TypesMs / 1000, 1)
            $modulesSeconds = [math]::Round($LoopSeconds - $typesSeconds, 1)
        }
        $signature = $null
        if ($IsWindows) {
            try {
                $signatureKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SOFTWARE\Microsoft\Windows Defender\Signature Updates')
                if ($signatureKey) {
                    $signature = [string] $signatureKey.GetValue('AVSignatureVersion')
                    $signatureKey.Dispose()
                }
            }
            catch {
                $signature = $null
            }
        }
        $line = ConvertTo-ImportLedgerLine -Started $Started -TotalSeconds $TotalSeconds -InitializerSeconds $InitializerSeconds `
            -VendorSeconds $VendorSeconds -TypesSeconds $typesSeconds -ModulesSeconds $modulesSeconds -FinalizerSeconds $FinalizerSeconds `
            -FileReadMs $FileReadMs -ParseCompileMs $ParseCompileMs -FileProbeMs $FileProbeMs -CpuSeconds $CpuSeconds `
            -SinceProcessStartSeconds $SinceProcessStartSeconds -HostKind $HostKind -AntivirusSignature $signature
        Add-ImportLedgerLine -Path ([System.IO.Path]::Combine($RepositoryRoot, 'out', 'import-times.jsonl')) -Line $line
    }
    catch {
        $null = $_
    }
    $suffix
}
