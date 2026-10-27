function Invoke-BicepParamsBuild {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $BicepPath,

        [Parameter(Mandatory)]
        [string] $BicepParamPath,

        [Parameter(Mandatory)]
        [string] $ParametersPath
    )

    Invoke-Executable "`"$BicepPath`" build-params `"$BicepParamPath`" --outfile `"$ParametersPath`"" | Out-Null
    Assert-PathExist $ParametersPath -PathType Leaf -ErrorText (
        "bicep build-params reported success but wrote no '$ParametersPath' from '$BicepParamPath'; check its output above.")
    Write-Message "Wrote $ParametersPath"
}
