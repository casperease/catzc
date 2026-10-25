<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-root-config/New-GitAttributes.ps1.md"
  warning: "Generated Header"
---
#>

function New-GitAttributes {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $placeholder = '{{file-kind-attributes}}'
    $width = 118

    $templatePath = Get-CatzcModuleRoot 'assets/root/.gitattributes-template'
    Assert-PathExist $templatePath
    $template = [System.IO.File]::ReadAllText($templatePath) -replace "`r`n", "`n"

    $placeholderLines = @($template -split "`n" | Where-Object { $_ -eq $placeholder })
    if ($placeholderLines.Count -ne 1) {
        throw "The .gitattributes template must hold the line '$placeholder' exactly once, found $($placeholderLines.Count): $templatePath"
    }

    $blocks = [System.Collections.Generic.List[string]]::new()
    $addBlock = {
        param([string] $Why, [string[]] $Globs, [string[]] $Attributes)
        $lines = [System.Collections.Generic.List[string]]::new()
        $current = '# catzc:'
        foreach ($word in ($Why -split '\s+' | Where-Object { $_ })) {
            if (($current.Length + 1 + $word.Length) -gt $width -and $current -ne '#') {
                $lines.Add($current)
                $current = '#'
            }
            $current += " $word"
        }
        $lines.Add($current)
        foreach ($glob in $Globs) {
            $lines.Add("$glob $($Attributes -join ' ')")
        }
        $blocks.Add($lines -join "`n")
    }
    foreach ($kind in (Get-Config -Config file-kinds).kinds) {
        foreach ($entry in @($kind.subkinds) + $kind) {
            if (@($entry.gitAttributes).Count -gt 0) {
                & $addBlock $entry.gitWhy @($entry.files) @($entry.gitAttributes)
            }
        }
    }
    # A track type that declares attributes gives them to every file under each place of each track of that type.
    $trackTypes = Get-Config -Config track-types
    foreach ($track in @(Get-Track)) {
        $type = $trackTypes.TypeOf($track.type)
        if ($type -and @($type.gitAttributes).Count -gt 0) {
            & $addBlock $type.gitWhy @($track.places | ForEach-Object { "$_/**" }) @($type.gitAttributes)
        }
    }

    # Every committed root config is generated: one line per target rootconfig.yml declares committed, so the list has one source.
    $rootPlaceholder = '{{generated-root-files}}'
    if (@($template -split "`n" | Where-Object { $_ -eq $rootPlaceholder }).Count -ne 1) {
        throw "The .gitattributes template must hold the line '$rootPlaceholder' exactly once: $templatePath"
    }
    $roots = @((Get-Config -Config rootconfig).files | Where-Object { $_.committed } | ForEach-Object { "/$($_.target) linguist-generated" })

    $template.Replace($placeholder, ($blocks -join "`n`n")).Replace($rootPlaceholder, ($roots -join "`n"))
}
