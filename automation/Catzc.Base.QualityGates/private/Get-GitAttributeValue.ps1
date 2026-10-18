<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-GitAttributeValue.ps1
    folder: private
    name: get-git-attribute-value
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-GitAttributeValue.Tests.ps1
---
#>

function Get-GitAttributeValue {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [string[]] $Attribute
    )

    $ret = @{}
    # Outside a git work tree (a test's scratch root) no .gitattributes applies, so nothing is specified.
    if (-not (Test-Path -LiteralPath (Join-Path $RepositoryRoot '.git'))) {
        return $ret
    }
    if ($Path.Count -eq 0) {
        return $ret
    }
    # One git process reads every path from stdin, NUL-separated both ways: a process per batch costs about 25 ms each, and no path is quoted or split.
    $listing = Invoke-Executable "git -C `"$RepositoryRoot`" -c core.quotepath=off check-attr -z --stdin $($Attribute -join ' ')" -InputText (($Path -join "`0") + "`0") -PassThru -Silent
    $fields = $listing.Output -split "`0"
    for ($position = 0; $position + 2 -lt $fields.Count; $position += 3) {
        $itemPath = $fields[$position]
        $value = $fields[$position + 2]
        if ($value -ne 'unspecified') {
            if (-not $ret.ContainsKey($itemPath)) {
                $ret[$itemPath] = @{}
            }
            $ret[$itemPath][$fields[$position + 1]] = $value
        }
    }
    $ret
}
