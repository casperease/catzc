<#
---
catzc:
  immutable:
    with_body_sha: ae545a72a12a
  edges:
    docs: "[Add-MinimapHit.ps1.md](../../../docs/references/pwsh/catzc-base-maps/private/Add-MinimapHit.ps1.md)"
---
#>

function Add-MinimapHit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [hashtable] $Count,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [hashtable] $Reasons,

        [Parameter(Mandatory)]
        [string[]] $At,

        [Parameter(Mandatory)]
        [Catzc.Base.Maps.MinimapReason] $Reason
    )

    # A cell counts each subject once, however many requested codes light it through that subject.
    $key = $At -join "`t"
    if (-not $Reasons.ContainsKey($key)) {
        $Reasons[$key] = [System.Collections.Generic.List[Catzc.Base.Maps.MinimapReason]]::new()
    }
    if (-not @($Reasons[$key] | Where-Object { $_.Subject -ceq $Reason.Subject }).Count) {
        $Count[$key] = 1 + [int] $Count[$key]
    }
    $Reasons[$key].Add($Reason)
}
