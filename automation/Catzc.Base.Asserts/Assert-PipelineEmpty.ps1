<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-PipelineEmpty.ps1
    kind: function
    module: Catzc.Base.Asserts
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Asserts that the pipeline contains no objects.
.DESCRIPTION
    Only a pipeline consumer works here: passing -InputObject directly is an error, not an empty check.
.PARAMETER InputObject
    Pipeline input (do not pass directly).
.EXAMPLE
    Get-ChildPath $logFolder -File -Filter '*.log' | Assert-PipelineEmpty
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
