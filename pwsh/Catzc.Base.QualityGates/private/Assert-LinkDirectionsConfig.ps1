<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Assert-LinkDirectionsConfig.ps1.md"
  header: "generated"
---
#>

function Assert-LinkDirectionsConfig {
    [CmdletBinding()]
    param(
        # The link-directions config as read, before its type maps it.
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $Config
    )

    $typed = [Catzc.Base.QualityGates.LinkDirectionsConfig]::new($Config)
    $classes = [System.Collections.Generic.List[string]]::new()
    $walk = {
        param($Entries, [string] $Role)
        foreach ($entry in $Entries) {
            $class = if ($Role) {
                "$Role/$($entry.subkind)"
            }
            else {
                $entry.role
            }
            $classes.Add($class)
            & $walk $entry.subkinds $(if ($Role) {
                    $Role
                }
                else {
                    $entry.role
                })
        }
    }
    & $walk (Get-Config -Config file-kinds).kinds ''
    $trackTypes = @((Get-Config -Config track-types).types.ForEach({ $_.id }))
    $tracks = @(Get-Track | ForEach-Object name)
    $aspects = @((Get-AspectGlobSet).Keys)
    $modules = @(Get-Module -Name 'Catzc.*' | ForEach-Object Name)
    $map = Get-DrsCitationMap

    $problems = [System.Collections.Generic.List[string]]::new()
    $number = 0
    foreach ($row in $typed.rows) {
        $number++
        foreach ($side in @(@{ name = 'from'; selector = $row.from }, @{ name = 'to'; selector = $row.to })) {
            $where = "row $number.$($side.name)"
            foreach ($class in $side.selector.classes) {
                $pattern = '^' + [regex]::Escape($class).Replace('\*', '.*') + '(/.*)?$'
                if (-not @($classes.Where({ $_ -cmatch $pattern })).Count) {
                    $problems.Add("${where}: class '$class' is no file kind of file-kinds.yml")
                }
            }
            foreach ($pair in @(
                    @{ key = 'aspects'; known = $aspects; source = 'the aspect model' }
                    @{ key = 'tracks'; known = $tracks; source = 'variants.yml' }
                    @{ key = 'track_types'; known = $trackTypes; source = 'track-types.yml' }
                    @{ key = 'modules'; known = $modules; source = 'the loaded modules' })) {
                foreach ($value in $side.selector.($pair.key)) {
                    if ($value -cnotin $pair.known) {
                        $problems.Add("${where}: $($pair.key) value '$value' is not declared in $($pair.source)")
                    }
                }
            }
        }
        if (-not $map.HasCode($row.because)) {
            $problems.Add("row ${number}: because '$($row.because)' is no rule code of the citation map")
        }
    }
    Assert-True ($problems.Count -eq 0) -ErrorText ('link-directions config: ' + ($problems -join '; '))
}
