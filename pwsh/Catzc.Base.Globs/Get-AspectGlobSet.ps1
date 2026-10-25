<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Get-AspectGlobSet.ps1.md"
  header: "generated"
---
#>

function Get-AspectGlobSet {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param()

    $aspectSet = [ordered]@{}
    $add = {
        param([string] $Name, [Catzc.Base.Globs.GlobSet] $Set)
        $aspectSet[$Name] = @(@($aspectSet[$Name]).Where({ $null -ne $_ })) + $Set
    }
    $codeTrack = Get-Track -Path (Get-CatzcModulesFolder)
    $aspectNames = @(Get-Aspect -Track $codeTrack.name).ForEach({ $_.Name })
    # A single-file module's set is the degenerate one-aspect partition: live ([DDR-ASPECT-ASPECTISAGLOBSET](/docs/drs/design/module-aspects.md#rule-ddr-aspect-aspectisaglobset)).
    $singleFile = @(Get-CatzcModule -Track $codeTrack.name -IncludeInternal).Where({ $_.shape -ceq 'file' }).ForEach({ [Catzc.Base.Objects.NameCase]::Render($_.name, 'kebab') })
    foreach ($set in @(Get-ModuleGlobSet).Where({ $_.Layer -ceq 'module' })) {
        if ($set.Name -cin $singleFile) {
            & $add 'live' $set
            continue
        }
        $aspect = $aspectNames.Where({ $set.Name.EndsWith("-$_", [System.StringComparison]::Ordinal) }, 'First')
        if ($aspect.Count -gt 0) {
            & $add $aspect[0] $set
        }
    }
    $declared = Get-AspectDeclaration
    foreach ($track in @(Get-Track).Where({ $declared.ContainsKey($_.name) })) {
        $aspects = [System.Collections.Generic.List[Catzc.Base.Globs.Aspect]]::new()
        foreach ($aspect in $declared[$track.name]) {
            $aspects.Add([Catzc.Base.Globs.Aspect]::new($aspect.Name, [string[]]$aspect.Patterns))
        }
        foreach ($place in $track.places) {
            foreach ($compiled in [Catzc.Base.Globs.AspectPartition]::Compile($aspects, $place)) {
                & $add $compiled.Name ([Catzc.Base.Globs.GlobSet]::new("$($track.name)-$($compiled.Name)", "Track aspect - $place [$($compiled.Name)]", 'module',
                        [string[]]$compiled.Include, [string[]]$compiled.Exclude, @(), @(), -1, $null))
            }
        }
    }
    $aspectSet
}
