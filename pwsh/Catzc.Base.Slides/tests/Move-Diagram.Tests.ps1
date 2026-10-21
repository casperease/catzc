<#
---
catzc:
  immutable:
    with_body_sha: "9c874fec3f74"
  edges:
    code: pwsh/Catzc.Base.Slides/Move-Diagram.ps1
    cites:
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
      - ADR-REPO-SLIDES-ONEBUILDCOMMAND
---
#>

Describe 'Move-Diagram' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-ONEBUILDCOMMAND' {
    BeforeEach {
        $script:widgetRoot = Join-Path $TestDrive "widget-repository-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
        $files = [ordered]@{
            'docs/widgets/index.md'                         = "# Widgets`n`n![Widget](assets/widget/diagram.drawio.png)`n`n[the gadget](../gadgets/index.md) [plain](./plain.md)`n"
            'docs/widgets/plain.md'                         = "# Plain`n`n[up](index.md)`n"
            'docs/widgets/assets/widget/diagram.drawio.png' = 'png'
            'docs/widgets/assets/widget/diagram.drawio.yml' = "description: A widget.`n"
            'docs/adr/index.md'                             = "# Widget decisions`n"
            'docs/gadgets/index.md'                         = "# Gadgets`n`n![the widget slide](../widgets/assets/widget/diagram.drawio.png)`n"
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

    It 'moves a diagram folder with git mv and re-points every page that embeds it' {
        $result = Move-Diagram docs/widgets/assets/widget docs/widgets/.assets/widget -RepositoryRoot $script:widgetRoot -PassThru

        $result.Moves.Count | Should -Be 2
        Test-Path (Join-Path $script:widgetRoot 'docs/widgets/assets/widget') | Should -BeFalse
        $index = @((Invoke-Executable 'git ls-files' -WorkingDirectory $script:widgetRoot -PassThru -Silent).Output -split "`r?`n")
        $index | Should -Contain 'docs/widgets/.assets/widget/diagram.drawio.yml'
        $index | Should -Not -Contain 'docs/widgets/assets/widget/diagram.drawio.yml'
        & $script:read 'docs/widgets/index.md' | Should -BeExactly "# Widgets`n`n![Widget](.assets/widget/diagram.drawio.png)`n`n[the gadget](../gadgets/index.md) [plain](./plain.md)`n"
        & $script:read 'docs/gadgets/index.md' | Should -BeExactly "# Gadgets`n`n![the widget slide](../widgets/.assets/widget/diagram.drawio.png)`n"
        @($result.Pages | Sort-Object) | Should -Be @('docs/gadgets/index.md', 'docs/widgets/index.md')
        @((Test-Links -Path (Join-Path $script:widgetRoot docs) -RepositoryRoot $script:widgetRoot -PassThru 6> $null).Issues) | Should -BeNullOrEmpty
    }

    It 'moves one file under a new name, re-pointing the files that link to it and its own links' {
        Move-Diagram docs/widgets/plain.md docs/gadgets/simple.md -RepositoryRoot $script:widgetRoot

        & $script:read 'docs/gadgets/simple.md' | Should -BeExactly "# Plain`n`n[up](../widgets/index.md)`n"
        & $script:read 'docs/widgets/index.md' | Should -BeExactly "# Widgets`n`n![Widget](assets/widget/diagram.drawio.png)`n`n[the gadget](../gadgets/index.md) [plain](../gadgets/simple.md)`n"
    }

    It 'lists the moves and the pages under -DryRun and changes nothing' {
        $result = Move-Diagram docs/widgets/assets/widget docs/widgets/.assets/widget -RepositoryRoot $script:widgetRoot -DryRun -PassThru

        $result.DryRun | Should -BeTrue
        $result.Moves.To | Should -Contain 'docs/widgets/.assets/widget/diagram.drawio.yml'
        Test-Path (Join-Path $script:widgetRoot 'docs/widgets/assets/widget/diagram.drawio.yml') | Should -BeTrue
        & $script:read 'docs/widgets/index.md' | Should -Match '\(assets/widget/diagram\.drawio\.png\)'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Slides -ParameterFilter { $Message -like 'Would move: *' } -Times 2 -Exactly
    }

    It 'formats every page whose links it re-pointed, and nothing under -DryRun' -Tag 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
        Move-Diagram docs/widgets/assets/widget docs/widgets/.assets/widget -RepositoryRoot $script:widgetRoot -DryRun
        Should -Invoke Format-Code -ModuleName Catzc.Base.Slides -Times 0 -Exactly

        Move-Diagram docs/widgets/assets/widget docs/widgets/.assets/widget -RepositoryRoot $script:widgetRoot
        $expected = @('docs/gadgets/index.md', 'docs/widgets/index.md' | ForEach-Object { [System.IO.Path]::GetFullPath((Join-Path $script:widgetRoot $_)) })
        Should -Invoke Format-Code -ModuleName Catzc.Base.Slides -Times 1 -Exactly -ParameterFilter {
            $Language -eq 'markdown' -and (@($Path | Sort-Object) -join '|') -eq (@($expected | Sort-Object) -join '|')
        }
    }

    It 'returns no pages under -PassThru when no page links the moved file' {
        $result = Move-Diagram docs/adr/index.md docs/adr/.assets/widget/index.md -RepositoryRoot $script:widgetRoot -DryRun -PassThru

        $result.Moves.To | Should -Be @('docs/adr/.assets/widget/index.md')
        @($result.Pages).Count | Should -Be 0
    }

    It 'refuses a destination that exists, one inside the source, a path outside the repository, and an untracked source' {
        { Move-Diagram docs/widgets/assets/widget docs/gadgets -RepositoryRoot $script:widgetRoot } | Should -Throw '*already exists*'
        { Move-Diagram docs/widgets/assets docs/widgets/assets/inner -RepositoryRoot $script:widgetRoot } | Should -Throw '*lies inside it*'
        { Move-Diagram docs/widgets/assets ../elsewhere -RepositoryRoot $script:widgetRoot } | Should -Throw '*inside the repository*'
        { Move-Diagram docs/nothing docs/somewhere -RepositoryRoot $script:widgetRoot } | Should -Throw '*holds no tracked file*'
    }
}
