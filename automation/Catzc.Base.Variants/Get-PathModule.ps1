<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Get-PathModule.ps1
    kind: function
    language: powershell
    filekind: ps1
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
      root, whatever the file's depth ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)).

      The `.internal` folder holds the loader's own modules, one `.psm1` file each, so a `.psm1` file directly in it is the module named by
      the file (`Catzc.Internal.Types.psm1` is the module `Catzc.Internal.Types`), and any other file under a folder of it is placed in the
      module `Catzc.Internal.<Folder>`, the folder name in PascalCase (`.internal/tests` is `Catzc.Internal.Tests`). The other folders whose
      names start with a dot (`.vendor`, `.scriptanalyzer`) hold third-party or tooling files and no module, and a path outside the track,
      or a file directly in the root, is placed in none: nothing is returned.
    parameters:
      Path: A repository-relative path ('/' or '\' separated).
    outputs: '[string] The module name, or nothing.'
    examples:
      - '(Get-PathModule ''automation/Catzc.Base.Variants/Get-Track.ps1'')   # -> Catzc.Base.Variants'
      - '(Get-PathModule ''automation/.internal/tests/Get-Foo.Tests.ps1'')   # -> Catzc.Internal.Tests'
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
    $normalized = $Path -replace '\\', '/'
    $match = [regex]::Match($normalized, '^' + [regex]::Escape($root) + '/(?<module>[^./][^/]*)/')
    if ($match.Success) {
        return $match.Groups['module'].Value
    }

    $internal = [regex]::Match($normalized, '^' + [regex]::Escape($root) + '/\.internal/(?:(?<file>[^/]+)|(?<folder>[^/]+)/.+)$')
    if (-not $internal.Success) {
        return
    }
    if ($internal.Groups['file'].Success) {
        if ($internal.Groups['file'].Value -match '^(?<name>.+)\.psm1$') {
            $Matches['name']
        }
        return
    }
    'Catzc.Internal.' + (($internal.Groups['folder'].Value -split '-' | ForEach-Object { $_.Substring(0, 1).ToUpperInvariant() + $_.Substring(1) }) -join '')
}
