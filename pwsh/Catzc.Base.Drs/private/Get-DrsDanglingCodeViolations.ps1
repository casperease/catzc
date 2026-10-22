<#
---
catzc:
  edges:
    docs: "[Get-DrsDanglingCodeViolations.ps1.md](../../../docs/references/pwsh/catzc-base-drs/private/Get-DrsDanglingCodeViolations.ps1.md)"
---
#>

function Get-DrsDanglingCodeViolations {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Drs.DrsConfig] $Adrs,

        [Parameter(Mandatory)]
        [pscustomobject] $Index,

        [Parameter(Mandatory)]
        [Catzc.Base.Drs.DrsCitationMap] $Map
    )

    $pattern = "(?<![\w-])$($Adrs.CodeForm.Cited)(?![\w#-]|:\d)"
    $ret = foreach ($relative in $Index.Relative) {
        $inFence = $false
        $lines = [System.IO.File]::ReadAllLines([System.IO.Path]::Combine($Index.Root, $relative))
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\s*(```|~~~)') {
                $inFence = -not $inFence
                continue
            }
            if ($inFence) {
                continue
            }
            foreach ($match in [regex]::Matches($lines[$i], $pattern)) {
                $code = $match.Value
                if (-not ($Map.IsRule($code) -or $Map.HasCode($code) -or $Map.IsDomainCode($code))) {
                    "$($Adrs.Root)/${relative}:$($i + 1): cites $code, which names no registered rule, record or domain (a dangling code)"
                }
            }
        }
    }

    [string[]] @($ret)
}
