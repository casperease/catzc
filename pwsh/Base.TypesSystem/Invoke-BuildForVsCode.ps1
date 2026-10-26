<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-types-system/Invoke-BuildForVsCode.ps1.md"
  header: "generated"
---
#>

function Invoke-BuildForVsCode {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $PassThru
    )

    Assert-SourceTree

    Assert-Command dotnet -ErrorText 'dotnet is not on PATH. Install the .NET SDK (Install-Dotnet), then re-run Invoke-BuildForVsCode.'

    $project = Join-Path (Get-CatzcModulesRoot) '.internal/assets/Catzc.Types.csproj'
    Assert-PathExist $project

    $configuration = (Get-Config -Config bcl).configuration
    Assert-DotnetOffline $project
    # Analyzer diagnostics stream through; a stale committed DLL or an analyzer error fails the build by its exit code.
    $result = Invoke-Executable "dotnet build `"$project`" --configuration $configuration" -PassThru
    Assert-NotNull $result -ErrorText "dotnet build of '$project' returned no result."

    if ($PassThru) {
        return $result
    }
    $project
}
