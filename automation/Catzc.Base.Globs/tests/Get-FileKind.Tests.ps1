<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/tests/Get-FileKind.Tests.ps1
    folder: tests
    name: get-file-kind-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-FILEMETA#2
---
#>

Describe 'Get-FileKind' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#2' {
    It 'names the role of a file in the shipped registry' -ForEach @(
        @{ Path = 'automation/Catzc.Base.Variants/Get-Track.ps1'; Class = 'function' }
        @{ Path = 'automation/Catzc.Base.Variants/Test-GitWorkspace.ps1'; Class = 'function/gate' }
        @{ Path = 'automation/Catzc.Base.Docs/Build-Glossary.ps1'; Class = 'function/writer' }
        @{ Path = 'automation/Catzc.Base.Asserts/Assert-NotNull.ps1'; Class = 'function/assert' }
        @{ Path = 'automation/Catzc.Base.Languages/Format-GeneratedFileHead.ps1'; Class = 'function/formatter' }
        @{ Path = 'automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1'; Class = 'function/fact' }
        @{ Path = 'automation/Catzc.Base.QualityGates/private/Get-FileMetaScope.ps1'; Class = 'function' }
        @{ Path = 'automation/.internal/Catzc.Internal.Types.psm1'; Class = 'module/internal' }
        @{ Path = 'automation/.internal/tests/Assert-CatzcRunModeExclusive.Tests.ps1'; Class = 'test' }
        @{ Path = 'automation/Catzc.Base.Globs/types/FileKindsConfig.cs'; Class = 'type' }
        @{ Path = 'automation/Catzc.Azure.Cli/tests/assets/config/azure.yml'; Class = 'fixture/input' }
        @{ Path = 'automation/Catzc.Azure.Cli/tests/data/sample.yml'; Class = 'fixture' }
        @{ Path = 'automation/Catzc.Base.Globs/configs/file-kinds.yml'; Class = 'config' }
        @{ Path = '.claude/drawio/contact_sheet.py'; Class = 'drawio-kit' }
        @{ Path = '.claude/drawio/STYLE.md'; Class = 'drawio-kit' }
        @{ Path = 'tools/export.py'; Class = 'script' }
        @{ Path = 'docs/.assets/explanation/widget-flow.drawio.png'; Class = 'diagram' }
        @{ Path = 'docs/.assets/explanation/grid/widget-flow.grid.md'; Class = 'asset-description' }
        @{ Path = 'docs/explanation/.assets/adr-widget-flow--gadget-spins--meta.drawio.png'; Class = 'diagram' }
        @{ Path = 'docs/explanation/.assets/grid/adr-widget-flow--gadget-spins--meta.grid.md'; Class = 'asset-description' }
        @{ Path = 'docs/explanation/design/gadget-spins.drawio.md'; Class = 'asset-description' }
        @{ Path = 'docs/explanation/design/gadget-spins.md'; Class = 'explanation' }
        @{ Path = 'docs/adr/index.md'; Class = 'index' }
        @{ Path = 'docs/adr/glossary.md'; Class = 'glossary' }
        @{ Path = 'docs/adr/repository/file-meta.md'; Class = 'adr' }
        @{ Path = 'docs/references/automation/catzc-base-globs/Get-FileKind.ps1.md'; Class = 'comment-page' }
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
        (Get-FileKind $Path).kind | Should -BeExactly 'other'
    }

    It 'reads a backslash path' {
        (Get-FileKind 'automation\Catzc.Base.Variants\Test-GitWorkspace.ps1').Class | Should -BeExactly 'function/gate'
    }

    It 'gives every shipped kind and subkind a definition' {
        foreach ($entry in (Get-Config -Config file-kinds).kinds) {
            $entry.definition | Should -Not -BeNullOrEmpty -Because "kind '$($entry.kind)'"
            foreach ($sub in $entry.subkinds) {
                $sub.definition | Should -Not -BeNullOrEmpty -Because "subkind '$($entry.kind)/$($sub.subkind)'"
            }
        }
    }
}
