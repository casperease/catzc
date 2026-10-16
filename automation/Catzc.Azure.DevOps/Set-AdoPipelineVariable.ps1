<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/Set-AdoPipelineVariable.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.DevOps
    visibility: public
    relatives:
      test: automation/Catzc.Azure.DevOps/tests/Set-AdoPipelineVariable.Tests.ps1
    adrs:
      - ADR-PWSH-ANNOUNCE#1
  config:
    synopsis: 'Sets an Azure DevOps pipeline variable via the ##vso logging command.'
    description: |-
      Wraps the ##vso[task.setvariable] command with output/secret flags
      and automatic no-op when running outside a pipeline.

      By default, throws if the variable name contains characters that ADO
      silently replaces during downstream resolution (. - '). This prevents
      hard-to-debug mismatches between the name you set and the name you
      reference. Use -SanitizeName to opt into automatic replacement instead.

      When running locally (Test-IsRunningInPipeline returns false), the function
      logs the variable but does not emit the ##vso command.

      The ##vso command is written like every other console line, through the
      writer chokepoint (Write-Message -NoHeader,
      [ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)): the host
      renders an information record to stdout exactly as it renders Write-Host,
      which is where the agent reads logging commands. Being an ordinary record, it
      honours 6> redirection, and a Pester run silences it — so a test run in a
      pipeline never sets a real pipeline variable.
    parameters:
      Name: The variable name. Must not contain . - ' unless -SanitizeName is set.
      Value: |-
        The variable value. Empty strings are allowed so callers can clear
        a variable or signal "no value" to downstream jobs.
      IsOutput: |-
        Mark as an output variable, accessible from downstream jobs via
        dependencies.JobName.outputs['StepName.VariableName'].
      IsSecret: |-
        Mark as secret. ADO masks the value in all log output.
        The function also omits the value from its own Write-Message output.
      SanitizeName: |-
        Replace . - ' with underscores instead of throwing. Use when the caller
        intentionally passes names with these characters (e.g. environment.template
        patterns from dynamic key generation).
    examples:
      - Set-AdoPipelineVariable -Name 'DeployTarget' -Value 'preprod'
      - Set-AdoPipelineVariable -Name 'dev_capi' -Value 'Deploy' -IsOutput
      - Set-AdoPipelineVariable -Name 'dev.capi' -Value 'Deploy' -SanitizeName
      - Set-AdoPipelineVariable -Name 'ConnectionString' -Value $connStr -IsSecret
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
