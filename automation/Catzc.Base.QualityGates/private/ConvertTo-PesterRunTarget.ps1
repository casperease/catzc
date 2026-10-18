<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/ConvertTo-PesterRunTarget.ps1
    folder: private
    name: convert-to-pester-run-target
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1
---
#>

function ConvertTo-PesterRunTarget {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string[]] $Path,

        [string] $EntryScript,

        [hashtable] $LanguageExecutable = @{}
    )

    $languageByFolder = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($testFolder in @(Get-LanguageTestFolders)) {
        $languageByFolder[$testFolder.Folder] = $testFolder.Language
    }

    $paths = [System.Collections.Generic.List[string]]::new()
    $containers = [System.Collections.Generic.List[object]]::new()
    $bridge = [System.IO.Path]::Combine((Get-RepositoryRoot), 'automation', 'Catzc.Base.QualityGates', 'tests', 'Language.Bridge.ps1')
    foreach ($item in $Path) {
        $full = [System.IO.Path]::GetFullPath($item).TrimEnd('\', '/')
        if ($languageByFolder.ContainsKey($full)) {
            $language = $languageByFolder[$full]
            # The engines other than pwsh, whose executables the source session located too, each under its name.
            $engineExecutable = @{}
            foreach ($engine in [Catzc.Base.Engines.ExecutionEngines]::All) {
                if ($engine.Name -ne [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name) {
                    $engineExecutable[$engine.Name] = "$($LanguageExecutable[$engine.Name])"
                }
            }
            $containers.Add((New-PesterContainer -Path $bridge -Data @{
                        Language         = $language
                        TestFolder       = $full
                        EntryScript      = "$EntryScript"
                        Executable       = "$($LanguageExecutable[$language])"
                        EngineExecutable = $engineExecutable
                    }))
        }
        else {
            $paths.Add($item)
        }
    }

    [pscustomobject]@{
        Path      = [string[]]$paths.ToArray()
        Container = [object[]]$containers.ToArray()
    }
}
