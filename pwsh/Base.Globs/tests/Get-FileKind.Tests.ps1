Describe 'Get-FileKind' -Tag 'L0', 'integrity', 'ADR-REPO-FILEMETA-METAKIND' {
    It 'names the role of a file in the shipped registry' -ForEach @(
        @{ Path = (Get-CatzcModulesFolder) + '/Base.Variants/Get-Track.ps1'; Class = 'function' }
        @{ Path = (Get-CatzcModulesFolder) + '/Base.Variants/Test-GitWorkspace.ps1'; Class = 'function/gate' }
        @{ Path = (Get-CatzcModulesFolder) + '/Base.Docs/Build-Glossary.ps1'; Class = 'function/writer' }
        @{ Path = (Get-CatzcModulesFolder) + '/Base.Asserts/Assert-NotNull.ps1'; Class = 'function/assert' }
        @{ Path = (Get-CatzcModulesFolder) + '/Base.Languages/Format-GeneratedFileHead.ps1'; Class = 'function/formatter' }
        @{ Path = (Get-CatzcModulesFolder) + '/Base.QualityGates/Get-WidgetFileMetaFact.ps1'; Class = 'function/fact' }
        @{ Path = (Get-CatzcModulesFolder) + '/Base.QualityGates/private/Get-FileMetaScope.ps1'; Class = 'function' }
        @{ Path = (Get-CatzcModulesFolder) + '/.internal/Catzc.Internal.Types.psm1'; Class = 'module/internal' }
        @{ Path = (Get-CatzcModulesFolder) + '/.internal/tests/Assert-CatzcRunModeExclusive.Tests.ps1'; Class = 'test' }
        @{ Path = (Get-CatzcModulesFolder) + '/Base.Globs/types/FileKindsConfig.cs'; Class = 'type' }
        @{ Path = (Get-CatzcModulesFolder) + '/Azure.Cli/tests/assets/config/azure.yml'; Class = 'fixture/input' }
        @{ Path = (Get-CatzcModulesFolder) + '/Azure.Cli/tests/data/sample.yml'; Class = 'fixture' }
        @{ Path = (Get-CatzcModulesFolder) + '/Base.Globs/configs/file-kinds.yml'; Class = 'config' }
        @{ Path = 'python/diagrams/drawio_png.py'; Class = 'drawio-kit' }
        @{ Path = 'python/diagrams/assets/STYLE.md'; Class = 'drawio-kit' }
        @{ Path = 'python/diagrams/assets/slides/patterns/rule.html'; Class = 'slides-kit' }
        @{ Path = 'python/diagrams/assets/slides/slides.yml'; Class = 'slides-kit' }
        @{ Path = 'tools/export.py'; Class = 'script' }
        @{ Path = 'docs/explanation/design/.assets/gadget-spins.drawio.png'; Class = 'diagram' }
        @{ Path = 'docs/explanation/design/.assets/gadget-spins.drawio.yml'; Class = 'diagram-declaration' }
        @{ Path = 'docs/drs/widget/.assets/gadget-turns.drawio.yml'; Class = 'diagram-declaration' }
        @{ Path = 'docs/explanation/design/.assets/gadget-spins.drawio.verify.md'; Class = 'explanation' }
        @{ Path = 'docs/explanation/design/gadget-spins.md'; Class = 'explanation' }
        @{ Path = 'docs/references/pwsh/.assets/catzc-widget.drawio.png'; Class = 'diagram' }
        @{ Path = 'docs/references/pwsh/.assets/catzc-widget.drawio.verify.md'; Class = 'reference' }
        @{ Path = 'docs/references/pwsh/catzc-widget.md'; Class = 'reference' }
        @{ Path = 'docs/drs/index.md'; Class = 'index' }
        @{ Path = 'docs/drs/glossary.md'; Class = 'glossary' }
        @{ Path = 'docs/drs/repository/file-meta.md'; Class = 'record' }
        @{ Path = 'docs/references/pwsh/base-globs/tests/get-file-kind.md'; Class = 'comment-page' }
        @{ Path = 'infrastructure/templates/foundation/main.bicep'; Class = 'template' }
        @{ Path = 'infrastructure/templates/foundation/options.yml'; Class = 'template/config' }
        @{ Path = 'infrastructure/templates/foundation/configuration/nsub.bicepparam'; Class = 'template/config' }
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

    It 'leaves the pipelines'' folder article out of comment-page, as its exclude names it' {
        (Get-FileKind 'docs/references/ado/pipelines/template-folders.md').role | Should -Not -Be 'comment-page'
        (Get-FileKind 'docs/references/ado/pipelines/ci-pwsh.md').role | Should -BeExactly 'comment-page'
    }

    It 'reads a backslash path' {
        (Get-FileKind ((Get-CatzcModulesFolder) + '\Base.Variants\Test-GitWorkspace.ps1')).Class |
            Should -BeExactly 'function/gate'
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
