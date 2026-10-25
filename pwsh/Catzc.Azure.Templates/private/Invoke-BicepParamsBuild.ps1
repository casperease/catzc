<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-templates/private/Invoke-BicepParamsBuild.ps1.md"
  warning: "Generated Header"
---
#>

function Invoke-BicepParamsBuild {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $BicepParamPath,

        [Parameter(Mandatory)]
        [string] $ParametersPath
    )

    Invoke-AzCli "bicep build-params --file `"$BicepParamPath`" --outfile `"$ParametersPath`"" | Out-Null
    Assert-PathExist $ParametersPath -PathType Leaf -ErrorText (
        "az bicep build-params reported success but wrote no '$ParametersPath' from '$BicepParamPath'; check its output above.")
    Write-Message "Wrote $ParametersPath"
}
