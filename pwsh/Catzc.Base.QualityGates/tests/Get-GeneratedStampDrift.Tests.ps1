Describe 'Get-GeneratedStampDrift' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#7' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'docs')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'widget')) | Out-Null

        $script:write = {
            param([string] $Relative, [string] $Text)
            [System.IO.File]::WriteAllText((Join-Path $script:root $Relative), $Text, [System.Text.UTF8Encoding]::new($false))
        }
        # A Markdown page whose head carries the hash of its body, as Format-GeneratedFileHead writes it.
        $pageBody = "# docs/current.md`n`nbody`n"
        $script:pageHash = (Get-MarkdownMetaState -Text $pageBody).BodyHash
        & $script:write 'docs/current.md' "---`ncatzc:`n  immutable:`n    with_body_sha: `"$script:pageHash`"`n    repo_status: locked`n    path: docs/current.md`n    kind: widget`n---`n$pageBody"
        # The same page with a stamp that no longer matches its body.
        & $script:write 'docs/stale.md' "---`ncatzc:`n  immutable:`n    with_body_sha: `"000000000000`"`n    repo_status: locked`n    path: docs/stale.md`n    kind: widget`n---`n# docs/stale.md`n`nother body`n"
        # A page with no head at all, and one with a head that holds no stamp.
        & $script:write 'docs/bare.md' "# docs/bare.md`n`nbody`n"
        & $script:write 'docs/unstamped.md' "---`ncatzc:`n  immutable:`n    repo_status: locked`n    path: docs/unstamped.md`n    kind: widget`n---`n# docs/unstamped.md`n`nbody`n"
        # A YAML file with a comment head, written through the code-head formatter the generators use.
        $yamlBody = "widget: gadget`n"
        $yamlForm = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#')
        $yamlHash = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf((Get-CodeMetaState -Text $yamlBody -Form $yamlForm).Rest)
        & $script:write 'widget/current.yml' (Format-CodeMetaHead -Text $yamlBody -Form $yamlForm -Immutable ([ordered]@{ with_body_sha = $yamlHash; repo_status = 'locked'; path = 'widget/current.yml'; kind = 'config' }))
        # A binary has no head to stamp.
        [System.IO.File]::WriteAllBytes((Join-Path $script:root 'widget/picture.png'), [byte[]] @(137, 80, 78, 71))

        $script:all = 'docs/current.md', 'docs/stale.md', 'docs/bare.md', 'docs/unstamped.md', 'widget/current.yml', 'widget/picture.png'
        $script:run = {
            param([string[]] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Path = $Path } {
                param($Root, $Path)
                Get-GeneratedStampDrift -RepositoryRoot $Root -Path $Path
            }
        }
    }

    It 'passes a page and a comment-head file whose stamp is the hash of the body' {
        $result = & $script:run @('docs/current.md', 'widget/current.yml')
        $result.Issues | Should -BeNullOrEmpty
        $result.Stamped | Should -Be 2
        $result.Unstamped | Should -BeNullOrEmpty
    }

    It 'reports a stamp that is not the hash of the body, naming both hashes and the file' {
        $result = & $script:run @('docs/stale.md')
        $result.Issues.Count | Should -Be 1
        $result.Issues[0] | Should -BeLike 'docs/stale.md: stale — the head''s with_body_sha 000000000000 is not the hash of the body, *; regenerate the file with its writer'
    }

    It 'lists a file with no head or no stamp as unstamped, not as an issue, and skips a binary' {
        $result = & $script:run $script:all
        $result.Stamped | Should -Be 3
        $result.Issues.Count | Should -Be 1
        $result.Unstamped | Should -Be @('docs/bare.md', 'docs/unstamped.md')
    }

    It 'returns empty counts for no paths' {
        $result = & $script:run @()
        $result.Stamped | Should -Be 0
        $result.Unstamped | Should -BeNullOrEmpty
        $result.Issues | Should -BeNullOrEmpty
    }
}
