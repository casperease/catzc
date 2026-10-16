<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Languages/Get-PathFileType.ps1
    name: get-path-file-type
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
    cites:
      - ADR-DSGN-TRACK#6
  config:
    synopsis: Returns the file type of a path, the extension of its file name without the dot.
    description: |-
      The file type says which sort of file inside its file language this is: `ps1`, `psm1` and `psd1` are all PowerShell, `yml` and `yaml`
      are different file types of the YAML family. It is the last extension of the file name, lower case. A file with no extension, a dotfile
      such as `.gitkeep`, and a name that ends in a dot have none: nothing is returned
      ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)).
    parameters:
      Path: A repository-relative or absolute path ('/' or '\' separated).
    outputs: '[string] The extension without its dot, in lower case, or nothing.'
    examples:
      - '(Get-PathFileType ''automation/.internal/Catzc.Internal.Types.psm1'')   # -> psm1'
      - '(Get-PathFileType ''docs/references/Get-Foo.ps1.md'')                   # -> md'
---
#>

function Get-PathFileType {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    $fileType = [Catzc.Base.Languages.PathParts]::FileTypeOf($Path)
    if ($fileType) {
        $fileType
    }
}
