# DocumentLinks lists the links a Markdown file points out of itself, in one spelling; a link that stays inside the file is not a link out.
Describe 'DocumentLinks' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
    BeforeAll {
        function script:Get-Links {
            param([string] $Text, [string] $Path = 'docs/widget/part.md', [string] $Page)
            , @([Catzc.Base.QualityGates.DocumentLinks]::Of($Text, $Path, $Page))
        }
    }

    It 'spells a relative link as a repository-relative path with its anchor' {
        Get-Links '[a](../gadget/spec.md#top)' | Should -Be @('docs/gadget/spec.md#top')
    }

    It 'spells a repository-rooted link the same way' {
        Get-Links '[a](/docs/gadget/spec.md#top)' | Should -Be @('docs/gadget/spec.md#top')
    }

    It 'keeps an absolute URL as written' {
        Get-Links '[a](https://example.com/widget?x=1#part)' | Should -Be @('https://example.com/widget?x=1#part')
    }

    It 'lists an image, a reference definition and an autolink as links' {
        $text = "![chart](../.assets/chart.png)`n`n[spec]: ../gadget/spec.md`n`nSee <https://example.com/doc>.`n"
        (Get-Links $text) | Should -Be @('docs/.assets/chart.png', 'docs/gadget/spec.md', 'https://example.com/doc')
    }

    It 'sorts the links and lists each once, however it was spelled' {
        $text = '[b](../gadget/spec.md) [a](/docs/gadget/spec.md) [c](other.md#x) [d](../gadget/other.md)'
        (Get-Links $text) | Should -Be @('docs/gadget/other.md', 'docs/gadget/spec.md', 'docs/widget/other.md#x')
    }

    It 'leaves out a link that stays inside the file' {
        $text = '[a](#top) [b](part.md#top) [c](part.md) [d](/docs/widget/part.md#x)'
        (Get-Links $text).Count | Should -Be 0
    }

    It 'leaves out the file''s own comment page' {
        $text = '[comment:1](/docs/references/widget/part.cs.md#comment1) [a](../gadget/spec.md)'
        Get-Links $text -Path 'docs/widget/part.md' -Page 'docs/references/widget/part.cs.md' | Should -Be @('docs/gadget/spec.md')
    }

    It 'reads no link from a code span or a fenced block' {
        $text = "Use ``[a](../gadget/spec.md)`` here.`n`n``````text`n[b](../gadget/other.md)`n```````n"
        (Get-Links $text).Count | Should -Be 0
    }

    It 'skips a link that climbs above the repository root' {
        (Get-Links '[a](../../../outside.md)').Count | Should -Be 0
    }

    It 'resolves a link from a file at the repository root' {
        Get-Links '[a](docs/gadget/spec.md)' -Path 'README.md' | Should -Be @('docs/gadget/spec.md')
    }

    It 'returns an empty list for an empty text' {
        (Get-Links '').Count | Should -Be 0
    }
}
