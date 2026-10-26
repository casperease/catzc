<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vs-code/private/New-VsCodeExtensionFolder.ps1.md"
  header: "generated"
---
#>

function New-VsCodeExtensionFolder {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Writes generated output under the output root; the folder is replaced on every render')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.VSCode.VscodeOwnExtension] $Extension,

        [Parameter(Mandatory)]
        [string] $OutputDirectory,

        [string] $AssetDirectory = (Join-Path (Get-RepositoryRoot) (Get-TrackPlace -Track js -TrackKind extensions))
    )

    $sourceFolder = (Get-Track -Name js).FolderNameOf($Extension.name)
    $script = Join-Path $AssetDirectory "$sourceFolder/extension.js"
    Assert-PathExist $script -ErrorText "New-VsCodeExtensionFolder: extension '$($Extension.name)' has no script at '$script'."

    $manifest = [ordered]@{
        name             = $Extension.name
        displayName      = $Extension.displayName
        description      = $Extension.description
        version          = $Extension.version
        publisher        = $Extension.publisher
        engines          = [ordered]@{ vscode = $Extension.engine }
        main             = './extension.js'
        activationEvents = @($Extension.activationEvents)
        # The source the installed shell loads from the workspace, so the shell spells no folder of its own.
        catzc            = [ordered]@{ source = "$(Get-TrackPlace -Track js -TrackKind extensions)/$sourceFolder" }
    }
    if ($Extension.contributes.Count -gt 0) {
        $manifest.contributes = Resolve-LampPaletteShade -InputObject (Expand-VsCodeCommandState -Contributes (Expand-VsCodeRepeat -Contributes $Extension.contributes))
    }

    $folder = Join-Path $OutputDirectory $Extension.name
    if (Test-Path -LiteralPath $folder) {
        Remove-Item -LiteralPath $folder -Recurse -Force
    }
    $null = New-Item -ItemType Directory -Path $folder -Force
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText((Join-Path $folder 'package.json'), ($manifest | ConvertTo-Json -Depth 32) + "`n",
        $utf8)
    # The entry and its sibling parts ship together; the tests/ folder below them never does.
    foreach ($part in [System.IO.Directory]::GetFiles((Split-Path $script), '*.js')) {
        $name = if ($part -eq $script) {
            'extension.js'
        }
        else {
            [System.IO.Path]::GetFileName($part)
        }
        Copy-Item -LiteralPath $part -Destination (Join-Path $folder $name)
    }
    $media = Join-Path $AssetDirectory "$sourceFolder/assets"
    if (Test-Path -LiteralPath $media -PathType Container) {
        Copy-Item -LiteralPath $media -Destination (Join-Path $folder 'media') -Recurse
    }
    $rendered = Join-Path $folder 'media'
    # An extension that contributes an icon theme gets the theme rendered from file-icons.yml into its media.
    if ($Extension.contributes.Contains('iconThemes')) {
        $null = New-VsCodeFileIconTheme -MediaDirectory $rendered -GlyphDirectory @((Join-Path $AssetDirectory "$sourceFolder/assets"),
            (Join-Path $AssetDirectory "$((Get-Track -Name js).FolderNameOf('catzc-track-lamps'))/assets"))
    }
    $repeats = if ($Extension.contributes.Contains('repeat')) {
        $Extension.contributes['repeat']
    }
    else {
        @{}
    }
    foreach ($name in $repeats.Keys) {
        $source = $repeats[$name]
        if (-not $source.Contains('glyphs')) {
            continue
        }
        $null = New-Item -ItemType Directory -Path $rendered -Force
        $config = Get-Config -Config $source['config']
        foreach ($item in @($config.($source['list']) | Where-Object { -not $source.Contains('where') -or $_.($source['where']) })) {
            $label = [System.Security.SecurityElement]::Escape("$($item.($source['title']))")
            $size = @{ 1 = 11; 2 = 9; 3 = 6.5; 4 = 5 }[[Math]::Min(4, [Math]::Max(1, $label.Length))]
            $stem = Join-Path $rendered "$($source['glyphs'])$($item.($source['key']))"
            $text = "<text x=`"8`" y=`"8`" dominant-baseline=`"central`" text-anchor=`"middle`" font-family=`"Consolas, 'Segoe UI', sans-serif`" font-weight=`"700`" font-size=`"$size`" fill=`"#3fb950`" stroke=`"none`">$label</text>"
            $on = "<svg xmlns=`"http://www.w3.org/2000/svg`" width=`"16`" height=`"16`" viewBox=`"0 0 16 16`" fill=`"none`" stroke=`"#3fb950`" stroke-width=`"1.6`">`n  $text`n</svg>`n"
            $off = "<svg xmlns=`"http://www.w3.org/2000/svg`" width=`"16`" height=`"16`" viewBox=`"0 0 16 16`" fill=`"none`" stroke=`"#1f6f3a`" stroke-linecap=`"round`" stroke-linejoin=`"round`">`n" +
            "  <circle cx=`"8`" cy=`"8`" r=`"7.2`" stroke-width=`"1`" stroke-dasharray=`"3 2.2`">`n    <animateTransform attributeName=`"transform`" type=`"rotate`" from=`"0 8 8`" to=`"360 8 8`" dur=`"2s`" repeatCount=`"indefinite`"/>`n  </circle>`n" +
            "  <g>`n    <animate attributeName=`"opacity`" values=`"1;0.35;1`" dur=`"1.2s`" repeatCount=`"indefinite`"/>`n    $($text.Replace('#3fb950', '#1f6f3a'))`n  </g>`n</svg>`n"
            [System.IO.File]::WriteAllText("$stem-on.svg", $on, $utf8)
            [System.IO.File]::WriteAllText("$stem-off.svg", $off, $utf8)
        }
    }
    $bases = @(if (Test-Path -LiteralPath $rendered) {
            Get-ChildPath $rendered -File -Filter '*-on.svg' -Depth 1
        })
    if ($bases.Count -gt 0) {
        $palette = (Get-Config -Config lamp-palette).ranges
        $stroke = '(?<=<svg [^>]*\bstroke=")#[0-9a-fA-F]{6}|(?<=<text [^>]*\bfill=")#[0-9a-fA-F]{6}'
        $corner = ' data-badge="bottom"'
        $hidden = ' data-empty="hidden"'
        # The staged and unstaged badge is a square, the failed one a dot that blinks while the lamp is unlit; the empty condition has none.
        $square = {
            param($Colour, $Low)
            "  <rect x=`"11.3`" y=`"$(if ($Low) { '11' } else { '0.8' })`" width=`"3.8`" height=`"3.8`" rx=`"0.8`" fill=`"$Colour`" stroke=`"none`"/>`n"
        }
        $dot = {
            param($Colour, $Lit, $Low)
            $centreY = if ($Low) {
                '12.8'
            }
            else {
                '2.8'
            }
            if ($Lit) {
                "  <circle cx=`"13.2`" cy=`"$centreY`" r=`"2.2`" fill=`"$Colour`" stroke=`"none`"/>`n"
            }
            else {
                "  <circle cx=`"13.2`" cy=`"$centreY`" r=`"2.2`" fill=`"$Colour`" stroke=`"none`">`n    <animate attributeName=`"opacity`" values=`"1;0.2;1`" dur=`"0.6s`" repeatCount=`"indefinite`"/>`n  </circle>`n"
            }
        }
        foreach ($base in $bases) {
            $lamp = [System.IO.Path]::GetFileName($base) -replace '-on\.svg$', ''
            $offPath = Join-Path $rendered "$lamp-off.svg"
            if (-not (Test-Path -LiteralPath $offPath)) {
                continue
            }
            $glyphs = @{ on = [System.IO.File]::ReadAllText($base); off = [System.IO.File]::ReadAllText($offPath) }
            foreach ($state in 'on', 'off') {
                $lit = $state -eq 'on'
                $shade = if ($lit) {
                    'glyph_lit'
                }
                else {
                    'glyph_unlit'
                }
                $low = $glyphs[$state].Contains($corner)
                $vanish = $glyphs[$state].Contains($hidden)
                $glyph = $glyphs[$state].Replace($corner, '').Replace($hidden, '')
                [System.IO.File]::WriteAllText((Join-Path $rendered "$lamp-$state.svg"), ($glyph -replace $stroke,
                        $palette['committed'].$shade), $utf8)
                foreach ($condition in 'staged', 'unstaged', 'failed', 'empty') {
                    $range = $palette[$condition]
                    $badge = switch ($condition) {
                        'failed' {
                            & $dot $range.badge $lit $low
                        }
                        'empty' {
                            ''
                        }
                        default {
                            & $square $range.badge $low
                        }
                    }
                    $svg = ($glyph -replace $stroke, $range.$shade) -replace '</svg>\s*$', ($badge + '</svg>')
                    if ($vanish -and $condition -eq 'empty') {
                        $svg = $svg -replace '^<svg ', '<svg opacity="0" '
                    }
                    [System.IO.File]::WriteAllText((Join-Path $rendered "$lamp-$state-$condition.svg"),
                        $svg.TrimEnd() + "`n", $utf8)
                }
            }
            $veto = $glyphs['off'].Replace($corner, '') -replace $stroke, $palette['veto'].glyph_lit
            $veto = $veto -replace 'stroke-width="1" stroke-dasharray="3 2.2"', 'stroke-width="1.4" stroke-dasharray="2 1.4"'
            $veto = $veto -replace 'to="360 8 8" dur="2s"', 'to="-360 8 8" dur="0.8s"'
            $veto = $veto -replace '(?m)^\s*<animate attributeName="opacity"[^>]*/>\r?\n', ''
            $veto = $veto -replace '</svg>\s*$', "  <line x1=`"2.8`" y1=`"13.2`" x2=`"13.2`" y2=`"2.8`" stroke-width=`"1.8`"/>`n</svg>"
            [System.IO.File]::WriteAllText((Join-Path $rendered "$lamp-veto.svg"), $veto.TrimEnd() + "`n", $utf8)
        }
    }
    (Resolve-Path -LiteralPath $folder).Path
}
