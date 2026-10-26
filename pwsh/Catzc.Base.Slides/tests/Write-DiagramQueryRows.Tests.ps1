Describe 'Write-DiagramQueryRows' -Tag 'L0', 'logic', 'DDR-VISUAL-ZOOMISANAXIS' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:widget = 'docs/explanation/widget/.assets/widget-code'
        $script:gadget = 'docs/explanation/gadget/.assets/gadget-parts'
        $script:plain = 'docs/explanation/plain/.assets/plain-flow'
        $declarations = @{
            $script:widget = "about:`n  adrs: [ADR-WIDGET]`n  zoom: C4`n  point: widgets/Widget.Kit`ncontent:`n  title: Widget code`n"
            $script:gadget = "about:`n  adrs: [ADR-WIDGET]`n  zoom: C3`n  point: widgets`ncontent:`n  title: Gadget parts`n"
            $script:plain  = "about:`n  adrs: [ADR-WIDGET]`ncontent:`n  title: Plain flow`n"
        }
        foreach ($stem in $declarations.Keys) {
            $source = Join-Path $script:root $stem
            [System.IO.Directory]::CreateDirectory((Split-Path $source -Parent)) | Out-Null
            [System.IO.File]::WriteAllText("$source.drawio.yml", $declarations[$stem])
        }
        Mock Get-DiagramCodeRows -ModuleName Catzc.Base.Slides {
            [ordered]@{ point = $Point; level = 'C4'; nodes = @([ordered]@{ id = 'get-widget'; label = 'Get-Widget.ps1'; kind = 'code' }); edges = @() }
        }
        Mock Get-DiagramComponentRows -ModuleName Catzc.Base.Slides {
            [ordered]@{ point = $Point; level = 'C3'; nodes = @([ordered]@{ id = 'widget-kit'; label = 'Widget.Kit'; kind = 'module' }); edges = @() }
        }
        function script:Invoke-Writer {
            param([string[]] $Stem)
            $path = Join-Path $script:root 'rows/query-rows.json'
            $null = InModuleScope Catzc.Base.Slides -Parameters @{ Stem = $Stem; Root = $script:root; Path = $path } {
                param($Stem, $Root, $Path)
                Write-DiagramQueryRows -Stem $Stem -RepositoryRoot $Root -Path $Path
            }
            Get-Content -Raw $path | ConvertFrom-Json
        }
    }

    It 'writes one row per point and level, from the query of each level, at the address it is given' {
        $written = Invoke-Writer -Stem $script:widget, $script:gadget, $script:plain
        @($written.rows).Count | Should -Be 2
        $c4 = @($written.rows).Where({ $_.level -eq 'C4' })[0]
        $c4.point | Should -BeExactly 'widgets/Widget.Kit'
        $c4.nodes[0].id | Should -BeExactly 'get-widget'
        @($written.rows).Where({ $_.level -eq 'C3' })[0].point | Should -BeExactly 'widgets'
        Should -Invoke Get-DiagramCodeRows -ModuleName Catzc.Base.Slides -Times 1 -Exactly
        Should -Invoke Get-DiagramComponentRows -ModuleName Catzc.Base.Slides -Times 1 -Exactly
    }

    It 'writes a file the published query-rows schema holds' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
        $null = Invoke-Writer -Stem $script:widget, $script:gadget
        $schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.1.0/catzc.base.maps/query-rows.schema.json'))
        Test-Json -Json ([System.IO.File]::ReadAllText((Join-Path $script:root 'rows/query-rows.json'))) -Schema $schema | Should -BeTrue
    }

    It 'writes an empty rows list when no diagram names a point' {
        @((Invoke-Writer -Stem $script:plain).rows).Count | Should -Be 0
    }

    It 'asks a point''s query once, however many slides share it' {
        $twin = 'docs/explanation/widget/.assets/widget-code-twin'
        [System.IO.File]::Copy((Join-Path $script:root "$($script:widget).drawio.yml"),
            (Join-Path $script:root "$twin.drawio.yml"))
        @((Invoke-Writer -Stem $script:widget, $twin).rows).Count | Should -Be 1
        Should -Invoke Get-DiagramCodeRows -ModuleName Catzc.Base.Slides -Times 1 -Exactly
    }

    It 'throws naming the slide when a point stands at a level no query answers' {
        $wrong = 'docs/explanation/wrong/.assets/wrong-level'
        $source = Join-Path $script:root $wrong
        [System.IO.Directory]::CreateDirectory((Split-Path $source -Parent)) | Out-Null
        [System.IO.File]::WriteAllText("$source.drawio.yml",
            "about:`n  adrs: [ADR-WIDGET]`n  zoom: C2`n  point: widgets`ncontent:`n  title: Wrong`n")
        { Invoke-Writer -Stem $wrong } | Should -Throw "*$wrong names about.point widgets at zoom 'C2'*"
    }
}
