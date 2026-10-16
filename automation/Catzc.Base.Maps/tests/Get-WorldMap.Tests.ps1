<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Maps
    relatives:
      page: docs/references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
      source: automation/Catzc.Base.Maps/Get-WorldMap.ps1
    adrs:
      - ADR-DSGN-TRACK#3
---
#>

Describe 'Get-WorldMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($file in @(
                @{ Path = 'widgets/Alpha/Get-Widget.ps1'; Text = '# ADR-WIDGET-GADGET#2' }
                @{ Path = 'widgets/Alpha/widget.json'; Text = '{ "note": "ADR-WIDGET-GADGET" }' }
                @{ Path = 'importer.ps1'; Text = '# the entry point' }
            )) {
            $full = Join-Path $script:root $file.Path
            New-Item -ItemType Directory -Path (Split-Path $full -Parent) -Force | Out-Null
            Set-Content -LiteralPath $full -Value $file.Text -NoNewline
        }
        $script:variants = [pscustomobject]@{
            aspects = @{ widgets = @([Catzc.Base.Variants.VariantAspect]::new('live', @('*.ps1')), [Catzc.Base.Variants.VariantAspect]::new('tests', @('**'))) }
        }
        $script:files = [pscustomobject]@{ modules = [ordered]@{ Alpha = [pscustomobject]@{ packages = [ordered]@{ entry = @('importer.ps1', 'widgets/x') } } } }
    }

    BeforeEach {
        InModuleScope Catzc.Base.Maps { $script:worldMapTextCache = $null }
        Mock Get-Track -ModuleName Catzc.Base.Maps { [Catzc.Base.Variants.VariantTrack]::new('widgets', 'widgets', 'core', @('widget-script')) }
        Mock Get-FileLanguage -ModuleName Catzc.Base.Maps { [Catzc.Base.Languages.FileLanguage]::new('widget-script', @('.ps1'), $null, 'fixture', $null, $null, $null) }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Maps { 'importer.ps1', 'widgets/Alpha/Get-Widget.ps1', 'widgets/Alpha/widget.json', 'widgets/Alpha/gone.ps1' }
        Mock Get-Aspect -ModuleName Catzc.Base.Maps { $script:variants.aspects[$Track] }
        Mock Get-AdrRuleSet -ModuleName Catzc.Base.Maps { [pscustomobject]@{ External = 'ADR-WIDGET-GADGET'; Domain = 'widgetry' } }
        Mock Get-AdrCitationMap -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name PathOf -Value { param($Code) "docs/adr/widgetry/$($Code.ToLowerInvariant()).md" } -PassThru
        }
        Mock Get-GlobSet -ModuleName Catzc.Base.Maps { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Maps { $script:root }
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Maps { Join-Path $script:root 'widgets' }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'variants' } { $script:variants }
        Mock Get-Config -ModuleName Catzc.Base.Maps -ParameterFilter { $Config -eq 'files' } { $script:files }
    }

    It 'builds the map from the registries on the zero-argument call' {
        $map = Get-WorldMap
        $map | Should -BeOfType [Catzc.Base.Maps.WorldMap]
        $map.FileCount | Should -Be 4
        $map.Placement('widgets/Alpha/Get-Widget.ps1').Citations | Should -Be @('ADR-WIDGET-GADGET#2')
        $map.Placement('widgets/Alpha/widget.json').StackViolation | Should -BeFalse -Because 'the widgets aspects leave a .json file in tests'
    }

    It 'reads no text from a file kind that does not cite, and skips a file missing from the working tree' {
        $map = Get-WorldMap
        $map.Placement('widgets/Alpha/widget.json').Citations | Should -BeNullOrEmpty
        $map.Placement('widgets/Alpha/gone.ps1').Basis | Should -Be 'none'
    }

    It 'gives a repository-root file its files.yml module''s folder under the modules root' {
        $importer = (Get-WorldMap).Placement('importer.ps1')
        $importer.Basis | Should -Be 'files.yml'
        $importer.Citations | Should -Be @('ADR-WIDGET-GADGET#2')
    }

    It 'reads each file once per session' {
        $null = Get-WorldMap
        Set-Content -LiteralPath (Join-Path $script:root 'widgets/Alpha/Get-Widget.ps1') -Value '# ADR-WIDGET-GADGET#7' -NoNewline
        try {
            (Get-WorldMap).Placement('widgets/Alpha/Get-Widget.ps1').Citations | Should -Be @('ADR-WIDGET-GADGET#2')
        }
        finally {
            Set-Content -LiteralPath (Join-Path $script:root 'widgets/Alpha/Get-Widget.ps1') -Value '# ADR-WIDGET-GADGET#2' -NoNewline
        }
    }

    It 'emits JSON with -AsJson' {
        $json = Get-WorldMap -AsJson
        $json | Should -BeOfType [string]
        ($json | ConvertFrom-Json).file_count | Should -Be 4
    }
}

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
        $report | Should -BeNullOrEmpty -Because 'a live file outside its track''s file languages is a second tech-stack (ADR-DSGN-TRACK#3)'
    }
}
