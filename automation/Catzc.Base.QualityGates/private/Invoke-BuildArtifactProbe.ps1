<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1
    folder: private
    name: invoke-build-artifact-probe
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
    cites:
      - ADR-AUTO-TEST#30
  config:
    synopsis: Loads a build cold in a fresh pwsh and returns what that build-mode session observed.
    description: |-
      Loaded assemblies and $env: are process-global, so a build is observed in its own child pwsh
      ([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)): the child dot-sources
      <BuildRoot>/Import-Catzc.ps1 -RepositoryRoot <RepositoryRoot>, observes the session once, and writes the
      observation to a JSON file — never stdout, so the importer's console lines cannot mix into it. The
      observation names the two roots and the run mode; per loaded Catzc module its base folder, exported and
      defined function names, and instance count; the internal modules' bases; the types assembly and an
      accelerator; every shipped config read through Get-Config; a few calls into the modules; and whether Pester's
      InModuleScope enters a built module. Test-BuildArtifact judges it.
    parameters:
      BuildRoot: The build root (Catzc/<version>/).
      RepositoryRoot: The working root the child passes to Import-Catzc.ps1.
      ScopeModule: A built module to enter with InModuleScope (the build ships Pester under the full vendor policy).
    outputs: '[pscustomobject] { ExitCode; Output; Observed } — Observed is $null when the child wrote no observation.'
    examples:
      - Invoke-BuildArtifactProbe -BuildRoot $build.BuildRoot -RepositoryRoot (Get-RepositoryRoot) -ScopeModule Catzc.Base.Config
---
#>

function Invoke-BuildArtifactProbe {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $BuildRoot,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $ScopeModule
    )

    $probe = @'
param([string] $BuildRoot, [string] $RepositoryRoot, [string] $ObservationPath, [string] $ScopeModule)
. (Join-Path $BuildRoot 'Import-Catzc.ps1') -RepositoryRoot $RepositoryRoot 6>$null

$hasConfig = [bool] (Get-Command Get-Config -ErrorAction Ignore)
$configFailures = [System.Collections.Generic.List[string]]::new()
$configCount = 0
foreach ($moduleDirectory in @(if ($hasConfig) { [System.IO.Directory]::GetDirectories($BuildRoot) })) {
    $configDirectory = Join-Path $moduleDirectory 'configs'
    if (-not [System.IO.Directory]::Exists($configDirectory)) {
        continue
    }
    foreach ($configFile in [System.IO.Directory]::GetFiles($configDirectory, '*.yml')) {
        $configCount++
        $name = [System.IO.Path]::GetFileNameWithoutExtension($configFile)
        try {
            # Read as this module's own config: a config name several modules ship (glossary) needs its owner.
            $null = Get-Config $name -Module ([System.IO.Path]::GetFileName($moduleDirectory))
        }
        catch {
            $configFailures.Add("${name}: $($_.Exception.Message)")
        }
    }
}

$catzcModules = @(Get-Module | Where-Object { $_.Name -like 'Catzc.*' -and $_.Name -notlike 'Catzc.Internal.*' })
Import-Module Pester 6>$null
$inModuleScope = InModuleScope $ScopeModule { $true }

[pscustomobject]@{
    ModulesRoot    = $env:CatzcModulesRoot
    RepositoryRoot = $env:RepositoryRoot
    RunMode        = Get-CatzcRunMode
    Modules        = @($catzcModules | ForEach-Object {
            $module = $_
            [pscustomobject]@{
                Name      = $module.Name
                Base      = $module.ModuleBase
                Exported  = @($module.ExportedFunctions.Keys)
                Defined   = @(& $module {
                        param($ModuleName)
                        foreach ($function in (Get-ChildItem function:)) {
                            if ($function.ModuleName -eq $ModuleName) {
                                $function.Name
                            }
                        }
                    } $module.Name)
                Instances = @(Get-Module $module.Name -All | Where-Object Name -EQ $module.Name).Count
            }
        })
    InternalBases  = @(Get-Module 'Catzc.Internal.*' | ForEach-Object { $_.ModuleBase })
    TypesAssembly  = [System.IO.Path]::GetFileName(([Catzc.Base.Objects.PSTypeAliasAttribute]).Assembly.Location)
    Accelerator    = [Catzc.Module.Depm].FullName
    HasConfig      = $hasConfig
    ConfigCount    = $configCount
    ConfigFailures = @($configFailures)
    Repository     = Get-RepositoryRoot
    ModuleRoot     = if ($hasConfig) { Get-CatzcModuleRoot 'configs/configs.yml' -Module 'Catzc.Base.Config' }
    Private        = [bool] (Get-Command Resolve-ConfigEntry -ErrorAction Ignore)
    InModuleScope  = $inModuleScope
} | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $ObservationPath -Encoding utf8NoBOM
'@

    $work = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-build-probe-' + [guid]::NewGuid().ToString('N'))
    [System.IO.Directory]::CreateDirectory($work) | Out-Null
    try {
        $probePath = Join-Path $work 'probe.ps1'
        $observationPath = Join-Path $work 'observation.json'
        [System.IO.File]::WriteAllText($probePath, $probe, [System.Text.UTF8Encoding]::new($false))

        $pwsh = [System.Environment]::ProcessPath
        $output = & $pwsh -NoProfile -NonInteractive -File $probePath -BuildRoot $BuildRoot -RepositoryRoot $RepositoryRoot `
            -ObservationPath $observationPath -ScopeModule $ScopeModule 2>&1
        $exitCode = $LASTEXITCODE

        [pscustomobject]@{
            ExitCode = $exitCode
            Output   = (@($output | Select-Object -Last 20) | ForEach-Object { "$_" }) -join "`n"
            Observed = if ([System.IO.File]::Exists($observationPath)) {
                [System.IO.File]::ReadAllText($observationPath) | ConvertFrom-Json
            }
        }
    }
    finally {
        [System.IO.Directory]::Delete($work, $true)
    }
}
