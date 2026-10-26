<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vs-code/private/ConvertFrom-EditorConfig.ps1.md"
  header: "generated"
---
#>

function ConvertFrom-EditorConfig {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        # Each section glob -> the VS Code language ids it renders into (vscode-settings.yml editorconfig).
        [Parameter(Mandatory)]
        [System.Collections.Generic.IReadOnlyDictionary[string, string[]]] $Section
    )

    # Only the properties VS Code has a setting for; every other one stays for the tools that read .editorconfig itself.
    $convert = {
        param([string] $Name, [string] $Value)
        switch ($Name) {
            'indent_style' {
                @{ 'editor.insertSpaces' = $Value -eq 'space' }
            }
            'indent_size' {
                @{ 'editor.tabSize' = [int] $Value }
            }
            'trim_trailing_whitespace' {
                @{ 'files.trimTrailingWhitespace' = $Value -eq 'true' }
            }
            'insert_final_newline' {
                @{ 'files.insertFinalNewline' = $Value -eq 'true' }
            }
            'end_of_line' {
                @{ 'files.eol' = @{ lf = "`n"; crlf = "`r`n" }[$Value] }
            }
            'charset' {
                @{ 'files.encoding' = @{ 'utf-8' = 'utf8'; 'utf-8-bom' = 'utf8bom' }[$Value] }
            }
            'max_line_length' {
                @{ 'editor.rulers' = @([int] $Value) }
            }
        }
    }

    $out = [ordered]@{}
    $target = $null
    foreach ($raw in $Text -split "`r?`n") {
        $line = $raw.Trim()
        if (-not $line -or $line.StartsWith('#') -or $line.StartsWith(';')) {
            continue
        }
        if ($line -match '^\[(?<glob>.+)\]$') {
            $glob = $Matches['glob']
            # No target, an unmapped section, skips its keys; the root section writes them bare.
            $target = $null
            if ($glob -eq '*') {
                $target = @('')
            }
            elseif ($Section.ContainsKey($glob)) {
                $target = @($Section[$glob] | ForEach-Object { "[$_]" })
            }
            continue
        }
        if ($null -eq $target -or $line -notmatch '^(?<name>[a-z_]+)\s*=\s*(?<value>.+)$') {
            continue
        }
        $mapped = & $convert $Matches['name'] $Matches['value'].Trim().ToLowerInvariant()
        if (-not $mapped -or $null -eq ($mapped.Values | Select-Object -First 1)) {
            continue
        }
        foreach ($key in $target) {
            $block = if ($key) {
                if (-not $out.Contains($key)) {
                    $out[$key] = [ordered]@{ 'editor.detectIndentation' = $false }
                }
                $out[$key]
            }
            else {
                $out
            }
            foreach ($setting in $mapped.Keys) {
                $block[$setting] = $mapped[$setting]
            }
        }
    }
    if ($out.Contains('editor.tabSize')) {
        $out['editor.detectIndentation'] = $false
    }
    $out
}
