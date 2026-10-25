<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-listen/Find-DocPattern.ps1.md"
  warning: "Generated Header"
---
#>

function Find-DocPattern {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Session,

        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Pattern,

        [string[]] $Tier,

        [string] $Path = ''
    )

    $Session = Resolve-ListenSession $Session
    $reference = Join-Path $Session 'reference'
    Assert-PathExist $reference -PathType Container -ErrorText "Find-DocPattern: the session '$Session' holds no reference."
    $slice = $Path.Replace('\', '/').Trim('/')
    $start = if ($slice) {
        Join-Path $reference $slice
    }
    else {
        $reference
    }
    if (-not [System.IO.Directory]::Exists($start)) {
        return
    }
    $regex = [regex]::new($Pattern, [System.Text.RegularExpressions.RegexOptions]::CultureInvariant)

    $files = [string[]] @(Get-ChildPath $start -File -Depth 64 -Exclude @('.git') -PruneVendor $false)
    [Array]::Sort($files, [System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        $relative = [System.IO.Path]::GetRelativePath($reference, $file).Replace('\', '/')
        $place = Get-ListenTier $relative
        if ($Tier -and $place.Tier -cnotin $Tier) {
            continue
        }

        $bytes = [System.IO.File]::ReadAllBytes($file)
        if ([Array]::IndexOf($bytes, [byte] 0, 0, [Math]::Min($bytes.Length, 8000)) -ge 0) {
            continue
        }
        $lines = [System.Text.Encoding]::UTF8.GetString($bytes) -split '\r?\n'
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($regex.IsMatch($lines[$i])) {
                [pscustomobject]@{
                    Path = $relative
                    Line = $i + 1
                    Text = $lines[$i].Trim()
                    Kind = $place.Kind
                    Tier = $place.Tier
                }
            }
        }
    }
}
