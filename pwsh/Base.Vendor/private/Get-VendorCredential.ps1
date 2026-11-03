function Get-VendorCredential {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '',
        Justification = 'The value comes from the environment variable the config names, read at call time; it is never written or logged')]
    [CmdletBinding()]
    [OutputType([pscredential])]
    param()

    $source = (Get-Config -Config vendor).package_source
    if (-not $source.credential_env) {
        return $null
    }

    $token = [System.Environment]::GetEnvironmentVariable($source.credential_env)
    if (-not $token) {
        throw "The vendor source '$($source.name)' needs the environment variable '$($source.credential_env)', and it is unset or empty."
    }

    [pscredential]::new('token', (ConvertTo-SecureString $token -AsPlainText -Force))
}
