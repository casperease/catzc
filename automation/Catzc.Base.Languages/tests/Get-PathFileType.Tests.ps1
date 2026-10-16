<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
    folder: tests
    name: get-path-file-type-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-DSGN-TRACK#6
---
#>

Describe 'Get-PathFileType' -Tag 'L0', 'logic', 'ADR-DSGN-TRACK#6' {
    It 'returns the extension of the file name without its dot' -ForEach @(
        @{ Path = 'widgetry/Catzc.Widget/Get-Gadget.ps1'; Expected = 'ps1' }
        @{ Path = 'widgetry/.internal/Catzc.Internal.Types.psm1'; Expected = 'psm1' }
        @{ Path = 'widgetry/Catzc.Widget/Catzc.Widget.psd1'; Expected = 'psd1' }
        @{ Path = 'widgetry/Catzc.Widget/types/Gadget.cs'; Expected = 'cs' }
        @{ Path = 'widgetry/configs/gadget.yml'; Expected = 'yml' }
        @{ Path = 'widgetry/configs/gadget.yaml'; Expected = 'yaml' }
    ) {
        Get-PathFileType $Path | Should -BeExactly $Expected
    }

    It 'takes the last extension of a name with several' -ForEach @(
        @{ Path = 'docs/references/Get-Gadget.ps1.md'; Expected = 'md' }
        @{ Path = 'widgetry/tests/Get-Gadget.Tests.ps1'; Expected = 'ps1' }
        @{ Path = 'docs/.assets/gadget.drawio.png'; Expected = 'png' }
    ) {
        Get-PathFileType $Path | Should -BeExactly $Expected
    }

    It 'gives lower case, whatever the file name''s case' {
        Get-PathFileType 'widgetry/GADGET.PS1' | Should -BeExactly 'ps1'
    }

    It 'reads a backslash path' {
        Get-PathFileType 'widgetry\.internal\tests\Get-Gadget.Tests.ps1' | Should -BeExactly 'ps1'
    }

    It 'reads an extension from the file name, never from a folder' {
        Get-PathFileType 'widgetry/gadget.d/LICENSE' | Should -BeNullOrEmpty
    }

    It 'gives none for a file with no extension, a dotfile, a trailing dot, and an empty path' -ForEach @(
        @{ Path = 'widgetry/LICENSE' }
        @{ Path = '.gitkeep' }
        @{ Path = 'widgetry/.cspell/.gitignore' }
        @{ Path = 'widgetry/gadget.' }
        @{ Path = '' }
    ) {
        Get-PathFileType $Path | Should -BeNullOrEmpty
    }
}
