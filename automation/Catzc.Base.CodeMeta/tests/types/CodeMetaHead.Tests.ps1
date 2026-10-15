# CodeMetaHead over short widget/gadget texts: the proofs are the byte-identical second run and the lossless removal.
Describe 'CodeMetaHead' -Tag 'L0', 'logic', 'ADR-REPO-CODEMETA#1', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        $script:block = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')
        $script:hash = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#')
        $script:facts = [ordered]@{ path = 'automation/Widget/Get-Gadget.ps1'; kind = 'function'; module = 'Widget' }
        $script:lf = { param([string[]] $Lines) ($Lines -join "`n") }
        $script:head = {
            param([string] $Text, $Form = $script:block, $Fact = $script:facts)
            [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($Text, $Form).WithFacts($Fact)
        }
        $script:written = & $script:lf '/*', '---', 'catzc:', '  derived:', '    path: automation/Widget/Get-Gadget.ps1', '    kind: function', '    module: Widget', '---', '*/'
    }

    Context 'rendering' {
        It 'wraps the front matter of a Markdown meta block in the delimiters of a block comment' {
            $block = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($script:facts, [string[]] @())
            [Catzc.Base.CodeMeta.CodeMetaHead]::Wrap($block, $script:block) | Should -Be @(
                '/*', '---', 'catzc:', '  derived:', '    path: automation/Widget/Get-Gadget.ps1', '    kind: function', '    module: Widget', '---', '*/')
        }

        It 'wraps it in a line prefix, one space in, for a language without block comments' {
            $block = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render([ordered]@{ path = 'a/b.yml' }, [string[]] @())
            [Catzc.Base.CodeMeta.CodeMetaHead]::Wrap($block, $script:hash) | Should -Be @('# ---', '# catzc:', '#   derived:', '#     path: a/b.yml', '# ---')
        }
    }

    Context 'imprinting a block head' {
        It 'puts the head above a file without one, with one blank line between' {
            $text = & $script:lf 'function Get-Gadget {', '}', ''
            & $script:head $text | Should -BeExactly ($script:written + "`n`n" + (& $script:lf 'function Get-Gadget {', '}', ''))
        }

        It 'changes nothing on a second run, and reads the keys back' {
            $once = & $script:head (& $script:lf 'function Get-Gadget {', '}', '')
            & $script:head $once | Should -BeExactly $once
            $parsed = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($once, $script:block)
            $parsed.HasHead | Should -BeTrue
            $parsed.Sections | Should -Be @('derived')
            $parsed.DerivedKeys | Should -Be @('path', 'kind', 'module')
            $parsed.Rest | Should -BeExactly (& $script:lf 'function Get-Gadget {', '}', '')
        }

        It 'rewrites a stale value and collapses the blank lines after the head, keeping the rest as written' {
            $stale = & $script:lf '/*', '---', 'catzc:', '  derived:', '    path: automation/Old/Get-Gadget.ps1', '    module: Old', '---', '*/', '', '', '// The insight.', 'class Gadget { }', ''
            & $script:head $stale | Should -BeExactly ($script:written + "`n`n" + (& $script:lf '// The insight.', 'class Gadget { }', ''))
        }

        It 'keeps the authored config lines and removes the head only when nothing is left to write' {
            $text = & $script:lf '/*', '---', 'catzc:', '  derived:', '    path: a/b.cs', '  config:', '    colour: red', '---', '*/', '', 'class Gadget { }', ''
            $rewritten = & $script:head $text $script:block ([ordered]@{ path = 'a/c.cs' })
            $rewritten | Should -BeLike '*path: a/c.cs*config:*colour: red*'
            & $script:head $text $script:block ([ordered]@{}) | Should -BeLike '*colour: red*'
            $plain = & $script:head (& $script:lf 'class Gadget { }', '') $script:block
            & $script:head $plain $script:block ([ordered]@{}) | Should -BeExactly (& $script:lf 'class Gadget { }', '')
        }

        It 'keeps CRLF line endings' {
            $result = & $script:head "function Get-Gadget {`r`n}`r`n"
            $result | Should -BeExactly (($script:written -replace "`n", "`r`n") + "`r`n`r`nfunction Get-Gadget {`r`n}`r`n")
            & $script:head $result | Should -BeExactly $result
        }

        It 'does not take a comment under the head as part of it' {
            $text = & $script:lf $script:written, '// The insight.', 'class Gadget { }', ''
            $parsed = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($text, $script:block)
            $parsed.HasHead | Should -BeTrue
            $parsed.Rest | Should -BeExactly (& $script:lf '// The insight.', 'class Gadget { }', '')
        }

        It 'writes a head alone in an empty file' {
            & $script:head '' $script:block ([ordered]@{ path = 'a/b.cs' }) | Should -BeExactly (& $script:lf '/*', '---', 'catzc:', '  derived:', '    path: a/b.cs', '---', '*/', '')
        }

        It 'does not read a block comment that is not front matter with a catzc block as a head' {
            $text = & $script:lf '/*', 'A licence paragraph.', '*/', '', 'class Gadget { }', ''
            $parsed = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($text, $script:block)
            $parsed.HasHead | Should -BeFalse
            $parsed.Rest | Should -BeExactly $text
            (& $script:head $text) | Should -BeExactly ($script:written + "`n" + "`n" + $text)
        }
    }

    Context 'imprinting a line head' {
        It 'reads back what it wrote and changes nothing on a second run' {
            $once = & $script:head (& $script:lf 'key: value', '') $script:hash ([ordered]@{ path = 'a/b.yml' })
            $once | Should -BeExactly (& $script:lf '# ---', '# catzc:', '#   derived:', '#     path: a/b.yml', '# ---', '', 'key: value', '')
            & $script:head $once $script:hash ([ordered]@{ path = 'a/b.yml' }) | Should -BeExactly $once
            [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($once, $script:hash).DerivedKeys | Should -Be @('path')
        }
    }

    Context 'stripping an old head' {
        It 'removes the whole run of an opener the form strips and writes the head once' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/', [Catzc.Base.CodeMeta.HeadAnchor]::Start, 0, [string[]] @('// catzc:'))
            $old = & $script:lf '// catzc:', '//   path: automation/Old/Get-Gadget.ps1', '//   module: Old', '', '// The insight.', 'class Gadget { }', ''
            $result = & $script:head $old $form
            $result | Should -BeExactly ($script:written + "`n`n" + (& $script:lf '// The insight.', 'class Gadget { }', ''))
            & $script:head $result $form | Should -BeExactly $result
        }

        It 'strips an old head even when nothing is written, and leaves a text that has none alone' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForLine('//', [Catzc.Base.CodeMeta.HeadAnchor]::Start, 0, [string[]] @('// catzc:'))
            $old = & $script:lf '// catzc:', '//   path: a/b.cs', '', 'class Gadget { }', ''
            & $script:head $old $form ([ordered]@{}) | Should -BeExactly (& $script:lf 'class Gadget { }', '')
            $plain = & $script:lf '// The insight.', 'class Gadget { }', ''
            & $script:head $plain $form ([ordered]@{}) | Should -BeExactly $plain
        }
    }

    Context 'anchors' {
        It 'puts the head after a shebang and an encoding line' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#', [Catzc.Base.CodeMeta.HeadAnchor]::AfterShebang)
            $text = & $script:lf '#!/usr/bin/env python3', '# -*- coding: utf-8 -*-', 'import widget', ''
            & $script:head $text $form ([ordered]@{ path = 'a/b.py' }) |
                Should -BeExactly (& $script:lf '#!/usr/bin/env python3', '# -*- coding: utf-8 -*-', '# ---', '# catzc:', '#   derived:', '#     path: a/b.py', '# ---', '', 'import widget', '')
        }

        It 'puts a block head after the XML declaration and the doctype' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('<!--', '-->', [Catzc.Base.CodeMeta.HeadAnchor]::AfterProlog)
            $text = & $script:lf '<?xml version="1.0"?>', '<!DOCTYPE widget>', '<Widget/>', ''
            $result = & $script:head $text $form ([ordered]@{ path = 'a/b.xml' })
            $result | Should -BeExactly (& $script:lf '<?xml version="1.0"?>', '<!DOCTYPE widget>', '<!--', '---', 'catzc:', '  derived:', '    path: a/b.xml', '---', '-->', '', '<Widget/>', '')
            & $script:head $result $form ([ordered]@{ path = 'a/b.xml' }) | Should -BeExactly $result
        }

        It 'puts the head after a fixed number of preamble lines and keeps the byte order mark' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#', [Catzc.Base.CodeMeta.HeadAnchor]::AfterPreamble, 2)
            $text = "$([char] 0xFEFF)`nMicrosoft Visual Studio Solution File, Format Version 12.00`nProject(`"widget`")`n"
            $result = & $script:head $text $form ([ordered]@{ path = 'a/b.sln' })
            $result | Should -BeExactly "$([char] 0xFEFF)`nMicrosoft Visual Studio Solution File, Format Version 12.00`n# ---`n# catzc:`n#   derived:`n#     path: a/b.sln`n# ---`n`nProject(`"widget`")`n"
            & $script:head $result $form ([ordered]@{ path = 'a/b.sln' }) | Should -BeExactly $result
        }
    }

    Context 'a block head that never closes' {
        It 'is no head, so the opener stays where it is' {
            $text = & $script:lf '/*', '---', 'catzc:', '  derived:', '    path: a/b.css', 'body { }', ''
            $parsed = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($text, $script:block)
            $parsed.HasHead | Should -BeFalse
            $parsed.Rest | Should -BeExactly $text
        }
    }
}
