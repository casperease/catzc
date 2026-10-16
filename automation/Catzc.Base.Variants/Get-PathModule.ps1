<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Get-PathModule.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Variants
    visibility: public
    relatives:
      test: automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK#3
  config:
    synopsis: Returns the module a repository-relative path is placed in, when it is placed in one.
    description: |-
      A module is a folder directly under the root of the `automation` track (Get-Track), so the module of a path is the folder under that
      root, whatever the file's depth ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)). A folder whose name starts
      with a dot (`.internal`, `.vendor`) holds infrastructure and no module, and a path outside the track, or a file directly in the root,
      is placed in none: nothing is returned.
    parameters:
      Path: A repository-relative path ('/' or '\' separated).
    outputs: '[string] The module name, or nothing.'
    examples:
      - '(Get-PathModule ''automation/Catzc.Base.Variants/Get-Track.ps1'')   # -> Catzc.Base.Variants'
---
#>

function Get-PathModule {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    $root = (Get-Track -Name automation).root
    $match = [regex]::Match(($Path -replace '\\', '/'), '^' + [regex]::Escape($root) + '/(?<module>[^./][^/]*)/')
    if ($match.Success) {
        $match.Groups['module'].Value
    }
}
