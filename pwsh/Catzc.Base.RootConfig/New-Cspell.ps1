<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-root-config/New-Cspell.ps1.md"
  warning: "Generated Header"
---
#>

function New-Cspell {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $TemplatePath = (Get-CatzcModuleRoot 'assets/root/cspell-template.yml')
    )

    $placeholder = '  - "{{third-party}}"'

    Assert-PathExist $TemplatePath
    $template = [System.IO.File]::ReadAllText($TemplatePath) -replace "`r`n", "`n"
    Assert-NotNullOrWhitespace $template -ErrorText "The cspell template is empty: $TemplatePath"

    $placeholderLines = @($template -split "`n" | Where-Object { $_ -eq $placeholder })
    Assert-True ($placeholderLines.Count -eq 1) `
        -ErrorText "The cspell template must hold the line '$placeholder' exactly once, found $($placeholderLines.Count): $TemplatePath"

    # The third-party glob set is the one declaration of what is not authored here; the spelling check skips exactly its includes.
    $thirdParty = Get-GlobSet -Name 'third-party'
    Assert-True (@($thirdParty.Exclude).Count -eq 0 -and @($thirdParty.Compose).Count -eq 0) `
        -ErrorText "The third-party glob set must list includes only, since cspell's ignorePaths has no exclude: remove its exclude and compose entries."
    $lines = @(
        '  # The third-party glob set (globs.yml): vendored or downloaded files, never authored here.'
        foreach ($pattern in $thirdParty.Include) {
            "  - `"$($pattern.Pattern)`""
        }
    )

    $template.Replace($placeholder, ($lines -join "`n"))
}
