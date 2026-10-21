<#
---
catzc:
  immutable:
    with_body_sha: "197ca274180d"
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Invoke-BuildForVSCode.Tests.ps1
    docs: "[Invoke-BuildForVSCode.ps1.md](docs/references/pwsh/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md)"
    cites:
      - ADR-BCL-TYPES
      - ADR-DSGN-RUNMODE
---
#>

function Invoke-BuildForVsCode {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $PassThru
    )

    Assert-SourceTree

    if (-not (Test-Command 'dotnet')) {
        throw 'dotnet is not on PATH. Install the .NET SDK (Install-Dotnet), then re-run Invoke-BuildForVsCode.'
    }

    $project = Join-Path (Get-CatzcModulesRoot) '.internal/assets/Catzc.Types.csproj'
    Assert-PathExist $project

    $configuration = (Get-Config -Config bcl).configuration
    $result = Invoke-Executable "dotnet build `"$project`" --configuration $configuration" -PassThru

    if ($PassThru) {
        return $result
    }
    $project
}
