function Select-GreedyFileOrder {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [System.Collections.IDictionary] $DurationMs = @{},

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.TestPolicyConfig] $Policy
    )

    $ranked = foreach ($path in $File) {
        $relative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $path) -replace '\\', '/'
        [pscustomobject]@{
            File   = $path
            # The apart files run one at a time, so their chain is the pool's critical path and starts with the run.
            Apart  = $Policy.IsApart($path)
            # An unmeasured file goes before every measured one: sorted last it never starts in a run that overruns, so it is never measured.
            Weight = if ($DurationMs.Contains($relative)) {
                [double] $DurationMs[$relative]
            }
            else {
                [double]::MaxValue
            }
        }
    }
    [string[]] @($ranked | Sort-Object -Property @{ Expression = 'Apart'; Descending = $true }, @{ Expression = 'Weight'; Descending = $true }, @{ Expression = 'File' } |
            ForEach-Object File)
}
