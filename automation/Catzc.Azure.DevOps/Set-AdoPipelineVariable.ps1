<#
.SYNOPSIS
    Sets an Azure DevOps pipeline variable via the ##vso logging command.
.DESCRIPTION
    Wraps the ##vso[task.setvariable] command with output/secret flags and automatic no-op when running outside a...
    [ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)
    [comment:1](/docs/references/automation/catzc-azure-devops/Set-AdoPipelineVariable.ps1.md#comment1)
.PARAMETER Name
    The variable name. Must not contain . - ' unless -SanitizeName is set.
.PARAMETER Value
    The variable value.
    [comment:2](/docs/references/automation/catzc-azure-devops/Set-AdoPipelineVariable.ps1.md#comment2)
.PARAMETER IsOutput
    Mark as an output variable, accessible from downstream jobs via...
    [comment:3](/docs/references/automation/catzc-azure-devops/Set-AdoPipelineVariable.ps1.md#comment3)
.PARAMETER IsSecret
    Mark as secret.
    [comment:4](/docs/references/automation/catzc-azure-devops/Set-AdoPipelineVariable.ps1.md#comment4)
.PARAMETER SanitizeName
    Replace.
    [comment:5](/docs/references/automation/catzc-azure-devops/Set-AdoPipelineVariable.ps1.md#comment5)
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
