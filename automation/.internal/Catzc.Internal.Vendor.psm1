<#
---
catzc:
  derived:
    path: automation/.internal/Catzc.Internal.Vendor.psm1
    kind: internal-module
    relatives:
      page: docs/references/automation/internal/Catzc.Internal.Vendor.psm1.md
---
#>

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

function Import-VendorModules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__CatzcLoadTimings is session-global import diagnostics collected across all modules, surfaced by importer.ps1 -DiagnoseLoadTime')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$VendorRoot,

        [string[]]$Lazy = @(),

        [switch]$DiagnoseLoadTime
    )

    if (-not [System.IO.Directory]::Exists($VendorRoot)) {
        Write-Verbose "No vendor folder at '$VendorRoot' — skipping"
        return
    }

    $sep = [System.IO.Path]::PathSeparator
    $vendorDirs = [System.IO.DirectoryInfo]::new($VendorRoot).GetDirectories()

    foreach ($dir in $vendorDirs) {
        if ($dir.Name -in $Lazy) {
            Write-Verbose "Deferring vendor module $($dir.Name): marked as lazy"
            continue
        }

        $existing = Get-Module $dir.Name -ErrorAction SilentlyContinue

        if ($existing -and $existing.ModuleBase -like "$VendorRoot*") {
            $vendorVersion = (Split-Path $existing.ModuleBase -Leaf)
            $onDiskVersions = $dir.GetDirectories().Name
            if ($onDiskVersions -and $vendorVersion -notin $onDiskVersions) {
                throw "Vendor module '$($dir.Name)' version changed on disk ($onDiskVersions) but $vendorVersion is loaded. Please restart your PowerShell session."
            }
            Write-Verbose "Skipping vendor module $($dir.Name): already loaded from vendor"
            continue
        }

        # Remove any system-installed version so the vendored one takes precedence
        if ($existing) {
            Write-Verbose "Removing existing module: $($existing.Name) $($existing.Version) from $($existing.ModuleBase)"
            Remove-Module $existing.Name -Force -ErrorAction SilentlyContinue
        }

        $before = @($env:PSModulePath -split $sep)
        $env:PSModulePath = ($before |
                Where-Object {
                    -not [System.IO.Directory]::Exists((Join-Path $_ $dir.Name))
                }) -join $sep
        $dropped = @($before | Where-Object { $_ -notin ($env:PSModulePath -split $sep) })

        Write-Verbose "Importing vendor module: $($dir.Name)"
        $vendorStopwatch = if ($DiagnoseLoadTime) {
            [Diagnostics.Stopwatch]::StartNew()
        }
        else {
            $null
        }
        try {
            $vendored = Import-Module $dir.FullName -Scope Global -Force -ErrorAction Stop -PassThru | Select-Object -First 1
            $line = "Loaded vendor module $($dir.Name) $($vendored.Version)"
        }
        catch {
            if ($_.Exception.InnerException -is [System.IO.FileLoadException] -or
                $_.Exception -is [System.IO.FileLoadException]) {
                # .NET assembly already loaded in-process (e.g., VS Code Extension Console)
                $line = "Skipped vendor module $($dir.Name): assembly already loaded in-process"
            }
            else {
                throw
            }
        }

        if ($existing) {
            $line += "; replaced $($existing.Name) $($existing.Version) from '$($existing.ModuleBase)'"
        }
        if ($dropped.Count) {
            $line += "; dropped from PSModulePath: '$($dropped -join "', '")'"
        }
        Write-ImporterMessage $line -StateChange
        if ($DiagnoseLoadTime) {
            $vendorMs = [int]$vendorStopwatch.Elapsed.TotalMilliseconds
            Write-ImporterMessage ('    {0,6}ms  vendor {1}' -f $vendorMs, $dir.Name) -ForegroundColor DarkGray
            if ($null -ne (Get-Variable -Name '__CatzcLoadTimings' -Scope Global -ValueOnly -ErrorAction Ignore)) {
                $global:__CatzcLoadTimings.Add([pscustomobject]@{ Stage = "vendor $($dir.Name)"; Ms = $vendorMs; ReadMs = 0; ImportMs = 0; FileCount = 0 })
            }
        }
    }

    # Prepend vendor root to PSModulePath so lazy (deferred) modules can autoload
    if ($Lazy.Count -gt 0) {
        if ($env:PSModulePath -split $sep -notcontains $VendorRoot) {
            $env:PSModulePath = $VendorRoot + $sep + $env:PSModulePath
            Write-ImporterMessage "PSModulePath now starts with '$VendorRoot', so $($Lazy -join ', ') load from it on first use" -StateChange
        }
    }
}

Export-ModuleMember -Function Import-VendorModules
