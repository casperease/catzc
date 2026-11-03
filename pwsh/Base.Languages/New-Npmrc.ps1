function New-Npmrc {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $source = (Get-Config -Config javascript).package_source
    $registry = $source.url.TrimEnd('/') + '/'
    $lines = @("registry=$registry")
    if ($source.credential_env) {
        # npm expands the variable at run time, so the token itself is never written.
        $withoutScheme = $registry -replace '^https?:', ''
        $lines += ('{0}:_authToken=${{{1}}}' -f $withoutScheme, $source.credential_env)
    }
    ($lines -join "`n") + "`n"
}
