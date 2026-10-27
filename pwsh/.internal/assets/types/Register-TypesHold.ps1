function Register-TypesHold {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Writes only an empty marker in the per-user shadow cache, an internal load-time detail of the importer.')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Hash,

        [string] $ShadowRoot = (Get-TypesShadowRoot)
    )

    [System.IO.Directory]::CreateDirectory($ShadowRoot) | Out-Null
    $hold = [System.IO.Path]::Combine($ShadowRoot, "Catzc.Types.$Hash.$PID.hold")
    if (-not [System.IO.File]::Exists($hold)) {
        [System.IO.File]::WriteAllBytes($hold, [byte[]] @())
    }
    $hold
}
