<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Get-PathModule.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Variants
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK#3
  config:
    synopsis: Returns the module a repository-relative path is placed in, and its module type, when it is placed in one.
    description: |-
      The module types of the module-types registry say where modules are placed and how a path names its module
      ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)): a PowerShell module is a folder under automation or one psm1
      file under automation/.internal, a settings module is a tool's dot-folder, a pipeline module is the folder that holds pipelines, and
      a Python, Go or Bash module is its track folder. The first module type to place a path names its module, so
      `automation/.internal/tests/Get-Foo.Tests.ps1` is in the module `Catzc.Internal.Tests`. A path no module type places, such as a
      file directly in the root or a documentation page, is in no module: nothing is returned.
    parameters:
      Path: A repository-relative path ('/' or '\' separated).
    outputs: '[Catzc.Base.Variants.PathModule] The module (name) and its module type (type), or nothing.'
    examples:
      - '(Get-PathModule ''automation/Catzc.Base.Variants/Get-Track.ps1'').name   # -> Catzc.Base.Variants'
      - '(Get-PathModule ''.claude/agents/x.md'').type                           # -> settings-module'
---
#>

function Get-PathModule {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.PathModule])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    $module = (Get-Config -Config module-types).Resolve($Path)
    if ($module) {
        $module
    }
}
