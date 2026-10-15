<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/Set-AdoPipelineVariable.ps1
    kind: function
    module: Catzc.Azure.DevOps
    visibility: public
    adrs:
      - ADR-PWSH-ANNOUNCE#1
---
#>

<#
.SYNOPSIS
    Sets an Azure DevOps pipeline variable via the ##vso logging command.
.DESCRIPTION
    Outside a pipeline nothing is emitted, so a local or test run never sets a real pipeline variable.
.PARAMETER Name
    The variable name. Must not contain . - ' unless -SanitizeName is set.
.PARAMETER Value
    An empty string is allowed on purpose: it clears a variable or tells downstream jobs there is no value.
.PARAMETER IsOutput
    Without it the variable is invisible to downstream jobs, which reach it only through the step outputs.
.PARAMETER IsSecret
    The function also omits the value from its own message output, so it never relies on ADO masking alone.
.PARAMETER SanitizeName
    Opt-in because a silent rename hides the mismatch between the name set and the name referenced later.
.EXAMPLE
    Set-AdoPipelineVariable -Name 'DeployTarget' -Value 'preprod'
.EXAMPLE
    Set-AdoPipelineVariable -Name 'dev_capi' -Value 'Deploy' -IsOutput
.EXAMPLE
    Set-AdoPipelineVariable -Name 'dev.capi' -Value 'Deploy' -SanitizeName
.EXAMPLE
    Set-AdoPipelineVariable -Name 'ConnectionString' -Value $connStr -IsSecret
#>
function Set-AdoPipelineVariable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Mandatory, Position = 1)]
        [AllowEmptyString()]
        [string] $Value,

        [switch] $IsOutput,
        [switch] $IsSecret,
        [switch] $SanitizeName
    )

    Assert-NotNullOrWhitespace $Name -ErrorText 'Pipeline variable name cannot be empty'

    if ($Name -match "[.\-']") {
        if ($SanitizeName) {
            $Name = $Name.Replace('.', '_').Replace('-', '_').Replace("'", '')
        }
        else {
            throw "Pipeline variable name '$Name' contains characters (. - ') that ADO silently replaces with underscores. " +
            'Use underscores in the name directly, or pass -SanitizeName to opt into automatic replacement.'
        }
    }

    if (-not (Test-IsRunningInPipeline)) {
        $displayValue = if ($IsSecret) {
            '***'
        }
        else {
            $Value
        }
        Write-Verbose "Skipping ##vso (not in pipeline): $Name = $displayValue"
        return
    }

    if ($IsSecret) {
        Write-Message "Setting pipeline variable: $Name = ***"
    }
    else {
        Write-Message "Setting pipeline variable: $Name = $Value"
    }

    $flags = "variable=$Name;"
    if ($IsOutput) {
        $flags += 'isOutput=true;'
    }
    $flags += "issecret=$($IsSecret.ToString().ToLower())"

    Write-Message "##vso[task.setvariable $flags]$Value" -NoHeader
}
