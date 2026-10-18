<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Git/private/Format-GitIgnoreSection.ps1
    folder: private
    name: format-git-ignore-section
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
---
#>

function Format-GitIgnoreSection {
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Title,

        [Parameter(Mandatory)]
        [string] $Why,

        [AllowEmptyCollection()]
        [object[]] $Pattern = @()
    )

    $width = 118

    # Rule line: '# ── Title ─────…' padded to the comment width.
    $lead = "# $([char]0x2500)$([char]0x2500) $Title "
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add($lead + ([string][char]0x2500) * [Math]::Max(3, $width - $lead.Length))

    # The why, wrapped word-by-word into '# ' comment lines.
    $current = '#'
    foreach ($word in ($Why -split '\s+' | Where-Object { $_ })) {
        if (($current.Length + 1 + $word.Length) -gt $width -and $current -ne '#') {
            $lines.Add($current)
            $current = '#'
        }
        $current += " $word"
    }
    if ($current -ne '#') {
        $lines.Add($current)
    }

    # Patterns, each note on its own comment line above its pattern.
    foreach ($entry in $Pattern) {
        if ($entry.note) {
            $lines.Add("# $($entry.note)")
        }
        $lines.Add($entry.pattern)
    }

    [string[]] $lines
}
