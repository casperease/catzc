function Build-CombinedTypeAssembly {
    # .SYNOPSIS
    #     Compiles the selected modules' C# type sources into one hash-named assembly on disk, without loading it.
    # .DESCRIPTION
    #     Compiles a frozen copy of the sources, so a save mid-compile cannot make the DLL name differ from its bytes.
    # .PARAMETER ModulesRoot
    #     The modules folder whose non-dot module folders hold the types/*.cs sources.
    # .PARAMETER Module
    #     Restricts the compile (and its hash) to these module folders. Omitted, every module's types compile.
    # .PARAMETER OutputDirectory
    #     The directory the Catzc.Types.<hash>.dll is written to; created when missing.
    # .OUTPUTS
    #     [pscustomobject] with Hash (the 8-char combined hash), Path (the DLL), Manifest (the Catzc.Types.<hash>.json
    # beside
    #     it, written when missing), Files (the source list, in order,
    #     from Get-CombinedTypeHash), Snapshot (the per-file digests), and Compiled (whether this call ran the
    # compiler).
    #     $null when the selection ships no C# type source.
    # .EXAMPLE
    #     Build-CombinedTypeAssembly -ModulesRoot $root -Module 'Catzc.Base.Objects' -OutputDirectory "$build/.compiled"
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $ModulesRoot,

        [string[]] $Module,

        [Parameter(Mandatory)]
        [string] $OutputDirectory
    )

    $hashArguments = @{ ModulesRoot = $ModulesRoot }
    if ($PSBoundParameters.ContainsKey('Module')) {
        $hashArguments.Module = $Module
    }
    $hashResult = Get-CombinedTypeHash @hashArguments
    if ($hashResult.Files.Count -eq 0) {
        return $null
    }

    $dll = [System.IO.Path]::Combine($OutputDirectory, ('Catzc.Types.{0}.dll' -f $hashResult.CombinedHash))
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

    # Freeze the sources, then hash and compile the copy, so the DLL's name keys exactly the bytes compiled.
    $frozenRoot = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(),
        "catzc-types-$PID-$([guid]::NewGuid().ToString('N'))")
    try {
        foreach ($file in $hashResult.Files) {
            $frozenTypes = [System.IO.Path]::Combine($frozenRoot, $file.Module, 'types')
            [System.IO.Directory]::CreateDirectory($frozenTypes) | Out-Null
            try {
                [System.IO.File]::Copy($file.Path, [System.IO.Path]::Combine($frozenTypes, "$($file.Base).cs"))
            }
            catch [System.IO.FileNotFoundException], [System.IO.DirectoryNotFoundException] {
                throw "C# type source '$($file.Path)' was removed while the types were being built. Re-run the build."
            }
        }
        # The carrier's head form is an input of the hash too, so the frozen copy hashes the bodies the live root
        # hashes.
        $carriers = [System.IO.Path]::Combine('Catzc.Base.Languages', 'configs', 'file-carriers.yml')
        if ([System.IO.File]::Exists([System.IO.Path]::Combine($ModulesRoot, $carriers))) {
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::Combine($frozenRoot, 'Catzc.Base.Languages',
                    'configs')) | Out-Null
            [System.IO.File]::Copy([System.IO.Path]::Combine($ModulesRoot, $carriers),
                [System.IO.Path]::Combine($frozenRoot, $carriers))
        }
        $frozenArguments = @{ ModulesRoot = $frozenRoot }
        if ($PSBoundParameters.ContainsKey('Module')) {
            $frozenArguments.Module = $Module
        }
        $frozen = Get-CombinedTypeHash @frozenArguments
        $dll = [System.IO.Path]::Combine($OutputDirectory, ('Catzc.Types.{0}.dll' -f $frozen.CombinedHash))
        $compiled = $false
        if (-not [System.IO.File]::Exists($dll)) {
            [System.IO.Directory]::CreateDirectory($OutputDirectory) | Out-Null
            $tmp = "$dll.$PID.tmp"
            try {
                try {
                    Add-Type -Path @($frozen.Files.Path) -OutputAssembly $tmp -OutputType Library -ErrorAction Stop
                }
                catch {
                    # The compiler names the frozen copies; name the sources the reader edits instead.
                    $message = $_.Exception.Message
                    foreach ($file in $hashResult.Files) {
                        $message = $message.Replace([System.IO.Path]::Combine($frozenRoot, $file.Module, 'types',
                                "$($file.Base).cs"), $file.Path)
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

    [pscustomobject]@{
        Hash     = $frozen.CombinedHash
        Path     = $dll
        Manifest = Write-TypesAssemblyManifest -Path $dll
        Files    = $hashResult.Files
        Snapshot = $frozen.Snapshot
        Compiled = $compiled
    }
}
