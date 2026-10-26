Describe 'Get-NameMentionFinding' -Tag 'L0', 'logic', 'DDR-VISUAL-NONAMEINPICTURE' {
    BeforeAll {
        $script:find = {
            param([string] $Path, [string] $Text, [string[]] $Exempt = @())
            , @(InModuleScope Catzc.Base.Slides -Parameters @{ Path = $Path; Text = $Text; Exempt = $Exempt } {
                    param($Path, $Text, $Exempt)
                    Get-NameMentionFinding -Path $Path -Text $Text -Exempt $Exempt
                })
        }
    }

    It 'flags a line that names catzc or cats as a word, with its line number' {
        $found = & $script:find 'docs/widgets/.assets/widget-act' "title: The widget`n  label: catzc loads the gadget`n  label: ask cats"
        $found.Count | Should -Be 2
        $found[0] | Should -BeLike 'docs/widgets/.assets/widget-act:2: names catzc*'
        $found[1] | Should -BeLike 'docs/widgets/.assets/widget-act:3: names cats*'
    }

    It 'passes a name joined into an identifier' {
        $text = "Catzc.Base.Widget`ncatzc-widget-lamps`ncatzc_gadgets`nGet-CatzcModuleRoot`nImport-Catzc.ps1`nWidgets/Catzc/6.6.666/"
        (& $script:find 'docs/widgets/.assets/widget-act' $text).Count | Should -Be 0
    }

    It 'passes a line that names both, the contrast between them' {
        (& $script:find 'docs/widgets/.assets/widget-act' 'label: cats is the word for catzc').Count | Should -Be 0
    }

    It 'passes a path declared in name_mentions' {
        (& $script:find 'docs/widgets/gadget.slide.md' 'catzc' @('docs/widgets/gadget.slide.md')).Count | Should -Be 0
    }

    It 'skips a slide''s front matter and a declaration''s comment lines' {
        (& $script:find 'docs/widgets/gadget.slide.md' "---`ntitle: catzc`n---`n# The widget").Count | Should -Be 0
        (& $script:find 'docs/widgets/.assets/widget-act' '# catzc: generated').Count | Should -Be 0
    }
}

Describe 'Get-NameMentionFinding (real tree)' -Tag 'L1', 'integrity', 'DDR-VISUAL-NONAMEINPICTURE' {
    It 'finds no name mention in any declared diagram or slide' {
        $found = InModuleScope Catzc.Base.Slides {
            $root = Get-RepositoryRoot
            $exempt = @((Get-Config -Config slides).name_mentions.Keys)
            $hits = [System.Collections.Generic.List[string]]::new()
            foreach ($file in [System.IO.Directory]::EnumerateFiles((Join-Path $root 'docs'), '*.slide.md', 'AllDirectories')) {
                $relative = [System.IO.Path]::GetRelativePath($root, $file).Replace('\', '/')
                foreach ($hit in @(Get-NameMentionFinding -Path $relative -Text ([System.IO.File]::ReadAllText($file)) -Exempt $exempt)) { $hits.Add($hit) }
            }
            foreach ($file in [System.IO.Directory]::EnumerateFiles((Join-Path $root 'docs'), '*.drawio.png', 'AllDirectories')) {
                $relative = [System.IO.Path]::GetRelativePath($root, $file).Replace('\', '/')
                $stem = $relative.Substring(0, $relative.Length - '.drawio.png'.Length)
                $text = Get-DiagramDeclarationText -Stem $stem -RepositoryRoot $root
                if ($null -eq $text) { continue }
                foreach ($hit in @(Get-NameMentionFinding -Path $stem -Text $text -Exempt $exempt)) { $hits.Add($hit) }
            }
            , $hits.ToArray()
        }
        $found | Should -BeNullOrEmpty
    }
}
