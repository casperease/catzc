function Get-GoEnvironment {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [switch] $Offline
    )

    # go reads a proxy credential from ~/.netrc, so the credential_env of go.yml package_source is not wired here.
    $source = (Get-Config -Config go).package_source
    $environment = [ordered]@{
        GOPROXY = $Offline ? 'off' : $source.url
    }
    if ($source.url -cne [Catzc.Base.Languages.PackageSource]::GoProxy.url) {
        $environment['GOPRIVATE'] = ([System.Uri] $source.url).Host
        $environment['GOSUMDB'] = 'off'
    }
    $environment
}
