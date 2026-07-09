<#
.SYNOPSIS
    The protection decision (ADR-REPO-PROTGLOB:9): drops the test files of every unit whose composite identity is
    unchanged since its last green run this session.
.DESCRIPTION
    Groups the run's test files by unit (Get-TestFileModule), composes each unit's protection identity
    (Get-ModuleProtectionIdentity — own set + declared closure + infra + runner, widened for integrity tests
    and unconstrained modules), and queries the session map. Protected units' files are removed from the
    returned work-lists; unprotected units are returned as candidates for Protect-TestedModule after a green
    run. In a pipeline this returns the input unchanged without computing a single identity — CI pays
    nothing and skips nothing.
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
        if ($categoryTags -contains 'integrity' -and $test.ScriptBlock -and $test.ScriptBlock.File) {
            [void]$integrityModules.Add((Get-TestFileModule $test.ScriptBlock.File))
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
