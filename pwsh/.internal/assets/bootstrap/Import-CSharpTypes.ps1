# .SYNOPSIS
#     Compiles and loads EVERY module's native C# types (types/*.cs) into ONE hash-keyed assembly.
# .DESCRIPTION
#     One assembly lets a type in one module reference a type in another; the module graph is policed by tests.
# .PARAMETER ModulesRoot
#     The modules folder. Its non-dot subfolders are the modules; the manifest is written to its .compiled/, the
# assembly to the shadow root.
# .PARAMETER DiagnoseLoadTime
#     Emit a single combined compile/cache-load timing line (surfaced by importer.ps1 -DiagnoseLoadTime).
# .PARAMETER PrebuiltOnly
#     A bundle: the prebuilt DLL and manifest must exist, and the run mode for the types-load policy is build.
# .PARAMETER HostKind
#     console or headless, the host axis of the types-load policy. Only the interactive importer passes console.
function Import-CSharpTypes {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
        Justification = 'Session-global by design: $global:__CatzcTypes (per-ModulesRoot hash+snapshot) must survive module reimport to detect C# source changes across the session, and $global:__CatzcLoadTimings collects import diagnostics')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulesRoot,

        [switch]$DiagnoseLoadTime,

        # Prebuilt-only load (a bundle): load the shipped combined-types assembly, and throw if it is absent —
        # never invoke Roslyn and never write. A bundle ships the DLL, so a read-only install never compiles.
        [switch]$PrebuiltOnly,

        # Only an interactive dot-source is console; a caller that says nothing gets the eager load (types-load.yml).
        [ValidateSet('console', 'headless')]
        [string]$HostKind = 'headless'
    )

    # The enumeration, deterministic ordering, per-file EOL-insensitive digest, combined hash, and per-file
    # snapshot all come from the ONE shared implementation (Get-CombinedTypeHash in the .internal shared module)
    # that the janitor (Clear-ModuleTypeCache) also calls — so the committed Catzc.Types.<hash>.dll key can never
    # drift between loader and janitor. The importer loads Catzc.Internal.Types before this pre-pass; the
    # Import-InternalModule call is a no-op guard that keeps this callable if the module was unloaded.
    Import-InternalModule Types
    # The hash memo lives beside the shadow copies, machine-local like them; a bundle is read-only and hashes every
    # file.
    $hashArguments = @{ ModulesRoot = $ModulesRoot }
    if (-not $PrebuiltOnly) {
        $hashArguments['StampPath'] = Get-TypesStampPath -ModulesRoot $ModulesRoot
    }
    $hashResult = Get-CombinedTypeHash @hashArguments
    if ($hashResult.Files.Count -eq 0) {
        return
    }

    # Validate each source and derive its FQN (<module>.<filename>). These two poka-yokes are the loader's job,
    # deliberately NOT in the shared enumerator (the janitor must never throw on a source that is wrong): a
    # dotted filename (the old fully-qualified style) is rejected, and a file whose declared file-scoped namespace
    # does not match its module folder (or is missing/block-scoped) is rejected — the same invariant
    # Test-Formatting enforces, checked here at load; Format-Types repairs all of them. The source list is already
    # ordinally sorted.
    $arr = [object[]]@(foreach ($file in $hashResult.Files) {
            $moduleName = $file.Module
            $base = $file.Base
            if ($base.Contains('.')) {
                throw "C# type file 'types/$base.cs' in module '$moduleName' must be named for the bare type only (e.g. 'CliResult.cs'); the namespace is derived from the module. Remove the dotted prefix."
            }
            $content = [System.IO.File]::ReadAllText($file.Path)
            if ($content -match '(?m)^\s*namespace\s+(\S+?)\s*;\s*$') {
                if ($Matches[1] -ne $moduleName) {
                    throw "C# type file 'types/$base.cs' in module '$moduleName' declares namespace '$($Matches[1])' but must declare 'namespace $moduleName;' (its module folder). Run Format-Types."
                }
            }
            elseif ($content -match '(?m)^\s*namespace\s+(\S+?)\s*\{') {
                throw "C# type file 'types/$base.cs' in module '$moduleName' uses a block-scoped namespace '$($Matches[1])'; it must declare a file-scoped 'namespace $moduleName;'. Run Format-Types."
            }
            else {
                throw "C# type file 'types/$base.cs' in module '$moduleName' declares no namespace; it must declare 'namespace $moduleName;' (its module folder). Run Format-Types."
            }
            [pscustomobject]@{
                Module = $moduleName
                Base   = $base
                Type   = "$moduleName.$base"
                Key    = $file.Key
                File   = "$moduleName/types/$base.cs"
                Path   = $file.Path
            }
        })
    $snapshot = $hashResult.Snapshot
    $combinedHash = $hashResult.CombinedHash

    # A loaded assembly cannot be reloaded. Whether the types in this process are current for THIS ModulesRoot is
    # measured in one place, Get-LoadedTypeDrift (Catzc.Internal.Types), which the public
    # Test-LoadedTypesCurrent / Assert-LoadedTypesCurrent pair and the importer's restart read too. The session
    # record is keyed by ModulesRoot, so loading a different tree (e.g. a test-fixture root) records its own
    # hash/snapshot and never poisons the real tree's guard; a root with no record of its own is compared per file
    # against the root that loaded the types (cross-root). The message names which files drifted and both hashes or
    # roots, so the cause is diagnosable from the error text alone (a pure CRLF/LF flip never drifts — the digests
    # strip CR).
    if (-not (Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly -ErrorAction Ignore)) {
        $global:__CatzcTypes = @{}
    }
    $typeState = Get-LoadedTypeDrift -ModulesRoot $ModulesRoot -HashResult $hashResult
    $loaded = $typeState.Loaded
    $rootKey = $typeState.RootKey
    $stackGeneration = 0
    if (-not $typeState.Current) {
        $changeSummary = $typeState.Summary
        if ($typeState.Drift.Count) {
            $changeSummary += ' Drifted: ' + ($typeState.Drift -join '; ') + '.'
        }
        # A loaded assembly cannot be swapped in the AppDomain. In a pipeline a stale-types load is a HARD
        # failure (CI must never run on old types). Inside a VS Code terminal nothing throws: the import cannot
        # restart that host, so the session keeps the loaded assembly whatever drifted and one line names the
        # loaded hash and the source hash. On any other devbox, a type the AppDomain lacks (added, or not
        # loaded cross-root) is a hard failure — the code that uses it is certain to fail later, far from
        # here. A changed or removed type degrades gracefully — keep the already-loaded types this session,
        # warn (orange), and return WITHOUT recording the new hash, so the warning repeats on every re-import
        # until you restart. Every devbox session, a person's included, takes this path
        # ([ADR-BCL-TYPES-ONEDRIFTMEASURE](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-onedriftmeasure)): one
        # yellow line naming the changed types by simple name, and the import goes on.
        if (Test-IsRunningInPipeline) {
            throw "$changeSummary Restart PowerShell to pick up the change."
        }
        # A developer's console session in the source tree may load the new build beside the old one and re-point the
        # Catzc.*
        # accelerators, up to the policy's generations; past that cap, or in any other cell, the paths below hold.
        if (-not $PrebuiltOnly -and $typeState.LoadedHash) {
            $deferredRecords = Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly -ErrorAction Ignore
            $generation = if ($deferredRecords -and $deferredRecords.ContainsKey($rootKey) -and
                $deferredRecords[$rootKey].ContainsKey('Generation')) {
                $deferredRecords[$rootKey].Generation
            }
            else {
                1
            }
            $stackPolicy = Get-TypesLoadPolicy -HostKind $HostKind -RunMode source
            if ($stackPolicy.Generations -gt $generation) {
                $stackGeneration = $generation + 1
            }
        }
    }
    if ($stackGeneration) {
        $loaded = $false
    }
    elseif (-not $typeState.Current) {
        # A throw cannot restart VS Code's terminal or host, so the session keeps the loaded assembly, whatever drifted,
        # and names it.
        if (Test-IsRunningInVsCode) {
            $loadedDll = if ($typeState.LoadedHash) {
                $typeState.LoadedHash
            }
            else {
                'loaded for another root'
            }
            Write-ImporterMessage "Loaded inside VS Code with non-current types dll: $loadedDll (sources $($typeState.SourceHash); a new terminal loads them)" -ForegroundColor Yellow
            return
        }
        if ($typeState.MissingTypes.Count) {
            throw "$changeSummary Restart PowerShell to pick up the change."
        }
        $names = @($typeState.Drift | ForEach-Object { $_ -replace '^.*/', '' })
        $shown = ($names | Select-Object -First 5) -join ', '
        if ($names.Count -gt 5) {
            $shown += " and $($names.Count - 5) more"
        }
        Write-ImporterMessage "Using the old C# types, restart PowerShell to pick up the change: $shown" -ForegroundColor Yellow
        return
    }

    $sw = if ($DiagnoseLoadTime) {
        [Diagnostics.Stopwatch]::StartNew()
    }
    else {
        $null
    }
    # Git keeps only the manifest in .compiled; the DLL is a per-machine build in the shadow root
    # ([ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD](/docs/drs/automation/caching.md#rule-adr-auto-cache-compiledtypeprebuild)).
    # A bundle ships its DLL beside the manifest and never compiles.
    $compiledDir = [System.IO.Path]::Combine($ModulesRoot, '.compiled')
    $buildDir = if ($PrebuiltOnly) {
        $compiledDir
    }
    else {
        Get-TypesShadowRoot
    }
    $dll = [System.IO.Path]::Combine($buildDir, ('Catzc.Types.{0}.dll' -f $combinedHash))

    # Ensure the hash-keyed DLL exists on disk — compile it if missing (a fresh machine, a pruned cache, or a
    # source never built). -OutputAssembly writes the file WITHOUT loading, so this restores the build even
    # when the types are already in the AppDomain (idempotent, self-healing re-import).
    $didCompile = $false
    if (-not [System.IO.File]::Exists($dll)) {
        if ($PrebuiltOnly) {
            throw "Bundle is missing its prebuilt combined-types assembly ($dll). The bundle is incomplete or corrupt — rebuild it (Build-Modules ships the DLL); a bundle never compiles types."
        }
        # The ONE compile path (Build-CombinedTypeAssembly in Catzc.Internal.Types, shared with a build): it
        # compiles the sources, once validated, to a temp file and moves it into place, so a concurrent import
        # never sees a half-written DLL. It re-derives the hash from disk, so a source edited mid-import is a
        # throw, never a DLL whose name keys a set of sources other than the ones validated above.
        $built = Build-CombinedTypeAssembly -ModulesRoot $ModulesRoot -OutputDirectory $buildDir
        if ($built.Hash -ne $combinedHash) {
            throw "C# type sources changed during the import ($combinedHash -> $($built.Hash)). Re-run the importer."
        }
        $didCompile = $true

        # Announce the real build — always, not only under -DiagnoseLoadTime. .internal (bootstrap) code only
        # ever runs from the importer, so output goes through Write-ImporterMessage like the rest of bootstrap.
        Write-ImporterMessage "Built $dll"
    }

    # The manifest is generated beside its DLL, so a DLL that predates it gets one here; a bundle never writes.
    $manifest = [System.IO.Path]::ChangeExtension($dll, 'json')
    if (-not [System.IO.File]::Exists($manifest)) {
        if ($PrebuiltOnly) {
            throw "Bundle is missing its prebuilt types manifest ($manifest). The bundle is incomplete or corrupt — rebuild it (Build-Modules ships the manifest beside the DLL)."
        }
        Write-TypesAssemblyManifest -Path $dll | Out-Null
    }

    # The committed manifest is the shadow build's copy; one manifest, the current hash's, stays in .compiled.
    if (-not $PrebuiltOnly) {
        $committedManifest = [System.IO.Path]::Combine($compiledDir, [System.IO.Path]::GetFileName($manifest))
        if (-not [System.IO.File]::Exists($committedManifest)) {
            [System.IO.Directory]::CreateDirectory($compiledDir) | Out-Null
            [System.IO.File]::Copy($manifest, $committedManifest, $true)
            foreach ($old in [System.IO.Directory]::EnumerateFiles($compiledDir, 'Catzc.Types.*.json')) {
                if ($old -ne $committedManifest) {
                    [System.IO.File]::Delete($old)
                }
            }
        }
    }

    # Load the assembly if not already in the AppDomain (a reimport keeps the live copy). Verify EVERY type.
    # Loading a binary into the session is a state change, so it is announced
    # ([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)) on the
    # importer's verbose record
    # ([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](/docs/drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)), naming
    # the DLL; a reimport that keeps the live copy loads
    # nothing and says nothing. The load goes through a per-user shadow copy (Import-TypesAssembly), never the
    # .compiled file itself, so no session ever locks a build inside the repository; the message names the
    # committed DLL, the artifact a reader recognizes.
    $deferred = $false
    if (-not $loaded) {
        Test-TypesAssemblyContent -Path $dll -Expected $arr
        $policy = Get-TypesLoadPolicy -HostKind $HostKind -RunMode $(if ($PrebuiltOnly) {
                'build'
            }
            else {
                'source'
            })
        foreach ($eagerType in $policy.EagerTypes) {
            if ($eagerType -notin $arr.Type) {
                throw "The types-load config names eager type '$eagerType' for $($policy.Cell), but no module declares it."
            }
        }
        Register-DeferredTypes -RootKey $rootKey -Path $dll -ShadowCopy $policy.ShadowCopy -Generation $(if ($stackGeneration) {
                $stackGeneration
            }
            else {
                1
            })
        $relativeDll = ([System.IO.Path]::GetRelativePath($env:RepositoryRoot, $dll)) -replace '\\', '/'
        if ($stackGeneration) {
            foreach ($result in @(Initialize-Types)) {
                Write-ImporterMessage "Loaded changed types $relativeDll beside the earlier build (build $stackGeneration of $($stackPolicy.Generations)); Catzc.* accelerators now name the new types" -StateChange
            }
        }
        elseif ($policy.Load -eq 'eager' -or $policy.EagerTypes.Count -gt 0) {
            # Publish [PSTypeAlias("Name")] accelerators from the freshly loaded types, so `[Name]` resolves to the
            # decorated type (e.g. [Catzc.Module.Depm]::Puml). This is registration only — Add-Type above stays the
            # sole compiler; the editor-facing MSBuild pathway is Invoke-BuildForVsCode. The alias literal lives in
            # the decorated types/*.cs, so a workspace search for it lands on the source. Idempotent
            # (Remove-then-Add) so a re-import never throws on a duplicate key; the Catzc.-namespaced names mean this
            # only ever reclaims our own accelerator, never another module's.
            foreach ($result in @(Initialize-Types)) {
                Write-ImporterMessage "Loaded types $relativeDll" -StateChange
                if ($result.Displayed -gt 0) {
                    Write-ImporterMessage "Registered default display properties for $($result.Displayed) type(s)" -StateChange
                }
            }
        }
        else {
            $deferred = $true
            Write-ImporterMessage "Deferred types $relativeDll (loaded by the first use)" -StateChange
        }
    }

    $global:__CatzcTypes[$rootKey] = [pscustomobject]@{ Hash = $combinedHash; Snapshot = $snapshot }

    if ($DiagnoseLoadTime) {
        $ms = [int]$sw.Elapsed.TotalMilliseconds
        $label = if ($deferred) {
            'verified, load deferred'
        }
        elseif ($didCompile -and $loaded) {
            'recompiled DLL, already loaded'
        }
        elseif ($didCompile) {
            'compile+load'
        }
        elseif ($loaded) {
            'already loaded'
        }
        else {
            'cache load'
        }
        Write-ImporterMessage ('    {0,6}ms  types (combined, {1} files) ({2})' -f $ms, $arr.Count,
            $label) -ForegroundColor DarkGray
        if ($null -ne (Get-Variable -Name '__CatzcLoadTimings' -Scope Global -ValueOnly -ErrorAction Ignore)) {
            $global:__CatzcLoadTimings.Add([pscustomobject]@{ Stage = 'types (combined)'; Ms = $ms; ReadMs = 0; ImportMs = 0; FileCount = $arr.Count })
        }
    }
}
