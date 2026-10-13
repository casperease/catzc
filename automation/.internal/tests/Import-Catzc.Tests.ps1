BeforeAll {
    Import-InternalModule Builder
    $script:repositoryRoot = Get-RepositoryRoot
    $script:metadata = @{
        Guid        = '01d6e700-b011-d000-0000-000000000000'
        Author      = 'Widget Author'
        CompanyName = 'Gadget Co'
        Description = 'Walking-skeleton build'
        Tags        = @('widget')
    }

    # One cold load of a build in a child pwsh (loaded assemblies and $env: are process-global), observed once and
    # asserted facet by facet (ADR-AUTO-TEST:20). The observation is written to a file, so the importer's console
    # lines never mix into it. -ScopeModule names a module to enter with Pester's InModuleScope, which rejects a
    # module name that more than one loaded module carries.
    $script:probe = @'
param([string] $BuildRoot, [string] $RepositoryRoot, [string] $ObservationPath, [string] $ScopeModule)
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

$catzcModules = @(Get-Module | Where-Object { $_.Name -like 'Catzc.*' -and $_.Name -notlike 'Catzc.Internal.*' })
$inModuleScope = $null
if ($ScopeModule) {
    Import-Module Pester 6>$null
    $inModuleScope = InModuleScope $ScopeModule { $true }
}

[pscustomobject]@{
    ModulesRoot    = $env:CatzcModulesRoot
    RepositoryRoot = $env:RepositoryRoot
    RunMode        = Get-CatzcRunMode
    Modules        = @($catzcModules | ForEach-Object {
            [pscustomobject]@{
                Name      = $_.Name
                Base      = $_.ModuleBase
                Exported  = $_.ExportedFunctions.Count
                Instances = @(Get-Module $_.Name -All | Where-Object Name -EQ $_.Name).Count
            }
        })
    InternalBases  = @(Get-Module 'Catzc.Internal.*' | ForEach-Object { $_.ModuleBase })
    TypesAssembly  = [System.IO.Path]::GetFileName(([Catzc.Base.Objects.PSTypeAliasAttribute]).Assembly.Location)
    Accelerator    = [Catzc.Module.Depm].FullName
    ConfigCount    = $configCount
    ConfigFailures = @($configFailures)
    Calls          = [ordered]@{
        Repository = Get-RepositoryRoot
        ModuleRoot = Get-CatzcModuleRoot 'configs/configs.yml' -Module 'Catzc.Base.Config'
        Asserts    = $(Assert-NotNullOrWhitespace 'widget'; $true)
    }
    HelpSynopsis   = (Get-Help Get-Config).Synopsis
    Private        = [bool] (Get-Command Resolve-ConfigEntry -ErrorAction Ignore)
    InModuleScope  = $inModuleScope
} | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $ObservationPath -Encoding utf8NoBOM
'@

    function script:Invoke-BuildProbe {
        param([string] $BuildRoot, [string] $Name, [string] $ScopeModule)
        $probePath = Join-Path $TestDrive "$Name-probe.ps1"
        $observationPath = Join-Path $TestDrive "$Name-observation.json"
        [System.IO.File]::WriteAllText($probePath, $probe)
        $arguments = @('-NoProfile', '-File', $probePath, '-BuildRoot', $BuildRoot, '-RepositoryRoot', $repositoryRoot, '-ObservationPath', $observationPath)
        if ($ScopeModule) {
            $arguments += @('-ScopeModule', $ScopeModule)
        }
        $output = pwsh @arguments 2>&1
        [pscustomobject]@{
            Exit     = $LASTEXITCODE
            Output   = ($output -join "`n")
            Observed = if ([System.IO.File]::Exists($observationPath)) {
                Get-Content -Raw $observationPath | ConvertFrom-Json
            }
        }
    }
}

Describe 'Import-Catzc loads a full build (walking skeleton)' -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    BeforeAll {
        # vendor_policy full, as the build suite builds: Pester ships, so the child can enter a module's scope.
        $script:build = Invoke-ModuleBuild -ModuleProfile full -Version 6.6.666 -VendorPolicy full -Destination (Join-Path $TestDrive 'full') -PackageMetadata $metadata
        $script:buildRoot = $build.BuildRoot
        $script:run = Invoke-BuildProbe -BuildRoot $buildRoot -Name 'full' -ScopeModule 'Catzc.Base.Config'
        $script:observed = $run.Observed
    }

    It 'the child load succeeded' {
        $run.Exit | Should -Be 0 -Because "the probe output was:`n$($run.Output)"
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

    It 'loads exactly one module per built module name — the merged file never adds a same-named nested module' {
        foreach ($module in $observed.Modules) {
            $module.Instances | Should -Be 1 -Because "Get-Module $($module.Name) -All must find the manifest module only"
        }
    }

    It 'lets Pester enter a built module''s scope (InModuleScope)' {
        $observed.InModuleScope | Should -BeTrue
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

    It 'passes the bundle integrity gate' {
        { Assert-CatzcBundle -Path $buildRoot } | Should -Not -Throw
    }
}

Describe 'Import-Catzc loads a reduced build' -Tag 'L2', 'integrity', 'greedy', 'source-only' {
    # A build of one module and its dependency closure still ships the full type set: the selected modules'
    # sources in their types/ folders, the rest under .compiled/types/, so the load-time hash finds the full DLL.
    BeforeAll {
        $script:build = Invoke-ModuleBuild -Module 'Catzc.Base.Config' -Version 6.6.666 -VendorPolicy runtime -Destination (Join-Path $TestDrive 'reduced') -PackageMetadata $metadata
        $script:buildRoot = $build.BuildRoot
        $script:run = Invoke-BuildProbe -BuildRoot $buildRoot -Name 'reduced'
        $script:observed = $run.Observed
    }

    It 'builds a subset that still names the full type set' {
        $build.Modules | Should -Contain 'Catzc.Base.Config'
        $build.Modules.Count | Should -BeLessThan (Get-ChildItem -Directory (Join-Path $repositoryRoot 'automation') | Where-Object Name -NotLike '.*').Count
        $build.TypesHash | Should -Be (Get-CombinedTypeHash -AutomationRoot (Join-Path $repositoryRoot 'automation')).CombinedHash
        (Get-CombinedTypeHash -AutomationRoot $buildRoot).CombinedHash | Should -Be $build.TypesHash
        { Assert-CatzcBundle -Path $buildRoot } | Should -Not -Throw
    }

    It 'loads in a child, in build mode, with only the built modules, each once' {
        $run.Exit | Should -Be 0 -Because "the probe output was:`n$($run.Output)"
        $observed.RunMode | Should -Be 'build'
        @($observed.Modules.Name | Sort-Object) | Should -Be @($build.Modules | Sort-Object)
        foreach ($module in $observed.Modules) {
            $module.Base | Should -Be (Join-Path $buildRoot $module.Name)
            $module.Instances | Should -Be 1
        }
    }

    It 'loads the full types assembly and reads its shipped configs' {
        $observed.TypesAssembly | Should -Be "Catzc.Types.$($build.TypesHash).dll"
        $observed.Accelerator | Should -Not -BeNullOrEmpty
        $observed.ConfigCount | Should -BeGreaterThan 0
        @($observed.ConfigFailures) | Should -BeNullOrEmpty
    }
}
