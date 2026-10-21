<#
---
catzc:
  immutable:
    with_body_sha: "885e42ab205f"
  edges:
    code: pwsh/Catzc.Base.Languages/types/PathParts.cs
    cites:
      - ADR-REPO-FILEMETA-ROLE
---
#>

Describe 'Catzc.Base.Languages.PathParts' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-ROLE' {
    Context 'Of' {
        It 'splits a path into its folder, its kebab-case name and its file type' -ForEach @(
            @{ Path = 'types/GadgetMetrics.cs'; Folder = 'types'; Name = 'gadget-metrics'; FileType = 'cs' }
            @{ Path = 'Get-GadgetPart.ps1'; Folder = ''; Name = 'get-gadget-part'; FileType = 'ps1' }
            @{ Path = 'tests/types/Gadget.Tests.ps1'; Folder = 'tests/types'; Name = 'gadget-tests'; FileType = 'ps1' }
            @{ Path = 'configs/gadget-map.yml'; Folder = 'configs'; Name = 'gadget-map'; FileType = 'yml' }
            @{ Path = 'HTTPServer.cs'; Folder = ''; Name = 'http-server'; FileType = 'cs' }
            @{ Path = 'docs/Gadget_Notes v2.MD'; Folder = 'docs'; Name = 'gadget-notes-v2'; FileType = 'md' }
            @{ Path = 'LICENSE'; Folder = ''; Name = 'license'; FileType = '' }
            @{ Path = '.gitkeep'; Folder = ''; Name = 'gitkeep'; FileType = '' }
        ) {
            $parts = [Catzc.Base.Languages.PathParts]::Of($Path)
            $parts.folder | Should -BeExactly $Folder
            $parts.name | Should -BeExactly $Name
            $parts.filetype | Should -BeExactly $FileType
        }

        It 'reads a backslash path' {
            [Catzc.Base.Languages.PathParts]::Of('types\Gadget.cs').folder | Should -BeExactly 'types'
        }

        It 'stops on an empty path, a name with nothing to name it by, and an empty folder segment' -ForEach @(
            @{ Path = ''; Message = '*the path is empty*' }
            @{ Path = 'types/..'; Message = '*holds no letter or digit*' }
            @{ Path = 'types//Gadget.cs'; Message = '*empty folder segment*' }
        ) {
            { [Catzc.Base.Languages.PathParts]::Of($Path) } | Should -Throw $Message
        }
    }

    Context 'FileTypeOf' {
        It 'is the last extension in lower case, and nothing for a dotfile or a trailing dot' -ForEach @(
            @{ Path = 'a/b/Get-Foo.Tests.PS1'; Expected = 'ps1' }
            @{ Path = 'a\b\.gitkeep'; Expected = '' }
            @{ Path = 'a/b/name.'; Expected = '' }
            @{ Path = 'a/b/LICENSE'; Expected = '' }
        ) {
            [Catzc.Base.Languages.PathParts]::FileTypeOf($Path) | Should -BeExactly $Expected
        }
    }
}
