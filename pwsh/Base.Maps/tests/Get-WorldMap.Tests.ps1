Describe 'Get-WorldMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($file in @(
                @{ Path = 'widgets/Alpha/Get-Widget.ps1'; Text = '# ADR-WIDGET-GADGET-SPIN' }
                @{ Path = 'widgets/Alpha/widget.json'; Text = '{ "note": "ADR-WIDGET-GADGET" }' }
                @{ Path = 'importer.ps1'; Text = '# the entry point' }
            )) {
            $full = Join-Path $script:root $file.Path
            New-Item -ItemType Directory -Path (Split-Path $full -Parent) -Force | Out-Null
            Set-Content -LiteralPath $full -Value $file.Text -NoNewline
        }
        $script:variants = [pscustomobject]@{
            aspects = @{ widgets = @([Catzc.Base.Variants.VariantAspect]::new('live', @('*.ps1')),
                    [Catzc.Base.Variants.VariantAspect]::new('tests', @('**')))
            }
        }
        $script:files = [pscustomobject]@{ modules = [ordered]@{ Alpha = [pscustomobject]@{ packages = [ordered]@{ entry = @('importer.ps1', 'widgets/x') } } } }
    }

    BeforeEach {
        InModuleScope Catzc.Base.Maps { $script:worldMapTextCache = $null }
        Mock Get-Track -ModuleName Catzc.Base.Maps { [Catzc.Base.Variants.VariantTrack]::new('widgets', @('widgets'),
                'modules', $null, @('widget-script')) }
        Mock Get-FileLanguage -ModuleName Catzc.Base.Maps { [Catzc.Base.Languages.FileLanguage]::new('widget-script',
                @('.ps1'), $null, 'fixture', $null, $null, $null) }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Maps { 'importer.ps1', 'widgets/Alpha/Get-Widget.ps1', 'widgets/Alpha/widget.json', 'widgets/Alpha/gone.ps1' }
        Mock Get-Aspect -ModuleName Catzc.Base.Maps { $script:variants.aspects[$Track] }
        Mock Test-AspectDeclaration -ModuleName Catzc.Base.Maps { $script:variants.aspects.ContainsKey($Track) }
        Mock Get-DrsRuleSet -ModuleName Catzc.Base.Maps { [pscustomobject]@{ External = 'ADR-WIDGET-GADGET'; Domain = 'widgetry' } }
        Mock Get-DrsCitationMap -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{} |
                Add-Member -MemberType ScriptMethod -Name PathOf -Value { param($Code) "docs/drs/widgetry/$($Code.ToLowerInvariant()).md" } -PassThru
        }
        Mock Get-GlobSet -ModuleName Catzc.Base.Maps { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Maps { $script:root }
        # The fixture root stands for the repository, so a shipped config lies outside it and reads from disk in a revision too.
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Repository { $script:root }
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Maps { Join-Path $script:root 'widgets' }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'files' } { $script:files }
    }

    It 'builds the map from the registries on the zero-argument call' {
        $map = Get-WorldMap
        $map | Should -BeOfType [Catzc.Base.Maps.WorldMap]
        $map.FileCount | Should -Be 4
        $map.Placement('widgets/Alpha/Get-Widget.ps1').Citations | Should -Be @('ADR-WIDGET-GADGET-SPIN')
        $map.Placement('widgets/Alpha/widget.json').StackViolation |
            Should -BeFalse -Because 'the widgets aspects leave a .json file in tests'
    }

    It 'reads no text from a file kind that does not cite, and skips a file missing from the working tree' {
        $map = Get-WorldMap
        $map.Placement('widgets/Alpha/widget.json').Citations | Should -BeNullOrEmpty
        $map.Placement('widgets/Alpha/gone.ps1').Basis | Should -Be 'none'
    }

    It 'gives a repository-root file its files.yml module''s folder under the modules root' {
        $importer = (Get-WorldMap).Placement('importer.ps1')
        $importer.Basis | Should -Be 'files.yml'
        $importer.Citations | Should -Be @('ADR-WIDGET-GADGET-SPIN')
    }

    It 'reads each file once per session' {
        $null = Get-WorldMap
        Set-Content -LiteralPath (Join-Path $script:root 'widgets/Alpha/Get-Widget.ps1') -Value '# ADR-WIDGET-GADGET-BEND' -NoNewline
        try {
            (Get-WorldMap).Placement('widgets/Alpha/Get-Widget.ps1').Citations | Should -Be @('ADR-WIDGET-GADGET-SPIN')
        }
        finally {
            Set-Content -LiteralPath (Join-Path $script:root 'widgets/Alpha/Get-Widget.ps1') -Value '# ADR-WIDGET-GADGET-SPIN' -NoNewline
        }
    }

    It 'reads a file''s citations from its body, never its catzc head, so a pipeline whose head cites still falls back to its globset' {
        $pipeline = Join-Path $script:root 'pipelines/ci-widgets.yaml'
        New-Item -ItemType Directory -Path (Split-Path $pipeline -Parent) -Force | Out-Null
        Set-Content -LiteralPath $pipeline -Value "# ---`n# catzc:`n#   edges:`n#     cites:`n#       - ADR-WIDGET-GADGET-BEND`n# ---`n`ntrigger: none`n" -NoNewline
        Mock Get-Track -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Variants.VariantTrack]::new('widgets', @('widgets'), 'modules', $null, @('widget-script'))
            [Catzc.Base.Variants.VariantTrack]::new([Catzc.Base.Maps.WorldMapBuilder]::AdoPipelinesTrack,
                @('pipelines'), 'pipelines', $null, @('widget-pipe'))
        }
        Mock Get-FileLanguage -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Languages.FileLanguage]::new('widget-script', @('.ps1'), $null, 'fixture', $null, $null, $null)
            [Catzc.Base.Languages.FileLanguage]::new('widget-pipe', @('.yaml'), $null, 'fixture', $null, $null, $null)
        }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Maps { 'widgets/Alpha/Get-Widget.ps1', 'pipelines/ci-widgets.yaml' }
        Mock Get-GlobSet -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Globs.GlobSet]::new('widgets-set', 'The widgets.', 'loose-fileset', @('widgets/**'), @(), @(),
                @(), -1, 'ci-widgets')
        }
        try {
            $placement = (Get-WorldMap).Placement('pipelines/ci-widgets.yaml')
            $placement.Basis | Should -Be 'globset'
            $placement.Citations | Should -Be @('ADR-WIDGET-GADGET-SPIN')
        }
        finally {
            Remove-Item -LiteralPath (Split-Path $pipeline -Parent) -Recurse -Force
        }
    }

    It 'reads a file''s citations from its comment page too, the same source its head is built from' {
        $code = Join-Path $script:root 'widgets/Alpha/Get-Gadget.ps1'
        $page = Join-Path $script:root 'docs/widget-pages/Get-Gadget.ps1.md'
        New-Item -ItemType Directory -Path (Split-Path $page -Parent) -Force | Out-Null
        Set-Content -LiteralPath $code -Value "<#`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-WIDGET-GADGET-BEND`n---`n#>`n`nfunction Get-Gadget { }`n" -NoNewline
        Set-Content -LiteralPath $page -Value "# widgets/Alpha/Get-Gadget.ps1`n`nThe gadget turns by ADR-WIDGET-GADGET-LIFT.`n" -NoNewline
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Maps { 'widgets/Alpha/Get-Widget.ps1', 'widgets/Alpha/Get-Gadget.ps1' }
        Mock Get-CommentPage -ModuleName Catzc.Base.Maps -ParameterFilter { $Path -eq 'widgets/Alpha/Get-Gadget.ps1' } { 'docs/widget-pages/Get-Gadget.ps1.md' }
        try {
            (Get-WorldMap).Placement('widgets/Alpha/Get-Gadget.ps1').Citations | Should -Be @('ADR-WIDGET-GADGET-LIFT')
        }
        finally {
            Remove-Item -LiteralPath $code, (Split-Path $page -Parent) -Recurse -Force
        }
    }

    It 'reads a revision''s paths and texts from its commit alone: a working-tree edit and an index-only path change nothing' {
        Mock Get-GitCommitTree -ModuleName Catzc.Base.Maps {
            [ordered]@{ 'importer.ps1' = '1' * 40; 'widgets/Alpha/Get-Widget.ps1' = '2' * 40 }
        }
        Mock Get-GitBlobText -ModuleName Catzc.Base.Maps {
            $known = @{ ('1' * 40) = '# the entry point'; ('2' * 40) = '# ADR-WIDGET-GADGET-SPIN' }
            $texts = @{}
            foreach ($id in $Blob) {
                $texts[$id] = $known[$id]
            }
            $texts
        }
        $before = Get-WorldMap -Revision ('c' * 40) -AsJson
        # A working-tree edit and a path only the index holds.
        Set-Content -LiteralPath (Join-Path $script:root 'widgets/Alpha/Get-Widget.ps1') -Value '# ADR-WIDGET-GADGET-BEND' -NoNewline
        try {
            InModuleScope Catzc.Base.Maps { $script:worldMapTextCache = $null }
            $after = Get-WorldMap -Revision ('c' * 40) -AsJson
        }
        finally {
            Set-Content -LiteralPath (Join-Path $script:root 'widgets/Alpha/Get-Widget.ps1') -Value '# ADR-WIDGET-GADGET-SPIN' -NoNewline
        }
        $after | Should -BeExactly $before
        ($after | ConvertFrom-Json).file_count | Should -Be 2 -Because 'the index-only widget.json and gone.ps1 are not in the commit'
        (Get-WorldMap -Revision ('c' * 40)).Placement('widgets/Alpha/Get-Widget.ps1').Citations | Should -Be @('ADR-WIDGET-GADGET-SPIN')
        Should -Invoke Get-GitCommitTree -ModuleName Catzc.Base.Maps -ParameterFilter { $Revision -eq ('c' * 40) }
    }

    It 'reads every input class from the revision: a working-tree edit to each leaves the JSON byte-equal' {
        # Each registry stand-in reads its one varying fact through the repository text seam, as the real readers do through Get-Config.
        $inputs = [ordered]@{
            track    = @{ Commit = 'widgets'; Working = 'gizmos'; Edited = 'sprockets' }
            language = @{ Commit = '.ps1'; Working = '.psm1'; Edited = '.psd1' }
            aspect   = @{ Commit = '*.ps1'; Working = '*.json'; Edited = '*.txt' }
            domain   = @{ Commit = 'widgetry'; Working = 'gadgetry'; Edited = 'sprocketry' }
            record   = @{ Commit = 'widgetry'; Working = 'gadgetry'; Edited = 'sprocketry' }
            globset  = @{ Commit = 'widgets/**'; Working = 'gizmos/**'; Edited = 'sprockets/**' }
            owner    = @{ Commit = 'importer.ps1'; Working = 'other.ps1'; Edited = 'third.ps1' }
            exclude  = @{ Commit = 'nothing/**'; Working = 'widgets/**'; Edited = '**' }
        }
        $tree = [ordered]@{ 'importer.ps1' = '1' * 40; 'widgets/Alpha/Get-Widget.ps1' = '2' * 40; 'widgets/Alpha/widget.json' = '3' * 40 }
        $known = @{ ('1' * 40) = '# the entry point'; ('2' * 40) = '# ADR-WIDGET-GADGET-SPIN'; ('3' * 40) = '{ "note": "ADR-WIDGET-GADGET" }' }
        $index = 0
        foreach ($name in $inputs.Keys) {
            $index++
            $blob = '{0:x40}' -f $index
            $tree["inputs/configs/$name.yml"] = $blob
            $known[$blob] = $inputs[$name].Commit
            $full = Join-Path $script:root "inputs/configs/$name.yml"
            New-Item -ItemType Directory -Path (Split-Path $full -Parent) -Force | Out-Null
            Set-Content -LiteralPath $full -Value $inputs[$name].Working -NoNewline
        }
        $script:read = { param($Name) Read-RepositoryText "inputs/configs/$Name.yml" }
        Mock Get-GitCommitTree -ModuleName Catzc.Base.Maps { $tree }
        Mock Get-GitBlobText -ModuleName Catzc.Base.Maps {
            $texts = @{}
            foreach ($id in $Blob) {
                $texts[$id] = $known[$id]
            }
            $texts
        }
        Mock Get-Track -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Variants.VariantTrack]::new((& $script:read track), @('widgets'), 'modules', $null, @('widget-script'))
        }
        Mock Get-FileLanguage -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Languages.FileLanguage]::new('widget-script', @(& $script:read language), $null, 'fixture', $null, $null, $null)
        }
        Mock Get-Aspect -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Variants.VariantAspect]::new('live', @(& $script:read aspect))
            [Catzc.Base.Variants.VariantAspect]::new('tests', @('**'))
        }
        Mock Test-AspectDeclaration -ModuleName Catzc.Base.Maps { $true }
        Mock Get-DrsRuleSet -ModuleName Catzc.Base.Maps { [pscustomobject]@{ External = 'ADR-WIDGET-GADGET'; Domain = (& $script:read domain) } }
        Mock Get-DrsCitationMap -ModuleName Catzc.Base.Maps {
            $folder = & $script:read record
            [pscustomobject]@{ Folder = $folder } |
                Add-Member -MemberType ScriptMethod -Name PathOf -Value { param($Code) "docs/drs/$($this.Folder)/$($Code.ToLowerInvariant()).md" } -PassThru
        }
        Mock Get-GlobSet -ModuleName Catzc.Base.Maps {
            [Catzc.Base.Globs.GlobSet]::new('widgets-set', 'The widgets.', 'loose-fileset', @(& $script:read globset), @(), @(), @(), -1, 'ci-widgets')
        }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'files' } {
            [pscustomobject]@{ modules = [ordered]@{ Alpha = [pscustomobject]@{ packages = [ordered]@{ entry = @(& $script:read owner) } } } }
        }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'maps' } {
            [pscustomobject]@{ highlight = [pscustomobject]@{ citation_exclude = @(& $script:read exclude) } }
        }
        $commit = 'c' * 40
        $before = Get-WorldMap -Revision $commit -AsJson
        foreach ($name in $inputs.Keys) {
            Set-Content -LiteralPath (Join-Path $script:root "inputs/configs/$name.yml") -Value $inputs[$name].Edited -NoNewline
        }
        Set-Content -LiteralPath (Join-Path $script:root 'widgets/Alpha/Get-Widget.ps1') -Value '# ADR-WIDGET-GADGET-BEND' -NoNewline
        try {
            InModuleScope Catzc.Base.Maps { $script:worldMapTextCache = $null }
            $after = Get-WorldMap -Revision $commit -AsJson
            $working = Get-WorldMap -AsJson
        }
        finally {
            Set-Content -LiteralPath (Join-Path $script:root 'widgets/Alpha/Get-Widget.ps1') -Value '# ADR-WIDGET-GADGET-SPIN' -NoNewline
            Remove-Item -LiteralPath (Join-Path $script:root 'inputs') -Recurse -Force
        }
        $after | Should -BeExactly $before
        $working | Should -Not -BeExactly $before -Because 'the edited working tree is a different set of inputs'
        $before | Should -Not -Match 'gizmos|sprockets|gadgetry|sprocketry'
    }

    It 'emits JSON with -AsJson' {
        $json = Get-WorldMap -AsJson
        $json | Should -BeOfType [string]
        ($json | ConvertFrom-Json).file_count | Should -Be 4
    }
}

# Every tracked file of the git index gets a cell, and no live file breaks its track's tech-stack.
Describe 'Get-WorldMap — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:map = Get-WorldMap
        $script:tracked = @(Get-GitTrackedPath '.')
    }

    It 'places every tracked file in exactly one cell' {
        $script:map.FileCount | Should -Be $script:tracked.Count
        ($script:map.Cells | Measure-Object FileCount -Sum).Sum | Should -Be $script:tracked.Count
        $unplaced = @($script:tracked | Where-Object { $null -eq $script:map.Placement($_) })
        $unplaced | Should -BeNullOrEmpty
    }

    It 'finds no stack violation' {
        $report = @($script:map.StackViolations | ForEach-Object { '{0} ({1} x {2})' -f $_.Path, $_.Track, $_.FileLanguage })
        $report |
            Should -BeNullOrEmpty -Because 'a live file outside its track''s file languages is a second tech-stack (DDR-TRACK-ONETECHSTACK)'
    }
}
