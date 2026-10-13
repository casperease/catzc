Describe 'Import-Catzc loads a full build (walking skeleton)' -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    # One build of the full profile from this commit, one cold load of it in a child pwsh (loaded assemblies and
    # $env: are process-global), one rich observation asserted facet by facet (ADR-AUTO-TEST:20).
    BeforeAll {
        Import-InternalModule Builder
        $script:repositoryRoot = Get-RepositoryRoot
        $metadata = @{
            Guid        = '6f0c4f2e-2d1a-4a8e-9b51-0d7c3c1e5a11'
            Author      = 'Widget Author'
            CompanyName = 'Gadget Co'
            Description = 'Walking-skeleton build'
            Tags        = @('widget')
        }
        $script:build = Invoke-ModuleBuild -ModuleProfile full -Version 6.6.666 -VendorPolicy runtime -Destination (Join-Path $TestDrive 'build') -PackageMetadata $metadata
        $script:buildRoot = $build.BuildRoot

        $observationPath = Join-Path $TestDrive 'observation.json'
        $probePath = Join-Path $TestDrive 'probe.ps1'
        $probe = @'
param([string] $BuildRoot, [string] $RepositoryRoot, [string] $ObservationPath)
. (Join-Path $BuildRoot 'Import-Catzc.ps1') -RepositoryRoot $RepositoryRoot 6>$null

$configFailures = [System.Collections.Generic.List[string]]::new()
$configCount = 0
foreach ($moduleDirectory in [System.IO.Directory]::GetDirectories($BuildRoot)) {
    $configDirectory = Join-Path $moduleDirectory 'configs'
    if (-not [System.IO.Directory]::Exists($configDirectory)) {
        continue
    }
    foreach ($configFile in [System.IO.Directory]::GetFiles($configDirectory, '*.yml')) {
        $configCount++
        $name = [System.IO.Path]::GetFileNameWithoutExtension($configFile)
        try {
            $null = Get-Config $name
        }
        catch {
            $configFailures.Add("${name}: $($_.Exception.Message)")
        }
    }
}

[pscustomobject]@{
    ModulesRoot    = $env:CatzcModulesRoot
    RepositoryRoot = $env:RepositoryRoot
    RunMode        = Get-CatzcRunMode
    Modules        = @(Get-Module | Where-Object { $_.Name -like 'Catzc.*' -and $_.Name -notlike 'Catzc.Internal.*' } |
            ForEach-Object { [pscustomobject]@{ Name = $_.Name; Base = $_.ModuleBase; Exported = $_.ExportedFunctions.Count } })
    InternalBases  = @(Get-Module 'Catzc.Internal.*' | ForEach-Object { $_.ModuleBase })
    TypesAssembly  = [System.IO.Path]::GetFileName(([Catzc.Base.Objects.PSTypeAliasAttribute]).Assembly.Location)
    Accelerator    = [Catzc.Module.Depm].FullName
    ConfigCount    = $configCount
    ConfigFailures = @($configFailures)
    Calls          = [ordered]@{
        Repository = Get-RepositoryRoot
        ModuleRoot = Get-CatzcModuleRoot 'configs/configs.yml' -Module 'Catzc.Base.Config'
        Objects    = (Copy-Object @{ widget = 1 }).widget
        Asserts    = $(Assert-NotNullOrWhitespace 'widget'; $true)
    }
    HelpSynopsis   = (Get-Help Get-Config).Synopsis
    Private        = [bool] (Get-Command Resolve-ConfigEntry -ErrorAction Ignore)
} | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $ObservationPath -Encoding utf8NoBOM
'@
        [System.IO.File]::WriteAllText($probePath, $probe)
        $script:probeOutput = pwsh -NoProfile -File $probePath -BuildRoot $buildRoot -RepositoryRoot $repositoryRoot -ObservationPath $observationPath 2>&1
        $script:probeExit = $LASTEXITCODE
        $script:observed = if ([System.IO.File]::Exists($observationPath)) {
            Get-Content -Raw $observationPath | ConvertFrom-Json
        }
    }

    It 'the child load succeeded' {
        $probeExit | Should -Be 0 -Because "the probe output was:`n$($probeOutput -join "`n")"
        $observed | Should -Not -BeNullOrEmpty
    }

    It 'sets the two roots: the build is the code root, the repository the working root, so the session is in build mode' {
        $observed.ModulesRoot | Should -Be $buildRoot
        $observed.RepositoryRoot | Should -Be ([System.IO.Path]::GetFullPath($repositoryRoot))
        $observed.RunMode | Should -Be 'build'
    }

    It 'loads every built module, and only from the build root' {
        @($observed.Modules.Name | Sort-Object) | Should -Be @($build.Modules | Sort-Object)
        foreach ($module in $observed.Modules) {
            $module.Base | Should -Be (Join-Path $buildRoot $module.Name)
            $module.Exported | Should -BeGreaterThan 0 -Because "$($module.Name) exports its public functions"
        }
        foreach ($base in $observed.InternalBases) {
            $base | Should -Be (Join-Path $buildRoot '.internal')
        }
    }

    It 'loads the types assembly shipped in the build, and its accelerators resolve' {
        $observed.TypesAssembly | Should -Be "Catzc.Types.$($build.TypesHash).dll"
        $observed.Accelerator | Should -Not -BeNullOrEmpty
    }

    It 'reads every shipped config through Get-Config' {
        $observed.ConfigCount | Should -BeGreaterThan 0
        @($observed.ConfigFailures) | Should -BeNullOrEmpty
    }

    It 'calls into modules and resolves module content under the build' {
        $observed.Calls.Repository | Should -Be ([System.IO.Path]::GetFullPath($repositoryRoot))
        $observed.Calls.ModuleRoot | Should -Be (Join-Path $buildRoot 'Catzc.Base.Config/configs/configs.yml')
        $observed.Calls.Objects | Should -Be 1   # Catzc.Base.Objects
        $observed.Calls.Asserts | Should -BeTrue
    }

    It 'keeps comment-based help with its function and privates out of the exports' {
        $observed.HelpSynopsis | Should -Not -BeNullOrEmpty
        $observed.HelpSynopsis | Should -Not -BeLike 'Get-Config *'
        $observed.Private | Should -BeFalse
    }

    It 'names the DLL for the hash of the type sources the build ships' {
        (Get-CombinedTypeHash -AutomationRoot $buildRoot).CombinedHash | Should -Be $build.TypesHash
    }
}
