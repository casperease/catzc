<#
.SYNOPSIS
    Splits a run's paths into the Pester run paths and the language bridge containers.
.DESCRIPTION
    A test run's paths are tests/ folders and *.Tests.ps1 files, which Pester runs by path, and the test folders of...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/ConvertTo-PesterRunTarget.ps1.md#comment1)
.PARAMETER Path
    The run's paths, in run order.
.PARAMETER EntryScript
    The engine entry of a build run (the build's Import-Catzc.ps1), handed to the bridge; empty for the source run.
.PARAMETER LanguageExecutable
    The managed tool per language the run's source session located (Get-LanguageTestExecutable: @{ go = <path>;...
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/ConvertTo-PesterRunTarget.ps1.md#comment2)
.OUTPUTS
    [pscustomobject] { Path (string[], the paths Pester runs as files and folders, in order); Container (object[],
    one bridge container per language test folder, in order) }.
.EXAMPLE
    $target = ConvertTo-PesterRunTarget -Path $testPaths
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
