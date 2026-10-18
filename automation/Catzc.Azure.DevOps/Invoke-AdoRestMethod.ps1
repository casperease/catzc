<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.DevOps/Invoke-AdoRestMethod.ps1
    name: invoke-ado-rest-method
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.DevOps/tests/Invoke-AdoRestMethod.Tests.ps1
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
