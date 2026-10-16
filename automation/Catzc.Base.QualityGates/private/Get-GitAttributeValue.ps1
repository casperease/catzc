<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-GitAttributeValue.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-GitAttributeValue.Tests.ps1
  config:
    synopsis: Reads the given .gitattributes attributes for many repository paths at once.
    description: |-
      The one place the scopes of the quality gates ask git which file classes .gitattributes declares (vendored,
      generated, fixture, own title), so every scope reads the same classes the same way. Runs `git check-attr` in
      batches that keep each command line short; a path need not be tracked. Only attributes git reports as set,
      unset, or a value are returned — `unspecified` is left out. A root that is not a git work tree has no
      .gitattributes, so nothing is returned for it.
    parameters:
      RepositoryRoot: The repository root the paths are relative to.
      Path: Repository-relative, '/'-separated paths.
      Attribute: The attribute names to read.
    outputs: '[hashtable] path -> @{ <attribute> = ''set'' | ''unset'' | <value> }, for the paths with any attribute specified.'
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
