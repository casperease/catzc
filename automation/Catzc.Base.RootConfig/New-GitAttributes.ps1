<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.RootConfig/New-GitAttributes.ps1
    name: new-git-attributes
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.RootConfig/tests/New-GitAttributes.Tests.ps1
---
#>

function New-GitAttributes {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $placeholder = '{{file-kind-attributes}}'
    $width = 118

    $templatePath = Get-CatzcModuleRoot 'assets/root/.gitattributes'
    Assert-PathExist $templatePath
    $template = [System.IO.File]::ReadAllText($templatePath) -replace "`r`n", "`n"

    $placeholderLines = @($template -split "`n" | Where-Object { $_ -eq $placeholder })
    if ($placeholderLines.Count -ne 1) {
        throw "The .gitattributes template must hold the line '$placeholder' exactly once, found $($placeholderLines.Count): $templatePath"
    }

    $blocks = [System.Collections.Generic.List[string]]::new()
    foreach ($kind in (Get-Config -Config file-kinds).kinds) {
        foreach ($entry in @($kind.subkinds) + $kind) {
            if (@($entry.gitAttributes).Count -eq 0) {
                continue
            }
            $lines = [System.Collections.Generic.List[string]]::new()
            $current = '# catzc:'
            foreach ($word in ($entry.gitWhy -split '\s+' | Where-Object { $_ })) {
                if (($current.Length + 1 + $word.Length) -gt $width -and $current -ne '#') {
                    $lines.Add($current)
                    $current = '#'
                }
                $current += " $word"
            }
            $lines.Add($current)
            foreach ($glob in $entry.files) {
                $lines.Add("$glob $(@($entry.gitAttributes) -join ' ')")
            }
            $blocks.Add($lines -join "`n")
        }
    }

    $template.Replace($placeholder, ($blocks -join "`n`n"))
}
