Describe 'Format-Links -MoveMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:writeFile = {
            param([string] $Root, [string] $Relative, [string] $Text)
            $full = Join-Path $Root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $Text)
        }
        $script:readFile = {
            param([string] $Root, [string] $Relative)
            [System.IO.File]::ReadAllText((Join-Path $Root $Relative))
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        & $script:writeFile $script:root 'docs/drs/index.md' "| Code | ADR |`n| ---- | --- |`n| ``ADR-TST-GADGET`` | [gadget-rules](gadget/gadget-rules.md) |`n"
        & $script:writeFile $script:root 'docs/drs/gadget/gadget-rules.md' "# Gadget rules`n`n### Rule ADR-TST-GADGET-TURN`n`nOne.`n"
        # The widget page moved from docs/old/widget.md to docs/pages/widget.md, as a rename leaves it: moved, its text untouched.
        & $script:writeFile $script:root 'docs/pages/widget.md' "# Widget`n`nSee [gadget](../drs/gadget/gadget-rules.md#rule-adr-tst-gadget-turn).`n"
        & $script:writeFile $script:root 'docs/guide.md' "# Guide`n`nRead [the widget](old/widget.md#spin) and [the index](./drs/index.md).`n"
        $script:map = Join-Path $TestDrive "$([guid]::NewGuid().ToString('N')).csv"
        [System.IO.File]::WriteAllText($script:map, "old,new`ndocs/old/widget.md,docs/pages/widget.md`n")
    }

    It 're-points a link to a moved page relative to the file that holds it, its anchor kept' -Tag 'PDR-ONELIVE-ONEVERSION' {
        Format-Links -RepositoryRoot $script:root -Path (Join-Path $script:root 'docs') -MoveMap $script:map | Out-Null
        & $script:readFile $script:root 'docs/guide.md' | Should -Match ([regex]::Escape('[the widget](pages/widget.md#spin)'))
    }

    It 'rewrites the links of a moved page from where it stands now, though their targets stayed' {
        Format-Links -RepositoryRoot $script:root -Path (Join-Path $script:root 'docs') -MoveMap $script:map | Out-Null
        & $script:readFile $script:root 'docs/pages/widget.md' |
            Should -BeLike '*(../drs/gadget/gadget-rules.md#rule-adr-tst-gadget-turn)*' -Because 'the page sits as deep as before'
    }

    It 'leaves a link neither end of which moved as written, however it is spelled' {
        Format-Links -RepositoryRoot $script:root -Path (Join-Path $script:root 'docs') -MoveMap $script:map | Out-Null
        & $script:readFile $script:root 'docs/guide.md' | Should -Match ([regex]::Escape('[the index](./drs/index.md)'))
    }

    It 'writes nothing under -DryRun and names the files it would re-point under -PassThru' -Tag 'ADR-AUTO-DRYRUN-SIDEEFFECTSTAKEDRYRUN' {
        $before = & $script:readFile $script:root 'docs/guide.md'
        $result = Format-Links -RepositoryRoot $script:root -Path (Join-Path $script:root 'docs') -MoveMap $script:map -DryRun -PassThru
        $result.Repointed | Should -Contain 'docs/guide.md'
        & $script:readFile $script:root 'docs/guide.md' | Should -BeExactly $before
    }
}
