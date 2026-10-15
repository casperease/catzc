<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/Invoke-AdoRestMethod.ps1
    kind: public-function
    module: Catzc.Azure.DevOps
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Calls an Azure DevOps REST API endpoint with authentication and standard error handling.
.DESCRIPTION
    The JSON content type is set only for POST, PUT and PATCH; a GET carries no body and no content type.
.PARAMETER Uri
    The full API URL including api-version query parameter.
.PARAMETER Method
    HTTP method. Defaults to Get.
.PARAMETER Body
    Request body for POST/PUT/PATCH. Accepts a hashtable or array — serialized to JSON automatically.
.PARAMETER UnwrapValue
    A GET unwraps by default, so a caller that needs the count field passes false to keep the wrapper.
.EXAMPLE
    $environments = Invoke-AdoRestMethod -Uri "$apiRoot/distributedtask/environments?api-version=7.1-preview.1&`$top=300"
.EXAMPLE
    $result = Invoke-AdoRestMethod -Uri $checksUrl -Method Post -Body @(
        @{ resourceId = $envId; resourceType = 'environment' }
    )
#>
function Invoke-AdoRestMethod {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Uri,

        [ValidateSet('Get', 'Post', 'Put', 'Patch', 'Delete')]
        [string] $Method = 'Get',

        [object] $Body,

        [Nullable[bool]] $UnwrapValue
    )

    $headers = Get-AdoAuthorizationHeader

    $params = @{
        Uri     = $Uri
        Method  = $Method
        Headers = $headers
    }

    if ($Body) {
        $params.Body = $Body | ConvertTo-Json -Depth 20 -Compress
        $params.ContentType = 'application/json'
    }

    Write-Message "$Method $Uri"

    $ret = Invoke-RestMethod @params

    $shouldUnwrap = if ($null -ne $UnwrapValue) {
        $UnwrapValue
    }
    else {
        $Method -eq 'Get'
    }

    if ($shouldUnwrap -and $null -ne $ret.value) {
        $ret.value
    }
    else {
        $ret
    }
}
