<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/Get-FileKind.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Globs
    relatives:
      source: automation/Catzc.Base.Globs/Get-FileKind.ps1
    adrs:
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
        @{ Path = 'automation/Catzc.Base.Globs/configs/file-kinds.yml'; Class = 'config' }
        @{ Path = '.claude/drawio/contact_sheet.py'; Class = 'script' }
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
