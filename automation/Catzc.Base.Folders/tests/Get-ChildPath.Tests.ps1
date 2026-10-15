<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
    kind: other
---
#>

Describe 'Get-ChildPath' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        foreach ($folder in 'widget/gadget/sprocket', 'widget/.vendor') {
            [System.IO.Directory]::CreateDirectory((Join-Path $root $folder)) | Out-Null
        }
        foreach ($file in 'top.txt', 'widget/a.yml', 'widget/gadget/b.yml', 'widget/gadget/sprocket/deep.yml', 'widget/.vendor/v.yml') {
            [System.IO.File]::WriteAllText((Join-Path $root $file), 'x')
        }
        $script:root = $root
        $script:relative = {
            param([string[]] $Paths)
            @($Paths | ForEach-Object { $_.Substring($script:root.Length + 1).Replace('\', '/') })
        }
    }

    It 'lists files and folders when neither switch is given, and both when both are' {
        $none = & $relative (Get-ChildPath $root -Depth 1 -Exclude @() -PruneVendor $false)
        $both = & $relative (Get-ChildPath $root -Depth 1 -Exclude @() -PruneVendor $false -Directory -File)
        $none | Should -Be @('top.txt', 'widget')
        $both | Should -Be $none
    }

    It 'lists folders only with -Directory and files only with -File' {
        & $relative (Get-ChildPath $root -Depth 2 -Directory -Exclude @() -PruneVendor $false) | Should -Be @('widget', 'widget/.vendor', 'widget/gadget')
        & $relative (Get-ChildPath $root -Depth 2 -File -Exclude @() -PruneVendor $false) | Should -Be @('top.txt', 'widget/a.yml')
    }

    It 'filters by wildcard and stops at the depth it is given' {
        & $relative (Get-ChildPath $root -Depth 3 -File -Filter '*.yml' -Exclude @() -PruneVendor $false) |
            Should -Be @('widget/.vendor/v.yml', 'widget/a.yml', 'widget/gadget/b.yml')
    }

    It 'prunes the vendor folder when asked to and enters it when not' -Tag 'ADR-PWSH-PARAM#4' {
        (& $relative (Get-ChildPath $root -Depth 3 -File -Exclude @() -PruneVendor $true)) | Should -Not -Contain 'widget/.vendor/v.yml'
        (& $relative (Get-ChildPath $root -Depth 3 -File -Exclude @() -PruneVendor $false)) | Should -Contain 'widget/.vendor/v.yml'
    }

    It 'prunes the folder names it is given' {
        (& $relative (Get-ChildPath $root -Depth 3 -File -Exclude @('gadget') -PruneVendor $false)) | Should -Not -Contain 'widget/gadget/b.yml'
    }

    It 'takes the path as its first positional argument' {
        @(Get-ChildPath $root -Depth 1 -Exclude @() -PruneVendor $false).Count | Should -Be 2
    }

    It 'fails fast on a folder that does not exist' -Tag 'ADR-AUTO-FAILFAST' {
        { Get-ChildPath (Join-Path $root 'gadget-missing') -Depth 1 -Exclude @() -PruneVendor $false } | Should -Throw '*does not exist*'
    }
}

Describe 'Get-ChildPath (shipped folder-walk.yml)' -Tag 'L1', 'integrity' {
    BeforeAll {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'widget/gadget/sprocket')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $root '.vendor')) | Out-Null
        foreach ($file in 'widget/a.txt', 'widget/gadget/b.txt', 'widget/gadget/sprocket/deep.txt', '.vendor/v.txt') {
            [System.IO.File]::WriteAllText((Join-Path $root $file), 'x')
        }
        $script:root = $root
    }

    It 'defaults to two levels, so the third is never loaded' -Tag 'ADR-AUTO-DEFAULT#6', 'ADR-PWSH-PARAM#4' {
        @(Get-ChildPath $root -File).Count | Should -Be 1
        @(Get-ChildPath $root -File -Depth 3).Count | Should -Be 2
        @(Get-ChildPath $root -File -Depth 4).Count | Should -Be 3
    }

    It 'prunes the vendor folder by default, from the registry value' -Tag 'ADR-AUTO-DEFAULT#6' {
        (Get-ChildPath $root -Directory) | Should -Not -Contain (Join-Path $root '.vendor')
        (Get-ChildPath $root -Directory -PruneVendor $false) | Should -Contain (Join-Path $root '.vendor')
    }
}
