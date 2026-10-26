function Format-PowerShellWidth {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [int] $Width
    )

    $newline = if ($Text.Contains("`r`n")) {
        "`r`n"
    }
    else {
        "`n"
    }
    $tokenize = {
        param([string] $Source)
        $tokens = $null
        $errors = $null
        $null = [System.Management.Automation.Language.Parser]::ParseInput($Source, [ref] $tokens, [ref] $errors)
        [pscustomobject]@{ Tokens = $tokens; Errors = $errors }
    }
    $before = & $tokenize $Text
    if (@($before.Errors).Count -gt 0) {
        return [pscustomobject]@{ Text = $Text; Changed = $false; Refused = 'the file does not parse' }
    }

    $current = $Text
    # Each pass makes one break on the first line that can take one; a line that cannot is remembered, so the loop ends.
    $skipped = [System.Collections.Generic.HashSet[int]]::new()
    for ($pass = 0; $pass -lt 2000; $pass++) {
        $parsed = & $tokenize $current
        $lines = $current -split [regex]::Escape($newline)
        $break = $null
        for ($index = 0; $index -lt $lines.Count -and $null -eq $break; $index++) {
            $number = $index + 1
            $line = $lines[$index]
            if ($line.Length -le $Width -or $skipped.Contains($number)) {
                continue
            }
            $indent = $line.Substring(0, $line.Length - $line.TrimStart().Length)
            $onLine = @($parsed.Tokens | Where-Object { $_.Extent.StartLineNumber -eq $number -and $_.Extent.EndLineNumber -eq $number })
            # A line inside a here-string or a block comment holds no token of its own, so it has no safe break.
            if ($onLine.Count -eq 0) {
                $null = $skipped.Add($number)
                continue
            }

            # A whole-line comment reflows at the last space that fits, as a second comment line under it.
            if ($onLine.Count -le 2 -and $onLine[0].Kind -eq 'Comment' -and $onLine[0].Text.StartsWith('#') -and
                $line.TrimStart().StartsWith('#')) {
                $cut = $line.LastIndexOf(' ', $Width)
                $lead = $indent.Length + 2
                if ($cut -gt $lead) {
                    $break = @{ Line = $index; Head = $line.Substring(0,
                        $cut).TrimEnd(); Tail = "$indent# " + $line.Substring($cut + 1).TrimStart() }
                }
                else {
                    $null = $skipped.Add($number)
                }
                continue
            }

            # Inside parentheses a newline after a comma or a logical operator continues the expression; at statement
            # level, after a pipe.
            $depth = 0
            $candidate = $null
            $all = @($parsed.Tokens | Where-Object { $_.Extent.StartLineNumber -le $number })
            foreach ($token in $all) {
                $sameLine = $token.Extent.StartLineNumber -eq $number -and $token.Extent.EndLineNumber -eq $number
                if ($sameLine -and $token.Extent.EndColumnNumber - 1 -le $Width) {
                    $rest = $line.Substring($token.Extent.EndColumnNumber - 1).Trim()
                    $fits = $rest.Length -gt 0 -and -not $rest.StartsWith('#')
                    if ($fits -and $token.Kind -eq 'Pipe' -and $depth -eq 0) {
                        $candidate = $token
                    }
                    elseif ($fits -and $depth -gt 0 -and $token.Kind -in 'Comma', 'And', 'Or') {
                        $candidate = $token
                    }
                }
                if ($token.Kind -in 'LParen', 'AtParen', 'DollarParen') {
                    $depth++
                }
                elseif ($token.Kind -eq 'RParen' -and $depth -gt 0) {
                    $depth--
                }
                elseif ($token.Kind -in 'LCurly', 'AtCurly') {
                    # A script block or a hashtable starts a statement context of its own.
                    $depth = 0
                }
            }
            if ($candidate) {
                $at = $candidate.Extent.EndColumnNumber - 1
                # A line that already continues the one above keeps its indent; the first break of a statement indents
                # one level.
                $previous = if ($index -gt 0) {
                    $lines[$index - 1].TrimEnd()
                }
                else {
                    ''
                }
                $continued = $previous -match '(\||,|-and|-or)$'
                $tailIndent = if ($continued) {
                    $indent
                }
                else {
                    "$indent    "
                }
                $break = @{ Line = $index; Head = $line.Substring(0,
                    $at).TrimEnd(); Tail = $tailIndent + $line.Substring($at).TrimStart() }
            }
            else {
                $null = $skipped.Add($number)
            }
        }
        if ($null -eq $break) {
            break
        }
        $updated = [System.Collections.Generic.List[string]]::new([string[]] $lines)
        $updated[$break.Line] = $break.Head
        $updated.Insert($break.Line + 1, $break.Tail)
        $current = $updated -join $newline
    }

    if ($current -ceq $Text) {
        return [pscustomobject]@{ Text = $Text; Changed = $false; Refused = $null }
    }
    # The proof: the result parses, its code tokens are the source's one for one, and its comments hold the same words
    # in order.
    $after = & $tokenize $current
    $code = {
        param($Tokens)
        @($Tokens | Where-Object { $_.Kind -notin 'NewLine', 'LineContinuation', 'EndOfInput', 'Comment' } |
            ForEach-Object { "$($_.Kind)|$($_.Text)" })
    }
    $words = {
        param($Tokens)
        (@($Tokens | Where-Object Kind -EQ 'Comment' | ForEach-Object { $_.Text -replace '^#+', '' }) -join ' ') -split '\s+' | Where-Object { $_ }
    }
    $sameCode = (@(& $code $before.Tokens) -join "`n") -ceq (@(& $code $after.Tokens) -join "`n")
    $sameWords = (@(& $words $before.Tokens) -join ' ') -ceq (@(& $words $after.Tokens) -join ' ')
    if (@($after.Errors).Count -gt 0 -or -not $sameCode -or -not $sameWords) {
        return [pscustomobject]@{ Text = $Text; Changed = $false; Refused = 'a break would change the code; left as it is' }
    }
    [pscustomobject]@{ Text = $current; Changed = $true; Refused = $null }
}
