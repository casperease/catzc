<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Select-ProtectedTestFile.ps1
    folder: private
    name: select-protected-test-file
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Select-ProtectedTestFile.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Select-ProtectedTestFile.ps1.md)"
    cites:
      - ADR-REPO-PROTGLOB-ORCHESTRATORDECIDES
---
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
    $modulesRoot = [System.IO.Path]::Combine((Get-RepositoryRoot), (Get-CatzcModulesFolder))
    $filesByModule = [ordered]@{}
    $outsideModules = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($file in @($ParallelFiles) + @($GreedyFiles) + @($SerialFiles)) {
        $unit = Get-TestFileModule $file
        if (-not $filesByModule.Contains($unit)) {
            $filesByModule[$unit] = [System.Collections.Generic.List[string]]::new()
        }
        $filesByModule[$unit].Add($file)
        # a unit with no folder under the modules root is a module of another track (its own tests/ folder)
        if (-not [System.IO.Directory]::Exists([System.IO.Path]::Combine($modulesRoot, $unit))) {
            [void]$outsideModules.Add($unit)
        }
    }

    $hashCache = @{}
    $droppedFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($unit in $filesByModule.Keys) {
        $identity = Get-ModuleProtectionIdentity -Module $unit `
            -HasIntegrityTests:($integrityModules.Contains($unit)) -OutsideModulesFolder:($outsideModules.Contains($unit)) -HashCache $hashCache
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
