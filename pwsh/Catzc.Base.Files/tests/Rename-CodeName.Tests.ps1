<#
---
catzc:
  immutable:
    with_body_sha: f9b8a94be208
  edges:
    code: pwsh/Catzc.Base.Files/Rename-CodeName.ps1
---
#>

Describe 'Rename-CodeName' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $files = [ordered]@{
            'widgets/Get-WidgetSet.ps1'     = "function Get-WidgetSet { [Catzc.Widget.WidgetConfig]::new() }`r`nGet-WidgetSets`r`n"
            'widgets/types/WidgetConfig.cs' = "public sealed class WidgetConfig { WidgetConfigs list; GadgetWidgetConfig other; }`n"
            'docs/widget.md'                = "Run Get-WidgetSet; the -WidgetRoot path; read widget.yml, not widgets.yml.`n"
            '.claude/learnings/learned.md'  = "Get-WidgetSet was named once.`n"
            'assets/widget.bin'             = "Get-WidgetSet`0"
        }
        foreach ($relative in $files.Keys) {
            $full = Join-Path $script:root $relative
            $null = New-Item -ItemType File -Path $full -Force
            [System.IO.File]::WriteAllText($full, $files[$relative], [System.Text.UTF8Encoding]::new($false))
        }
        $bom = Join-Path $script:root 'widgets/Bom.ps1'
        [System.IO.File]::WriteAllText($bom, "Get-WidgetSet`n", [System.Text.UTF8Encoding]::new($true))
        $script:tracked = @($files.Keys) + 'widgets/Bom.ps1' + 'docs/deleted.md'
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Files { $script:root }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Files { $script:tracked }
        $script:map = [ordered]@{ 'Get-WidgetSet' = 'Get-GadgetSet'; 'WidgetConfig' = 'GadgetConfig'; '-WidgetRoot' = '-GadgetRoot'; 'widget.yml' = 'gadget.yml' }
        $script:read = { param([string] $Relative) [System.IO.File]::ReadAllText((Join-Path $script:root $Relative)) }
    }

    It 'renames whole tokens and leaves a name inside a longer one alone' {
        $null = Rename-CodeName $script:map
        & $script:read 'widgets/Get-WidgetSet.ps1' | Should -BeExactly "function Get-GadgetSet { [Catzc.Widget.GadgetConfig]::new() }`r`nGet-WidgetSets`r`n"
        & $script:read 'widgets/types/WidgetConfig.cs' | Should -BeExactly "public sealed class GadgetConfig { WidgetConfigs list; GadgetWidgetConfig other; }`n"
    }

    It 'renames a parameter name and a file name given with their punctuation' {
        $null = Rename-CodeName $script:map
        & $script:read 'docs/widget.md' | Should -BeExactly "Run Get-GadgetSet; the -GadgetRoot path; read gadget.yml, not widgets.yml.`n"
    }

    It 'reports each changed file with its count, and nothing for a file without the names' {
        $rows = @(Rename-CodeName $script:map -DryRun)
        ($rows | Where-Object Path -eq 'widgets/Get-WidgetSet.ps1').Count | Should -Be 2
        ($rows | Where-Object Path -eq 'docs/widget.md').Count | Should -Be 3
        $rows.Path | Should -Not -Contain 'assets/widget.bin'
    }

    It 'writes nothing under -DryRun' {
        $null = Rename-CodeName $script:map -DryRun
        & $script:read 'docs/widget.md' | Should -BeExactly "Run Get-WidgetSet; the -WidgetRoot path; read widget.yml, not widgets.yml.`n"
    }

    It 'leaves the history logs, binaries and deleted files alone by default' {
        $rows = @(Rename-CodeName $script:map)
        $rows.Path | Should -Not -Contain '.claude/learnings/learned.md'
        & $script:read '.claude/learnings/learned.md' | Should -BeExactly "Get-WidgetSet was named once.`n"
        [System.IO.File]::ReadAllText((Join-Path $script:root 'assets/widget.bin')) | Should -BeExactly "Get-WidgetSet`0"
    }

    It 'keeps a byte order mark where the file had one' {
        $null = Rename-CodeName $script:map
        $bytes = [System.IO.File]::ReadAllBytes((Join-Path $script:root 'widgets/Bom.ps1'))
        $bytes[0..2] | Should -Be @(0xEF, 0xBB, 0xBF)
        [System.Text.Encoding]::UTF8.GetString($bytes, 3, $bytes.Length - 3) | Should -BeExactly "Get-GadgetSet`n"
    }

    It 'refuses a map row whose new name is empty or the same' {
        { Rename-CodeName @{ 'Get-WidgetSet' = '' } } | Should -Throw '*non-empty old name and a different non-empty new name*'
        { Rename-CodeName @{ 'Get-WidgetSet' = 'Get-WidgetSet' } } | Should -Throw '*different non-empty new name*'
    }
}
