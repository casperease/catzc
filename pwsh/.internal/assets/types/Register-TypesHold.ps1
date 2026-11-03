function Register-TypesHold {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Writes only an empty marker in the per-user shadow cache, an internal load-time detail of the importer.')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Hash,

        [string] $ShadowRoot = (Get-TypesShadowRoot),

        [ValidateNotNullOrEmpty()]
        [string] $Namespace = $ExecutionContext.SessionState.PSVariable.GetValue('script:typesDefaultNamespace')
    )

    [System.IO.Directory]::CreateDirectory($ShadowRoot) | Out-Null
    $hold = [System.IO.Path]::Combine($ShadowRoot, "$(Get-TypesAssemblyPrefix -Namespace $Namespace)$Hash.$PID.hold")
    if (-not [System.IO.File]::Exists($hold)) {
        [System.IO.File]::WriteAllBytes($hold, [byte[]] @())
    }
    $hold
}
