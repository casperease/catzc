<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/Get-AdoYamlInventory.ps1
    kind: function
    module: Catzc.Azure.DevOps
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Combines YAML file scanning with ADO pipeline registration data.
.DESCRIPTION
    A file that ADO has registered as a pipeline is promoted from Unknown to Pipeline.
.PARAMETER Path
    Root directory to scan. Defaults to the repository root via Get-RepositoryRoot.
.PARAMETER Exclude
    Names match exactly at any depth of the path, not as wildcards or partial paths.
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.EXAMPLE
    Get-AdoYamlInventory -Path 'C:\repos\big-mono'
.EXAMPLE
    Get-AdoYamlInventory -Path 'C:\repos\big-mono' | Where-Object { -not $_.IsRegistered -and $_.Classification -eq 'Pipeline' }
#>
function Get-AdoYamlInventory {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [string] $Path,

        [string[]] $Exclude = @('.git', 'node_modules', '.terraform'),

        [string] $Project,

        [string] $Organization
    )

    $scanParams = @{ Exclude = $Exclude }
    if ($Path) {
        $scanParams.Path = $Path
    }

    $files = Get-AdoYamlFiles @scanParams

    $defParams = @{}
    if ($Project) {
        $defParams.Project = $Project
    }
    if ($Organization) {
        $defParams.Organization = $Organization
    }

    $definitions = Get-AdoPipelineDefinitions @defParams

    $registeredByPath = @{}
    foreach ($definition in $definitions) {
        if ($definition.YamlPath) {
            $registeredByPath[$definition.YamlPath] = $definition
        }
    }

    # A scan of a subdirectory shifts the paths, so the prefix is detected from the data, not assumed.
    # [comment:3](/docs/references/automation/catzc-azure-devops/Get-AdoYamlInventory.ps1.md#comment3)
    $pathPrefix = ''
    foreach ($file in $files) {
        foreach ($definition in $definitions) {
            if ($definition.YamlPath -and $definition.YamlPath.EndsWith("/$($file.RelativePath)")) {
                $pathPrefix = $definition.YamlPath.Substring(0, $definition.YamlPath.Length - $file.RelativePath.Length)
                break
            }
        }
        if ($pathPrefix) {
            break
        }
    }

    foreach ($file in $files) {
        $registered = $registeredByPath[$pathPrefix + $file.RelativePath]
        $isRegistered = $null -ne $registered

        $classification = $file.Classification
        if ($classification -eq 'Unknown' -and $isRegistered) {
            $classification = 'Pipeline'
        }

        [Catzc.Azure.DevOps.YamlInventoryRecord]::new(
            $file.Root, $file.Path, $file.RelativePath, $file.RelativeDirectory,
            $classification, $file.TemplateType, $isRegistered,
            $registered.Name, $registered.Id, $registered.Folder,
            $file.TopLevelKeys, $file.ParseError)
    }
}
