<#
---
catzc:
  immutable:
    with_body_sha: d73d8576ada5
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Write-TestRunManifest.Tests.ps1
    docs: "[Write-TestRunManifest.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Write-TestRunManifest.ps1.md)"
---
#>

function Write-TestRunManifest {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Manifest
    )

    Assert-PathExist $RunDirectory -PathType Container

    $path = Join-Path $RunDirectory 'run.json'
    $temp = "$path.$PID.tmp"

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($temp, (ConvertTo-Json -InputObject $Manifest -Depth 4), $utf8NoBom)
    [System.IO.File]::Move($temp, $path, $true)

    $path
}
