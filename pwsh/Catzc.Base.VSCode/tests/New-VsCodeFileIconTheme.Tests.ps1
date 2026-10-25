Describe 'New-VsCodeFileIconTheme' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:glyphs = Join-Path $TestDrive 'glyphs'
        $null = New-Item -ItemType Directory -Path $script:glyphs
        Set-Content -LiteralPath (Join-Path $script:glyphs 'gadget-on.svg') -Value '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" stroke="#000000" data-badge="bottom"><path d="M1 1h4"/></svg>'
        $script:config = [Catzc.Base.VSCode.FileIconsConfig]::new([ordered]@{ icons = [ordered]@{
                    widget     = [ordered]@{ glyph = 'gadget'; color = '#abcdef'; extensions = @('wdg', 'tests.wdg') }
                    sprocket   = [ordered]@{ label = 'S&P'; color = '#123456'; names = @('.gadget') }
                    cog        = [ordered]@{ label = 'COG'; style = 'prompt'; color = '#654321'; language = 'cogs'; language_ids = @('cog-flavour') }
                    'cog-test' = [ordered]@{ label = 'CT'; color = '#654321'; extensions = @('gear') }
                }
            })
        $script:languages = @([pscustomobject]@{ name = 'cogs'; extensions = @('.cog', '.GEAR') })
        $script:media = Join-Path $TestDrive 'media'
        $script:theme = InModuleScope Catzc.Base.VSCode -Parameters @{ Media = $script:media; Config = $script:config; Glyphs = $script:glyphs; Languages = $script:languages } {
            param($Media, $Config, $Glyphs, $Languages)
            New-VsCodeFileIconTheme -MediaDirectory $Media -Config $Config -GlyphDirectory $Glyphs -Languages $Languages
        }
    }

    It 'takes a language''s extensions from the language system, except one another icon names itself, and maps a language id' {
        $json = Get-Content -LiteralPath $script:theme -Raw | ConvertFrom-Json -AsHashtable
        $json.fileExtensions['cog'] | Should -Be 'cog'
        $json.fileExtensions['gear'] | Should -Be 'cog-test'
        $json.languageIds['cog-flavour'] | Should -Be 'cog'
    }

    It 'draws a prompt label over a console chevron, and a text label as its characters alone' {
        Get-Content -LiteralPath (Join-Path $script:media 'cog.svg') -Raw | Should -BeLike '*<path d="M6.6 11.4*'
        Get-Content -LiteralPath (Join-Path $script:media 'sprocket.svg') -Raw | Should -Not -BeLike '*<path*'
    }

    It 'maps every extension and file name to its icon, with the plain file as the fallback and no folder icon' {
        $json = Get-Content -LiteralPath $script:theme -Raw | ConvertFrom-Json -AsHashtable
        $json.fileExtensions['wdg'] | Should -Be 'widget'
        $json.fileExtensions['tests.wdg'] | Should -Be 'widget'
        $json.fileNames['.gadget'] | Should -Be 'sprocket'
        $json.file | Should -Be '_file'
        $json.ContainsKey('folder') | Should -BeFalse
        $json.ContainsKey('folderExpanded') | Should -BeFalse
        Get-Content -LiteralPath (Join-Path $script:media '_file.svg') -Raw | Should -BeLike '*d="M8 8h0"*'
        foreach ($name in $json.iconDefinitions.Keys) {
            Join-Path $script:media "$name.svg" | Should -Exist
        }
    }

    It 'recolours a glyph and drops its badge marker, and escapes a label' {
        $glyph = Get-Content -LiteralPath (Join-Path $script:media 'widget.svg') -Raw
        $glyph | Should -BeLike '*stroke="#abcdef"*'
        $glyph | Should -Not -BeLike '*data-badge*'
        Get-Content -LiteralPath (Join-Path $script:media 'sprocket.svg') -Raw | Should -BeLike '*>S&amp;P</text>*'
    }

    It 'throws on a glyph that has no lamp SVG' {
        $missing = [Catzc.Base.VSCode.FileIconsConfig]::new([ordered]@{ icons = [ordered]@{ widget = [ordered]@{ glyph = 'nothing'; color = '#abcdef'; extensions = @('wdg') } } })
        { InModuleScope Catzc.Base.VSCode -Parameters @{ Media = (Join-Path $TestDrive 'other'); Config = $missing; Glyphs = $script:glyphs } {
                param($Media, $Config, $Glyphs)
                New-VsCodeFileIconTheme -MediaDirectory $Media -Config $Config -GlyphDirectory $Glyphs -Languages @()
            } } | Should -Throw "*names glyph 'nothing'*"
    }

    It 'throws on a language the language system does not declare' {
        $unknown = [Catzc.Base.VSCode.FileIconsConfig]::new([ordered]@{ icons = [ordered]@{ widget = [ordered]@{ label = 'W'; color = '#abcdef'; language = 'nothing' } } })
        { InModuleScope Catzc.Base.VSCode -Parameters @{ Media = (Join-Path $TestDrive 'unknown'); Config = $unknown; Languages = $script:languages } {
                param($Media, $Config, $Languages)
                New-VsCodeFileIconTheme -MediaDirectory $Media -Config $Config -Languages $Languages
            } } | Should -Throw "*names language 'nothing'*"
    }
}

Describe 'New-VsCodeFileIconTheme — real file-icons.yml' -Tag 'L1', 'integrity' {
    It 'gives every file type tracked in the repository an icon' {
        $theme = InModuleScope Catzc.Base.VSCode -Parameters @{ Media = (Join-Path $TestDrive 'shipped') } {
            param($Media)
            New-VsCodeFileIconTheme -MediaDirectory $Media
        }
        $json = Get-Content -LiteralPath $theme -Raw | ConvertFrom-Json -AsHashtable
        $missing = @(git -C (Get-RepositoryRoot) ls-files | ForEach-Object {
                $leaf = ($_ -split '/')[-1]
                $parts = $leaf.ToLowerInvariant().Split('.')
                $marked = $json.fileNames.ContainsKey($leaf)
                for ($i = 1; -not $marked -and $i -lt $parts.Count; $i++) {
                    $marked = $json.fileExtensions.ContainsKey(($parts[$i..($parts.Count - 1)] -join '.'))
                }
                if (-not $marked -and $parts.Count -gt 1 -and $parts[0]) {
                    ".$($parts[-1])"
                }
            } | Sort-Object -Unique)
        $missing | Should -BeNullOrEmpty -Because 'each tracked extension needs an entry in file-icons.yml'
    }
}
