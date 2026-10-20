<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
    name: invoke-build-for-vs-code
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Invoke-BuildForVSCode.Tests.ps1
    docs: "[Invoke-BuildForVSCode.ps1.md](docs/references/pwsh/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md)"
    cites:
      - ADR-AUTO-TYPES
      - ADR-DSGN-RUNMODE
---
#>

function Invoke-BuildForVSCode {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [ValidateSet('Debug', 'Release')]
        [string] $Configuration = 'Debug',

        [switch] $PassThru
    )

    Assert-SourceTree

    if (-not (Test-Command 'dotnet')) {
        throw 'dotnet is not on PATH. Install the .NET SDK (Install-Dotnet), then re-run Invoke-BuildForVSCode.'
    }

    $project = Join-Path (Get-CatzcModulesRoot) '.internal/assets/Catzc.Types.csproj'
    Assert-PathExist $project

    $result = Invoke-Executable "dotnet build `"$project`" --configuration $Configuration" -PassThru

    if ($PassThru) {
        return $result
    }
    $project
}
