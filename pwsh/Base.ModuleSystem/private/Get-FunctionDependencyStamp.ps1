function Get-FunctionDependencyStamp {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [Parameter(Mandatory)]
        [string] $ModulesRoot
    )

    # One line per script: its path below the modules root and the hash of its bytes, in the order the graph reads them.
    $lines = foreach ($path in $File) {
        $relative = [System.IO.Path]::GetRelativePath($ModulesRoot, $path) -replace '\\', '/'
        $hash = [Catzc.Base.Globs.DurableHash]::HashFile($path)
        "$relative|$hash"
    }
    [Catzc.Base.Globs.DurableHash]::HashFold(($lines -join "`n"))
}
