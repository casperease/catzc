# Catzc.Internal.Vendor — the shared vendor-module loader.
#
# Loading the vendored modules under automation/.vendor/<Name>/<Version>/ happens BEFORE any Catzc module
# exists (the importer loads vendor dependencies first), so the implementation cannot live in a Catzc module.
# It also must be callable AFTER import by the Catzc.Base.Vendor cover functions that delegate to it — the
# single home for what both layers share (see docs/adr/principles/one-living-version.md). Like the other
# .internal shared libraries (Types, the Loader), this module stays in the session; it is NOT removed with
# the transient bootstrap. Loaded on demand through Import-InternalModule Vendor.

<#
.SYNOPSIS
    Imports third-party modules from a vendor directory.
.DESCRIPTION
    Loads every automation/.vendor/<Name>/<Version>/ module into the global session, removing any
    system-installed copy from $env:PSModulePath first so the vendored version takes precedence. Skips a
    module already loaded from the vendor path, and throws if its on-disk version changed under a loaded one
    (a session restart is required). Modules named in -Lazy are deferred (the vendor root is prepended to
    PSModulePath so they still autoload on first use).
.PARAMETER VendorRoot
    Path to the vendor directory. Skips silently if the path does not exist.
.PARAMETER Lazy
    Module names to defer rather than import eagerly (e.g. Pester, PSScriptAnalyzer) so they do not slow
    shell startup; they autoload on first use from the vendor root.
.PARAMETER DiagnoseLoadTime
    Emit a per-vendor-module import time (surfaced by importer.ps1 -DiagnoseLoadTime).
.EXAMPLE
    Import-VendorModules -VendorRoot $vendorRoot -Lazy 'Pester', 'PSScriptAnalyzer'
#>
function Import-VendorModules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__CatzcLoadTimings is session-global import diagnostics collected across all modules, surfaced by importer.ps1 -DiagnoseLoadTime')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$VendorRoot,

        [string[]]$Lazy = @(),

        # Emit a per-vendor-module import time. Surfaced by importer.ps1 -DiagnoseLoadTime. A vendor import
        # loads the module's .NET assemblies (e.g. YamlDotNet for powershell-yaml), which an enterprise
        # antivirus scans on first load — the prime suspect for a slow startup. This isolates that cost
        # per module so it's measured, not guessed. Off = no overhead.
        [switch]$DiagnoseLoadTime
    )

    if (-not [System.IO.Directory]::Exists($VendorRoot)) {
        Write-Verbose "No vendor folder at '$VendorRoot' — skipping"
        return
    }

    $sep = [System.IO.Path]::PathSeparator
    $vendorDirs = Get-ChildItem -Path $VendorRoot -Directory

    foreach ($dir in $vendorDirs) {
        if ($dir.Name -in $Lazy) {
            Write-Verbose "Deferring vendor module $($dir.Name): marked as lazy"
            continue
        }

        $existing = Get-Module $dir.Name -ErrorAction SilentlyContinue

        # Already loaded from our vendor path — skip (re-importing can fail
        # if the module loaded .NET assemblies that can't be replaced in-process)
        if ($existing -and $existing.ModuleBase -like "$VendorRoot*") {
            $vendorVersion = (Split-Path $existing.ModuleBase -Leaf)
            $onDiskVersions = (Get-ChildItem -Path $dir.FullName -Directory).Name
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

        # Remove system paths for this module from PSModulePath so auto-loading
        # cannot resurrect the system version after we import the vendored one
        $env:PSModulePath = ($env:PSModulePath -split $sep |
                Where-Object {
                    -not [System.IO.Directory]::Exists((Join-Path $_ $dir.Name))
                }) -join $sep

        Write-Verbose "Importing vendor module: $($dir.Name)"
        $vendorStopwatch = if ($DiagnoseLoadTime) {
            [Diagnostics.Stopwatch]::StartNew()
        }
        else {
            $null
        }
        try {
            Import-Module $dir.FullName -Scope Global -Force -ErrorAction Stop
        }
        catch {
            if ($_.Exception.InnerException -is [System.IO.FileLoadException] -or
                $_.Exception -is [System.IO.FileLoadException]) {
                # .NET assembly already loaded in-process (e.g., VS Code Extension Console)
                Write-ImporterMessage "Skipping vendor module $($dir.Name): assembly already loaded in-process"
            }
            else {
                throw
            }
        }
        if ($DiagnoseLoadTime) {
            $vendorMs = [int]$vendorStopwatch.Elapsed.TotalMilliseconds
            Write-ImporterMessage ('    {0,6}ms  vendor {1}' -f $vendorMs, $dir.Name) -ForegroundColor DarkGray
            if ($null -ne $global:__CatzcLoadTimings) {
                $global:__CatzcLoadTimings.Add([pscustomobject]@{ Stage = "vendor $($dir.Name)"; Ms = $vendorMs; ReadMs = 0; ImportMs = 0; FileCount = 0 })
            }
        }
    }

    # Prepend vendor root to PSModulePath so lazy (deferred) modules can autoload
    if ($Lazy.Count -gt 0) {
        if ($env:PSModulePath -split $sep -notcontains $VendorRoot) {
            $env:PSModulePath = $VendorRoot + $sep + $env:PSModulePath
        }
    }
}

Export-ModuleMember -Function Import-VendorModules
