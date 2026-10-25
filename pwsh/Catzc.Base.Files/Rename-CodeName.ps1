<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-files/Rename-CodeName.ps1.md"
  warning: "Generated Header"
---
#>

function Rename-CodeName {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [System.Collections.IDictionary] $Map,

        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path = @('.'),

        [string[]] $Exclude = @('.claude/learnings/', '.claude/hindsight/'),

        [switch] $DryRun
    )

    $bad = @($Map.Keys | Where-Object { [string]::IsNullOrEmpty($_) -or [string]::IsNullOrEmpty($Map[$_]) -or $_ -ceq $Map[$_] })
    Assert-True ($bad.Count -eq 0) -ErrorText "Rename-CodeName: every map row needs a non-empty old name and a different non-empty new name ($($bad -join ', '))."

    $lookup = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    foreach ($old in $Map.Keys) {
        $lookup[$old] = $Map[$old]
    }
    # Longest first, so a name that contains another is replaced whole; a name matches only as a token, never inside a longer one.
    $alternation = (@($lookup.Keys) | Sort-Object { $_.Length } -Descending | ForEach-Object { [regex]::Escape($_) }) -join '|'
    $token = [regex]::new("(?<![\w-])(?:$alternation)(?![\w-])")
    # The longer tokens a name sits inside, such as an id `g-<name>`, are skipped by design; each is reported so the caller decides.
    $within = [regex]::new("[\w-]*(?:$alternation)[\w-]*")

    $root = Get-RepositoryRoot
    foreach ($relative in @(Get-GitTrackedPath $Path)) {
        if (@($Exclude | Where-Object { $relative.StartsWith($_, [System.StringComparison]::Ordinal) }).Count) {
            continue
        }
        $full = Join-Path $root $relative
        # A tracked file deleted from the working tree is still in the index, but names nothing.
        if (-not [System.IO.File]::Exists($full)) {
            continue
        }
        $bytes = [System.IO.File]::ReadAllBytes($full)
        $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
        $encoding = [System.Text.UTF8Encoding]::new($hasBom)
        $text = $encoding.GetString($bytes, ($hasBom ? 3 : 0), $bytes.Length - ($hasBom ? 3 : 0))
        if ($text.Contains([char] 0)) {
            continue
        }
        $count = $token.Matches($text).Count
        $skipped = [string[]] @(foreach ($match in $within.Matches($text)) {
                if (-not $lookup.ContainsKey($match.Value)) {
                    "$(($text.Substring(0, $match.Index) -split "`n").Count):$($match.Value)"
                }
            })
        if ($count -eq 0 -and $skipped.Count -eq 0) {
            continue
        }
        if ($count -gt 0 -and -not $DryRun) {
            $renamed = $token.Replace($text, { param($match) $lookup[$match.Value] })
            [System.IO.File]::WriteAllText($full, $renamed, $encoding)
        }
        [pscustomobject]@{ Path = $relative; Count = $count; Skipped = $skipped }
    }
}
