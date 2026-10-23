function New-Cspell {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $TemplatePath = (Get-CatzcModuleRoot 'assets/root/cspell-template.yml')
    )

    $placeholder = '  - "{{third-party}}"'

    Assert-PathExist $TemplatePath
    $template = [System.IO.File]::ReadAllText($TemplatePath) -replace "`r`n", "`n"

    $placeholderLines = @($template -split "`n" | Where-Object { $_ -eq $placeholder })
    if ($placeholderLines.Count -ne 1) {
        throw "The cspell template must hold the line '$placeholder' exactly once, found $($placeholderLines.Count): $TemplatePath"
    }

    # The third-party glob set is the one declaration of what is not authored here; the spelling gate skips exactly its includes.
    $thirdParty = Get-GlobSet -Name 'third-party'
    if (@($thirdParty.Exclude).Count -gt 0 -or @($thirdParty.Compose).Count -gt 0) {
        throw "The third-party glob set must list includes only, since cspell's ignorePaths has no exclude: remove its exclude and compose entries."
    }
    $lines = @(
        '  # The third-party glob set (globs.yml): vendored or downloaded files, never authored here.'
        foreach ($pattern in $thirdParty.Include) {
            "  - `"$($pattern.Pattern)`""
        }
    )

    $template.Replace($placeholder, ($lines -join "`n"))
}
