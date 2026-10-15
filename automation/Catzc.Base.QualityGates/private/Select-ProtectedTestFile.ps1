<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Select-ProtectedTestFile.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    The protection decision:
    drops the test files of every unit whose composite identity is
    unchanged since its last green run this session.
.DESCRIPTION
    In a pipeline the input returns unchanged with no identity computed, so CI pays nothing and skips nothing.
    [ADR-REPO-PROTGLOB#9](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob9)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Select-ProtectedTestFile.ps1.md#comment1)
.PARAMETER ParallelFiles
    The parallel-phase test files.
.PARAMETER GreedyFiles
    The greedy-phase test files.
.PARAMETER SerialFiles
    The serial-phase test files.
.PARAMETER Discovery
    The run's discovery-only Pester result — used to find which units carry integrity-tagged tests.
.PARAMETER ProtectionKey
    The run-parameter key ('test-automation|L<min>-L<max>|<category>').
.OUTPUTS
    [pscustomobject] with ParallelFiles, GreedyFiles, SerialFiles (the work-lists minus protected units'
    files), ProtectedModules, and Candidates (units to promote when they come back green).
#>
function Select-ProtectedTestFile {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [AllowEmptyCollection()]
        [string[]] $ParallelFiles = @(),

        [AllowEmptyCollection()]
        [string[]] $GreedyFiles = @(),

        [AllowEmptyCollection()]
        [string[]] $SerialFiles = @(),

        [Parameter(Mandatory)]
        $Discovery,

        [Parameter(Mandatory)]
        [string] $ProtectionKey
    )

    $protectedModules = [System.Collections.Generic.List[string]]::new()
    $candidates = [System.Collections.Generic.List[string]]::new()

    if (Test-IsRunningInPipeline) {
        return [pscustomobject]@{
            ParallelFiles    = $ParallelFiles
            GreedyFiles      = $GreedyFiles
            SerialFiles      = $SerialFiles
            ProtectedModules = @()
            Candidates       = @()
        }
    }

    # which units carry integrity-tagged tests (they read the real repo -> widened to the repo-wide set)
    $integrityModules = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($test in @($Discovery.Tests)) {
        $categoryTags = @(Get-TestBlockTag -Test $test -Valid 'logic', 'integrity')
        # The test's run file: its test file, or the Go test folder of a Go bridge test.
        $file = Get-TestRunFile -Test $test
        if ($categoryTags -contains 'integrity' -and $file) {
            [void]$integrityModules.Add((Get-TestFileModule $file))
        }
    }

    # group the run's files by unit, decide per unit, drop the protected units' files
    $filesByModule = [ordered]@{}
    foreach ($file in @($ParallelFiles) + @($GreedyFiles) + @($SerialFiles)) {
        $unit = Get-TestFileModule $file
        if (-not $filesByModule.Contains($unit)) {
            $filesByModule[$unit] = [System.Collections.Generic.List[string]]::new()
        }
        $filesByModule[$unit].Add($file)
    }

    $hashCache = @{}
    $droppedFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($unit in $filesByModule.Keys) {
        $identity = Get-ModuleProtectionIdentity -Module $unit `
            -HasIntegrityTests:($integrityModules.Contains($unit)) -HashCache $hashCache
        if (Test-GlobSetProtection -Test $ProtectionKey -Name $unit -Hash $identity) {
            foreach ($file in $filesByModule[$unit]) {
                [void]$droppedFiles.Add($file)
            }
            $protectedModules.Add($unit)
        }
        else {
            $candidates.Add($unit)
        }
    }

    if ($droppedFiles.Count -gt 0) {
        Write-Message "$($protectedModules.Count) module(s) skipped (protected — unchanged since their last green run this session): $($protectedModules -join ', ')" -ForegroundColor Yellow
    }

    [pscustomobject]@{
        ParallelFiles    = @($ParallelFiles | Where-Object { -not $droppedFiles.Contains($_) })
        GreedyFiles      = @($GreedyFiles | Where-Object { -not $droppedFiles.Contains($_) })
        SerialFiles      = @($SerialFiles | Where-Object { -not $droppedFiles.Contains($_) })
        ProtectedModules = @($protectedModules)
        Candidates       = @($candidates)
    }
}
