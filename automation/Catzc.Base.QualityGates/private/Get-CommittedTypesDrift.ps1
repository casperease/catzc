<#
.SYNOPSIS
    Reports why the committed combined types assembly is not the current one.
.DESCRIPTION
    The build ships the committed automation/.compiled/Catzc.Types.<hash>.dll by copy, so that file must be the
    assembly of the current type sources: exactly one Catzc.Types.*.dll, named for the combined hash of the
    sources (Get-CombinedTypeHash, the one implementation the loader and the janitor share), and no pending git
    change under automation/.compiled — the importer rebuilds the DLL when a types/*.cs changes, and a rebuild
    that was not committed shows there. Each failure is one reason; none means the committed assembly is current.
.PARAMETER RepositoryRoot
    The repository whose automation/.compiled is checked.
.OUTPUTS
    [string[]] One reason per drift found; nothing when the committed assembly is current.
.EXAMPLE
    Get-CommittedTypesDrift -RepositoryRoot (Get-RepositoryRoot)
#>
function Get-CommittedTypesDrift {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    Import-InternalModule Types
    $currentHash = (Get-CombinedTypeHash (Join-Path $RepositoryRoot 'automation')).CombinedHash

    $compiledRoot = Join-Path $RepositoryRoot 'automation/.compiled'
    # @() around the whole if: a single match must stay an array (.Count under strict mode).
    $dlls = @(if ([System.IO.Directory]::Exists($compiledRoot)) {
            foreach ($dll in [System.IO.Directory]::EnumerateFiles($compiledRoot, 'Catzc.Types.*.dll')) {
                [System.IO.Path]::GetFileName($dll)
            }
        })

    $reasons = [System.Collections.Generic.List[string]]::new()
    $expected = "Catzc.Types.$currentHash.dll"
    if ($dlls.Count -ne 1) {
        $reasons.Add("automation/.compiled holds $($dlls.Count) Catzc.Types.*.dll ($($dlls -join ', ')); expected exactly $expected — run the importer")
    }
    elseif ($dlls[0] -ne $expected) {
        $reasons.Add("automation/.compiled/$($dlls[0]) is not the current assembly $expected — run the importer")
    }
    if (Test-GitPathChanged 'automation/.compiled') {
        $reasons.Add('automation/.compiled has pending git changes — commit the rebuilt Catzc.Types.<hash>.dll')
    }

    [string[]] $reasons.ToArray()
}
