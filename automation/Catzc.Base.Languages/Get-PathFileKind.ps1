<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/Get-PathFileKind.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Languages
    visibility: public
    relatives:
      test: automation/Catzc.Base.Languages/tests/Get-PathFileKind.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK#6
  config:
    synopsis: Returns the file kind of a path, the extension of its file name without the dot.
    description: |-
      The file kind says which sort of file inside its file language this is: `ps1`, `psm1` and `psd1` are all PowerShell, `yml` and `yaml`
      are different file kinds of the YAML family. It is the last extension of the file name, lower case. A file with no extension, a dotfile
      such as `.gitkeep`, and a name that ends in a dot have none: nothing is returned
      ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)).
    parameters:
      Path: A repository-relative or absolute path ('/' or '\' separated).
    outputs: '[string] The extension without its dot, in lower case, or nothing.'
    examples:
      - '(Get-PathFileKind ''automation/.internal/Catzc.Internal.Types.psm1'')   # -> psm1'
      - '(Get-PathFileKind ''docs/references/Get-Foo.ps1.md'')                   # -> md'
---
#>

function Get-PathFileKind {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    $name = ($Path -replace '\\', '/') -replace '^.*/', ''
    $dot = $name.LastIndexOf('.')
    if ($dot -gt 0 -and $dot -lt $name.Length - 1) {
        $name.Substring($dot + 1).ToLowerInvariant()
    }
}
