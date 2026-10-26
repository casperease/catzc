<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/private/Get-DrsDanglingCodeViolations.ps1.md"
  header: "generated"
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
        $fence = $null
        $lines = [System.IO.File]::ReadAllLines([System.IO.Path]::Combine($Index.Root, $relative))
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($null -eq $fence) {
                if ($lines[$i] -match '^\s*(?<run>`{3,}|~{3,})') {
                    $fence = $Matches['run']
                }
                else {
                    foreach ($match in [regex]::Matches($lines[$i], $pattern)) {
                        $code = $match.Value
                        if (-not ($Map.IsRule($code) -or $Map.HasCode($code) -or $Map.IsDomainCode($code))) {
                            "$($Adrs.Root)/${relative}:$($i + 1): cites $code, which names no registered rule, record or domain (a dangling code)"
                        }
                    }
                }
                continue
            }
            if ($lines[$i] -match "^\s*(?<run>$([regex]::Escape($fence[0]))+)\s*$" -and
                $Matches['run'].Length -ge $fence.Length) {
                $fence = $null
            }
        }
    }

    [string[]] @($ret)
}
