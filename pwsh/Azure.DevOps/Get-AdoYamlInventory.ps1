<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-dev-ops/Get-AdoYamlInventory.ps1.md"
  header: "generated"
---
#>

function Get-AdoYamlInventory {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [string] $Path,

        [int] $Depth = (Get-Config -Config ado).yaml_inventory_depth,

        [string] $Project,

        [string] $Organization
    )

    $scanParams = @{ Depth = $Depth }
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

    # ADO paths are repo-root relative but scan paths are scan-root relative, so a subfolder scan shows a prefix mismatch.
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
