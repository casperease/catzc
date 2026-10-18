<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Set-CSharpFileScopedNamespace.ps1
    folder: private
    name: set-c-sharp-file-scoped-namespace
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
    page: docs/references/automation/catzc-base-qualitygates/private/Set-CSharpFileScopedNamespace.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Set-CSharpFileScopedNamespace.Tests.ps1
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
