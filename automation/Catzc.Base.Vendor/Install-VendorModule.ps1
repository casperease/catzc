<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Vendor/Install-VendorModule.ps1
    kind: automation-function
    module: Catzc.Base.Vendor
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-vendor/Install-VendorModule.ps1.md
      test: automation/Catzc.Base.Vendor/tests/Install-VendorModule.Tests.ps1
    adrs:
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-VENDOR
      - ADR-PWSH-VENDOR#7
  config:
    synopsis: Saves a PowerShell module into the automation/.vendor directory from the configured source.
    description: |-
      Downloads with Save-PSResource from the vendor source (configs/vendor.yml — PSGallery by default, or a
      custom feed) into automation/.vendor/<Name>/<Version>/, then removes folders the toolset never loads
      (legacy .NET Framework builds, PSScriptAnalyzer's compatibility_profiles). The only supported way to add a vendor module
      ([ADR-PWSH-VENDOR](/docs/adr/pwsh/vendor-toolset-dependencies.md)); commit the result.
      Must be run in a fresh session — a loaded module may lock its files. Writes into the source tree's
      .vendor, so it stops with a named error in build mode (Assert-SourceTree,
      [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
    parameters:
      Name: The module name to install from the vendor source.
      RequiredVersion: An optional specific version to install. Installs the latest if omitted.
    examples:
      - Install-VendorModule 'Pester'
      - Install-VendorModule 'Pester' -RequiredVersion '5.5.0'
---
#>

function Install-VendorModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Position = 1)]
        [string] $RequiredVersion
    )

    Assert-SourceTree

    # Warn if the module is currently loaded — Save-PSResource may fail on locked files.
    $loaded = Get-Module $Name -ErrorAction Ignore
    if ($loaded) {
        throw "Module '$Name' is currently loaded. Please run Install-VendorModule in a fresh PowerShell session."
    }

    $vendorRoot = Join-Path (Get-RepositoryRoot) 'automation/.vendor'
    if (-not (Test-Path $vendorRoot)) {
        Write-Verbose "Creating vendor directory: $vendorRoot"
        New-Item -Path $vendorRoot -ItemType Directory -Force | Out-Null
    }

    $saveParams = @{
        Name            = $Name
        Repository      = (Resolve-VendorRepository)
        Path            = $vendorRoot
        TrustRepository = $true
    }
    if ($RequiredVersion) {
        $saveParams.Version = $RequiredVersion
    }

    Write-Verbose "Downloading $Name from the vendor source$(if ($RequiredVersion) { " (v$RequiredVersion)" })"
    Save-PSResource @saveParams

    $moduleDir = Join-Path $vendorRoot $Name
    $prunedFolders = @('net20', 'net35', 'net40', 'net45', 'net451', 'net452',
        'net46', 'net461', 'net462', 'net47', 'net471', 'net472', 'net48', 'compatibility_profiles')
    # A vendored module's folders reach three levels below the module folder; the walk must enter every one, vendor included.
    $unusedFolders = @(Get-ChildPath $moduleDir -Directory -Depth 5 -Exclude @() -PruneVendor $false |
            Where-Object { [System.IO.Path]::GetFileName($_) -in $prunedFolders })
    foreach ($unusedFolder in $unusedFolders) {
        # A folder inside an already removed one is gone with it.
        if ([System.IO.Directory]::Exists($unusedFolder)) {
            Remove-Item $unusedFolder -Recurse -Force
            Write-Message "Removed unused folder: $($unusedFolder.Substring($vendorRoot.Length + 1))"
        }
    }

    Write-Message "Installed vendor module: $Name$(if ($RequiredVersion) { " v$RequiredVersion" })"
}
