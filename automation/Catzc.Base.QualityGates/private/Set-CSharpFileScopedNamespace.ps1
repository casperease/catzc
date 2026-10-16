<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Set-CSharpFileScopedNamespace.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Set-CSharpFileScopedNamespace.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Set-CSharpFileScopedNamespace.Tests.ps1
  config:
    synopsis: Returns the C# source with a file-scoped `namespace <Namespace>;` line present and correct.
    description: |-
      The string engine behind Format-Types. Pure (text in, text out), so it is unit-tested directly.

        - When the source already declares a file-scoped namespace, its name is corrected to <Namespace>
          (a no-op when it already matches).
        - When it declares none, `namespace <Namespace>;` is inserted after the leading comment/using block —
          before the first type or attribute — padded by a blank line on each side.
        - A block-scoped `namespace X { … }` (not a shape this repo authors) is left untouched, so the helper
          never double-declares; Format-Types reports it and Test-Formatting turns it into an issue.

      Line endings are normalised to LF and a single trailing newline is preserved (repo convention).
    parameters:
      Content: The C# source text.
      Namespace: The module namespace the file must declare (its <Module> folder).
    outputs: '[string] The source with the namespace line in place.'
---
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
    # Each line loses one trailing CR: every CRLF becomes LF, and a CR ending the whole text goes too.
    $normalized = $Content.Replace("`r`n", "`n")
    if ($normalized.EndsWith("`r")) {
        $normalized = $normalized.Substring(0, $normalized.Length - 1)
    }
    $lines = [System.Collections.Generic.List[string]]::new([string[]] $normalized.Split("`n"))
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
