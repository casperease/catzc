# CodeMetaHead over short widget/gadget texts: the proofs are the byte-identical second run and the lossless removal.
Describe 'CodeMetaHead' -Tag 'L0', 'logic', 'ADR-REPO-CODEMETA#1', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        $script:hash = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#')
        $script:slash = [Catzc.Base.CodeMeta.HeadForm]::ForLine('//')
        $script:facts = [ordered]@{ path = 'automation/Widget/Get-Gadget.ps1'; module = 'Widget'; visibility = 'public' }
        $script:lf = { param([string[]] $Lines) ($Lines -join "`n") }
        $script:head = {
            param([string] $Text, $Form = $script:hash, $Fact = $script:facts)
            [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($Text, $Form).WithFacts($Fact)
        }
    }

    Context 'rendering' {
        It 'writes a line head with the prefix, one space, and the keys three spaces in' {
            [Catzc.Base.CodeMeta.CodeMetaHead]::Render($script:facts, $script:hash) | Should -Be @(
                '# catzc:', '#   path: automation/Widget/Get-Gadget.ps1', '#   module: Widget', '#   visibility: public')
            [Catzc.Base.CodeMeta.CodeMetaHead]::Render([ordered]@{ path = 'a/b.cs' }, $script:slash) | Should -Be @('// catzc:', '//   path: a/b.cs')
        }

        It 'writes a block head with the delimiters on the opener and on a line of their own' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('<!--', '-->')
            [Catzc.Base.CodeMeta.CodeMetaHead]::Render([ordered]@{ path = 'a/b.xml'; module = 'Widget' }, $form) | Should -Be @(
                '<!-- catzc:', '  path: a/b.xml', '  module: Widget', '-->')
        }

        It 'accepts a path that starts with a dot, and refuses a key or value it could not read back' {
            { [Catzc.Base.CodeMeta.CodeMetaHead]::Render([ordered]@{ path = '.claude/hooks/x.py' }, $script:hash) } | Should -Not -Throw
            { [Catzc.Base.CodeMeta.CodeMetaHead]::Render([ordered]@{ Path = 'a' }, $script:hash) } | Should -Throw "*lowercase words joined by '_', got 'Path'*"
            { [Catzc.Base.CodeMeta.CodeMetaHead]::Render([ordered]@{ path = 'a b' }, $script:hash) } | Should -Throw "*value of 'path' must be a plain path or name*"
            { [Catzc.Base.CodeMeta.CodeMetaHead]::Render([ordered]@{ path = '' }, $script:hash) } | Should -Throw "*value of 'path' must be a plain path or name*"
        }
    }

    Context 'imprinting a line head' {
        It 'puts the head above a file without one, with one blank line between' {
            $text = & $script:lf 'function Get-Gadget {', '}', ''
            & $script:head $text | Should -BeExactly (& $script:lf '# catzc:', '#   path: automation/Widget/Get-Gadget.ps1', '#   module: Widget', '#   visibility: public', '', 'function Get-Gadget {', '}', '')
        }

        It 'changes nothing on a second run, and reads the facts back in the order written' {
            $once = & $script:head (& $script:lf 'function Get-Gadget {', '}', '')
            & $script:head $once | Should -BeExactly $once
            $parsed = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($once, $script:hash)
            $parsed.HasHead | Should -BeTrue
            $parsed.Facts.Key | Should -Be @('path', 'module', 'visibility')
            $parsed.Facts.Value | Should -Be @('automation/Widget/Get-Gadget.ps1', 'Widget', 'public')
        }

        It 'rewrites a stale value and collapses the blank lines after the head, keeping the rest as written' {
            $stale = & $script:lf '# catzc:', '#   path: automation/Old/Get-Gadget.ps1', '#   module: Old', '', '', '# The insight.', 'function Get-Gadget {', '}', ''
            & $script:head $stale | Should -BeExactly (& $script:lf '# catzc:', '#   path: automation/Widget/Get-Gadget.ps1', '#   module: Widget', '#   visibility: public', '', '# The insight.', 'function Get-Gadget {', '}', '')
        }

        It 'removes the head and its blank line when there are no facts, giving back the original text' {
            $original = & $script:lf '# The insight.', 'function Get-Gadget {', '}', ''
            $withHead = & $script:head $original
            & $script:head $withHead $script:hash ([ordered]@{}) | Should -BeExactly $original
        }

        It 'keeps CRLF line endings' {
            $text = "function Get-Gadget {`r`n}`r`n"
            $result = & $script:head $text
            $result | Should -BeExactly "# catzc:`r`n#   path: automation/Widget/Get-Gadget.ps1`r`n#   module: Widget`r`n#   visibility: public`r`n`r`nfunction Get-Gadget {`r`n}`r`n"
            & $script:head $result | Should -BeExactly $result
        }

        It 'does not take a comment directly under the head as part of it, and separates the two' {
            $text = & $script:lf '# catzc:', '#   path: automation/Widget/Get-Gadget.ps1', '# The insight.', 'function Get-Gadget {', '}', ''
            $parsed = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($text, $script:hash)
            $parsed.Facts.Count | Should -Be 1
            $parsed.Rest | Should -BeExactly (& $script:lf '# The insight.', 'function Get-Gadget {', '}', '')
            & $script:head $text $script:hash ([ordered]@{ path = 'automation/Widget/Get-Gadget.ps1' }) |
                Should -BeExactly (& $script:lf '# catzc:', '#   path: automation/Widget/Get-Gadget.ps1', '', '# The insight.', 'function Get-Gadget {', '}', '')
        }

        It 'writes a head alone in an empty file' {
            & $script:head '' $script:hash ([ordered]@{ path = 'a/b.ps1' }) | Should -BeExactly (& $script:lf '# catzc:', '#   path: a/b.ps1', '')
        }
    }

    Context 'anchors' {
        It 'puts the head after a shebang and an encoding line' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#', [Catzc.Base.CodeMeta.HeadAnchor]::AfterShebang)
            $text = & $script:lf '#!/usr/bin/env python3', '# -*- coding: utf-8 -*-', 'import widget', ''
            & $script:head $text $form ([ordered]@{ path = 'a/b.py' }) |
                Should -BeExactly (& $script:lf '#!/usr/bin/env python3', '# -*- coding: utf-8 -*-', '# catzc:', '#   path: a/b.py', '', 'import widget', '')
            & $script:head 'import widget' $form ([ordered]@{ path = 'a/b.py' }) | Should -BeExactly (& $script:lf '# catzc:', '#   path: a/b.py', '', 'import widget')
        }

        It 'puts a block head after the XML declaration and the doctype' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('<!--', '-->', [Catzc.Base.CodeMeta.HeadAnchor]::AfterProlog)
            $text = & $script:lf '<?xml version="1.0"?>', '<!DOCTYPE widget>', '<Widget/>', ''
            $result = & $script:head $text $form ([ordered]@{ path = 'a/b.xml' })
            $result | Should -BeExactly (& $script:lf '<?xml version="1.0"?>', '<!DOCTYPE widget>', '<!-- catzc:', '  path: a/b.xml', '-->', '', '<Widget/>', '')
            & $script:head $result $form ([ordered]@{ path = 'a/b.xml' }) | Should -BeExactly $result
        }

        It 'puts the head after a fixed number of preamble lines and keeps the byte order mark' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#', [Catzc.Base.CodeMeta.HeadAnchor]::AfterPreamble, 2)
            $text = "$([char] 0xFEFF)`nMicrosoft Visual Studio Solution File, Format Version 12.00`nProject(`"widget`")`n"
            $result = & $script:head $text $form ([ordered]@{ path = 'a/b.sln' })
            $result | Should -BeExactly "$([char] 0xFEFF)`nMicrosoft Visual Studio Solution File, Format Version 12.00`n# catzc:`n#   path: a/b.sln`n`nProject(`"widget`")`n"
            & $script:head $result $form ([ordered]@{ path = 'a/b.sln' }) | Should -BeExactly $result
        }

        It 'ends the text with a line ending before a head that follows an unterminated preamble line' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#', [Catzc.Base.CodeMeta.HeadAnchor]::AfterShebang)
            & $script:head '#!/bin/sh' $form ([ordered]@{ path = 'a/b.sh' }) | Should -BeExactly (& $script:lf '#!/bin/sh', '# catzc:', '#   path: a/b.sh', '')
        }
    }

    Context 'a block head that never closes' {
        It 'is no head, so the opener stays where it is' {
            $form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')
            $text = & $script:lf '/* catzc:', '  path: a/b.css', 'body { }', ''
            $parsed = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($text, $form)
            $parsed.HasHead | Should -BeFalse
            $parsed.Facts.Count | Should -Be 0
            $parsed.Rest | Should -BeExactly $text
        }
    }
}
