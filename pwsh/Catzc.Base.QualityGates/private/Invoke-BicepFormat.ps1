<#
---
catzc:
  immutable:
    with_body_sha: "9a56da6da3e5"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1
    docs: "[Invoke-BicepFormat.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Invoke-BicepFormat.ps1.md)"
    cites:
      - ADR-PRIN-CONFIG-NEWINSTANCEISCONFIGCHANGE
---
#>

function Invoke-BicepFormat {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [switch] $DryRun
    )

    if ($File.Count -eq 0) {
        return , [string[]] @()
    }
    $bicep = Resolve-ToolExecutable -Tool bicep
    if (-not ($bicep.Found -and $bicep.VersionOk)) {
        throw "The bicep engine needs the Bicep CLI at the tools.yml pin '$($bicep.Required)' (found: $($bicep.Version ?? 'none')). Run Install-Bicep."
    }

    $changed = [System.Collections.Generic.List[string]]::new()
    $folder = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-bicep-format-$([guid]::NewGuid().ToString('N'))"
    [System.IO.Directory]::CreateDirectory($folder) | Out-Null
    try {
        $copies = [string[]]::new($File.Count)
        for ($index = 0; $index -lt $File.Count; $index++) {
            $copies[$index] = Join-Path $folder "$index$([System.IO.Path]::GetExtension($File[$index]))"
            [System.IO.File]::Copy($File[$index], $copies[$index])
        }
        foreach ($extension in @($copies | ForEach-Object { [System.IO.Path]::GetExtension($_) } | Sort-Object -Unique)) {
            $pattern = (Join-Path $folder "*$extension") -replace '\\', '/'
            $result = Invoke-Executable "`"$($bicep.Path)`" format --pattern `"$pattern`"" -PassThru -NoAssert -Silent
            if ($result.ExitCode -ne 0) {
                throw "bicep could not format the Bicep files (exit $($result.ExitCode)):`n$($result.Full)"
            }
        }
        for ($index = 0; $index -lt $File.Count; $index++) {
            $original = [System.IO.File]::ReadAllBytes($File[$index])
            $formatted = [System.IO.File]::ReadAllBytes($copies[$index])
            if (-not [System.Linq.Enumerable]::SequenceEqual($original, $formatted)) {
                if (-not $DryRun) {
                    [System.IO.File]::WriteAllBytes($File[$index], $formatted)
                }
                $changed.Add($File[$index])
            }
        }
    }
    finally {
        [System.IO.Directory]::Delete($folder, $true)
    }

    , [string[]] $changed.ToArray()
}
