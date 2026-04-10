<#
.SYNOPSIS
    Returns the C# source with a file-scoped `namespace <Namespace>;` line present and correct.
.DESCRIPTION
    The string engine behind Format-Types. Pure (text in, text out), so it is unit-tested directly.

      - When the source already declares a file-scoped namespace, its name is corrected to <Namespace>
        (a no-op when it already matches).
      - When it declares none, `namespace <Namespace>;` is inserted after the leading comment/using block —
        before the first type or attribute — padded by a blank line on each side.
      - A block-scoped `namespace X { … }` (not a shape this repo authors) is left untouched, so the helper
        never double-declares; Test-Types reports it instead.

    Line endings are normalised to LF and a single trailing newline is preserved (repo convention).
.PARAMETER Content
    The C# source text.
.PARAMETER Namespace
    The module namespace the file must declare (its <Module> folder).
.OUTPUTS
    [string] The source with the namespace line in place.
#>
function Set-CSharpFileScopedNamespace {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Content,

        [Parameter(Mandatory)]
        [string] $Namespace
    )

    $hadTrailingNewline = $Content.EndsWith("`n")
    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($line in ($Content -split "`n")) {
        $lines.Add(($line -replace "`r$", ''))
    }
    if ($hadTrailingNewline -and $lines.Count -gt 0 -and $lines[$lines.Count - 1] -eq '') {
        $lines.RemoveAt($lines.Count - 1)
    }

    $rebuild = {
        param($result)
        $joined = [string]::Join("`n", $result)
        if ($hadTrailingNewline) {
            $joined += "`n"
        }
        $joined
    }

    # An existing namespace declaration: correct a file-scoped one in place (no-op when already right);
    # leave a block-scoped one (file-scoped lines end with ';'; anything else is a block) untouched — not a
    # shape we author, so Test-Types reports it rather than this helper double-declaring.
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*namespace\s+\S') {
            if (($lines[$i] -match '^\s*namespace\s+(\S+?)\s*;\s*$') -and ($Matches[1] -ne $Namespace)) {
                $lines[$i] = "namespace $Namespace;"
            }
            return (& $rebuild $lines)
        }
    }

    # No namespace yet: insert after the leading comment/using/preprocessor block.
    $insert = $lines.Count
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $trimmed = $lines[$i].Trim()
        if ($trimmed -eq '' -or $trimmed.StartsWith('//') -or $trimmed.StartsWith('using ') -or $trimmed.StartsWith('#')) {
            continue
        }
        $insert = $i
        break
    }

    $out = [System.Collections.Generic.List[string]]::new()
    for ($i = 0; $i -lt $insert; $i++) {
        $out.Add($lines[$i])
    }
    if ($out.Count -gt 0 -and $out[$out.Count - 1] -ne '') {
        $out.Add('')
    }
    $out.Add("namespace $Namespace;")
    $out.Add('')
    for ($i = $insert; $i -lt $lines.Count; $i++) {
        $out.Add($lines[$i])
    }

    return (& $rebuild $out)
}
