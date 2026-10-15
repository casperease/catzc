<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
    kind: function
    module: Catzc.Base.Globs
    visibility: private
    adrs:
      - ADR-FLOW-CD-GLOBS
---
#>

<#
.SYNOPSIS
    Reads a pipeline or workflow YAML's trigger path filters — the actual, on-disk trigger globs.
.DESCRIPTION
    A missing section comes back as an empty array, never null, so a caller compares without null guards.
.PARAMETER Path
    The pipeline/workflow YAML file to read (absolute path).
.PARAMETER Vendor
    Ado or GitHub — which dialect's trigger keys to extract.
.OUTPUTS
    [pscustomobject] Ado: { TriggerInclude; TriggerExclude; PrInclude; PrExclude }.
                     GitHub: { PushPaths; PrPaths }.
#>
function Get-PipelineTrigger {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory)]
        [ValidateSet('Ado', 'GitHub')]
        [string] $Vendor
    )

    $doc = Get-Content -Path $Path -Raw | ConvertFrom-Yaml -Ordered

    $getIn = {
        param($node, [string[]] $keys)
        $cur = $node
        foreach ($key in $keys) {
            if ($null -eq $cur -or -not ($cur -is [System.Collections.IDictionary]) -or -not $cur.Contains($key)) {
                return $null
            }
            $cur = $cur[$key]
        }
        $cur
    }

    if ($Vendor -eq 'Ado') {
        $triggerInclude = & $getIn $doc @('trigger', 'paths', 'include')
        $triggerExclude = & $getIn $doc @('trigger', 'paths', 'exclude')
        $prInclude = & $getIn $doc @('pr', 'paths', 'include')
        $prExclude = & $getIn $doc @('pr', 'paths', 'exclude')
        [pscustomobject]@{
            TriggerInclude = [string[]] @(if ($null -ne $triggerInclude) {
                    $triggerInclude
                })
            TriggerExclude = [string[]] @(if ($null -ne $triggerExclude) {
                    $triggerExclude
                })
            PrInclude      = [string[]] @(if ($null -ne $prInclude) {
                    $prInclude
                })
            PrExclude      = [string[]] @(if ($null -ne $prExclude) {
                    $prExclude
                })
        }
    }
    else {
        $on = if ($doc -is [System.Collections.IDictionary] -and $doc.Contains('on')) {
            $doc['on']
        }
        elseif ($doc -is [System.Collections.IDictionary] -and $doc.Contains($true)) {
            $doc[$true]
        }
        else {
            $null
        }
        $pushPaths = & $getIn $on @('push', 'paths')
        $prPaths = & $getIn $on @('pull_request', 'paths')
        [pscustomobject]@{
            PushPaths = [string[]] @(if ($null -ne $pushPaths) {
                    $pushPaths
                })
            PrPaths   = [string[]] @(if ($null -ne $prPaths) {
                    $prPaths
                })
        }
    }
}
