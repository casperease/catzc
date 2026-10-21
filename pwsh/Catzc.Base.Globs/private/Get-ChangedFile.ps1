<#
---
catzc:
  immutable:
    with_body_sha: "64487cfd30eb"
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
    docs: "[Get-ChangedFile.ps1.md](docs/references/pwsh/catzc-base-globs/private/Get-ChangedFile.ps1.md)"
    cites:
      - FDR-CD-GLOBS-TRACKEDFILESONLY
---
#>

function Get-ChangedFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Range
    )

    $ret = Invoke-Executable "git -c core.quotepath=off diff --name-only --no-renames $Range" -PassThru -Silent
    $ret.Output -split "`r?`n" | Where-Object { $_ -ne '' }
}
