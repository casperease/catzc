# A real dynamic module with neutral names, so its functions and contracts behave as bundled code does without naming a real one.
$script:fixtureRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
$script:modulesRoot = Join-Path $fixtureRoot 'bundle'
$script:overlayRoot = Join-Path $fixtureRoot 'consumer/.catzc/pwsh'
foreach ($folder in 'Base.Widget/configs', 'Base.Widget/assets') {
    [System.IO.Directory]::CreateDirectory((Join-Path $modulesRoot $folder)) | Out-Null
}
Set-Content -Path (Join-Path $modulesRoot 'Base.Widget/configs/widget.yml') -Value 'limit: 3'
Set-Content -Path (Join-Path $modulesRoot 'Base.Widget/assets/lever.txt') -Value 'bundled'
# The built shape: a built root's module folder carries the namespace, while the overlay folder stays bare.
$script:builtModulesRoot = Join-Path $fixtureRoot 'built'
foreach ($folder in 'Catzc.Base.Widget/configs', 'Catzc.Base.Widget/assets') {
    [System.IO.Directory]::CreateDirectory((Join-Path $builtModulesRoot $folder)) | Out-Null
}
Set-Content -Path (Join-Path $builtModulesRoot 'Catzc.Base.Widget/configs/widget.yml') -Value 'limit: 3'
Set-Content -Path (Join-Path $builtModulesRoot 'Catzc.Base.Widget/assets/lever.txt') -Value 'bundled'

function script:New-OverlayFixtureModule {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'Test fixture: the module lives inside one test file''s lifecycle and Remove-OverlayFixture removes it; its output belongs to Pester')]
    param()

    New-Module -Name Catzc.Base.Widget -ScriptBlock {
        # The public half, so an overlay override of an exported function has something real to replace.
        function Get-Widget {
            [OutputType([string])]
            param(
                [Parameter(Mandatory)]
                [string] $Name,

                [int] $Count
            )
            "bundled:$Name/$Count/$(Get-WidgetCore)"
        }
        # The private half, so an override of the public function can be seen still reaching the module's own internals.
        function Get-WidgetCore {
            [OutputType([string])]
            param()
            'core'
        }
        Export-ModuleMember -Function Get-Widget
    } | Import-Module -Global
}
New-OverlayFixtureModule

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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'Test fixture: removes the module New-OverlayFixtureModule loaded for the same test file; its output belongs to Pester')]
    param()

    Remove-Module Catzc.Base.Widget -Force -ErrorAction Ignore
    Remove-Item -Path function:global:Get-Widget -ErrorAction Ignore
}

# The overlay functions find the fixture through the same seams they find a real overlay.
$script:useFixtureRoots = {
    Mock Get-OverlayRoot -ModuleName Catzc.Base.Overlay -MockWith { $overlayRoot }
    Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Repository -MockWith { $modulesRoot }
    Mock Get-CatzcRunMode -ModuleName Catzc.Base.Repository -MockWith { 'source' }
    Mock Write-Message -ModuleName Catzc.Base.Overlay -MockWith { }
    # The engine's own track is the namespace the bundled modules are named in; the consumer declares none unless a case adds some.
    Mock Get-CatzcRunMode -ModuleName Catzc.Base.Overlay -MockWith { 'source' }
    Mock Get-Track -ModuleName Catzc.Base.Overlay -MockWith { [pscustomobject]@{ name = 'pwsh'; namespace = 'Catzc' } }
    Mock Get-Config -ModuleName Catzc.Base.Overlay -ParameterFilter { $Config -eq 'configs' } -MockWith {
        [pscustomobject]@{ sealedConfigs = @('gadget') }
    }
}

# The same seams over the built shape, applied after $useFixtureRoots.
$script:useBuiltRoot = {
    Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Repository -MockWith { $builtModulesRoot }
    Mock Get-CatzcRunMode -ModuleName Catzc.Base.Repository -MockWith { 'build' }
}
