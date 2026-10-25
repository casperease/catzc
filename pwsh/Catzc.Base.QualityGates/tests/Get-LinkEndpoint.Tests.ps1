# Get-LinkEndpoint builds each distinct path's facets from the registries, read once per call.
Describe 'Get-LinkEndpoint' -Tag 'L0', 'logic', 'ADR-REPO-LINKS-ENDPOINTSAREFACETS' {
    BeforeAll {
        $script:inModule = { param([scriptblock] $Body, [hashtable] $With = @{}) InModuleScope Catzc.Base.QualityGates -Parameters $With $Body }
    }

    BeforeEach {
        InModuleScope Catzc.Base.QualityGates {
            $kinds = [pscustomobject] @{} | Add-Member -PassThru ScriptMethod Resolve {
                param($Path)
                if ($Path -like 'docs/*') {
                    [pscustomobject] @{ Class = 'reference/gadget' }
                }
                elseif ($Path -like '*.ps1') {
                    [pscustomobject] @{ Class = 'code' }
                }
            }
            $modules = [pscustomobject] @{} | Add-Member -PassThru ScriptMethod Resolve {
                param($Path)
                if ($Path -like 'mods/Widget/*') {
                    [pscustomobject] @{ name = 'Widget' }
                }
            }
            $track = { param([string] $Name, [string] $Type, [string] $Place)
                [pscustomobject] @{ name = $Name; type = $Type; place = $Place } | Add-Member -PassThru ScriptMethod PlaceLengthOf {
                    param($Path)
                    if ($Path -eq $this.place -or $Path.StartsWith($this.place + '/')) {
                        $this.place.Length
                    }
                    else {
                        -1
                    }
                }
            }
            Mock Get-Config -ParameterFilter { $Config -eq 'file-kinds' } { $kinds }.GetNewClosure()
            Mock Get-Config -ParameterFilter { $Config -eq 'module-types' } { $modules }.GetNewClosure()
            Mock Get-Track { (& $track 'mods' 'widgets' 'mods'); (& $track 'docs' 'documentation' 'docs') }.GetNewClosure()
            Mock Get-FileAspect {
                $map = [ordered]@{}
                foreach ($p in $Path) {
                    $map[$p] = if ($p -like '*/tests/*') {
                        'tests'
                    }
                    elseif ($p -like 'mods/*') {
                        'live'
                    }
                    else {
                        ''
                    }
                }
                $map
            }
        }
    }

    It 'gives each path its class, aspect, track, track type and module' {
        $endpoints = & $inModule { Get-LinkEndpoint -Path 'mods/Widget/Get-Widget.ps1', 'docs/gadget.md', 'loose.txt' }
        $widget = $endpoints['mods/Widget/Get-Widget.ps1']
        @($widget.Class, $widget.Aspect, $widget.Track, $widget.TrackType, $widget.Module) | Should -Be @('code', 'live', 'mods', 'widgets', 'Widget')
        $gadget = $endpoints['docs/gadget.md']
        @($gadget.Class, $gadget.Aspect, $gadget.Track, $gadget.Module) | Should -Be @('reference/gadget', '', 'docs', '')
        $loose = $endpoints['loose.txt']
        @($loose.Class, $loose.Track, $loose.TrackType) | Should -Be @('', '', '') -Because 'a file no registry claims leaves each facet empty, never a guess'
    }

    It 'resolves each distinct path once and reads each registry once per call' {
        $endpoints = & $inModule { Get-LinkEndpoint -Path 'mods/Widget/a.ps1', 'mods\Widget\a.ps1', 'mods/Widget/tests/a.Tests.ps1' }
        @($endpoints.Keys) | Should -Be @('mods/Widget/a.ps1', 'mods/Widget/tests/a.Tests.ps1')
        $endpoints['mods/Widget/tests/a.Tests.ps1'].Aspect | Should -Be 'tests'
        Should -Invoke Get-Track -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
        Should -Invoke Get-FileAspect -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly
        Should -Invoke Get-Config -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly
    }

    It 'returns an empty table for no paths' {
        (& $inModule { Get-LinkEndpoint -Path @() }).Count | Should -Be 0
    }
}
