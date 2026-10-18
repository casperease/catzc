Describe 'WorldMapHighlight' -Tag 'L0', 'logic' {
    BeforeAll {
        $tracks = @(
            [Catzc.Base.Variants.VariantTrack]::new('widgets', @('widgets'), 'modules', $null, @('widget-script'))
            [Catzc.Base.Variants.VariantTrack]::new('docs', @('docs'), 'documentation', $null, @('notes'))
            [Catzc.Base.Variants.VariantTrack]::new([Catzc.Base.Maps.WorldMapBuilder]::PipelinesTrack, @('pipelines'), 'pipelines', $null, @('gadget-pipe'))
        )
        $languages = @(
            [Catzc.Base.Languages.FileLanguage]::new('widget-script', @('.ps1'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('gadget-pipe', @('.yaml'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('notes', @('.md'), $null, 'fixture', $null, $null, $null)
        )
        $texts = [ordered]@{
            'widgets/Alpha/Get-Widget.ps1' = '# ADR-WIDGET-GADGET#2'
            'widgets/Alpha/Set-Widget.ps1' = '# ADR-WIDGET-GADGET'
            'widgets/Beta/Get-Gizmo.ps1'   = "function Get-Gizmo {}`n# ADR-GIZMO-COG"
            'docs/guide.md'                = 'Read ADR-WIDGET-SPROCKET.'
            'pipelines/ci-widgets.yaml'    = 'trigger: none'
            'importer.ps1'                 = ''
            'README.md'                    = 'See ADR-WIDGET-GADGET#3.'
        }
        $paths = @(
            'widgets/Alpha/Get-Widget.ps1', 'widgets/Alpha/Set-Widget.ps1', 'widgets/Beta/Get-Gizmo.ps1', 'docs/adr/widgetry/widget-gadget.md',
            'docs/adr/widgetry/widget-sprocket.md', 'docs/adr/gizmos/gizmo-cog.md', 'docs/guide.md', 'pipelines/ci-widgets.yaml', 'importer.ps1', 'README.md'
        )
        $globSets = @([Catzc.Base.Globs.GlobSet]::new('widgets-set', 'The widgets.', 'loose-fileset', @('widgets/Beta/**'), @(), @(), @(), -1, 'ci-widgets'))
        $script:map = [Catzc.Base.Maps.WorldMapBuilder]::Build($tracks, $languages, ($paths | Sort-Object -Descending), [ordered]@{},
            [ordered]@{ 'ADR-WIDGET-GADGET' = 'widgetry'; 'ADR-WIDGET-SPROCKET' = 'widgetry'; 'ADR-GIZMO-COG' = 'gizmos' },
            [ordered]@{ 'ADR-WIDGET-GADGET' = 'docs/adr/widgetry/widget-gadget.md'; 'ADR-WIDGET-SPROCKET' = 'docs/adr/widgetry/widget-sprocket.md'
                'ADR-GIZMO-COG' = 'docs/adr/gizmos/gizmo-cog.md'
            }, $texts,
            [ordered]@{ 'importer.ps1' = 'widgets/Alpha' }, $globSets)
        $script:pin = { param([string] $Adr, [string] $Track, [string] $FileLanguage) [Catzc.Base.Maps.MapsPin]::new($Adr, $Track, $FileLanguage, 'reviewed') }
        $script:forAdr = {
            param([string[]] $Adr, $Pins = @(), $Exceptions = @())
            [Catzc.Base.Maps.WorldMapHighlight]::ForAdr($script:map, $Adr, $Pins, $Exceptions)
        }
        $script:cellNames = { param($Highlight) @($Highlight.Cells | ForEach-Object { "$($_.Track) x $($_.FileLanguage)" }) }
    }

    Context 'ADR references' {
        It 'lights the requested ADR''s own file and every file the D5 order ties to the code, in the map''s order' {
            $highlight = & $script:forAdr 'ADR-WIDGET-GADGET'
            $highlight.Kind | Should -Be 'adr'
            $highlight.Requested | Should -Be @('ADR-WIDGET-GADGET')
            & $script:cellNames $highlight | Should -Be @('docs x notes', 'widgets x widget-script', '(no track) x notes', '(no track) x widget-script')
            $docs = $highlight.Cells[0]
            $docs.Files | Should -Be @('docs/adr/widgetry/widget-gadget.md')
            $docs.Sources | Should -Be @('adr-file')
            $highlight.Cells[1].Files | Should -Be @('widgets/Alpha/Get-Widget.ps1', 'widgets/Alpha/Set-Widget.ps1')
            $highlight.Cells[1].Sources | Should -Be @('citations')
            $highlight.Cells[3].Sources | Should -Be @('files.yml')
        }

        It 'lights a pipeline through its globset when it cites nothing' {
            $highlight = & $script:forAdr 'ADR-GIZMO-COG'
            & $script:cellNames $highlight | Should -Be @('docs x notes', 'pipelines x gadget-pipe', 'widgets x widget-script')
            $highlight.Cells[1].Sources | Should -Be @('globset')
            $highlight.Cells[1].Files | Should -Be @('pipelines/ci-widgets.yaml')
        }

        It 'lights an ADR''s own file and its citing files, never a sibling ADR''s file of the same domain' {
            $highlight = & $script:forAdr 'ADR-WIDGET-SPROCKET'
            $docs = $highlight.Cells | Where-Object FileLanguage -EQ 'notes' | Where-Object Track -EQ 'docs'
            $docs.Files | Should -Be @('docs/adr/widgetry/widget-sprocket.md', 'docs/guide.md')
            @($highlight.Cells).Count | Should -Be 1
        }

        It 'lights two ADRs of one domain each on its own file only' -Tag 'ADR-DSGN-TRACK#12' {
            $docs = (& $script:forAdr 'ADR-WIDGET-GADGET', 'ADR-WIDGET-SPROCKET').Cells | Where-Object Track -EQ 'docs'
            @($docs.Reasons | Where-Object Basis -EQ 'adr-file' | ForEach-Object { "$($_.Path) $($_.Requested)" }) |
                Should -Be @('docs/adr/widgetry/widget-gadget.md ADR-WIDGET-GADGET', 'docs/adr/widgetry/widget-sprocket.md ADR-WIDGET-SPROCKET')
        }

        It 'narrows a rule request to its rule and the bare citations' {
            $highlight = & $script:forAdr 'ADR-WIDGET-GADGET:3'
            $highlight.Requested | Should -Be @('ADR-WIDGET-GADGET#3')
            $widgets = $highlight.Cells | Where-Object Track -EQ 'widgets'
            $widgets.Files | Should -Be @('widgets/Alpha/Set-Widget.ps1')
            ($highlight.Cells | Where-Object FileLanguage -EQ 'notes' | Where-Object Track -EQ '(no track)').Files | Should -Be @('README.md')
        }

        It 'keeps an exception dark and lights a pin, the pin winning' {
            $exceptions = @(& $script:pin 'ADR-WIDGET-GADGET' 'widgets' 'widget-script'; & $script:pin 'ADR-WIDGET-GADGET#2' '(no track)' 'notes')
            $pins = @(& $script:pin 'ADR-WIDGET-GADGET#3' 'pipelines' 'gadget-pipe'; & $script:pin 'ADR-WIDGET-GADGET' '(no track)' 'notes')
            $highlight = & $script:forAdr 'ADR-WIDGET-GADGET' -Pins $pins -Exceptions $exceptions
            & $script:cellNames $highlight | Should -Be @('docs x notes', 'pipelines x gadget-pipe', '(no track) x notes', '(no track) x widget-script')
            ($highlight.Cells | Where-Object Track -EQ 'pipelines').Sources | Should -Be @('pin')
            ($highlight.Cells | Where-Object Track -EQ 'pipelines').FileCount | Should -Be 0
            ($highlight.Cells | Where-Object FileLanguage -EQ 'notes' | Where-Object Track -EQ '(no track)').Sources | Should -Be @('pin')
        }

        It 'applies no pin or exception of another ADR' {
            $pins = @(& $script:pin 'ADR-GIZMO-COG' 'pipelines' 'gadget-pipe')
            $exceptions = @(& $script:pin 'ADR-GIZMO-COG' 'widgets' 'widget-script')
            $highlight = & $script:forAdr 'ADR-WIDGET-SPROCKET' -Pins $pins -Exceptions $exceptions
            & $script:cellNames $highlight | Should -Be @('docs x notes')
        }

        It 'lights nothing for an empty request' {
            (& $script:forAdr @()).Cells | Should -BeNullOrEmpty
        }

        It 'throws on an unknown code, and on a pin naming no cell or no code' {
            { & $script:forAdr 'ADR-WIDGET-UNKNOWN' } | Should -Throw "*'ADR-WIDGET-UNKNOWN' is not an ADR code*"
            { & $script:forAdr 'widget gadget' } | Should -Throw '*is not an ADR code*'
            { & $script:forAdr 'ADR-WIDGET-GADGET' -Pins @(& $script:pin 'ADR-WIDGET-GADGET' 'gizmos' 'notes') } | Should -Throw "*names the cell 'gizmos' x 'notes'*"
            { & $script:forAdr 'ADR-WIDGET-GADGET' -Exceptions @(& $script:pin 'ADR-GIZMO-WHEEL' 'docs' 'notes') } | Should -Throw "*'ADR-GIZMO-WHEEL'*"
        }
    }

    Context 'reasons' {
        It 'gives every lit file its reason: the basis, the covering request and the citation sites' -Tag 'ADR-DSGN-TRACK#12' {
            $highlight = & $script:forAdr 'ADR-WIDGET-GADGET'
            $docs = $highlight.Cells[0].Reasons
            @($docs).Count | Should -Be 1
            "$($docs[0].Path) $($docs[0].Basis) $($docs[0].Requested)" | Should -Be 'docs/adr/widgetry/widget-gadget.md adr-file ADR-WIDGET-GADGET'
            $widgets = $highlight.Cells[1].Reasons
            @($widgets | ForEach-Object { "$($_.Path) $($_.Basis) $($_.Requested)" }) |
                Should -Be @('widgets/Alpha/Get-Widget.ps1 citations ADR-WIDGET-GADGET', 'widgets/Alpha/Set-Widget.ps1 citations ADR-WIDGET-GADGET')
            @($widgets[0].Sites | ForEach-Object { "$($_.Path):$($_.Line) $($_.Kind) $($_.Citation)" }) |
                Should -Be @('widgets/Alpha/Get-Widget.ps1:1 help ADR-WIDGET-GADGET#2')
            $widgets[0].Mention | Should -BeFalse
            $highlight.Cells[1].Touched | Should -BeFalse
        }

        It 'names the owner''s files a root file is lit through' -Tag 'ADR-DSGN-TRACK#7' {
            $root = (& $script:forAdr 'ADR-WIDGET-GADGET').Cells[3].Reasons
            $root[0].Path | Should -Be 'importer.ps1'
            $root[0].Basis | Should -Be 'files.yml'
            @($root[0].Sites | ForEach-Object { "$($_.Path):$($_.Line)" }) | Should -Be @('widgets/Alpha/Get-Widget.ps1:1', 'widgets/Alpha/Set-Widget.ps1:1')
        }

        It 'marks a cell lit only by passing comments as touched' {
            $widgets = (& $script:forAdr 'ADR-GIZMO-COG').Cells | Where-Object Track -EQ 'widgets'
            $widgets.Reasons[0].Mention | Should -BeTrue
            $widgets.Touched | Should -BeTrue
        }

        It 'gives a pin its own reason, the reviewed note' {
            $highlight = & $script:forAdr 'ADR-WIDGET-GADGET#3' -Pins @(& $script:pin 'ADR-WIDGET-GADGET#3' 'pipelines' 'gadget-pipe')
            $pin = ($highlight.Cells | Where-Object Track -EQ 'pipelines').Reasons
            "$($pin.Path)|$($pin.Basis)|$($pin.Requested)|$($pin.Note)" | Should -Be '|pin|ADR-WIDGET-GADGET#3|reviewed'
        }

        It 'gives a requested file the path basis' {
            $reason = ([Catzc.Base.Maps.WorldMapHighlight]::ForPaths($script:map, @('docs/guide.md'))).Cells[0].Reasons[0]
            "$($reason.Path) $($reason.Basis)" | Should -Be 'docs/guide.md path'
        }
    }

    Context 'files' {
        It 'lights the cells the files sit in' {
            $highlight = [Catzc.Base.Maps.WorldMapHighlight]::ForPaths($script:map, @('README.md', 'widgets\Beta\Get-Gizmo.ps1', 'docs/guide.md'))
            $highlight.Kind | Should -Be 'path'
            $highlight.Requested | Should -Be @('README.md', 'widgets/Beta/Get-Gizmo.ps1', 'docs/guide.md')
            & $script:cellNames $highlight | Should -Be @('docs x notes', 'widgets x widget-script', '(no track) x notes')
            $highlight.Cells[1].Sources | Should -Be @('path')
        }

        It 'throws on a file the map does not hold' {
            { [Catzc.Base.Maps.WorldMapHighlight]::ForPaths($script:map, @('widgets/missing.ps1')) } | Should -Throw "*'widgets/missing.ps1' is not a tracked file*"
        }
    }

    Context 'data form' {
        It 'emits the JSON shape: kind, request and lit cells' {
            $data = (& $script:forAdr 'ADR-GIZMO-COG').ToJson() | ConvertFrom-Json
            @($data.PSObject.Properties.Name) | Should -Be @('kind', 'requested', 'cells')
            $data.kind | Should -Be 'adr'
            @($data.cells[0].PSObject.Properties.Name) | Should -Be @('track', 'file_language', 'file_count', 'sources', 'files', 'touched', 'reasons')
            $data.cells[0].files | Should -Be @('docs/adr/gizmos/gizmo-cog.md')
            @($data.cells[0].reasons[0].PSObject.Properties.Name) | Should -Be @('path', 'basis', 'requested', 'note', 'mention', 'sites')
            $site = ($data.cells | Where-Object track -EQ 'widgets').reasons[0].sites[0]
            @($site.PSObject.Properties.Name) | Should -Be @('path', 'line', 'kind', 'citation')
            "$($site.path):$($site.line) $($site.kind)" | Should -Be 'widgets/Beta/Get-Gizmo.ps1:2 comment'
        }

        It 'renders console-ready' {
            "$(& $script:forAdr 'ADR-GIZMO-COG')" | Should -BeLike 'WorldMapHighlight {*Kind = adr*'
            "$((& $script:forAdr 'ADR-GIZMO-COG').Cells[0])" | Should -BeLike 'HighlightedCell {*Track = docs*'
        }
    }
}
