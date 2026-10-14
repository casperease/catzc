# Shared fixture of the overlay tests: a bundled module Catzc.Base.Widget (a dynamic module in the session, so its
# functions and their contracts are real), a code root that ships it, and a consumer overlay root — all neutral
# names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)). Dot-source it in BeforeAll;
# call Remove-OverlayFixture in AfterAll.

$script:fixtureRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
$script:modulesRoot = Join-Path $fixtureRoot 'bundle'
$script:overlayRoot = Join-Path $fixtureRoot 'consumer/.catzc/automation'
foreach ($folder in 'Catzc.Base.Widget/configs', 'Catzc.Base.Widget/assets') {
    [System.IO.Directory]::CreateDirectory((Join-Path $modulesRoot $folder)) | Out-Null
}
Set-Content -Path (Join-Path $modulesRoot 'Catzc.Base.Widget/configs/widget.yml') -Value 'limit: 3'
Set-Content -Path (Join-Path $modulesRoot 'Catzc.Base.Widget/assets/lever.txt') -Value 'bundled'

New-Module -Name Catzc.Base.Widget -ScriptBlock {
    function Get-Widget {
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string] $Name,

            [int] $Count
        )
        "bundled:$(Get-WidgetCore)"
    }
    function Get-WidgetCore {
        [OutputType([string])]
        param()
        'core'
    }
    Export-ModuleMember -Function Get-Widget
} | Import-Module -Global

function script:Set-OverlayFile {
    param([string] $RelativePath, [string] $Content)
    $path = Join-Path $overlayRoot $RelativePath
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
    Set-Content -Path $path -Value $Content
}

function script:Clear-OverlayFixture {
    if ([System.IO.Directory]::Exists($overlayRoot)) {
        [System.IO.Directory]::Delete($overlayRoot, $true)
    }
    [System.IO.Directory]::CreateDirectory($overlayRoot) | Out-Null
}

function script:Remove-OverlayFixture {
    Remove-Module Catzc.Base.Widget -Force -ErrorAction Ignore
    Remove-Item -Path function:global:Get-Widget -ErrorAction Ignore
}

# The overlay functions find the fixture through the same seams they find a real overlay.
$script:useFixtureRoots = {
    Mock Get-CatzcOverlayRoot -ModuleName Catzc.Base.Overlay -MockWith { $overlayRoot }
    Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Overlay -MockWith { $modulesRoot }
    Mock Get-CatzcModuleRoot -ModuleName Catzc.Base.Overlay -MockWith { [System.IO.Path]::Combine($modulesRoot, $Module, $ChildPath) }
    Mock Get-Config -ModuleName Catzc.Base.Overlay -ParameterFilter { $Config -eq 'configs' } -MockWith {
        [pscustomobject]@{ sealedConfigs = @('gadget') }
    }
}
