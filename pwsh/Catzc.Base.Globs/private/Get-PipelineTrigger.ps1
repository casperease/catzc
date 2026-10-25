<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md"
  warning: "Generated Header"
---
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
