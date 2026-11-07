function ConvertTo-ImportLedgerLine {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [datetime] $Started,

        [Parameter(Mandatory)]
        [double] $TotalSeconds,

        [Parameter(Mandatory)]
        [double] $InitializerSeconds,

        [Parameter(Mandatory)]
        [double] $VendorSeconds,

        # Null when the load-time diagnostics were off, since the types step runs inside the module loop and only they time it apart.
        [Nullable[double]] $TypesSeconds,

        [Parameter(Mandatory)]
        [double] $ModulesSeconds,

        [Parameter(Mandatory)]
        [double] $FinalizerSeconds,

        # Null when the load-time diagnostics were off, since only they read the files twice.
        [Nullable[int]] $FileReadMs,

        # Null when the load-time diagnostics were off.
        [Nullable[int]] $ParseCompileMs,

        # Null when the probe could not run.
        [Nullable[int]] $FileProbeMs,

        [Parameter(Mandatory)]
        [double] $CpuSeconds,

        [Parameter(Mandatory)]
        [double] $SinceProcessStartSeconds,

        [Parameter(Mandatory)]
        [string] $HostKind,

        [string] $AntivirusSignature
    )

    $signature = $null
    if ($AntivirusSignature) {
        $signature = $AntivirusSignature
    }

    [ordered]@{
        started                  = $Started.ToString('o')
        totalSeconds             = $TotalSeconds
        initializerSeconds       = $InitializerSeconds
        vendorSeconds            = $VendorSeconds
        typesSeconds             = $TypesSeconds
        modulesSeconds           = $ModulesSeconds
        finalizerSeconds         = $FinalizerSeconds
        fileReadMs               = $FileReadMs
        parseCompileMs           = $ParseCompileMs
        fileProbeMs              = $FileProbeMs
        cpuSeconds               = $CpuSeconds
        sinceProcessStartSeconds = $SinceProcessStartSeconds
        hostKind                 = $HostKind
        antivirusSignature       = $signature
    } | ConvertTo-Json -Compress
}
