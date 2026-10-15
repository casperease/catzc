<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/tests/types/GitHistoryScan.Tests.ps1
    kind: pester-test
---
#>

Describe 'GitHistoryScan' -Tag 'L0', 'logic' {
    BeforeAll {
        # Builds a `git cat-file --batch` stream by hand.
        # [comment:1](/docs/references/automation/catzc-base-git/tests/types/GitHistoryScan.Tests.ps1.md#comment1)
        function script:New-ObjectId {
            param([int] $Number)
            '{0:x40}' -f $Number
        }

        function script:New-Record {
            param([string] $Id, [string] $Type, [byte[]] $Content)
            $head = [System.Text.Encoding]::ASCII.GetBytes("$Id $Type $($Content.Length)`n")
            [byte[]] ($head + $Content + [byte[]] @(10))
        }

        # UTF-8 bytes of the lines, joined with LF as git stores text.
        function script:New-Text {
            param([string[]] $Line)
            [System.Text.Encoding]::UTF8.GetBytes(($Line -join "`n"))
        }

        # One tree entry: '<mode> <name>' NUL, then the 20-byte binary id.
        function script:New-TreeEntry {
            param([string] $Mode, [string] $Name, [string] $Id)
            [byte[]] ([System.Text.Encoding]::UTF8.GetBytes("$Mode $Name") + [byte[]] @(0) + [System.Convert]::FromHexString($Id))
        }

        function script:New-Commit {
            param([string] $Tree, [string[]] $Parent = @(), [string] $Message)
            $lines = @("tree $Tree") + @($Parent | ForEach-Object { "parent $_" }) + @('author w <w@example.com> 0 +0000', 'committer w <w@example.com> 0 +0000', '', $Message)
            New-Text ($lines -join "`n")
        }

        # A two-commit history: commit 1 (root): widget.txt (clean), gadget/ (a tree holding notes.txt with the...
        # [comment:2](/docs/references/automation/catzc-base-git/tests/types/GitHistoryScan.Tests.ps1.md#comment2)
        $ids = @{}
        foreach ($name in 'clean', 'secret', 'binary', 'gadgetTree', 'vendorTree', 'tree1', 'tree2', 'commit1', 'commit2', 'unreachable') {
            $ids[$name] = New-ObjectId ($ids.Count + 1)
        }
        $script:ids = $ids

        $gadgetTree = New-TreeEntry '100644' 'notes.txt' $ids.secret
        $vendorTree = New-TreeEntry '100644' 'copy.txt' $ids.secret
        $tree1 = [byte[]] ((New-TreeEntry '40000' 'gadget' $ids.gadgetTree) + (New-TreeEntry '100644' 'widget.txt' $ids.clean))
        $tree2 = [byte[]] ((New-TreeEntry '100644' 'blob.bin' $ids.binary) + (New-TreeEntry '40000' 'gadget' $ids.gadgetTree) +
            (New-TreeEntry '100644' 'sekret-plan.md' $ids.clean) + (New-TreeEntry '40000' 'vendor' $ids.vendorTree) +
            (New-TreeEntry '100644' 'widget.txt' $ids.clean))

        $script:batch = [byte[]] (
            (New-Record $ids.clean 'blob' (New-Text 'hello', 'world', '')) +
            (New-Record $ids.secret 'blob' (New-Text 'line one', "key=SEKRET`r", 'line three', '')) +
            (New-Record $ids.binary 'blob' ([byte[]] @(0, 1, 2) + (New-Text 'sekret'))) +
            (New-Record $ids.gadgetTree 'tree' $gadgetTree) +
            (New-Record $ids.vendorTree 'tree' $vendorTree) +
            (New-Record $ids.tree1 'tree' $tree1) +
            (New-Record $ids.tree2 'tree' $tree2) +
            (New-Record $ids.commit1 'commit' (New-Commit $ids.tree1 -Message 'initial widget')) +
            (New-Record $ids.commit2 'commit' (New-Commit $ids.tree2 -Parent $ids.commit1 -Message (@('wire up the Sekret', '', 'body line') -join "`n"))) +
            (New-Record $ids.unreachable 'blob' (New-Text 'sekret in garbage')))

        function script:Invoke-Scan {
            param([string[]] $Root = @($script:ids.commit2), [string] $Token = 'sekret', [string[]] $Exclude = @())
            [Catzc.Base.Git.GitHistoryScan]::Scan($script:batch, $Root, $Token, $Exclude)
        }
    }

    It 'finds the token in a blob, a path and a message, ignoring ASCII case' {
        $scan = Invoke-Scan
        $scan.Clean | Should -BeFalse
        $scan.Blobs | Should -Be @("$($ids.secret):gadget/notes.txt:key=SEKRET")
        $scan.Paths | Should -Be @('sekret-plan.md')
        $scan.Messages | Should -Be @('wire up the Sekret')
    }

    It 'searches each distinct blob once, however many commits and paths hold it' {
        # The secret blob sits in both commits and under two paths; the clean blob under three paths.
        (Invoke-Scan).BlobsSearched | Should -Be 2
    }

    It 'skips a binary blob, as git grep -I does' {
        (Invoke-Scan).Blobs | Should -Not -Match $ids.binary
    }

    It 'reads only what the roots reach' {
        $scan = Invoke-Scan -Root $ids.commit1
        $scan.Paths | Should -BeNullOrEmpty
        $scan.Messages | Should -BeNullOrEmpty
        $scan.Blobs | Should -Be @("$($ids.secret):gadget/notes.txt:key=SEKRET")
        (Invoke-Scan).Blobs | Should -Not -Match $ids.unreachable
    }

    It 'ignores a blob only when every path it appears under is excluded' {
        (Invoke-Scan -Exclude 'vendor/').Blobs | Should -Be @("$($ids.secret):gadget/notes.txt:key=SEKRET")
        (Invoke-Scan -Exclude 'vendor/', 'gadget/').Blobs | Should -BeNullOrEmpty
    }

    It 'excludes a path under an excluded prefix' {
        (Invoke-Scan -Exclude 'sekret').Paths | Should -BeNullOrEmpty
    }

    It 'reports clean for a token that appears nowhere' {
        $scan = Invoke-Scan -Token 'gizmo'
        $scan.Clean | Should -BeTrue
        $scan.Blobs.Count + $scan.Paths.Count + $scan.Messages.Count | Should -Be 0
    }

    It 'follows an annotated tag to its commit' {
        $tag = New-ObjectId 99
        $batch = [byte[]] ($script:batch + (New-Record $tag 'tag' (New-Text "object $($ids.commit2)", 'type commit', 'tag v1', '', 'release')))
        [Catzc.Base.Git.GitHistoryScan]::Scan($batch, [string[]] @($tag), 'sekret', [string[]] @()).Paths | Should -Be @('sekret-plan.md')
    }

    It 'throws on <problem>' -ForEach @(
        @{ problem = 'a truncated stream'; cut = 5; expected = '*truncated*' }
        @{ problem = 'a stream ending inside a header'; cut = -1; expected = '*inside a header*' }
    ) {
        $length = $script:batch.Length - $cut
        if ($cut -lt 0) {
            $length = 10
        }
        $bytes = [byte[]] $script:batch[0..($length - 1)]
        { [Catzc.Base.Git.GitHistoryScan]::Scan($bytes, [string[]] @($ids.commit2), 'sekret', [string[]] @()) } | Should -Throw $expected
    }

    It 'throws when a reachable object is missing' {
        { Invoke-Scan -Root (New-ObjectId 12345) } | Should -Throw '*missing from the object stream*'
    }

    It 'rejects an empty token' {
        { Invoke-Scan -Token '' } | Should -Throw '*must not be empty*'
    }
}
