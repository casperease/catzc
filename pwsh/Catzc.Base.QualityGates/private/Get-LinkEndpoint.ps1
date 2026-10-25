<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-LinkEndpoint.ps1.md"
  warning: "Generated Header"
---
#>

function Get-LinkEndpoint {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[string, Catzc.Base.QualityGates.LinkEndpoint]])]
    param(
        # Repository-relative, '/'-separated paths; each distinct path is resolved once.
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    $kinds = Get-Config -Config file-kinds
    $moduleTypes = Get-Config -Config module-types
    $tracks = @(Get-Track)
    $distinct = @($Path | ForEach-Object { $_.Replace('\', '/') } | Select-Object -Unique)
    $aspects = Get-FileAspect -Path $distinct

    $endpoints = [System.Collections.Generic.Dictionary[string, Catzc.Base.QualityGates.LinkEndpoint]]::new([System.StringComparer]::Ordinal)
    foreach ($file in $distinct) {
        $kind = $kinds.Resolve($file)
        $track = $null
        $bestLength = -1
        foreach ($candidate in $tracks) {
            $length = $candidate.PlaceLengthOf($file)
            if ($length -gt $bestLength) {
                $track = $candidate
                $bestLength = $length
            }
        }
        $module = $moduleTypes.Resolve($file)
        $endpoints[$file] = [Catzc.Base.QualityGates.LinkEndpoint]::new(
            $file,
            $(if ($kind) {
                    $kind.Class
                }
                else {
                    ''
                }),
            $aspects[$file],
            $(if ($track) {
                    $track.name
                }
                else {
                    ''
                }),
            $(if ($track) {
                    $track.type
                }
                else {
                    ''
                }),
            $(if ($module) {
                    $module.name
                }
                else {
                    ''
                }))
    }
    , $endpoints
}
