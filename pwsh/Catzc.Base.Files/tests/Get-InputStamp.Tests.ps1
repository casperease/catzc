Describe 'Get-InputStamp' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:widget = Join-Path $TestDrive 'widget.txt'
        $script:gadgets = Join-Path $TestDrive 'gadgets'
        [System.IO.Directory]::CreateDirectory((Join-Path $gadgets 'deep')) | Out-Null
        [System.IO.File]::WriteAllText($widget, 'one')
        [System.IO.File]::WriteAllText((Join-Path $gadgets 'a.md'), 'a')
        [System.IO.File]::WriteAllText((Join-Path $gadgets 'deep/b.txt'), 'b')
    }

    It 'returns a 64-character lowercase hex string' {
        Get-InputStamp $widget | Should -MatchExactly '^[0-9a-f]{64}$'
    }

    It 'is stable across calls and across path order' {
        $first = Get-InputStamp $widget, $gadgets
        Get-InputStamp $gadgets, $widget | Should -BeExactly $first
        Get-InputStamp $widget, $gadgets | Should -BeExactly $first
    }

    It 'changes when a file changes, even to a text of the same length' {
        $before = Get-InputStamp $widget
        [System.IO.File]::WriteAllText($widget, 'two')
        Get-InputStamp $widget | Should -Not -BeExactly $before
    }

    It 'does not change when a file is only touched' {
        $before = Get-InputStamp $widget
        [System.IO.File]::SetLastWriteTimeUtc($widget, [datetime]::UtcNow.AddHours(-3))
        Get-InputStamp $widget | Should -BeExactly $before
    }

    It 'does not change between LF and CRLF line endings' {
        [System.IO.File]::WriteAllText($widget, "one`ntwo`n")
        $lf = Get-InputStamp $widget
        [System.IO.File]::WriteAllText($widget, "one`r`ntwo`r`n")
        Get-InputStamp $widget | Should -BeExactly $lf
    }

    It 'names paths relative to -Root, so the same tree in another place stamps the same' {
        $copy = Join-Path $TestDrive 'copy'
        Copy-Item $gadgets (Join-Path $copy 'gadgets') -Recurse
        Get-InputStamp $gadgets -Root $TestDrive | Should -BeExactly (Get-InputStamp (Join-Path $copy 'gadgets') -Root $copy)
    }

    It 'includes files below a folder, recursively' {
        $before = Get-InputStamp $gadgets
        [System.IO.File]::WriteAllText((Join-Path $gadgets 'deep/c.txt'), 'c')
        Get-InputStamp $gadgets | Should -Not -BeExactly $before
    }

    It '-Filter narrows a folder to the matching names' {
        $before = Get-InputStamp $gadgets -Filter '*.md'
        [System.IO.File]::WriteAllText((Join-Path $gadgets 'deep/c.txt'), 'c')
        Get-InputStamp $gadgets -Filter '*.md' | Should -BeExactly $before
        [System.IO.File]::WriteAllText((Join-Path $gadgets 'd.md'), 'd')
        Get-InputStamp $gadgets -Filter '*.md' | Should -Not -BeExactly $before
    }

    It 'a missing path stamps differently from a present one, and a deleted input changes the stamp' {
        $before = Get-InputStamp $widget
        Remove-Item $widget
        Get-InputStamp $widget | Should -Not -BeExactly $before
    }

    It '-Exclude leaves a file out of a folder, so writing it does not change the stamp' {
        $output = Join-Path $gadgets 'out.md'
        [System.IO.File]::WriteAllText($output, 'one')
        $before = Get-InputStamp $gadgets -Exclude $output
        [System.IO.File]::WriteAllText($output, 'a longer output')
        Get-InputStamp $gadgets -Exclude $output | Should -BeExactly $before
        Get-InputStamp $gadgets | Should -Not -BeExactly $before
    }

    It '-Salt is folded into the stamp' {
        Get-InputStamp $widget -Salt 'x' | Should -Not -BeExactly (Get-InputStamp $widget -Salt 'y')
    }

    Context '-By Metadata' {
        It 'changes when a file is only touched' {
            $before = Get-InputStamp $widget -By Metadata
            [System.IO.File]::SetLastWriteTimeUtc($widget, [datetime]::UtcNow.AddHours(-3))
            Get-InputStamp $widget -By Metadata | Should -Not -BeExactly $before
        }

        It 'keeps the stamp while the last write and the size stay the same, whatever the content' {
            $written = [datetime]::UtcNow.AddHours(-1)
            [System.IO.File]::SetLastWriteTimeUtc($widget, $written)
            $before = Get-InputStamp $widget -By Metadata
            [System.IO.File]::WriteAllText($widget, 'two')
            [System.IO.File]::SetLastWriteTimeUtc($widget, $written)
            Get-InputStamp $widget -By Metadata | Should -BeExactly $before
        }

        It 'names paths relative to -Root, so the same tree with the same metadata in another place stamps the same' {
            $copy = Join-Path $TestDrive 'metadata-copy'
            Remove-Item -LiteralPath $copy -Recurse -Force -ErrorAction Ignore
            [void] [System.IO.Directory]::CreateDirectory($copy)
            Copy-Item $gadgets (Join-Path $copy 'gadgets') -Recurse
            foreach ($file in Get-ChildItem $gadgets -Recurse -File) {
                $twin = Join-Path $copy ([System.IO.Path]::GetRelativePath($TestDrive, $file.FullName))
                [System.IO.File]::SetLastWriteTimeUtc($twin, $file.LastWriteTimeUtc)
            }
            Get-InputStamp $gadgets -Root $TestDrive -By Metadata | Should -BeExactly (Get-InputStamp (Join-Path $copy 'gadgets') -Root $copy -By Metadata)
        }

        It 'stamps by content when -By is not given' {
            Get-InputStamp $widget | Should -BeExactly (Get-InputStamp $widget -By Content)
        }
    }
}
