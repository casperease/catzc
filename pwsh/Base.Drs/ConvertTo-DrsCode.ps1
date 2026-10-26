<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-drs/ConvertTo-DrsCode.ps1.md"
  header: "generated"
---
#>

function ConvertTo-DrsCode {
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string] $Code,

        # Old prefix to new prefix, matched by whole segments; the longest prefix wins.
        [hashtable] $Move = @{},

        # Old code to new code, taken as written: no other transform applies.
        [hashtable] $Override = @{},

        # Known lower-case words; a word the code already says is dropped only at a word boundary they prove, so no words, no drop.
        [System.Collections.Generic.HashSet[string]] $Words = [System.Collections.Generic.HashSet[string]]::new()
    )

    process {
        Assert-DrsCode $Code
        $check = (Get-Config -Config drs-checks).code_language
        $transforms = [System.Collections.Generic.List[string]]::new()
        $review = [System.Collections.Generic.List[string]]::new()

        $new = $Code
        if ($Override.ContainsKey($Code)) {
            $new = [string] $Override[$Code]
            $transforms.Add("override to $new")
        }
        else {
            $prefix = @($Move.Keys | Where-Object { [Catzc.Base.Drs.DrsCodeForm]::Covers($_, $Code) } |
                    Sort-Object { $_.Length } -Descending | Select-Object -First 1)
            if ($prefix.Count -gt 0) {
                $new = $Move[$prefix[0]] + $Code.Substring($prefix[0].Length)
                $transforms.Add("move $($prefix[0]) to $($Move[$prefix[0]])")
            }

            $segments = $new.Split('-')
            $leaf = $segments[-1]
            foreach ($said in $segments[1..($segments.Count - 2)]) {
                if ($said.Length -lt 3 -or -not $leaf.StartsWith($said, [System.StringComparison]::Ordinal)) {
                    continue
                }
                $rest = $leaf.Substring($said.Length)
                if ($rest.Length -lt 3 -or -not $Words.Contains($said.ToLowerInvariant())) {
                    continue
                }
                $lower = $leaf.ToLowerInvariant()
                $runsOn = @(1..([Math]::Min(8, $rest.Length)) | Where-Object { $Words.Contains($lower.Substring(0, $said.Length + $_)) })
                $starts = @(3..([Math]::Min(12, $rest.Length)) | Where-Object { $Words.Contains($rest.Substring(0, $_).ToLowerInvariant()) })
                if ($runsOn.Count -gt 0 -or $starts.Count -eq 0) {
                    continue
                }
                $transforms.Add("drop $said, already said by the code")
                $review.Add("check that $rest still names the rule")
                $leaf = $rest
                break
            }
            # A word repeated back to back inside the rule segment is said once.
            $once = [regex]::Replace($leaf, '([A-Z]{4,})\1', '$1')
            if ($once -cne $leaf) {
                $transforms.Add("say a repeated word once in $leaf")
                $leaf = $once
            }
            $segments[-1] = $leaf
            $new = $segments -join '-'
        }

        $violation = $check.Violation($new, $true)
        if ($violation) {
            $review.Add($violation)
        }

        [pscustomobject]@{
            OldCode    = $Code
            NewCode    = $new
            Transforms = [string[]] $transforms
            Review     = [string[]] $review
        }
    }
}
