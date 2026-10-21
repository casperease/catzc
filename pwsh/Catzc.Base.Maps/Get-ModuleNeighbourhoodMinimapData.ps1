<#
---
catzc:
  immutable:
    with_body_sha: "8bf32509d69d"
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-ModuleNeighbourhoodMinimapData.Tests.ps1
    docs: "[Get-ModuleNeighbourhoodMinimapData.ps1.md](docs/references/pwsh/catzc-base-maps/Get-ModuleNeighbourhoodMinimapData.ps1.md)"
    cites:
      - ADR-AUTO-DEPM
---
#>

function Get-ModuleNeighbourhoodMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Adr,

        [Catzc.Base.Maps.WorldMap] $WorldMap,

        [hashtable] $Facts,

        [switch] $AsJson
    )

    # The subject's modules, the modules they depend on, and the modules that depend on them, from the module dependency registry.
    $dependencies = Get-Config -Config dependencies
    $dependsOn = @{}
    foreach ($group in $dependencies.groups.Values) {
        foreach ($name in $group.members.Keys) {
            $dependsOn["$name"] = [string[]] @($group.members[$name])
        }
    }
    foreach ($name in $dependencies.modules.Keys) {
        $dependsOn["$name"] = [string[]] @($dependencies.modules[$name])
    }

    $count = @{}
    $reasons = @{}
    $subject = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($item in @(Get-MinimapSubject -Adr $Adr -WorldMap $WorldMap -Facts $Facts)) {
        if (-not $item.Facts -or -not $item.Facts['module']) {
            continue
        }
        $module = "$($item.Facts['module'])"
        $note = if ($item.Facts['moduletype']) {
            "$($item.Facts['moduletype'])"
        }
        else {
            $null
        }
        [void] $subject.Add($module)
        Add-MinimapHit -Count $count -Reasons $reasons -At @('subject', $module) -Reason ([Catzc.Base.Maps.MinimapReason]::new($item.Path, 'module', $item.Requested, $note))
    }

    # A neighbour's count is how many subject modules it is joined to.
    $rings = [ordered]@{ 'depends-on' = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal); 'used-by' = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal) }
    foreach ($module in $subject) {
        foreach ($target in @($dependsOn[$module] | Where-Object { $_ -and -not $subject.Contains($_) })) {
            [void] $rings['depends-on'].Add($target)
            $count["depends-on`t$target"] = 1 + [int] $count["depends-on`t$target"]
        }
        foreach ($user in @($dependsOn.Keys | Where-Object { -not $subject.Contains($_) -and @($dependsOn[$_]) -ccontains $module })) {
            [void] $rings['used-by'].Add($user)
            $count["used-by`t$user"] = 1 + [int] $count["used-by`t$user"]
        }
    }
    $cells = [string[][]] @(
        foreach ($module in $subject) {
            , [string[]] @('subject', $module)
        }
        foreach ($ring in $rings.Keys) {
            foreach ($module in $rings[$ring]) {
                , [string[]] @($ring, $module)
            }
        })
    $modules = [string[]] @($cells | ForEach-Object { $_[1] } | Sort-Object -Unique)
    $axes = [ordered]@{ ring = [string[]] @('subject', 'depends-on', 'used-by'); module = $modules }
    $data = New-MinimapData -Id ([Catzc.Base.Maps.MinimapData]::ModuleNeighbourhood) -Axes $axes -Cells $cells -Count $count -Reasons $reasons
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
