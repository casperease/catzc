<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Asserts/Assert-PipelineEmpty.ps1
    name: assert-pipeline-empty
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: automation/Catzc.Base.Asserts/tests/Assert-PipelineEmpty.Tests.ps1
  config:
    synopsis: Asserts that the pipeline contains no objects.
    description: |-
      Throws on the first object received. Must be used as a pipeline consumer;
      passing -InputObject directly is an error.
    parameters:
      InputObject: Pipeline input (do not pass directly).
    examples:
      - Get-ChildPath $logFolder -File -Filter '*.log' | Assert-PipelineEmpty
---
#>

function Assert-PipelineEmpty {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object] $InputObject
    )

    begin {
        if ($PSBoundParameters.ContainsKey('InputObject')) {
            throw [System.ArgumentException]::new(
                'Assert-PipelineEmpty must take its input from the pipeline.',
                'InputObject'
            )
        }
    }

    process {
        throw 'Assertion failed: pipeline was not empty — {0}, line {1}' -f $MyInvocation.ScriptName, $MyInvocation.ScriptLineNumber
    }
}
