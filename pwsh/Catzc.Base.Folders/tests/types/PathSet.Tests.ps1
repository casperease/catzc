# PathSet holds the files a type owns: named under a base, or found by a pattern through the bounded walker; full paths, sorted, unique.
Describe 'PathSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        foreach ($folder in 'widget/private', 'widget/configs') {
            [System.IO.Directory]::CreateDirectory((Join-Path $root $folder)) | Out-Null
        }
        foreach ($file in 'widget/Get-SpinWidgetFact.ps1', 'widget/Get-WidgetFact.ps1', 'widget/Set-Widget.ps1', 'widget/private/Get-TurnWidgetFact.ps1', 'widget/configs/widget.yml') {
            [System.IO.File]::WriteAllText((Join-Path $root $file), 'x')
        }
        $script:base = Join-Path $root 'widget'
        $script:relative = {
            param([string[]] $Paths)
            @($Paths | ForEach-Object { $_.Substring($script:base.Length + 1).Replace('\', '/') })
        }
    }

    It 'adds a file under a base as its full path, whether or not it exists, since a missing input is an input too' {
        $set = [Catzc.Base.Folders.PathSet]::new().AddFile($script:base, 'configs/widget.yml').AddFile($script:base, 'configs/gadget.yml')
        & $script:relative $set.ToArray() | Should -Be @('configs/gadget.yml', 'configs/widget.yml')
        $set.ToArray() | ForEach-Object { [System.IO.Path]::IsPathFullyQualified($_) | Should -BeTrue }
    }

    It 'adds the files a pattern finds in one folder by default, and the folders below it only at a greater depth' {
        $flat = [Catzc.Base.Folders.PathSet]::new().AddPattern($script:base, 'Get-*WidgetFact.ps1')
        & $script:relative $flat.ToArray() | Should -Be @('Get-SpinWidgetFact.ps1', 'Get-WidgetFact.ps1')
        $deep = [Catzc.Base.Folders.PathSet]::new().AddPattern($script:base, 'Get-*WidgetFact.ps1', 2)
        & $script:relative $deep.ToArray() | Should -Be @('Get-SpinWidgetFact.ps1', 'Get-WidgetFact.ps1', 'private/Get-TurnWidgetFact.ps1')
    }

    It 'adds nothing for a pattern in a folder that does not exist' {
        [Catzc.Base.Folders.PathSet]::new().AddPattern((Join-Path $script:base 'gone'), '*.ps1').Count | Should -Be 0
    }

    It 'holds each path once, in ordinal order, however it was added' {
        $set = [Catzc.Base.Folders.PathSet]::new()
        $null = $set.AddFile($script:base, 'Get-WidgetFact.ps1').AddPattern($script:base, 'Get-*WidgetFact.ps1').AddFile($script:base, './Get-WidgetFact.ps1')
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
