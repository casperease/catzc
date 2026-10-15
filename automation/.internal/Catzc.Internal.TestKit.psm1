<#
---
catzc:
  derived:
    path: automation/.internal/Catzc.Internal.TestKit.psm1
    kind: internal-module
    relatives:
      page: docs/references/automation/internal/Catzc.Internal.TestKit.psm1.md
---
#>

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

function New-ModuleFolder {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Root,

        [Parameter(Mandatory)]
        [string] $Name,

        [string[]] $Public = @(),

        [string[]] $Private = @(),

        [hashtable] $Files = @{}
    )

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $moduleDirectory = Join-Path $Root "automation/$Name"
    [System.IO.Directory]::CreateDirectory($moduleDirectory) | Out-Null

    foreach ($function in $Public) {
        if ($function) {
            [System.IO.File]::WriteAllText((Join-Path $moduleDirectory "$function.ps1"), "function $function {}", $utf8)
        }
    }
    if (@($Private).Where({ $_ }).Count -gt 0) {
        $privateDirectory = Join-Path $moduleDirectory 'private'
        [System.IO.Directory]::CreateDirectory($privateDirectory) | Out-Null
        foreach ($function in $Private) {
            if ($function) {
                [System.IO.File]::WriteAllText((Join-Path $privateDirectory "$function.ps1"), "function $function {}", $utf8)
            }
        }
    }
    foreach ($relative in $Files.Keys) {
        $path = Join-Path $moduleDirectory $relative
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
        [System.IO.File]::WriteAllText($path, [string] $Files[$relative], $utf8)
    }

    $moduleDirectory
}

function New-FakeRepositoryRoot {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Test fixture: the swap lives inside one test''s lifecycle and Remove-FakeRepositoryRoot restores it (the split form of ADR-AUTO-CONSOLE#12); its output belongs to Pester')]
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [hashtable] $Modules = @{},

        [hashtable] $Files = @{},

        [switch] $WorkingRootOnly
    )

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $root = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-fixture-' + [guid]::NewGuid().ToString('N'))
    [System.IO.Directory]::CreateDirectory((Join-Path $root 'automation')) | Out-Null

    foreach ($name in $Modules.Keys) {
        $specification = $Modules[$name]
        $params = @{ Root = $root; Name = $name }
        if ($specification -is [System.Collections.IDictionary]) {
            if ($specification['Public']) {
                $params['Public'] = @($specification['Public'])
            }
            if ($specification['Private']) {
                $params['Private'] = @($specification['Private'])
            }
            if ($specification['Files'] -is [System.Collections.IDictionary]) {
                $params['Files'] = $specification['Files']
            }
        }
        New-ModuleFolder @params | Out-Null
    }
    foreach ($relative in $Files.Keys) {
        $path = Join-Path $root $relative
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
        [System.IO.File]::WriteAllText($path, [string] $Files[$relative], $utf8)
    }

    $saved = @{ RepositoryRoot = $env:RepositoryRoot; CatzcModulesRoot = $env:CatzcModulesRoot }
    $automation = Join-Path $root 'automation'
    $env:RepositoryRoot = $root
    if (-not $WorkingRootOnly) {
        $env:CatzcModulesRoot = $automation
    }
    @{ Root = $root; Automation = $automation; Saved = $saved }
}

function Remove-FakeRepositoryRoot {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Test fixture: restores the swap New-FakeRepositoryRoot made inside the same test (the split form of ADR-AUTO-CONSOLE#12); its output belongs to Pester')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable] $Handle
    )

    $env:RepositoryRoot = $Handle.Saved.RepositoryRoot
    $env:CatzcModulesRoot = $Handle.Saved.CatzcModulesRoot
    if ($Handle.Root -and (Test-Path $Handle.Root)) {
        Remove-Item $Handle.Root -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function New-BuiltCatzcRoot {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Test fixture: builds into a temp folder inside one test''s lifecycle and Remove-BuiltCatzcRoot removes it; its output belongs to Pester')]
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string[]] $Module = @(),

        [string] $ModuleProfile,

        [string] $WorkingRoot
    )

    if (-not (Get-Command Build-Modules -ErrorAction Ignore)) {
        throw 'New-BuiltCatzcRoot needs Build-Modules (Catzc.Base.Exporter), which is not loaded in this session.'
    }
    if (-not $WorkingRoot) {
        $WorkingRoot = $env:RepositoryRoot
    }

    $selection = @{}
    if ($Module.Count -gt 0) {
        $selection['Module'] = $Module
    }
    if ($ModuleProfile) {
        $selection['ModuleProfile'] = $ModuleProfile
    }

    $saved = @{ RepositoryRoot = $env:RepositoryRoot; CatzcModulesRoot = $env:CatzcModulesRoot }
    $destination = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-built-' + [guid]::NewGuid().ToString('N'))
    try {
        $build = Build-Modules @selection -VendorPolicy full -Destination $destination -Silent
    }
    catch {
        if ([System.IO.Directory]::Exists($destination)) {
            [System.IO.Directory]::Delete($destination, $true)
        }
        throw
    }

    @{
        BuildRoot   = [string] $build.BuildRoot
        WorkingRoot = $WorkingRoot
        Saved       = $saved
        Destination = $destination
        Modules     = @($build.Modules)
        Build       = $build
    }
}

function Invoke-InBuiltCatzc {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable] $Handle,

        [Parameter(Mandatory)]
        [scriptblock] $ScriptBlock,

        [object[]] $ArgumentList = @()
    )

    $importScript = Join-Path $Handle.BuildRoot 'Import-Catzc.ps1'
    if (-not [System.IO.File]::Exists($importScript)) {
        throw "Invoke-InBuiltCatzc: no Import-Catzc.ps1 in the build root '$($Handle.BuildRoot)'."
    }

    $work = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-inbuilt-' + [guid]::NewGuid().ToString('N'))
    [System.IO.Directory]::CreateDirectory($work) | Out-Null
    try {
        $utf8 = [System.Text.UTF8Encoding]::new($false)
        $blockPath = Join-Path $work 'block.ps1'
        $argumentsPath = Join-Path $work 'arguments.clixml'
        $resultPath = Join-Path $work 'result.clixml'
        $runnerPath = Join-Path $work 'runner.ps1'
        [System.IO.File]::WriteAllText($blockPath, $ScriptBlock.ToString(), $utf8)
        # Wrapped in a table: a bare top-level array round-trips through CliXml as one object, not its elements.
        Export-Clixml -InputObject @{ Arguments = @($ArgumentList) } -LiteralPath $argumentsPath -Depth 5

        $runner = @'
param([string] $CatzcChildImportScript, [string] $CatzcChildWorkingRoot, [string] $CatzcChildBlockPath,
    [string] $CatzcChildArgumentsPath, [string] $CatzcChildResultPath)
$ErrorActionPreference = 'Stop'
$catzcChildOutcome = @{ Output = @(); Error = $null }
try {
    . $CatzcChildImportScript -RepositoryRoot $CatzcChildWorkingRoot
    $catzcChildBlock = [scriptblock]::Create([System.IO.File]::ReadAllText($CatzcChildBlockPath))
    $catzcChildArguments = @((Import-Clixml -LiteralPath $CatzcChildArgumentsPath).Arguments)
    $catzcChildOutcome.Output = @(& $catzcChildBlock @catzcChildArguments)
}
catch {
    $catzcChildOutcome.Error = "$($_.Exception.Message)`n$($_.ScriptStackTrace)"
}
Export-Clixml -InputObject $catzcChildOutcome -LiteralPath $CatzcChildResultPath -Depth 5
exit ([int][bool]$catzcChildOutcome.Error)
'@
        [System.IO.File]::WriteAllText($runnerPath, $runner, $utf8)

        $pwsh = [System.Environment]::ProcessPath
        $childOutput = & $pwsh -NoProfile -NonInteractive -File $runnerPath -CatzcChildImportScript $importScript `
            -CatzcChildWorkingRoot $Handle.WorkingRoot -CatzcChildBlockPath $blockPath `
            -CatzcChildArgumentsPath $argumentsPath -CatzcChildResultPath $resultPath 2>&1
        $exitCode = $LASTEXITCODE
        $outputTail = (@($childOutput | Select-Object -Last 20) | ForEach-Object { "$_" }) -join "`n"

        if (-not [System.IO.File]::Exists($resultPath)) {
            throw "Invoke-InBuiltCatzc: the child pwsh exited $exitCode without writing its result. Output:`n$outputTail"
        }
        $outcome = Import-Clixml -LiteralPath $resultPath
        if ($outcome.Error) {
            throw "Invoke-InBuiltCatzc: the block failed in the built session: $($outcome.Error)"
        }
        foreach ($item in @($outcome.Output)) {
            $item
        }
    }
    finally {
        [System.IO.Directory]::Delete($work, $true)
    }
}

function Remove-BuiltCatzcRoot {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Test fixture: removes the temp build New-BuiltCatzcRoot made inside the same test; its output belongs to Pester')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable] $Handle
    )

    $env:RepositoryRoot = $Handle.Saved.RepositoryRoot
    $env:CatzcModulesRoot = $Handle.Saved.CatzcModulesRoot
    if ($Handle.Destination -and [System.IO.Directory]::Exists($Handle.Destination)) {
        [System.IO.Directory]::Delete($Handle.Destination, $true)
    }
}

Export-ModuleMember -Function New-ModuleFolder, New-FakeRepositoryRoot, Remove-FakeRepositoryRoot, `
    New-BuiltCatzcRoot, Invoke-InBuiltCatzc, Remove-BuiltCatzcRoot
