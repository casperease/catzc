<#
---
catzc:
  immutable:
    with_body_sha: cc616dc255e4
  edges:
    test: pwsh/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1
    docs: "[Get-ExecutableVersion.ps1.md](docs/references/pwsh/catzc-base-execution/private/Get-ExecutableVersion.ps1.md)"
---
#>

function Get-ExecutableVersion {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [AllowEmptyString()]
        [string] $Arguments = '',

        [Parameter(Mandatory)]
        [string] $Pattern
    )

    $folder = [System.IO.Path]::GetDirectoryName($Path)
    $result = Invoke-Executable "`"$Path`" $Arguments".TrimEnd() -WorkingDirectory $folder -PassThru -NoAssert -Silent

    if ($result.Full -match $Pattern) {
        return $Matches['ver']
    }
    $null
}
