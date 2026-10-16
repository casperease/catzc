<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/private/Get-GeneratorPath.ps1
    folder: private
    name: get-generator-path
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.Languages/tests/Get-GeneratorPath.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#7
  config:
    synopsis: Returns the repository-relative path of the file a generator command is defined in.
    description: |-
      A generated file's head names its generator by that path, so a reader opens the writer straight from the head. The command is looked
      up among the loaded functions, and one that is not loaded is an error: a head never names a generator that cannot be found.
    parameters:
      Name: The generator command, such as Build-AdrIndex.
    outputs: '[string] The path relative to the root the catzc code lives in (the repository root in the mono repo), with forward slashes.'
    examples:
      - Get-GeneratorPath Build-AdrIndex   # automation/Catzc.Base.Docs/Build-AdrIndex.ps1
---
#>

function Get-GeneratorPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name
    )

    $command = Get-Command -Name $Name -CommandType Function -ErrorAction SilentlyContinue | Select-Object -First 1
    Assert-NotNull $command -ErrorText "Get-GeneratorPath: '$Name' is no loaded function, so a head cannot name its file."
    $file = $command.ScriptBlock.File
    Assert-NotNull $file -ErrorText "Get-GeneratorPath: '$Name' was not loaded from a file, so a head cannot name its path."
    Assert-NotNull $command.Module -ErrorText "Get-GeneratorPath: '$Name' belongs to no module, so the root its code lives in is unknown."
    # Relative to the root the code lives in (the parent of automation/), which is the working repository root only in the mono repo.
    $codeRoot = Split-Path -Parent (Split-Path -Parent $command.Module.ModuleBase)
    [System.IO.Path]::GetRelativePath($codeRoot, $file) -replace '\\', '/'
}
