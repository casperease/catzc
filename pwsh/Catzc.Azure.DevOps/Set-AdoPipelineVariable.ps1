<#
---
catzc:
  immutable:
    with_body_sha: "311627d480df"
  edges:
    test: pwsh/Catzc.Azure.DevOps/tests/Set-AdoPipelineVariable.Tests.ps1
    docs: "[Set-AdoPipelineVariable.ps1.md](docs/references/pwsh/catzc-azure-dev-ops/Set-AdoPipelineVariable.ps1.md)"
    cites:
      - ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT
---
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
