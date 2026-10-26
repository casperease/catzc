# A fixture repository is made and moved in with real git (init, mv, ls-files), so the launch is the point of the file: L2.
Describe 'Move-Diagram' -Tag 'L2', 'logic', 'ADR-REPO-SLIDES-ONEBUILDCOMMAND' {
    BeforeAll {
        $script:skip = if (Get-Command git -ErrorAction Ignore) {
            $null
        }
        else {
            'tool_git_missing'
        }
    }

    BeforeEach {
        if ($script:skip) {
            return
        }
        $script:widgetRoot = Join-Path $TestDrive "widget-repository-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
        $files = [ordered]@{
            'docs/widgets/index.md'                 = "# Widgets`n`n![Widget](assets/widget.drawio.png)`n`n[the gadget](../gadgets/index.md) [plain](./plain.md)`n"
            'docs/widgets/plain.md'                 = "# Plain`n`n[up](index.md)`n"
            'docs/widgets/assets/widget.drawio.png' = 'png'
            'docs/widgets/assets/widget.drawio.yml' = "description: A widget.`n"
            'docs/drs/index.md'                     = "# Widget decisions`n"
            'docs/gadgets/index.md'                 = "# Gadgets`n`n![the widget slide](../widgets/assets/widget.drawio.png)`n"
        }
        foreach ($file in $files.Keys) {
            $full = Join-Path $script:widgetRoot $file
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $files[$file])
        }
        foreach ($command in 'git init --quiet', 'git add -A') {
            Invoke-Executable $command -WorkingDirectory $script:widgetRoot -Silent | Out-Null
        }
        Mock Write-Message -ModuleName Catzc.Base.Slides { }
        Mock Format-Code -ModuleName Catzc.Base.Slides { }
        $script:read = { param([string] $File) [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot $File)) }
    }

    It 'moves a diagram pair, named by its stem, with git mv and re-points every page that embeds it' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result = Move-Diagram docs/widgets/assets/widget docs/widgets/.assets/widget -RepositoryRoot $script:widgetRoot -PassThru

        $result.Moves.Count | Should -Be 2
        Test-Path (Join-Path $script:widgetRoot 'docs/widgets/assets/widget.drawio.png') | Should -BeFalse
        $index = @((Invoke-Executable 'git ls-files' -WorkingDirectory $script:widgetRoot -PassThru -Silent).Output -split "`r?`n")
        $index | Should -Contain 'docs/widgets/.assets/widget.drawio.yml'
        $index | Should -Contain 'docs/widgets/.assets/widget.drawio.png'
        $index | Should -Not -Contain 'docs/widgets/assets/widget.drawio.yml'
        & $script:read 'docs/widgets/index.md' |
            Should -BeExactly "# Widgets`n`n![Widget](.assets/widget.drawio.png)`n`n[the gadget](../gadgets/index.md) [plain](./plain.md)`n"
        & $script:read 'docs/gadgets/index.md' |
            Should -BeExactly "# Gadgets`n`n![the widget slide](../widgets/.assets/widget.drawio.png)`n"
        @($result.Pages | Sort-Object) | Should -Be @('docs/gadgets/index.md', 'docs/widgets/index.md')
        @((Test-Links -Path (Join-Path $script:widgetRoot docs) -RepositoryRoot $script:widgetRoot -PassThru 6> $null).Issues) | Should -BeNullOrEmpty
    }

    It 'moves one file under a new name, re-pointing the files that link to it and its own links' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        Move-Diagram docs/widgets/plain.md docs/gadgets/simple.md -RepositoryRoot $script:widgetRoot

        & $script:read 'docs/gadgets/simple.md' | Should -BeExactly "# Plain`n`n[up](../widgets/index.md)`n"
        & $script:read 'docs/widgets/index.md' |
            Should -BeExactly "# Widgets`n`n![Widget](assets/widget.drawio.png)`n`n[the gadget](../gadgets/index.md) [plain](../gadgets/simple.md)`n"
    }

    It 'lists the moves and the pages under -DryRun and changes nothing' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result = Move-Diagram docs/widgets/assets/widget docs/widgets/.assets/widget -RepositoryRoot $script:widgetRoot -DryRun -PassThru

        $result.DryRun | Should -BeTrue
        $result.Moves.To | Should -Contain 'docs/widgets/.assets/widget.drawio.yml'
        Test-Path (Join-Path $script:widgetRoot 'docs/widgets/assets/widget.drawio.yml') | Should -BeTrue
        & $script:read 'docs/widgets/index.md' | Should -Match '\(assets/widget\.drawio\.png\)'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -ParameterFilter { $Message -like 'Would move: *' } -Times 2 -Exactly
    }

    It 'skips a page that the index still holds but the disk no longer does' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        Remove-Item -LiteralPath (Join-Path $script:widgetRoot 'docs/gadgets/index.md')

        $result = Move-Diagram docs/widgets/assets/widget docs/widgets/.assets/widget -RepositoryRoot $script:widgetRoot -DryRun -PassThru

        @($result.Pages) | Should -Be @('docs/widgets/index.md')
    }

    It 'formats every page whose links it re-pointed, and nothing under -DryRun' -Tag 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        Move-Diagram docs/widgets/assets/widget docs/widgets/.assets/widget -RepositoryRoot $script:widgetRoot -DryRun
        Should -Invoke Format-Code -ModuleName Catzc.Base.Slides -Times 0 -Exactly

        Move-Diagram docs/widgets/assets/widget docs/widgets/.assets/widget -RepositoryRoot $script:widgetRoot
        $expected = @('docs/gadgets/index.md',
            'docs/widgets/index.md' | ForEach-Object { [System.IO.Path]::GetFullPath((Join-Path $script:widgetRoot $_)) })
        Should -Invoke Format-Code -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
            $Language -eq 'markdown' -and (@($Path | Sort-Object) -join '|') -eq (@($expected | Sort-Object) -join '|')
        }
    }

    It 'returns no pages under -PassThru when no page links the moved file' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result = Move-Diagram docs/drs/index.md docs/adr/.assets/widget/index.md -RepositoryRoot $script:widgetRoot -DryRun -PassThru

        $result.Moves.To | Should -Be @('docs/adr/.assets/widget/index.md')
        @($result.Pages).Count | Should -Be 0
    }

    It 'refuses a destination that exists, one inside the source, a path outside the repository, and an untracked source' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        { Move-Diagram docs/widgets/assets docs/gadgets -RepositoryRoot $script:widgetRoot } |
            Should -Throw '*already exists*'
        { Move-Diagram docs/widgets/assets/widget.drawio.png docs/widgets/assets/widget -RepositoryRoot $script:widgetRoot } | Should -Throw '*lies inside it*'
        { Move-Diagram docs/widgets/assets docs/widgets/assets/inner -RepositoryRoot $script:widgetRoot } |
            Should -Throw '*lies inside it*'
        { Move-Diagram docs/widgets/assets ../elsewhere -RepositoryRoot $script:widgetRoot } |
            Should -Throw '*inside the repository*'
        { Move-Diagram docs/nothing docs/somewhere -RepositoryRoot $script:widgetRoot } |
            Should -Throw '*holds no tracked file*'
    }
}

# L2: real git (init, mv, ls-files) and the kit's own rekey through uv edit the fixture tree.
Describe 'Move-Diagram — an article-carried diagram' -Tag 'L2', 'logic', 'source-only', 'ADR-REPO-SLIDES-DECLARATION' {
    BeforeAll {
        $script:skip = if (Get-Command git -ErrorAction Ignore) {
            $null
        }
        else {
            'tool_git_missing'
        }
    }

    BeforeEach {
        if ($script:skip) {
            return
        }
        $script:widgetRoot = Join-Path $TestDrive "widget-repository-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
        $script:block = "``````yml drawio`ncontent: { title: Gadget }`n```````n`n"
        $files = [ordered]@{
            'python/diagrams/configs/drawio.yml'     = "renderer:`n  carrier: file # the default`nroles: # by stem`n  docs/widgets/.assets/gadget: legend`n"
            'docs/widgets/gadget.md'                 = "# Gadget`n`n$($script:block)![Gadget](.assets/gadget.drawio.png)`n"
            'docs/widgets/.assets/gadget.drawio.png' = 'png'
            'docs/gadgets/gadget.md'                 = "# Gadget here`n`n![Gadget](../widgets/.assets/gadget.drawio.png)`n"
            'docs/drs/index.md'                      = "# Widget decisions`n"
        }
        foreach ($file in $files.Keys) {
            $full = Join-Path $script:widgetRoot $file
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $files[$file])
        }
        foreach ($command in 'git init --quiet', 'git add -A') {
            Invoke-Executable $command -WorkingDirectory $script:widgetRoot -Silent | Out-Null
        }
        Mock Write-Message -ModuleName Catzc.Base.Slides { }
        Mock Format-Code -ModuleName Catzc.Base.Slides { }
        $script:read = { param([string] $File) [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot $File)) }
    }

    It 'moves its block to the page beside the new .assets that embeds the png, and re-keys its role through the kit' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        Move-Diagram docs/widgets/.assets/gadget docs/gadgets/.assets/gadget -RepositoryRoot $script:widgetRoot -Kit python/diagrams

        & $script:read 'docs/gadgets/gadget.md' |
            Should -BeExactly "# Gadget here`n`n$($script:block)![Gadget](.assets/gadget.drawio.png)`n"
        & $script:read 'docs/widgets/gadget.md' |
            Should -BeExactly "# Gadget`n`n![Gadget](../gadgets/.assets/gadget.drawio.png)`n"
        & $script:read 'python/diagrams/configs/drawio.yml' |
            Should -BeExactly "renderer:`n  carrier: file # the default`nroles: # by stem`n  docs/gadgets/.assets/gadget: legend`n"
        Test-Path (Join-Path $script:widgetRoot 'docs/gadgets/.assets/gadget.drawio.png') | Should -BeTrue
    }

    It 'moves its block to a target page whose image already points at the new .assets, a page with no link to re-point' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadgets/gadget.md'),
            "# Gadget here`n`n![Gadget](.assets/gadget.drawio.png)`n")
        Invoke-Executable 'git add -A' -WorkingDirectory $script:widgetRoot -Silent | Out-Null

        Move-Diagram docs/widgets/.assets/gadget docs/gadgets/.assets/gadget -RepositoryRoot $script:widgetRoot -Kit python/diagrams

        & $script:read 'docs/gadgets/gadget.md' |
            Should -BeExactly "# Gadget here`n`n$($script:block)![Gadget](.assets/gadget.drawio.png)`n"
        & $script:read 'docs/widgets/gadget.md' |
            Should -BeExactly "# Gadget`n`n![Gadget](../gadgets/.assets/gadget.drawio.png)`n"
    }

    It 'refuses, changing nothing, when no page beside the new .assets embeds the png' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        { Move-Diagram docs/widgets/.assets/gadget docs/drs/.assets/gadget -RepositoryRoot $script:widgetRoot -Kit python/diagrams } | Should -Throw '*Carry it to the file carrier first*'
        & $script:read 'docs/widgets/gadget.md' |
            Should -BeExactly "# Gadget`n`n$($script:block)![Gadget](.assets/gadget.drawio.png)`n"
        Test-Path (Join-Path $script:widgetRoot 'docs/widgets/.assets/gadget.drawio.png') | Should -BeTrue
        & $script:read 'python/diagrams/configs/drawio.yml' | Should -Match 'docs/widgets/\.assets/gadget: legend'
    }
}
