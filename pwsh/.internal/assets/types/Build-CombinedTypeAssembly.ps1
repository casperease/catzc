function Build-CombinedTypeAssembly {
    # .SYNOPSIS
    #     Compiles C# type sources into one hash-named assembly on disk, without loading it.
    # .DESCRIPTION
    #     Compiles a frozen copy of the sources, so a save mid-compile cannot make the DLL name differ from its bytes.
    #     The sources are the selected modules' types/*.cs under a modules root, or an explicit -Source list. The DLL is named
    #     <Namespace>.Types.<hash>.dll; a source declaring a Catzc. C# namespace is refused for any other namespace.
    # .PARAMETER ModulesRoot
    #     The modules folder whose non-dot module folders hold the types/*.cs sources.
    # .PARAMETER Module
    #     Restricts the compile (and its hash) to these module folders. Omitted, every module's types compile.
    # .PARAMETER Source
    #     The .cs files to compile, in place of a modules root. File names must differ.
    # .PARAMETER OutputDirectory
    #     The directory the <Namespace>.Types.<hash>.dll is written to; created when missing.
    # .PARAMETER Namespace
    #     The namespace the assembly is named for; defaults to Catzc.
    # .PARAMETER Reference
    #     Assemblies (paths) the compile references beyond the defaults.
    # .OUTPUTS
    #     [pscustomobject] with Hash (the 8-char combined hash), Path (the DLL), Manifest (the <Namespace>.Types.<hash>.json
    # beside
    #     it, written when missing), Files (the source list, in order,
    #     from Get-CombinedTypeHash), Snapshot (the per-file digests), and Compiled (whether this call ran the
    # compiler).
    #     $null when the selection ships no C# type source.
    # .EXAMPLE
    #     Build-CombinedTypeAssembly -ModulesRoot $root -Module 'Catzc.Base.Objects' -OutputDirectory "$build/.compiled"
    [CmdletBinding(DefaultParameterSetName = 'Modules')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Modules')]
        [string] $ModulesRoot,

        [Parameter(ParameterSetName = 'Modules')]
        [string[]] $Module,

        [Parameter(Mandatory, ParameterSetName = 'Source')]
        [AllowEmptyCollection()]
        [string[]] $Source,

        [Parameter(Mandatory)]
        [string] $OutputDirectory,

        [ValidateNotNullOrEmpty()]
        [string] $Namespace = 'Catzc',

        [string[]] $Reference
    )

    $prefix = Get-TypesAssemblyPrefix -Namespace $Namespace
    $fromSources = $PSCmdlet.ParameterSetName -eq 'Source'

    $hashResult = $null
    if (-not $fromSources) {
        $hashArguments = @{ ModulesRoot = $ModulesRoot }
        if ($PSBoundParameters.ContainsKey('Module')) {
            $hashArguments.Module = $Module
        }
        $hashResult = Get-CombinedTypeHash @hashArguments
        if ($hashResult.Files.Count -eq 0) {
            return $null
        }

        $dll = [System.IO.Path]::Combine($OutputDirectory, ('{0}{1}.dll' -f $prefix, $hashResult.CombinedHash))
        if ([System.IO.File]::Exists($dll)) {
            return [pscustomobject]@{
                Hash     = $hashResult.CombinedHash
                Path     = $dll
                Manifest = Write-TypesAssemblyManifest -Path $dll
                Files    = $hashResult.Files
                Snapshot = $hashResult.Snapshot
                Compiled = $false
            }
        }
    }
    elseif ($Source.Count -eq 0) {
        return $null
    }

    # Freeze the sources, then hash and compile the copy, so the DLL's name keys exactly the bytes compiled.
    $frozenRoot = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(),
        "catzc-types-$PID-$([guid]::NewGuid().ToString('N'))")
    try {
        # Each frozen copy with the source the reader edits, to name that source in a compiler error.
        $origins = [System.Collections.Generic.List[object]]::new()
        $sourceFiles = $fromSources ? @() : @($hashResult.Files)
        if ($fromSources) {
            $sourceFiles = foreach ($path in $Source) {
                [pscustomobject]@{ Module = 'source'; Base = [System.IO.Path]::GetFileNameWithoutExtension($path); Path = $path }
            }
            $duplicates = @($sourceFiles | Group-Object -Property Base | Where-Object Count -gt 1)
            if ($duplicates.Count -gt 0) {
                throw "C# type sources must have distinct file names; '$($duplicates[0].Name)' is listed more than once."
            }
        }
        foreach ($file in $sourceFiles) {
            $frozenTypes = [System.IO.Path]::Combine($frozenRoot, $file.Module, 'types')
            [System.IO.Directory]::CreateDirectory($frozenTypes) | Out-Null
            $frozenPath = [System.IO.Path]::Combine($frozenTypes, "$($file.Base).cs")
            try {
                [System.IO.File]::Copy($file.Path, $frozenPath)
            }
            catch [System.IO.FileNotFoundException], [System.IO.DirectoryNotFoundException] {
                throw "C# type source '$($file.Path)' was removed while the types were being built. Re-run the build."
            }
            $origins.Add([pscustomobject]@{ Frozen = $frozenPath; Original = $file.Path })
        }
        # The carrier's head form is an input of the hash too, so the frozen copy hashes the bodies the live root
        # hashes.
        $moduleNamespace = $fromSources ? '' : (Get-ModuleNamespace -ModulesRoot $ModulesRoot)
        if (-not $fromSources) {
            $languagesFolder = Resolve-ModuleName -FullName 'Catzc.Base.Languages' -Namespace $moduleNamespace
            $carriers = [System.IO.Path]::Combine($languagesFolder, 'configs', 'file-carriers.yml')
            if ([System.IO.File]::Exists([System.IO.Path]::Combine($ModulesRoot, $carriers))) {
                [System.IO.Directory]::CreateDirectory([System.IO.Path]::Combine($frozenRoot, $languagesFolder, 'configs')) | Out-Null
                [System.IO.File]::Copy([System.IO.Path]::Combine($ModulesRoot, $carriers),
                    [System.IO.Path]::Combine($frozenRoot, $carriers))
            }
        }
        # The frozen copy's folder names no track, so it hashes under the live root's namespace.
        $frozenArguments = @{ ModulesRoot = $frozenRoot; ModuleNamespace = $moduleNamespace }
        if ($PSBoundParameters.ContainsKey('Module')) {
            $frozenArguments.Module = $Module
        }
        $frozen = Get-CombinedTypeHash @frozenArguments

        # Only the catzc build may declare Catzc.* types.
        if ($Namespace -cne 'Catzc') {
            foreach ($file in $frozen.Files) {
                if ([System.IO.File]::ReadAllText($file.Path) -match '(?m)^\s*namespace\s+Catzc\.') {
                    $original = ($origins | Where-Object Frozen -eq $file.Path).Original
                    throw "C# type source '$original' declares a Catzc. namespace, which only the Catzc build may; this build is '$Namespace'."
                }
            }
        }

        $dll = [System.IO.Path]::Combine($OutputDirectory, ('{0}{1}.dll' -f $prefix, $frozen.CombinedHash))
        $compiled = $false
        if (-not [System.IO.File]::Exists($dll)) {
            [System.IO.Directory]::CreateDirectory($OutputDirectory) | Out-Null
            $tmp = "$dll.$PID.tmp"
            try {
                try {
                    if ($Reference) {
                        Add-Type -Path @($frozen.Files.Path) -OutputAssembly $tmp -OutputType Library -ReferencedAssemblies $Reference -ErrorAction Stop
                    }
                    else {
                        Add-Type -Path @($frozen.Files.Path) -OutputAssembly $tmp -OutputType Library -ErrorAction Stop
                    }
                }
                catch {
                    # The compiler names the frozen copies; name the sources the reader edits instead.
                    $message = $_.Exception.Message
                    foreach ($origin in $origins) {
                        $message = $message.Replace($origin.Frozen, $origin.Original)
                    }
                    throw $message
                }
                try {
                    [System.IO.File]::Move($tmp, $dll)
                }
                catch {
                    if (-not [System.IO.File]::Exists($dll)) {
                        throw
                    }
                }
            }
            finally {
                if ([System.IO.File]::Exists($tmp)) {
                    [System.IO.File]::Delete($tmp)
                }
            }
            $compiled = $true
        }
    }
    finally {
        if ([System.IO.Directory]::Exists($frozenRoot)) {
            [System.IO.Directory]::Delete($frozenRoot, $true)
        }
    }

    $files = $fromSources ? @($frozen.Files | ForEach-Object {
            $frozenPath = $_.Path
            [pscustomobject]@{ Module = $_.Module; Base = $_.Base; Key = $_.Key; Path = ($origins | Where-Object Frozen -eq $frozenPath).Original }
        }) : $hashResult.Files

    [pscustomobject]@{
        Hash     = $frozen.CombinedHash
        Path     = $dll
        Manifest = Write-TypesAssemblyManifest -Path $dll
        Files    = $files
        Snapshot = $frozen.Snapshot
        Compiled = $compiled
    }
}
