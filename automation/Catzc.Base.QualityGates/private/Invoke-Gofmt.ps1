<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Invoke-Gofmt.ps1
    folder: private
    name: invoke-gofmt
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
    test: automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1
    cites:
      - ADR-AUTO-GO
      - ADR-PRIN-CONFIG#2
---
#>

function Invoke-Gofmt {
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
    $go = Resolve-ToolExecutable -Tool go
    if (-not ($go.Found -and $go.VersionOk)) {
        throw "The gofmt engine needs the managed go at the tools.yml pin '$($go.Required)' (found: $($go.Version ?? 'none')). Run Install-Go."
    }
    $gofmt = Join-Path ([System.IO.Path]::GetDirectoryName($go.Path)) ($IsWindows ? 'gofmt.exe' : 'gofmt')
    Assert-PathExist $gofmt -PathType Leaf

    $changed = [System.Collections.Generic.List[string]]::new()
    foreach ($batch in @(Split-CommandLineBatch -Item $File)) {
        $quoted = ($batch | ForEach-Object { "`"$_`"" }) -join ' '
        $list = Invoke-Executable "`"$gofmt`" -l $quoted" -PassThru -NoAssert -Silent
        if ($list.ExitCode -ne 0) {
            throw "gofmt could not read the Go files (exit $($list.ExitCode)):`n$($list.Full)"
        }
        foreach ($line in ($list.Output -split '\r?\n')) {
            if ($line.Trim()) {
                $changed.Add([System.IO.Path]::GetFullPath($line.Trim()))
            }
        }
    }

    if ($changed.Count -gt 0 -and -not $DryRun) {
        foreach ($batch in @(Split-CommandLineBatch -Item $changed.ToArray())) {
            $quoted = ($batch | ForEach-Object { "`"$_`"" }) -join ' '
            Invoke-Executable "`"$gofmt`" -w $quoted" -Silent
        }
    }

    , [string[]] $changed.ToArray()
}
