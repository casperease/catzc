<#
.SYNOPSIS
    Returns the C# source with a file-scoped `namespace <Namespace>;` line present and correct.
.DESCRIPTION
    A block-scoped namespace is left alone, so the helper never double-declares; Format-Types reports it.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Set-CSharpFileScopedNamespace.ps1.md#comment1)
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

    # A block-scoped namespace is left untouched: the repo never authors one, so Format-Types reports it instead.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Set-CSharpFileScopedNamespace.ps1.md#comment2)
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
