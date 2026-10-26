Describe 'Build-TrackGlobSets' -Tag 'L0', 'logic', 'FDR-GLOBS-TRACKSETDERIVED' {
    BeforeAll {
        function script:New-Track {
            param([string] $Name, [object[]] $Members)
            $raw = [ordered]@{ tracks = [ordered]@{} }
            $raw.tracks[$Name] = [ordered]@{ members = $Members; type = 'widget-works' }
            [Catzc.Base.Variants.VariantsConfig]::new($raw).tracks[0]
        }
    }

    BeforeEach {
        $script:folder = Join-Path $TestDrive 'globs'
        [System.IO.Directory]::CreateDirectory($script:folder) | Out-Null
        Set-Content -LiteralPath (Join-Path $script:folder 'globs.yml') -Value @(
            'globsets:'
            '  widget:'
            '    description: d'
            '    layer: loose-fileset'
            '    pipeline: ci-widget'
            '    track: widget'
            '  gadget:'
            '    description: d'
            '    layer: loose-fileset'
            '    pipeline: ci-gadget'
            '    track: gadget'
            '  spares:'
            '    description: d'
            '    layer: loose-fileset'
            '    include: [widget/spares/**]'
        )
        Mock Get-CatzcModuleRoot -ModuleName Catzc.Base.Globs { Join-Path $TestDrive ($ChildPath -replace '^configs/', '') }
        Mock ConvertTo-RepoRelativePath -ModuleName Catzc.Base.Globs { 'widget/configs/globs/track-sets.yml' }
        Mock Format-GeneratedFileHead -ModuleName Catzc.Base.Globs { $Text }
        Mock Get-Track -ModuleName Catzc.Base.Globs {
            New-Track widget @('widget', [ordered]@{ path = 'widget/*/*.cog'; generated = $true; committed = $false })
            New-Track gadget @('widget/gadget')
            New-Track trinket @('widget/.trinket')
        }
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.Globs {
            [pscustomobject]@{ path = 'widget/README.md'; generator = 'Build-Readme' }
            [pscustomobject]@{ path = 'elsewhere/README.md'; generator = 'Build-Readme' }
        }
        Mock Write-Message -ModuleName Catzc.Base.Globs { }
    }

    It 'derives each track set from its members: places in, generated members and targets out, a piped nested track out, the rest kept' {
        $result = Build-TrackGlobSets -PassThru
        $result.Changed | Should -BeTrue
        $parsed = Get-Content -LiteralPath (Join-Path $script:folder 'track-sets.yml') -Raw | ConvertFrom-Yaml
        $parsed.globsets.Keys | Sort-Object | Should -Be @('gadget', 'widget')
        $parsed.globsets.widget.include | Should -Be @('widget/**')
        $parsed.globsets.widget.exclude | Should -Be @('widget/*/*.cog', 'widget/README.md', 'widget/gadget/**') -Because 'the trinket track has no pipeline of its own, so it stays'
        $parsed.globsets.gadget.include | Should -Be @('widget/gadget/**')
        $parsed.globsets.gadget.Contains('exclude') | Should -BeFalse
    }

    It 'writes nothing the second time, and only reports under -DryRun' {
        Build-TrackGlobSets | Should -BeNullOrEmpty -Because 'the result comes back only under -PassThru'
        (Build-TrackGlobSets -PassThru).Changed | Should -BeFalse
        Set-Content -LiteralPath (Join-Path $script:folder 'track-sets.yml') -Value 'stale'
        (Build-TrackGlobSets -DryRun -PassThru).Changed | Should -BeTrue
        Get-Content -LiteralPath (Join-Path $script:folder 'track-sets.yml') -Raw | Should -BeLike 'stale*'
    }

    It 'refuses a set that names a track variants.yml does not declare' {
        Mock Get-Track -ModuleName Catzc.Base.Globs { New-Track gadget @('widget/gadget') }
        { Build-TrackGlobSets } | Should -Throw "*globset 'widget' names track 'widget', which variants.yml does not declare*"
    }
}

Describe 'Build-TrackGlobSets — its assets' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'reads its declared part and writes its derived part where the module ships them, in the repository and in a bundle' {
        $result = Build-TrackGlobSets -DryRun -PassThru -Silent
        $result.Path | Should -BeLike '*configs/globs/track-sets.yml'
        Get-GlobSet -Name pwsh | Should -Not -BeNullOrEmpty -Because 'the joined config resolves the derived set'
    }
}

Describe 'Build-TrackGlobSets — the real tree' -Tag 'L1', 'integrity', 'source-only', 'FDR-GLOBS-TRACKSETDERIVED' {
    It 'finds the committed derived part current, with the generated READMEs out of the infrastructure trigger' {
        (Build-TrackGlobSets -DryRun -PassThru -Silent).Changed | Should -BeFalse -Because 'run Build-TrackGlobSets'
        $set = Get-GlobSet -Name infrastructure
        $set.Matches('infrastructure/README.md') | Should -BeFalse
        $set.Matches('infrastructure/templates/foundation/main.bicep') | Should -BeTrue
        $vendored = "$((Get-Track -Name vendor_pwsh.modules).places[0])/Pester/Pester.psd1"
        (Get-GlobSet -Name pwsh).Matches($vendored) | Should -BeTrue -Because 'a nested track with no pipeline of its own stays in its parent''s set'
    }
}
