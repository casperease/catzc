<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-types-system/New-Solution.ps1.md"
  header: "generated"
---
#>

function New-Solution {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $csharpType = '9A19103F-16F7-4668-BE54-9A1E7A4F7556'
    $folderType = '2150E333-8FDC-42A3-9474-1A3956D46DE8'
    $id = { param($Sentence) "$(ConvertTo-Guid $Sentence)".ToUpperInvariant() }

    $claudeFolder = & $id 'claude folder'
    $hooksFolder = & $id 'claude hooks folder'
    $projects = [System.Collections.Generic.List[object]]::new()
    $projects.Add([pscustomobject]@{
            Name   = 'Catzc.Types'
            Path   = "$(Get-CatzcModulesFolder)\.internal\assets\Catzc.Types.csproj".Replace('/', '\')
            Id     = & $id 'catzc types project'
            Parent = $null
        })
    [string[]] $hooks = Get-AgentHookName
    foreach ($hook in $hooks) {
        $projects.Add([pscustomobject]@{
                Name   = $hook
                Path   = ".claude\hooks\$hook\$hook.csproj"
                Id     = & $id "$(($hook -creplace '(?<=[a-z])(?=[A-Z])', ' ').Replace('-', ' ').ToLowerInvariant()) hook project"
                Parent = $hooksFolder
            })
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('Microsoft Visual Studio Solution File, Format Version 12.00')
    $lines.Add('VisualStudioVersion = 17.0.31903.59')
    $lines.Add('MinimumVisualStudioVersion = 10.0.40219.1')
    $entry = { param($Type, $Name, $Path,
            $Guid) $lines.Add("Project(`"{$Type}`") = `"$Name`", `"$Path`", `"{$Guid}`""); $lines.Add('EndProject') }
    & $entry $csharpType $projects[0].Name $projects[0].Path $projects[0].Id
    $hookProjects = @($projects | Where-Object Parent)
    if ($hookProjects.Count -gt 0) {
        & $entry $folderType '.claude' '.claude' $claudeFolder
        & $entry $folderType 'hooks' 'hooks' $hooksFolder
        foreach ($project in $hookProjects) {
            & $entry $csharpType $project.Name $project.Path $project.Id
        }
    }
    $lines.Add('Global')
    $lines.Add("`tGlobalSection(SolutionConfigurationPlatforms) = preSolution")
    $lines.Add("`t`tDebug|Any CPU = Debug|Any CPU")
    $lines.Add("`tEndGlobalSection")
    $lines.Add("`tGlobalSection(ProjectConfigurationPlatforms) = postSolution")
    foreach ($project in $projects) {
        $lines.Add("`t`t{$($project.Id)}.Debug|Any CPU.ActiveCfg = Debug|Any CPU")
        $lines.Add("`t`t{$($project.Id)}.Debug|Any CPU.Build.0 = Debug|Any CPU")
    }
    $lines.Add("`tEndGlobalSection")
    $lines.Add("`tGlobalSection(SolutionProperties) = preSolution")
    $lines.Add("`t`tHideSolutionNode = FALSE")
    $lines.Add("`tEndGlobalSection")
    if ($hookProjects.Count -gt 0) {
        $lines.Add("`tGlobalSection(NestedProjects) = preSolution")
        $lines.Add("`t`t{$hooksFolder} = {$claudeFolder}")
        foreach ($project in $hookProjects) {
            $lines.Add("`t`t{$($project.Id)} = {$hooksFolder}")
        }
        $lines.Add("`tEndGlobalSection")
    }
    $lines.Add('EndGlobal')
    ($lines -join "`n") + "`n"
}
