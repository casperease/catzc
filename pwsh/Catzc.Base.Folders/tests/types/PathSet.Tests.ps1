<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-folders/tests/types/PathSet.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'PathSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        foreach ($folder in 'widget/private/deep', 'widget/configs', 'widget/node_modules', 'widget/.vendor') {
            [System.IO.Directory]::CreateDirectory((Join-Path $root $folder)) | Out-Null
        }
        foreach ($file in 'widget/Get-SpinWidgetFact.ps1', 'widget/Get-WidgetFact.ps1', 'widget/Set-Widget.ps1',
            'widget/private/Get-TurnWidgetFact.ps1',
            'widget/private/deep/Get-DeepWidgetFact.ps1', 'widget/configs/widget.yml',
            'widget/node_modules/Get-NodeWidgetFact.ps1', 'widget/.vendor/Get-VendorWidgetFact.ps1') {
            [System.IO.File]::WriteAllText((Join-Path $root $file), 'x')
        }
        $script:base = Join-Path $root 'widget'
        $script:relative = {
            param([string[]] $Paths)
            @($Paths | ForEach-Object { $_.Substring($script:base.Length + 1).Replace('\', '/') })
        }
    }

    It 'adds a file under a base as its full path, whether or not it exists, since a missing input is an input too' {
        $set = [Catzc.Base.Folders.PathSet]::new().AddFile($script:base, 'configs/widget.yml').AddFile($script:base,
            'configs/gadget.yml')
        & $script:relative $set.ToArray() | Should -Be @('configs/gadget.yml', 'configs/widget.yml')
        $set.ToArray() | ForEach-Object { [System.IO.Path]::IsPathFullyQualified($_) | Should -BeTrue }
    }

    It 'walks to the depth declared on FolderWalkConfig by default, and to the depth given, 1 for the folder itself' -Tag 'ADR-PWSH-ENUM-SHALLOWBYDEFAULT' {
        [Catzc.Base.Folders.FolderWalkConfig]::DefaultDepth | Should -Be 2
        $default = [Catzc.Base.Folders.PathSet]::new().AddPattern($script:base, 'Get-*WidgetFact.ps1')
        & $script:relative $default.ToArray() | Should -Be @('Get-SpinWidgetFact.ps1', 'Get-WidgetFact.ps1',
            'private/Get-TurnWidgetFact.ps1')
        $flat = [Catzc.Base.Folders.PathSet]::new().AddPattern($script:base, 'Get-*WidgetFact.ps1', 1)
        & $script:relative $flat.ToArray() | Should -Be @('Get-SpinWidgetFact.ps1', 'Get-WidgetFact.ps1')
    }

    It 'takes its default depth and its pruned names from the config it is given' {
        $deep = [Catzc.Base.Folders.FolderWalkConfig]::new(@{ depth = 3; exclude = @('configs') })
        $set = [Catzc.Base.Folders.PathSet]::new($deep).AddPattern($script:base, 'Get-*WidgetFact.ps1')
        & $script:relative $set.ToArray() | Should -Contain 'private/deep/Get-DeepWidgetFact.ps1'
        & $script:relative $set.ToArray() |
            Should -Contain 'node_modules/Get-NodeWidgetFact.ps1' -Because 'this config prunes configs only'
        [Catzc.Base.Folders.PathSet]::new($deep).AddPattern($script:base, '*.yml').Count | Should -Be 0
    }

    It 'prunes the config''s folder names and the vendor folder, never walking into them' -Tag 'ADR-PWSH-ENUM-PRUNEFOLDERS' {
        $set = [Catzc.Base.Folders.PathSet]::new().AddPattern($script:base, 'Get-*WidgetFact.ps1', 2)
        & $script:relative $set.ToArray() | Should -Not -Contain 'node_modules/Get-NodeWidgetFact.ps1'
        & $script:relative $set.ToArray() | Should -Not -Contain '.vendor/Get-VendorWidgetFact.ps1'
        [Catzc.Base.Folders.PathSet]::Pruned($null) | Should -Contain '.vendor'
        [Catzc.Base.Folders.PathSet]::Pruned($null) | Should -Contain 'node_modules'
    }

    It 'adds nothing for a pattern in a folder that does not exist' {
        [Catzc.Base.Folders.PathSet]::new().AddPattern((Join-Path $script:base 'gone'), '*.ps1').Count | Should -Be 0
    }

    It 'holds each path once, in ordinal order, however it was added' {
        $set = [Catzc.Base.Folders.PathSet]::new()
        $null = $set.AddFile($script:base, 'Get-WidgetFact.ps1').AddPattern($script:base, 'Get-*WidgetFact.ps1',
            1).AddFile($script:base, './Get-WidgetFact.ps1')
        $set.Count | Should -Be 2
        & $script:relative $set.ToArray() | Should -Be @('Get-SpinWidgetFact.ps1', 'Get-WidgetFact.ps1')
    }

    It 'rejects an empty base, path, folder or pattern, naming the argument' {
        { [Catzc.Base.Folders.PathSet]::new().AddFile('', 'a.yml') } | Should -Throw '*baseFolder*'
        { [Catzc.Base.Folders.PathSet]::new().AddFile($script:base, '') } | Should -Throw '*relativePath*'
        { [Catzc.Base.Folders.PathSet]::new().AddPattern('', '*.ps1') } | Should -Throw '*folder*'
        { [Catzc.Base.Folders.PathSet]::new().AddPattern($script:base, '') } | Should -Throw '*pattern*'
    }
}
