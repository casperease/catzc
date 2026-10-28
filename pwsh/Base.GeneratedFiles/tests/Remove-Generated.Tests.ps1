Describe 'Remove-Generated' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'widget-repository'
        $script:targets = @(
            [Catzc.Base.Variants.GeneratedTarget]::new('docs/widget.md', 'Build-Widget', 'rollable')
            [Catzc.Base.Variants.GeneratedTarget]::new('docs/missing.md', 'Build-Widget', 'rollable')
            [Catzc.Base.Variants.GeneratedTarget]::new('gadget/**/*.png', 'Build-Gadget', 'rollable')
            [Catzc.Base.Variants.GeneratedTarget]::new('sprocket.yml', 'Build-Sprocket', 'import-critical')
            [Catzc.Base.Variants.GeneratedTarget]::new('cog/price.json', 'Update-Cog', 'snapshot')
        )
        $script:write = {
            param([string] $Path)
            $full = Join-Path $script:root $Path
            [void] [System.IO.Directory]::CreateDirectory((Split-Path $full))
            [System.IO.File]::WriteAllText($full, 'sprocket')
        }
        $script:run = {
            param([hashtable] $Extra = @{})
            InModuleScope Catzc.Base.GeneratedFiles -Parameters @{ Root = $script:root; Extra = $Extra } {
                param($Root, $Extra)
                Remove-Generated -RepositoryRoot $Root @Extra
            }
        }
    }

    BeforeEach {
        Mock Get-GeneratedTarget -ModuleName Catzc.Base.GeneratedFiles { $script:targets }
        Remove-Item -LiteralPath $script:root -Recurse -ErrorAction Ignore
        foreach ($path in 'docs/widget.md', 'docs/authored.md', 'gadget/a/spin.png', 'gadget/spin.png', 'gadget/notes.txt', 'sprocket.yml', 'cog/price.json') {
            & $script:write $path
        }
    }

    It 'deletes the files of rollable targets, literal and wildcard, and answers their paths' {
        $removed = @(& $script:run)
        $removed | Should -Be @('docs/widget.md', 'gadget/a/spin.png', 'gadget/spin.png')
        foreach ($path in $removed) {
            Join-Path $script:root $path | Should -Not -Exist
        }
    }

    It 'keeps every other class and every file no rollable target takes' {
        [void] (& $script:run)
        foreach ($path in 'docs/authored.md', 'gadget/notes.txt', 'sprocket.yml', 'cog/price.json') {
            Join-Path $script:root $path | Should -Exist
        }
    }

    It 'lists and deletes nothing under -WhatIf' {
        [void] (& $script:run @{ WhatIf = $true })
        foreach ($path in 'docs/widget.md', 'gadget/a/spin.png', 'gadget/spin.png') {
            Join-Path $script:root $path | Should -Exist
        }
    }

    It 'answers nothing when no rollable file is present' {
        [void] (& $script:run)
        @(& $script:run) | Should -HaveCount 0
    }
}
