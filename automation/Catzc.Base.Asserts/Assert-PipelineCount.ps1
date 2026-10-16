<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/Assert-PipelineCount.ps1
    name: assert-pipeline-count
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: automation/Catzc.Base.Asserts/tests/Assert-PipelineCount.Tests.ps1
  config:
    synopsis: Asserts the number of objects in the pipeline.
    description: |-
      Counts pipeline objects and validates against -Equals, -Minimum, or -Maximum.
      Objects are passed through. Fails early when the count exceeds -Equals or -Maximum.
    parameters:
      InputObject: Pipeline input (do not pass directly).
      Equals: Exact expected count.
      Minimum: Minimum acceptable count (inclusive).
      Maximum: Maximum acceptable count (inclusive).
    examples:
      - Get-Process | Assert-PipelineCount -Minimum 1
      - 1..3 | Assert-PipelineCount 3
---
#>

function Assert-PipelineCount {
    [CmdletBinding(DefaultParameterSetName = 'Equals')]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object] $InputObject,

        [Parameter(Mandatory, ParameterSetName = 'Equals', Position = 0)]
        [uint64] $Equals,

        [Parameter(Mandatory, ParameterSetName = 'Minimum')]
        [uint64] $Minimum,

        [Parameter(Mandatory, ParameterSetName = 'Maximum')]
        [uint64] $Maximum
    )

    begin {
        if ($PSBoundParameters.ContainsKey('InputObject')) {
            throw [System.ArgumentException]::new(
                'Assert-PipelineCount must take its input from the pipeline.',
                'InputObject'
            )
        }

        [uint64] $count = 0

        $failEarly, $failFinal = switch ($PSCmdlet.ParameterSetName) {
            'Equals' {
                { $count -gt $Equals }, { $count -ne $Equals }
            }
            'Maximum' {
                { $count -gt $Maximum }, { $count -gt $Maximum }
            }
            'Minimum' {
                { $false }, { $count -lt $Minimum }
            }
        }
    }

    process {
        $count++
        $InputObject

        if (& $failEarly) {
            throw "Assertion failed: pipeline count exceeded $($PSCmdlet.ParameterSetName) — {0}, line {1}" -f $MyInvocation.ScriptName, $MyInvocation.ScriptLineNumber
        }
    }

    end {
        if (& $failFinal) {
            throw "Assertion failed: pipeline count ($count) did not meet $($PSCmdlet.ParameterSetName) constraint — {0}, line {1}" -f $MyInvocation.ScriptName, $MyInvocation.ScriptLineNumber
        }
    }
}
