<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Languages/private/Get-GeneratorPath.ps1
    folder: private
    name: get-generator-path
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Languages/tests/Get-GeneratorPath.Tests.ps1
    docs: "[Get-GeneratorPath.ps1.md](docs/references/pwsh/catzc-base-languages/private/Get-GeneratorPath.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-COMPOSEDFILES
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
    # Relative to the root the code lives in (the parent of pwsh/), which is the working repository root only in the mono repo.
    $codeRoot = Split-Path -Parent (Split-Path -Parent $command.Module.ModuleBase)
    [System.IO.Path]::GetRelativePath($codeRoot, $file) -replace '\\', '/'
}
