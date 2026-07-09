<#
.SYNOPSIS
    Writes a bootstrap/importer console message, prefixed to match Write-Message's [Caller] style.
.DESCRIPTION
    The importer and its .internal bootstrap run before the module system (and Write-Message) are available,
    so they use Write-Host. This wrapper prepends '[Importer.ps1] ' so importer output reads consistently
    with the rest of the toolset's '[Caller] ...' messages. .internal code only ever runs from the importer.
.PARAMETER Message
    The message text.
.PARAMETER ForegroundColor
    Optional text color (e.g. DarkGray for diagnostics, Yellow for warnings).
#>
function Write-ImporterMessage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Importer/bootstrap output; runs before the module system (Write-Message) is available')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Message,

        [System.ConsoleColor] $ForegroundColor
    )

    $line = "[Importer.ps1] $Message"
    if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        Write-Host $line -ForegroundColor $ForegroundColor
    }
    else {
        Write-Host $line
    }
}

<#
.SYNOPSIS
    Deletes the compiled C# type assembly so the next import rebuilds it from source.
.DESCRIPTION
    Removes every <ModulesRoot>/.compiled/*.dll (the single combined types assembly). Run by the importer's
    -ClearCompiledTypes switch BEFORE modules load, so Import-CSharpTypes finds no cached DLL and compiles all
    modules' types fresh from source — "build from source", not "trust the committed/cached DLL".

    Distinct from Catzc.Base.TypesSystem's Clear-ModuleTypeCache: that is a post-import janitor that KEEPS the
    current build and skips in CI; this wipes every build (current included) pre-import and runs in any
    context. Best-effort: a DLL still locked (a loaded build on Windows, a concurrent process) is
    skipped — never stalls.
.PARAMETER ModulesRoot
    Path to the automation directory (the parent of .compiled/).
#>
function Clear-CompiledType {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulesRoot
    )

    $removed = 0
    $skipped = 0
    $compiledDir = [System.IO.Path]::Combine($ModulesRoot, '.compiled')
    if ([System.IO.Directory]::Exists($compiledDir)) {
        foreach ($dll in [System.IO.Directory]::EnumerateFiles($compiledDir, '*.dll')) {
            try {
                [System.IO.File]::Delete($dll); $removed++
            }
            catch {
                $skipped++; Write-Verbose "Could not delete (in use?): $dll"
            }
        }
    }

    Write-ImporterMessage "Cleared compiled type cache — building from source (removed $removed, skipped $skipped)"
}

function New-DynamicManifest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulePath,

        [switch]$ExportPrivates,

        # Read-only load (a bundle): never generate or write the manifest — it must already be present
        # (Build-Catzc pre-generates every module's manifest), so a read-only install store is never written to.
        [switch]$ReadOnly
    )

    $moduleName = Split-Path $ModulePath -Leaf
    $manifestPath = Join-Path $ModulePath "$moduleName.psd1"

    if ($ReadOnly) {
        if (-not [System.IO.File]::Exists($manifestPath)) {
            throw "Read-only load: module '$moduleName' is missing its generated manifest ($manifestPath). Rebuild the bundle — Build-Catzc pre-generates every module manifest."
        }
        return $manifestPath
    }

    $pathPrefixLength = $ModulePath.Length + 1

    # Collect public .ps1 files (root level) — .NET API avoids Get-ChildItem pipeline overhead
    $publicFiles = @(foreach ($f in [System.IO.Directory]::EnumerateFiles($ModulePath, '*.ps1')) {
            if (-not [System.IO.Path]::GetFileName($f).EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                $f
            }
        })

    # Collect private .ps1 files (private subfolder)
    $privatePath = Join-Path $ModulePath 'private'
    $privateFiles = @()
    if ([System.IO.Directory]::Exists($privatePath)) {
        foreach ($f in [System.IO.Directory]::GetFiles($privatePath, '*.ps1')) {
            $privateFiles += $f
        }
    }

    if ($publicFiles.Count -eq 0 -and $privateFiles.Count -eq 0) {
        Write-Verbose "No .ps1 files found in '$ModulePath'"
        return $null
    }

    # NestedModules runs each .ps1 in the module's shared session state. Private functions group first, then
    # public; each group is ordinal-sorted and its paths use forward slashes, so the emitted manifest is
    # byte-identical on every platform and every build of the same commit.
    $privateRelative = [string[]] @(foreach ($f in $privateFiles) {
            $f.Substring($pathPrefixLength).Replace('\', '/')
        })
    $publicRelative = [string[]] @(foreach ($f in $publicFiles) {
            $f.Substring($pathPrefixLength).Replace('\', '/')
        })
    [System.Array]::Sort($privateRelative, [System.StringComparer]::Ordinal)
    [System.Array]::Sort($publicRelative, [System.StringComparer]::Ordinal)
    $nestedModules = [string[]] @($privateRelative + $publicRelative)

    $exportNames = [string[]] @(foreach ($f in $publicFiles) {
            [System.IO.Path]::GetFileNameWithoutExtension($f)
        })
    [System.Array]::Sort($exportNames, [System.StringComparer]::Ordinal)

    # Canonical, formatter-stable text — no hand-padded alignment (ADR-REPO-FORMAT#1); the L2 suite gates the invariant.
    $content = Get-DynamicManifestContent -NestedModule $nestedModules -FunctionToExport $exportNames -ExportAll:$ExportPrivates

    # Write only on drift (the janitors' write-on-drift pattern): the manifest is a pure derivation of the
    # module's files, so an unchanged tree yields identical bytes and the write is skipped. Beyond saving ~40
    # writes per import, this is what lets Test-Automation's parallel workers dot-source the importer
    # concurrently — the parent's own import regenerated every manifest just before spawning, so the workers
    # all compare-equal and none writes, and there is no cross-process race on the .psd1 files.
    if ([System.IO.File]::Exists($manifestPath) -and [System.IO.File]::ReadAllText($manifestPath) -ceq $content) {
        return $manifestPath
    }
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($manifestPath, $content, $utf8NoBom)
    return $manifestPath
}

function Get-DynamicManifestContent {
    <#
    .SYNOPSIS
        Renders a module manifest hashtable as canonical .psd1 text.
    .DESCRIPTION
        The manifest is generated on every import, so it is canonical by construction: the '=' column is computed
        from the longest key rather than hand-padded (ADR-REPO-FORMAT#1), the text uses LF endings with a trailing newline,
        and it is formatter-stable — running Invoke-Formatter over it is a no-op (gated in the L2 suite). Callers
        pass ordinal-sorted, forward-slashed inputs, so the bytes are identical on every platform and every build
        of a commit.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string[]] $NestedModule = @(),

        [string[]] $FunctionToExport = @(),

        [switch] $ExportAll
    )

    if ($NestedModule.Count) {
        $quoted = foreach ($m in $NestedModule) {
            "'$m'"
        }
        $nested = '@(' + ($quoted -join ', ') + ')'
    }
    else {
        $nested = '@()'
    }

    if ($ExportAll) {
        $exports = "@('*')"
    }
    elseif ($FunctionToExport.Count) {
        $quotedExports = foreach ($fn in $FunctionToExport) {
            "'$fn'"
        }
        $exports = '@(' + ($quotedExports -join ', ') + ')'
    }
    else {
        $exports = '@()'
    }

    # Ordered fields with their value literals. The '=' column width is derived from the longest key, so a new
    # field re-aligns automatically and no alignment is maintained by hand (ADR-REPO-FORMAT#1).
    $fields = [ordered]@{
        RootModule        = "''"
        ModuleVersion     = "'0.1.0'"
        PowerShellVersion = "'7.4'"
        NestedModules     = $nested
        FunctionsToExport = $exports
        CmdletsToExport   = '@()'
        VariablesToExport = '@()'
        AliasesToExport   = "@('*')"
    }
    $width = 0
    foreach ($key in $fields.Keys) {
        if ($key.Length -gt $width) {
            $width = $key.Length
        }
    }

    $lines = foreach ($key in $fields.Keys) {
        '    {0} = {1}' -f $key.PadRight($width), $fields[$key]
    }
    "@{`n" + ($lines -join "`n") + "`n}`n"
}

<#
.SYNOPSIS
    Compiles and loads EVERY module's native C# types (types/*.cs) into ONE hash-keyed assembly.
.DESCRIPTION
    Autoloads all modules' types/ folders as a SINGLE assembly (automation/.compiled/Catzc.Types.<hash>.dll),
    so a type in one module can reference a type in another — a shared base class, a layered record graph.
    Each .cs file is named for the BARE type it must produce and declares the file-scoped namespace of its
    module ("namespace <module>;"), maintained by Format-Types and gated by Test-Types. The loader compiles the
    sources AS AUTHORED (Add-Type -Path, one compilation unit per file, so each file's file-scoped namespace is
    legal) and derives the expected type as <module>.<filename>: types/CliRunner.cs in module Catzc.Base.Execution
    -> type Catzc.Base.Execution.CliRunner. The loader requires each source's declared namespace to match its
    module folder (the same invariant Test-Types enforces) and identifies the type from the filename.

    Because everything is ONE assembly, there are NO cross-ASSEMBLY references — only cross-NAMESPACE
    references inside it, which the compiler and CLR resolve unconditionally. The combined assembly is a leaf
    in the assembly-reference graph (nothing references it by assembly identity; PowerShell resolves
    [Namespace.Type] by FQN), so the Roslyn-assigned random assembly name is irrelevant and Add-Type stays the
    compiler. The module dependency graph is NOT enforced by the compiler here — it is policed by
    Get-CSharpTypeDependency / Assert-ModuleDependency in the L2 suite.

    The assembly is committed as automation/.compiled/Catzc.Types.<combinedHash8>.dll (deterministic per the
    combined source hash, like .vendor) so a fresh checkout and CI load it without invoking Roslyn. The
    combined hash folds in each file's MODULE and bare type name (not just content), so moving a .cs between
    modules (new namespace) or renaming it (new type) re-keys the assembly even when the content is identical.
    States:

      1. A type already in the AppDomain (types survive module reimport) -> compare the combined source hash to
         what was recorded; a change throws (restart required), otherwise it is a no-op.
      2. Not loaded -> load the cached DLL if its hash matches, else compile all sources to the hash-named DLL
         (Roslyn, once per combined hash) and load it. Then verify EVERY expected type resolved, else throw.

    Runs once from Bootstrap (not a Catzc module) as a pre-pass before any module's functions import.
.PARAMETER ModulesRoot
    The automation directory. Its non-dot subfolders are the modules; the assembly is written to its .compiled/.
.PARAMETER DiagnoseLoadTime
    Emit a single combined compile/cache-load timing line (surfaced by importer.ps1 -DiagnoseLoadTime).
#>
function Import-CSharpTypes {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Session-global by design: $global:__CatzcTypes (per-ModulesRoot hash+snapshot) must survive module reimport to detect C# source changes across the session, and $global:__CatzcLoadTimings collects import diagnostics')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawPipelineDetection', '', Justification = 'Pipeline detection is inlined here because Test-IsRunningInPipeline lives in Catzc.Base.Repository, which loads after this C#-types pre-pass and so is not callable yet')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulesRoot,

        [switch]$DiagnoseLoadTime,

        # Prebuilt-only load (a bundle): load the shipped combined-types assembly, and throw if it is absent —
        # never invoke Roslyn and never write. A bundle ships the DLL, so a read-only install never compiles.
        [switch]$PrebuiltOnly
    )

    # The enumeration, deterministic ordering, per-file EOL-insensitive digest, combined hash, and per-file
    # snapshot all come from the ONE shared implementation (Get-CombinedTypeHash in the .internal shared module)
    # that the janitor (Clear-ModuleTypeCache) also calls — so the committed Catzc.Types.<hash>.dll key can never
    # drift between loader and janitor. The importer loads Catzc.Internal.Types before this pre-pass; the
    # Import-InternalModule call is a no-op guard that keeps this callable if the module was unloaded.
    Import-InternalModule Types
    $hashResult = Get-CombinedTypeHash $ModulesRoot
    if ($hashResult.Files.Count -eq 0) {
        return
    }

    # Validate each source and derive its FQN (<module>.<filename>). These two poka-yokes are the loader's job,
    # deliberately NOT in the shared enumerator (the janitor must never throw on a bad source): a dotted filename
    # (the old fully-qualified style) is rejected, and a file whose declared file-scoped namespace does not match
    # its module folder (or is missing/block-scoped) is rejected — the same invariant Test-Types enforces,
    # checked here at load; Format-Types repairs all of them. The source list is already ordinally sorted.
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
    $expected = @($arr.Type)
    $snapshot = $hashResult.Snapshot
    $combinedHash = $hashResult.CombinedHash

    $loaded = $false
    foreach ($t in $expected) {
        if (([System.Management.Automation.PSTypeName]$t).Type) {
            $loaded = $true; break
        }
    }

    # A loaded assembly cannot be reloaded. If any source changed since THIS ModulesRoot was last loaded, the
    # live copy is stale — fail fast. The session record is keyed by ModulesRoot, so loading a different tree
    # (e.g. a test-fixture root) records its own hash/snapshot and never poisons the real tree's guard — a
    # cross-root compare used to throw a bogus "types changed" on the next real import after the test suite ran.
    # The message names which files drifted (added/removed/changed) and both hashes, so the cause is diagnosable
    # from the error text alone (a pure CRLF/LF flip can no longer reach here either — see above).
    if (-not $global:__CatzcTypes) {
        $global:__CatzcTypes = @{}
    }
    $rootKey = [System.IO.Path]::GetFullPath($ModulesRoot)
    if ($loaded) {
        $prior = $global:__CatzcTypes[$rootKey]
        if ($prior -and $prior.Hash -ne $combinedHash) {
            $drift = [System.Collections.Generic.List[string]]::new()
            foreach ($key in $snapshot.Keys) {
                if (-not $prior.Snapshot.Contains($key)) {
                    $drift.Add("added $key")
                }
                elseif ($prior.Snapshot[$key] -ne $snapshot[$key]) {
                    $drift.Add("changed $key")
                }
            }
            foreach ($key in $prior.Snapshot.Keys) {
                if (-not $snapshot.Contains($key)) {
                    $drift.Add("removed $key")
                }
            }
            $detail = if ($drift.Count) {
                ' Drifted: ' + ($drift -join '; ') + '.'
            }
            else {
                ''
            }
            # A loaded assembly cannot be swapped in the AppDomain. In a pipeline a stale-types load is a HARD
            # failure (CI must never run on old types); on a devbox, degrade gracefully — keep the already-loaded
            # types this session, warn (orange), and return WITHOUT recording the new hash, so the warning repeats
            # on every re-import until you restart. The pipeline check is INLINED because Test-IsRunningInPipeline
            # lives in Catzc.Base.Repository, which loads AFTER this pre-pass runs and so is not callable here.
            $changeSummary = "C# types changed since they were loaded ($($prior.Hash) -> $combinedHash).$detail"
            if (([bool]$env:TF_BUILD) -or ([bool]$env:GITHUB_ACTIONS)) {
                throw "$changeSummary Restart PowerShell to pick up the change."
            }
            Write-ImporterMessage "Using old cached C# types — $changeSummary Restart PowerShell to pick up the change." -ForegroundColor DarkYellow
            return
        }
    }

    $sw = if ($DiagnoseLoadTime) {
        [Diagnostics.Stopwatch]::StartNew()
    }
    else {
        $null
    }
    $compiledDir = [System.IO.Path]::Combine($ModulesRoot, '.compiled')
    $dll = [System.IO.Path]::Combine($compiledDir, ('Catzc.Types.{0}.dll' -f $combinedHash))

    # Ensure the committed, hash-keyed DLL exists on disk — recompile if missing (deleted, git-cleaned, or a
    # never-built source). -OutputAssembly writes the file WITHOUT loading, so this restores the artifact even
    # when the types are already in the AppDomain (idempotent, self-healing re-import).
    $didCompile = $false
    if (-not [System.IO.File]::Exists($dll)) {
        if ($PrebuiltOnly) {
            throw "Bundle is missing its prebuilt combined-types assembly ($dll). The bundle is incomplete or corrupt — rebuild it (Build-Catzc ships the DLL); a bundle never compiles types."
        }
        if (-not [System.IO.Directory]::Exists($compiledDir)) {
            New-Item -ItemType Directory -Path $compiledDir -Force | Out-Null
        }
        # Compile all sources to a temp file, then move into place so a concurrent import never sees a
        # half-written DLL (same hash => same source => harmless lost race; just discard our temp). Each .cs is
        # a SEPARATE compilation unit (Add-Type -Path), so each file's file-scoped namespace is legal and all
        # the types still land in one assembly — file-scoped namespaces cannot be concatenated into one unit.
        $tmp = "$dll.$PID.tmp"
        Add-Type -Path @($arr.Path) -OutputAssembly $tmp -OutputType Library
        try {
            [System.IO.File]::Move($tmp, $dll)
        }
        catch {
            if (Test-Path $tmp) {
                [System.IO.File]::Delete($tmp)
            }
        }
        $didCompile = $true

        # Prune superseded-hash builds — the .compiled dir's old Catzc.Types.*.dll. Best-effort: a DLL still
        # locked (the live build on Windows, or a concurrent process) is skipped, never fails the import.
        foreach ($old in [System.IO.Directory]::EnumerateFiles($compiledDir, 'Catzc.Types.*.dll')) {
            if ($old -eq $dll) {
                continue
            }
            try {
                [System.IO.File]::Delete($old)
            }
            catch {
                Write-Verbose "Skipped locked stale type DLL: $old"
            }
        }

        # Announce the real build (a freshly created, committable artifact) — always, not only under
        # -DiagnoseLoadTime. .internal (bootstrap) code only ever runs from the importer, so output goes
        # through Write-ImporterMessage like the rest of bootstrap (Write-Message may not be loaded yet).
        $relativeDll = ([System.IO.Path]::GetRelativePath($env:RepositoryRoot, $dll)) -replace '\\', '/'
        Write-ImporterMessage "Built $relativeDll"
    }

    # Load the assembly if not already in the AppDomain (a reimport keeps the live copy). Verify EVERY type.
    if (-not $loaded) {
        Add-Type -Path $dll
        foreach ($tf in $arr) {
            if (-not ([System.Management.Automation.PSTypeName]$tf.Type).Type) {
                throw "Compiled C# types but '$($tf.Type)' was not produced. $($tf.File) must declare a public class named '$([System.IO.Path]::GetFileNameWithoutExtension($tf.Path))' (the module namespace '$($tf.Module)' is added automatically)."
            }
        }

        # Publish [PSTypeAlias("Name")] accelerators from the freshly loaded types, so `[Name]` resolves to the
        # decorated type (e.g. [Catzc.Module.Depm]::Puml). This is registration only — Add-Type above stays the
        # sole compiler; the editor-facing MSBuild pathway is Invoke-BuildForVSCode. The alias literal lives in
        # the decorated types/*.cs, so a workspace search for it lands on the source. Idempotent
        # (Remove-then-Add) so a re-import never throws on a duplicate key; the Catzc.-namespaced names mean this
        # only ever reclaims our own accelerator, never another module's.
        $aliasAttrType = ([System.Management.Automation.PSTypeName]'Catzc.Base.Objects.PSTypeAliasAttribute').Type
        if ($aliasAttrType) {
            $accelerators = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
            foreach ($tf in $arr) {
                $type = ([System.Management.Automation.PSTypeName]$tf.Type).Type
                foreach ($alias in $type.GetCustomAttributes($aliasAttrType, $false)) {
                    [void] $accelerators::Remove($alias.Name)
                    $accelerators::Add($alias.Name, $type)
                }
            }
        }
    }

    $global:__CatzcTypes[$rootKey] = [pscustomobject]@{ Hash = $combinedHash; Snapshot = $snapshot }

    if ($DiagnoseLoadTime) {
        $ms = [int]$sw.Elapsed.TotalMilliseconds
        $label = if ($didCompile -and $loaded) {
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
        Write-ImporterMessage ('    {0,6}ms  types (combined, {1} files) ({2})' -f $ms, $arr.Count, $label) -ForegroundColor DarkGray
        if ($null -ne $global:__CatzcLoadTimings) {
            $global:__CatzcLoadTimings.Add([pscustomobject]@{ Stage = 'types (combined)'; Ms = $ms; ReadMs = 0; ImportMs = 0; FileCount = $arr.Count })
        }
    }
}

<#
.SYNOPSIS
    Fails the import when an exported function name collides — across automation modules, or with a shipped
    (vendored/built-in) command that is already imported.
.DESCRIPTION
    PowerShell does NOT error on a command-name clash — the command imported last silently shadows the rest.
    This pre-pass turns that silent collision into a fast, loud failure before any module (or C# type) loads.
    It catches two cases and collects all of them into one error:

    1. Two automation modules exporting the same name — a caller of Get-Foo would get whichever module sorted
       last.
    2. An automation function whose name would shadow an already-imported shipped command. Vendored modules and
       built-ins load before our modules, so a clash means our -Scope Global import silently overrides them.
       The check is scoped to shipped commands by module path (under .vendor/ or $PSHOME), so a user's
       unrelated session module never blocks the import and our own modules are naturally excluded.

    The checked set mirrors New-DynamicManifest's exports: module-root *.ps1 are always exported; private/*.ps1
    join the set only under -ExportPrivates (which exports '*'). Without the flag, two modules each owning a
    private of the same name is legal (privates are module-scoped, not exported) and is not a collision.
.PARAMETER ModuleDirs
    The discovered module directories (dot-prefixed infrastructure already excluded).
.PARAMETER ExportPrivates
    When set, private/ functions are exported too, so they join the uniqueness check.
#>
function Assert-UniqueModuleFunctionName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.IO.DirectoryInfo[]]$ModuleDirs,

        [switch]$ExportPrivates
    )

    # function name -> list of '<Module>/<relative path>' files that export it
    $sources = @{}

    foreach ($dir in $ModuleDirs) {
        $files = [System.Collections.Generic.List[string]]::new()
        foreach ($f in [System.IO.Directory]::EnumerateFiles($dir.FullName, '*.ps1')) {
            if (-not [System.IO.Path]::GetFileName($f).EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                $files.Add($f)
            }
        }
        if ($ExportPrivates) {
            $privatePath = [System.IO.Path]::Combine($dir.FullName, 'private')
            if ([System.IO.Directory]::Exists($privatePath)) {
                foreach ($f in [System.IO.Directory]::EnumerateFiles($privatePath, '*.ps1')) {
                    if (-not [System.IO.Path]::GetFileName($f).EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                        $files.Add($f)
                    }
                }
            }
        }

        foreach ($f in $files) {
            $name = [System.IO.Path]::GetFileNameWithoutExtension($f)
            $relative = $f.Substring($dir.FullName.Length + 1) -replace '\\', '/'
            if (-not $sources.ContainsKey($name)) {
                $sources[$name] = [System.Collections.Generic.List[string]]::new()
            }
            $sources[$name].Add("$($dir.Name)/$relative")
        }
    }

    $violations = [System.Collections.Generic.List[string]]::new()

    # 1) Two automation modules exporting the same name — the module imported last silently shadows the others.
    foreach ($entry in $sources.GetEnumerator()) {
        if ($entry.Value.Count -gt 1) {
            $violations.Add("  $($entry.Key): defined by $($entry.Value -join ', ')")
        }
    }

    # 2) An automation function shadowing an already-imported SHIPPED command (vendored module or built-in).
    #    Vendor modules and built-ins import before our modules, so a name clash means our -Scope Global import
    #    would silently shadow them. Scope the check to shipped commands by module path — under .vendor/ or
    #    $PSHOME — so a user's unrelated session module never blocks the import, and our own modules (current
    #    or stale on a devbox re-import) are naturally excluded (their base is neither).
    $shipped = @{}
    foreach ($m in Get-Module) {
        $base = $m.ModuleBase
        # Shipped = a command that loads BEFORE our automation modules and would be silently shadowed by our
        # -Scope Global import: built-ins ($PSHOME), vendored third-party (.vendor), and the .internal shared
        # modules (loaded by the importer before this check). The .internal modules sit directly in the folder,
        # so their ModuleBase ENDS at .internal (no trailing separator) — match that too.
        $isShipped = ($base -like "$PSHOME*") -or ($base -match '[\\/]\.vendor[\\/]') -or ($base -match '[\\/]\.internal([\\/]|$)')
        if (-not $isShipped) {
            continue
        }
        foreach ($cmdName in $m.ExportedCommands.Keys) {
            if (-not $shipped.ContainsKey($cmdName)) {
                $shipped[$cmdName] = $m.Name
            }
        }
    }
    foreach ($entry in $sources.GetEnumerator()) {
        if ($shipped.ContainsKey($entry.Key)) {
            $where = $entry.Value -join ', '
            $violations.Add("  $($entry.Key): $where would shadow imported command from '$($shipped[$entry.Key])'")
        }
    }

    if ($violations.Count) {
        $sorted = $violations | Sort-Object
        $lines = @(
            'Function name collision(s) detected before import. Each automation function name must be unique'
            'across modules AND must not shadow an already-imported (vendored/built-in) command:'
        ) + $sorted
        throw ($lines -join "`n")
    }
}

<#
.SYNOPSIS
    Imports all module directories under a given root path.
.PARAMETER ModulesRoot
    Path to the directory containing module folders.
#>
function Import-AllModules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__CatzcLoadTimings is session-global import diagnostics collected across all modules, surfaced by importer.ps1 -DiagnoseLoadTime')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulesRoot,

        [switch]$ExportPrivates,

        # Emit a per-module load-time breakdown: manifest generation, a raw-read probe (cold file I/O), and
        # Import-Module (parse). Surfaced by importer.ps1 -DiagnoseLoadTime so an author can see WHICH
        # module(s) are slow and whether the cost is file I/O (raw-read column) or parse (import column);
        # manifest enumeration is native .NET and consistently ~1-7ms. Off = no overhead.
        [switch]$DiagnoseLoadTime,

        # Read-only bundle load: manifests must be pre-generated (never written), and the combined-types DLL
        # must be shipped (never compiled). Passed by Invoke-Importer -Bundle; off for the mono repo.
        [switch]$Bundle
    )

    $moduleDirs = Get-ChildItem -Path $ModulesRoot -Directory |
        Where-Object { $_.Name -notmatch '^\.' }

    # Fail fast on duplicate exported function names BEFORE any module or C# type loads — a collision would
    # otherwise be silent (the module imported last shadows the others).
    Assert-UniqueModuleFunctionName -ModuleDirs $moduleDirs -ExportPrivates:$ExportPrivates

    $sw = if ($DiagnoseLoadTime) {
        [Diagnostics.Stopwatch]::StartNew()
    }
    else {
        $null
    }

    # Remove previously loaded automation modules (handles deleted/renamed modules). Exclude Bootstrap, the
    # vendored third-party modules (.vendor), and the .internal shared modules — the last are loaded by the
    # importer before this runs and must SURVIVE into the session (Import-CSharpTypes and post-import cover
    # functions call them); they live under the automation root, so without this they match the stale sweep.
    Get-Module |
        Where-Object {
            $_.Path -like "$ModulesRoot*" -and $_.Name -ne 'Bootstrap' -and
            $_.Path -notlike '*/.vendor/*' -and $_.Path -notlike '*\.vendor\*' -and
            $_.Path -notlike '*/.internal/*' -and $_.Path -notlike '*\.internal\*'
        } |
        ForEach-Object {
            Write-Verbose "Removing stale module: $($_.Name)"
            Remove-Module $_.Name -Force -ErrorAction SilentlyContinue
        }
    if ($DiagnoseLoadTime) {
        Write-ImporterMessage ('    {0,6}ms  (remove stale modules)' -f [int]$sw.Elapsed.TotalMilliseconds) -ForegroundColor DarkGray
    }

    # Native C# types (every module's types/*.cs) compile/load ONCE, before any module's functions, into a
    # single combined assembly — so a function (or a module's load-time code) can reference any type, and a
    # type in one module can reference a type in another. Module import order below is therefore irrelevant.
    Import-CSharpTypes -ModulesRoot $ModulesRoot -DiagnoseLoadTime:$DiagnoseLoadTime -PrebuiltOnly:$Bundle

    foreach ($dir in $moduleDirs) {
        if ($DiagnoseLoadTime) {
            $sw.Restart()
        }
        $manifestPath = New-DynamicManifest -ModulePath $dir.FullName -ExportPrivates:$ExportPrivates -ReadOnly:$Bundle
        $manifestMs = if ($DiagnoseLoadTime) {
            [int]$sw.Elapsed.TotalMilliseconds
        }
        else {
            0
        }

        if ($manifestPath) {
            Write-Verbose "Importing module: $($dir.Name)"

            # Diagnostic probe: read every .ps1 this module imports, raw, BEFORE Import-Module. This pays
            # the cold per-file *open* cost — the part an antivirus real-time scan or a network share
            # intercepts — so the Import-Module that follows reads from warm OS cache and its time is ≈ pure
            # parse/compile. Splitting them is the point: raw-read = I/O cost, import = parse cost. Only the
            # set Import-Module will load (root + private .ps1, no tests), so the warming is representative.
            $readMs = 0
            $fileCount = 0
            if ($DiagnoseLoadTime) {
                $sw.Restart()
                foreach ($pf in [System.IO.Directory]::EnumerateFiles($dir.FullName, '*.ps1')) {
                    if (-not $pf.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                        [void][System.IO.File]::ReadAllText($pf)
                        $fileCount++
                    }
                }
                $privateDir = [System.IO.Path]::Combine($dir.FullName, 'private')
                if ([System.IO.Directory]::Exists($privateDir)) {
                    foreach ($pf in [System.IO.Directory]::GetFiles($privateDir, '*.ps1')) {
                        [void][System.IO.File]::ReadAllText($pf)
                        $fileCount++
                    }
                }
                $readMs = [int]$sw.Elapsed.TotalMilliseconds
            }

            if ($DiagnoseLoadTime) {
                $sw.Restart()
            }
            Import-Module $manifestPath -Scope Global -Force
            if ($DiagnoseLoadTime) {
                $importMs = [int]$sw.Elapsed.TotalMilliseconds
                $total = $manifestMs + $readMs + $importMs
                Write-ImporterMessage ('    {0,6}ms  {1} (manifest {2}ms + raw-read {3}ms + import {4}ms)' -f $total, $dir.Name, $manifestMs, $readMs, $importMs) -ForegroundColor DarkGray
                if ($null -ne $global:__CatzcLoadTimings) {
                    $global:__CatzcLoadTimings.Add([pscustomobject]@{ Stage = $dir.Name; Ms = $total; ReadMs = $readMs; ImportMs = $importMs; FileCount = $fileCount })
                }
            }
        }
        else {
            # Clean up stale .psd1 if module dir became empty
            $stalePsd1 = Join-Path $dir.FullName "$($dir.Name).psd1"
            if ([System.IO.File]::Exists($stalePsd1)) {
                [System.IO.File]::Delete($stalePsd1)
            }
        }
    }
}

Export-ModuleMember -Function 'Import-AllModules', 'Write-ImporterMessage', 'Clear-CompiledType'
