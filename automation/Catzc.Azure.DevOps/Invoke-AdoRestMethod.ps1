<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/Invoke-AdoRestMethod.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Azure.DevOps
    visibility: public
    relatives:
      test: automation/Catzc.Azure.DevOps/tests/Invoke-AdoRestMethod.Tests.ps1
  config:
    synopsis: Calls an Azure DevOps REST API endpoint with authentication and standard error handling.
    description: |-
      Wraps Invoke-RestMethod with the dual-auth pattern (Get-AdoAuthorizationHeader),
      JSON content type for POST/PUT/PATCH, and response unwrapping for list endpoints
      (extracts the .value array automatically).

      Designed for the ADO REST API conventions:
      - Bearer token authentication
      - JSON request/response bodies
      - List responses wrapped in { "count": N, "value": [...] }
    parameters:
      Uri: The full API URL including api-version query parameter.
      Method: HTTP method. Defaults to Get.
      Body: Request body for POST/PUT/PATCH. Accepts a hashtable or array — serialized to JSON automatically.
      UnwrapValue: |-
        For list endpoints, extract the .value array from the response instead of returning the wrapper.
        Defaults to true for GET requests.
    examples:
      - '$environments = Invoke-AdoRestMethod -Uri "$apiRoot/distributedtask/environments?api-version=7.1-preview.1&`$top=300"'
      - |-
        $result = Invoke-AdoRestMethod -Uri $checksUrl -Method Post -Body @(
            @{ resourceId = $envId; resourceType = 'environment' }
        )
---
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
