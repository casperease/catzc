# FolderWalker lists below a folder to a bounded depth, prunes named folders while it walks, and never follows a link.
Describe 'FolderWalker' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        foreach ($folder in 'widget/gadget/sprocket', 'widget/.vendor', 'widget/node_modules') {
            [System.IO.Directory]::CreateDirectory((Join-Path $root $folder)) | Out-Null
        }
        foreach ($file in 'top.txt', 'top.yml', 'widget/a.txt', 'widget/gadget/b.yml',
            'widget/gadget/sprocket/deep.txt', 'widget/.vendor/v.txt', 'widget/node_modules/n.txt') {
            [System.IO.File]::WriteAllText((Join-Path $root $file), 'x')
        }
        $script:root = $root
        # Relative names, in the ordinal order the walker returns them in.
        $script:relative = {
            param([string[]] $Paths)
            @($Paths | ForEach-Object { $_.Substring($script:root.Length + 1).Replace('\', '/') })
        }
        $script:walk = {
            param([int] $Depth, $Patterns = @('*'), [bool] $Files = $true, [bool] $Directories = $true, $Exclude = @())
            & $script:relative ([Catzc.Base.Folders.FolderWalker]::Walk($script:root, $Depth, [string[]] $Patterns,
                    $Files, $Directories, [string[]] $Exclude))
        }
    }

    It 'lists the direct children only at depth 1' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        & $walk 1 | Should -Be @('top.txt', 'top.yml', 'widget')
    }

    It 'lists one more level at depth 2 and stops there' {
        & $walk 2 | Should -Be @('top.txt', 'top.yml', 'widget', 'widget/.vendor', 'widget/a.txt', 'widget/gadget',
            'widget/node_modules')
    }

    It 'lists every level once the depth reaches the bottom of the tree' {
        (& $walk 4) | Should -Contain 'widget/gadget/sprocket/deep.txt'
        (& $walk 3) | Should -Not -Contain 'widget/gadget/sprocket/deep.txt'
    }

    It 'lists folders only, or files only' {
        & $walk 3 @('*') $false $true @('.vendor', 'node_modules') | Should -Be @('widget', 'widget/gadget',
            'widget/gadget/sprocket')
        & $walk 1 @('*') $true $false | Should -Be @('top.txt', 'top.yml')
    }

    It 'lists nothing when neither files nor folders are asked for' {
        & $walk 3 @('*') $false $false | Should -BeNullOrEmpty
    }

    It 'matches any of several patterns, and still enters a folder whose name does not match' {
        & $walk 3 @('*.yml', 'a.txt') | Should -Be @('top.yml', 'widget/a.txt', 'widget/gadget/b.yml')
    }

    It 'prunes a named folder, so neither it nor anything below it is listed' {
        $listed = & $walk 4 @('*') $true $true @('.vendor', 'node_modules')
        $listed | Should -Not -Contain 'widget/.vendor'
        $listed | Should -Not -Contain 'widget/.vendor/v.txt'
        $listed | Should -Not -Contain 'widget/node_modules/n.txt'
        $listed | Should -Contain 'widget/gadget/sprocket/deep.txt'
    }

    It 'lists files and folders apart in one walk, relative to a given root, the same sets the separate walks list' {
        $widget = Join-Path $script:root 'widget'
        $found = [Catzc.Base.Folders.FolderWalker]::WalkRelative($widget, 3, [string[]] @('node_modules'), $script:root)
        $found[0] | Should -Be @('widget/.vendor/v.txt', 'widget/a.txt', 'widget/gadget/b.yml',
            'widget/gadget/sprocket/deep.txt')
        $found[1] | Should -Be @('widget/.vendor', 'widget/gadget', 'widget/gadget/sprocket')
        $separate = & $script:relative ([Catzc.Base.Folders.FolderWalker]::Walk($widget, 3, [string[]] @('*'), $true,
                $true, [string[]] @('node_modules')))
        @($found[0]) + @($found[1]) | Sort-Object { $_ } -Culture '' |
            Should -Be @($separate | Sort-Object { $_ } -Culture '')
        { [Catzc.Base.Folders.FolderWalker]::WalkRelative((Join-Path $script:root 'absent'), 1, $null, $script:root) } |
            Should -Throw '*does not exist*'
    }

    It 'returns the paths in ordinal order' {
        $listed = & $walk 4
        $sorted = [string[]] $listed.Clone()
        [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
        $listed | Should -Be $sorted
    }

    It 'fails fast on a missing folder and on a depth below 1' -Tag 'ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY' {
        { [Catzc.Base.Folders.FolderWalker]::Walk((Join-Path $root 'gadget-missing'), 1, $null, $true, $true, $null) } |
            Should -Throw '*does not exist*'
        { [Catzc.Base.Folders.FolderWalker]::Walk($root, 0, $null, $true, $true, $null) } | Should -Throw '*at least 1*'
        { [Catzc.Base.Folders.FolderWalker]::Walk('', 1, $null, $true, $true, $null) } |
            Should -Throw '*must not be empty*'
    }

    It 'treats a null pattern list as every name' {
        @([Catzc.Base.Folders.FolderWalker]::Walk($root, 1, $null, $true, $true, $null)).Count | Should -Be 3
    }

    It 'lists a link but does not follow it, so a link back to an ancestor ends the walk' {
        $linkRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $linkRoot 'widget')) | Out-Null
        $linkPath = Join-Path $linkRoot 'widget/loop'
        $made = try {
            New-Item -ItemType ($IsWindows ? 'Junction' : 'SymbolicLink') -Path $linkPath -Target $linkRoot -ErrorAction Stop; $true
        }
        catch {
            $false
        }
        if (-not $made) {
            Set-ItResult -Skipped -Because 'link_creation_not_permitted'; return
        }

        # The link goes before the test ends: Pester's own TestDrive cleanup follows a link, and a cycle never ends.
        try {
            $listed = @([Catzc.Base.Folders.FolderWalker]::Walk($linkRoot, 8, $null, $true, $true, $null))
        }
        finally {
            [System.IO.Directory]::Delete($linkPath)
        }
        $listed | Should -Contain $linkPath
        $listed | Should -HaveCount 2
    }
}
