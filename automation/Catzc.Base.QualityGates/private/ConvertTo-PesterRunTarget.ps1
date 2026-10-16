<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/ConvertTo-PesterRunTarget.ps1
    folder: private
    name: convert-to-pester-run-target
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1
  config:
    synopsis: Splits a run's paths into the Pester run paths and the language bridge containers.
    description: |-
      A test run's paths are tests/ folders and *.Tests.ps1 files, which Pester runs by path, and the test folders of
      the test languages beside PowerShell (Get-LanguageTestFolders: Go, Python), which have no Pester file of their
      own: each runs through the one shared language bridge, automation/Catzc.Base.QualityGates/tests/Language.Bridge.ps1,
      as a Pester container whose data names the language (Language), the folder (TestFolder), the engine entry the
      tests start (EntryScript), the tool that runs them (Executable, that language's entry of -LanguageExecutable), and
      the executables of the other execution engines the tests also run under (EngineExecutable: one entry per engine
      other than pwsh, by its name, empty for an engine the source session did not find).
      Get-TestRunFile reads the folder back from a test's container, so the folder stays the run file of its tests.

      The bridge is read from the repository, not the code root: tests never ship, and the build run runs the
      repository's tests against the build.
    parameters:
      Path: The run's paths, in run order.
      EntryScript: The engine entry of a build run (the build's Import-Catzc.ps1), handed to the bridge; empty for the source run.
      LanguageExecutable: |-
        The managed tool per language the run's source session located (Get-LanguageTestExecutable:
        @{ go = <path>; python = <uv path>; <engine> = <path> per engine other than pwsh }), handed to the bridge; a
        missing or empty entry means there is none.
    outputs: |-
      [pscustomobject] { Path (string[], the paths Pester runs as files and folders, in order); Container (object[],
      one bridge container per language test folder, in order) }.
    examples:
      - '$target = ConvertTo-PesterRunTarget -Path $testPaths'
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
