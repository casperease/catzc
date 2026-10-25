<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-languages/New-DotnetBuildProps.ps1.md"
  warning: "Generated Header"
---
#>

function New-DotnetBuildProps {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $version = "$(Get-ConfigValue -Address 'global.tools.dotnet.version')"
    if ($version -notmatch '^\d+\.\d+$') {
        throw "tools.yml dotnet.version '$version' is not a .NET major.minor version (e.g. '10.0'), so it names no target framework."
    }

    # The one target framework is the SDK the tooling installs, so a project never names a framework whose reference pack must be downloaded.
    @"
<Project>
  <PropertyGroup>
    <TargetFramework>net$version</TargetFramework>
    <NuGetAudit>false</NuGetAudit>
  </PropertyGroup>
</Project>
"@ + "`n"
}
