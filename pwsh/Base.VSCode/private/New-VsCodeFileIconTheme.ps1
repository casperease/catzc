<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vs-code/private/New-VsCodeFileIconTheme.ps1.md"
  header: "generated"
---
#>

# cspell:ignore Segoe linejoin linecap dasharray
function New-VsCodeFileIconTheme {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Writes generated output into a freshly rendered extension folder')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        # The extension's media folder; the theme and its SVGs are written into it.
        [Parameter(Mandatory)]
        [string] $MediaDirectory,

        [Catzc.Base.VSCode.FileIconsConfig] $Config = (Get-Config -Config file-icons),

        # The glyph folders, in order: the icon theme's own glyphs, then the lamp glyphs.
        [string[]] $GlyphDirectory = @(
            (Join-Path (Get-RepositoryRoot) "$(Get-TrackPlace -Track js -TrackKind extensions)/$((Get-Track -Name js).FolderNameOf('catzc-file-icons'))/assets")
            (Join-Path (Get-RepositoryRoot) "$(Get-TrackPlace -Track js -TrackKind extensions)/$((Get-Track -Name js).FolderNameOf('catzc-track-lamps'))/assets")
        ),

        # Each language's extensions come from the language system, never restated in file-icons.yml.
        $Languages = (Get-Config -Config languages).languages
    )

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $stroke = '(?<=<svg [^>]*\bstroke=")#[0-9a-fA-F]{6}'
    $null = New-Item -ItemType Directory -Path $MediaDirectory -Force
    $write = { param([string] $Name,
            [string] $Svg) [System.IO.File]::WriteAllText((Join-Path $MediaDirectory "$Name.svg"), $Svg.TrimEnd() + "`n",
            $utf8) }
    # A label shrinks with its length so four characters fit the 16-pixel square; the prompt style draws a chevron and a cursor.
    $labelSvg = {
        param([string] $Text, [string] $Color, [string] $Style)
        $size = @{ 1 = 11; 2 = 9; 3 = 6.5; 4 = 5 }[$Text.Length]
        $escaped = [System.Security.SecurityElement]::Escape($Text)
        $under = if ($Style -eq 'prompt') {
            "  <path d=`"M6.6 11.4l2.4 1.8-2.4 1.8`" fill=`"none`" stroke=`"$Color`" stroke-width=`"1.4`" stroke-linecap=`"round`" stroke-linejoin=`"round`"/>"
        }
        else {
            ''
        }
        $y = if ($Style -eq 'prompt') {
            '6.2'
        }
        else {
            '8'
        }
        @"
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16">
  <text x="8" y="$y" dominant-baseline="central" text-anchor="middle" font-family="Consolas, 'Segoe UI', sans-serif" font-weight="700" font-size="$size" fill="$Color">$escaped</text>
$under
</svg>
"@
    }

    # An extension an icon names itself wins over the same extension reached through another icon's language.
    $named = @{}
    foreach ($icon in $Config.icons) {
        foreach ($extension in $icon.extensions) {
            $named[$extension] = $true
        }
    }

    $definitions = [ordered]@{}
    $fileExtensions = [ordered]@{}
    $fileNames = [ordered]@{}
    $languageIds = [ordered]@{}
    foreach ($icon in $Config.icons) {
        if ($icon.glyph) {
            $candidates = foreach ($directory in $GlyphDirectory) {
                Join-Path $directory "$($icon.glyph).svg"
                Join-Path $directory "$($icon.glyph)-on.svg"
            }
            $source = $candidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
            Assert-NotNull $source -ErrorText "New-VsCodeFileIconTheme: icon '$($icon.name)' names glyph '$($icon.glyph)', which none of '$($GlyphDirectory -join "', '")' holds."
            $svg = [System.IO.File]::ReadAllText($source).Replace(' data-badge="bottom"',
                '') -replace $stroke, $icon.color
        }
        else {
            $svg = & $labelSvg $icon.label $icon.color $icon.style
        }
        if ($icon.language) {
            $language = $Languages | Where-Object name -EQ $icon.language
            Assert-NotNull $language -ErrorText "New-VsCodeFileIconTheme: icon '$($icon.name)' names language '$($icon.language)', which languages.yml does not declare."
            foreach ($extension in $language.extensions) {
                $bare = $extension.TrimStart('.').ToLowerInvariant()
                if (-not $named.ContainsKey($bare)) {
                    $fileExtensions[$bare] = $icon.name
                }
            }
        }
        foreach ($id in $icon.language_ids) {
            $languageIds[$id] = $icon.name
        }
        & $write $icon.name $svg
        $definitions[$icon.name] = [ordered]@{ iconPath = "./$($icon.name).svg" }
        foreach ($extension in $icon.extensions) {
            $fileExtensions[$extension] = $icon.name
        }
        foreach ($name in $icon.names) {
            $fileNames[$name] = $icon.name
        }
    }

    # A file no icon marks is one dot; the theme names no folder icon, so the Explorer's chevron marks a folder.
    & $write '_file' "<svg xmlns=`"http://www.w3.org/2000/svg`" width=`"16`" height=`"16`" viewBox=`"0 0 16 16`">`n  <path d=`"M8 8h0`" stroke=`"$($Config.file)`" stroke-width=`"2.4`" stroke-linecap=`"round`"/>`n</svg>"
    $definitions['_file'] = [ordered]@{ iconPath = './_file.svg' }
    $theme = [ordered]@{
        iconDefinitions = $definitions
        file            = '_file'
        fileExtensions  = $fileExtensions
        fileNames       = $fileNames
        languageIds     = $languageIds
    }
    $path = Join-Path $MediaDirectory 'file-icons.json'
    [System.IO.File]::WriteAllText($path, ($theme | ConvertTo-Json -Depth 8) + "`n", $utf8)
    $path
}
