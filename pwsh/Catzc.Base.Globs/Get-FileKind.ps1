<#
---
catzc:
  immutable:
    with_body_sha: c86b90351839
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-FileKind.Tests.ps1
    docs: "[Get-FileKind.ps1.md](../../docs/references/pwsh/catzc-base-globs/Get-FileKind.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-METAKIND
---
#>

function Get-FileKind {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Globs.FileKindMatch])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    (Get-Config -Config file-kinds).Resolve(($Path -replace '\\', '/'))
}
