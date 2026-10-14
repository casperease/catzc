<#
.SYNOPSIS
    Splits a run's paths into the Pester run paths and the Go bridge containers.
.DESCRIPTION
    A test run's paths are tests/ folders and *.Tests.ps1 files, which Pester runs by path, and Go test folders
    (Get-GoTestFolders), which have no Pester file of their own: each runs through the one shared Go bridge,
    automation/Catzc.Base.QualityGates/tests/Go.Bridge.ps1, as a Pester container whose data names the folder
    (GoTestFolder), the engine entry the Go tests start (EntryScript), and the go that runs them (GoExecutable). Get-TestRunFile reads the folder back
    from a test's container, so the folder stays the run file of its tests.

    The bridge is read from the repository, not the code root: tests never ship, and the build run runs the
    repository's tests against the build.
.PARAMETER Path
    The run's paths, in run order.
.PARAMETER EntryScript
    The engine entry of a build run (the build's Import-Catzc.ps1), handed to the bridge; empty for the source run.
.PARAMETER GoExecutable
    The managed go the run's source session located (Get-GoTestExecutable), handed to the bridge; empty when there
    is none.
.OUTPUTS
    [pscustomobject] { Path (string[], the paths Pester runs as files and folders, in order); Container (object[],
    one bridge container per Go test folder, in order) }.
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

        [string] $GoExecutable
    )

    $goFolders = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($goFolder in @(Get-GoTestFolders)) {
        [void]$goFolders.Add($goFolder.Folder)
    }

    $paths = [System.Collections.Generic.List[string]]::new()
    $containers = [System.Collections.Generic.List[object]]::new()
    $bridge = [System.IO.Path]::Combine((Get-RepositoryRoot), 'automation', 'Catzc.Base.QualityGates', 'tests', 'Go.Bridge.ps1')
    foreach ($item in $Path) {
        $full = [System.IO.Path]::GetFullPath($item).TrimEnd('\', '/')
        if ($goFolders.Contains($full)) {
            $containers.Add((New-PesterContainer -Path $bridge -Data @{ GoTestFolder = $full; EntryScript = "$EntryScript"; GoExecutable = "$GoExecutable" }))
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
