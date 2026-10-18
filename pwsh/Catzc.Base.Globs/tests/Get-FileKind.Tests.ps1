Describe 'Get-FileKind' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-METAKIND' {
    It 'names the role of a file in the shipped registry' -ForEach @(
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Base.Variants/Get-Track.ps1'; Class = 'function' }
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Base.Variants/Test-GitWorkspace.ps1'; Class = 'function/gate' }
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Base.Docs/Build-Glossary.ps1'; Class = 'function/writer' }
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Base.Asserts/Assert-NotNull.ps1'; Class = 'function/assert' }
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Base.Languages/Format-GeneratedFileHead.ps1'; Class = 'function/formatter' }
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1'; Class = 'function/fact' }
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Base.QualityGates/private/Get-FileMetaScope.ps1'; Class = 'function' }
        @{ Path = (Get-CatzcModulesFolder) + '/.internal/Catzc.Internal.Types.psm1'; Class = 'module/internal' }
        @{ Path = (Get-CatzcModulesFolder) + '/.internal/tests/Assert-CatzcRunModeExclusive.Tests.ps1'; Class = 'test' }
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Base.Globs/types/FileKindsConfig.cs'; Class = 'type' }
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Azure.Cli/tests/assets/config/azure.yml'; Class = 'fixture/input' }
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Azure.Cli/tests/data/sample.yml'; Class = 'fixture' }
        @{ Path = (Get-CatzcModulesFolder) + '/Catzc.Base.Globs/configs/file-kinds.yml'; Class = 'config' }
        @{ Path = '.claude/drawio/contact_sheet.py'; Class = 'drawio-kit' }
        @{ Path = '.claude/drawio/STYLE.md'; Class = 'drawio-kit' }
        @{ Path = '.claude/slides/patterns/rule.html'; Class = 'slides-kit' }
        @{ Path = '.claude/slides/slides.yml'; Class = 'slides-kit' }
        @{ Path = 'tools/export.py'; Class = 'script' }
        @{ Path = 'docs/.assets/explanation/widget-flow.drawio.png'; Class = 'diagram' }
        @{ Path = 'docs/.assets/explanation/grid/widget-flow.grid.md'; Class = 'asset-description' }
        @{ Path = 'docs/explanation/.assets/adr-widget-flow--gadget-spins--meta.drawio.png'; Class = 'diagram' }
        @{ Path = 'docs/explanation/.assets/grid/adr-widget-flow--gadget-spins--meta.grid.md'; Class = 'asset-description' }
        @{ Path = 'docs/explanation/design/gadget-spins.drawio.md'; Class = 'asset-description' }
        @{ Path = 'docs/explanation/design/gadget-spins.md'; Class = 'explanation' }
        @{ Path = 'docs/explanation/design/widget-deck/gadget-spins.slide.md'; Class = 'slide' }
        @{ Path = 'docs/references/.assets/automation/catzc-widget/gadget-spins.drawio.png'; Class = 'diagram' }
        @{ Path = 'docs/references/.assets/automation/catzc-widget/gadget-spins.drawio.verify.md'; Class = 'asset-description' }
        @{ Path = 'docs/references/pwsh/catzc-widget/gadget-spins.drawio.md'; Class = 'asset-description' }
        @{ Path = 'docs/references/pwsh/catzc-widget.md'; Class = 'reference' }
        @{ Path = 'docs/adr/index.md'; Class = 'index' }
        @{ Path = 'docs/adr/glossary.md'; Class = 'glossary' }
        @{ Path = 'docs/adr/repository/file-meta.md'; Class = 'adr' }
        @{ Path = 'docs/references/pwsh/catzc-base-globs/Get-FileKind.ps1.md'; Class = 'comment-page' }
        @{ Path = 'infrastructure/templates/foundation/main.bicep'; Class = 'template' }
        @{ Path = 'infrastructure/templates/foundation/options.yml'; Class = 'template/config' }
        @{ Path = 'infrastructure/modules/storage.bicep'; Class = 'template/module' }
    ) {
        (Get-FileKind $Path).Class | Should -BeExactly $Class
    }

    It 'names a file no kind selects other' -ForEach @(
        @{ Path = 'LICENSE' }
        @{ Path = '.gitignore' }
        @{ Path = 'elsewhere/notes.txt' }
    ) {
        (Get-FileKind $Path).role | Should -BeExactly 'other'
    }

    It 'reads a backslash path' {
        (Get-FileKind ((Get-CatzcModulesFolder) + '\Catzc.Base.Variants\Test-GitWorkspace.ps1')).Class | Should -BeExactly 'function/gate'
    }

    It 'gives every shipped kind and subkind a definition' {
        foreach ($entry in (Get-Config -Config file-kinds).kinds) {
            $entry.definition | Should -Not -BeNullOrEmpty -Because "kind '$($entry.role)'"
            foreach ($sub in $entry.subkinds) {
                $sub.definition | Should -Not -BeNullOrEmpty -Because "subkind '$($entry.role)/$($sub.subkind)'"
            }
        }
    }
}
