# cspell:ignore Segoe linejoin linecap
function New-VsCodeFileIconTheme {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Writes generated output into a freshly rendered extension folder')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        # The extension's media folder; the theme and its SVGs are written into it.
        [Parameter(Mandatory)]
        [string] $MediaDirectory,

        [Catzc.Base.VSCode.FileIconsConfig] $Config = (Get-Config -Config file-icons),

        [string] $GlyphDirectory = (Get-CatzcModuleRoot -ChildPath 'assets/extensions/catzc-track-lamps'),

        # The language system an icon's 'language' names; each language's extensions come from here, never restated in file-icons.yml.
        $Languages = (Get-Config -Config languages).languages
    )

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $stroke = '(?<=<svg [^>]*\bstroke=")#[0-9a-fA-F]{6}'
    $null = New-Item -ItemType Directory -Path $MediaDirectory -Force
    $write = { param([string] $Name, [string] $Svg) [System.IO.File]::WriteAllText((Join-Path $MediaDirectory "$Name.svg"), $Svg.TrimEnd() + "`n", $utf8) }
    $labelSvg = {
        param([string] $Text, [string] $Color, [string] $Style)
        $size = @{ 1 = 11; 2 = 9; 3 = 6.5; 4 = 5 }[$Text.Length]
        $escaped = [System.Security.SecurityElement]::Escape($Text)
        $under = if ($Style -eq 'prompt') {
            "  <path d=`"M2 11.4l2.6 1.8-2.6 1.8`" fill=`"none`" stroke=`"$Color`" stroke-width=`"1.3`" stroke-linecap=`"round`" stroke-linejoin=`"round`"/>`n  <rect x=`"6.4`" y=`"13.9`" width=`"4.2`" height=`"1.3`" rx=`"0.4`" fill=`"$Color`"/>"
        }
        else {
            "  <rect x=`"2`" y=`"13.4`" width=`"12`" height=`"1.2`" rx=`"0.6`" fill=`"$Color`"/>"
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
            $source = Join-Path $GlyphDirectory "$($icon.glyph)-on.svg"
            Assert-PathExist $source -ErrorText "New-VsCodeFileIconTheme: icon '$($icon.name)' names glyph '$($icon.glyph)', which has no '$source'."
            $svg = [System.IO.File]::ReadAllText($source).Replace(' data-badge="bottom"', '') -replace $stroke, $icon.color
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

    & $write '_file' @"
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="$($Config.file)" stroke-width="1.2" stroke-linejoin="round">
  <path d="M3.5 1.5h6l3 3v10h-9z"/>
  <path d="M9.5 1.5v3h3"/>
</svg>
"@
    & $write '_folder' @"
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="$($Config.folder)" stroke-width="1.2" stroke-linejoin="round">
  <path d="M1.5 3.5h4.5l1.5 1.5h7v8.5h-13z"/>
</svg>
"@
    & $write '_folder_open' @"
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="$($Config.folder)" stroke-width="1.2" stroke-linejoin="round">
  <path d="M1.5 13.5v-10h4.5l1.5 1.5h6v2"/>
  <path d="M1.5 13.5l2.5-6h11l-2.5 6z"/>
</svg>
"@
    foreach ($fixed in '_file', '_folder', '_folder_open') {
        $definitions[$fixed] = [ordered]@{ iconPath = "./$fixed.svg" }
    }

    $theme = [ordered]@{
        iconDefinitions = $definitions
        file            = '_file'
        folder          = '_folder'
        folderExpanded  = '_folder_open'
        fileExtensions  = $fileExtensions
        fileNames       = $fileNames
        languageIds     = $languageIds
    }
    $path = Join-Path $MediaDirectory 'file-icons.json'
    [System.IO.File]::WriteAllText($path, ($theme | ConvertTo-Json -Depth 8) + "`n", $utf8)
    $path
}
