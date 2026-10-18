<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
    name: invoke-build-for-vs-code
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
    test: automation/Catzc.Base.TypesSystem/tests/Invoke-BuildForVSCode.Tests.ps1
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

    $project = Join-Path (Get-RepositoryRoot) 'automation/.internal/assets/Catzc.Types.csproj'
    Assert-PathExist $project

    $result = Invoke-Executable "dotnet build `"$project`" --configuration $Configuration" -PassThru

    if ($PassThru) {
        return $result
    }
    $project
}
