# InputStamp.ComputeMany stamps several path sets in one pass, each exactly as Compute stamps that set alone.
Describe 'InputStamp' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'gadgets')) | Out-Null
        foreach ($name in 'widget.txt', 'gadgets/a.md', 'gadgets/b.txt') {
            [System.IO.File]::WriteAllText((Join-Path $root $name), $name)
        }
        $script:full = { param([string] $Name) Join-Path $script:root $Name }
        $script:sets = [string[][]] @(
            , [string[]] @((& $full 'widget.txt'), (& $full 'gadgets/a.md'))
            , [string[]] @((& $full 'gadgets/a.md'), (& $full 'gadgets/b.txt'), (& $full 'absent.txt'))
            , [string[]] @((& $full 'gadgets'))
        )
        $script:salts = [string[]] @('widget-salt', '', 'gadget-salt')
    }

    It 'gives each set the stamp Compute gives it alone, for <Identity> identity' -ForEach @(@{ Identity = 'Metadata' }, @{ Identity = 'Content' }) {
        $by = [Catzc.Base.Files.InputStampIdentity]::$Identity
        $many = [Catzc.Base.Files.InputStamp]::ComputeMany($sets, '*', [string[]] @(), $root, $salts, $by)
        $many | Should -HaveCount 3
        for ($i = 0; $i -lt 3; $i++) {
            $many[$i] | Should -BeExactly ([Catzc.Base.Files.InputStamp]::Compute($sets[$i], '*', [string[]] @(), $root, $salts[$i], $by))
        }
    }

    It 'stamps a set apart from the others, so a change reaches only the sets that name the file' {
        $by = [Catzc.Base.Files.InputStampIdentity]::Content
        $before = [Catzc.Base.Files.InputStamp]::ComputeMany($sets, '*', [string[]] @(), $root, $salts, $by)
        [System.IO.File]::WriteAllText((& $full 'widget.txt'), 'changed')
        $after = [Catzc.Base.Files.InputStamp]::ComputeMany($sets, '*', [string[]] @(), $root, $salts, $by)
        $after[0] | Should -Not -BeExactly $before[0]
        $after[1] | Should -BeExactly $before[1]
        $after[2] | Should -BeExactly $before[2]
    }

    It 'refuses a salt list that does not hold one salt per set' -Tag 'ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY' {
        { [Catzc.Base.Files.InputStamp]::ComputeMany($sets, '*', [string[]] @(), $root, [string[]] @('one'), [Catzc.Base.Files.InputStampIdentity]::Metadata) } |
            Should -Throw '*one salt per path set*'
    }
}
