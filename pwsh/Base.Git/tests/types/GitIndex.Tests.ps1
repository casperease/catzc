<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-git/tests/types/GitIndex.Tests.ps1.md"
  header: "generated"
---
#>

# cspell:ignore blåbær  -- the non-ASCII fixture path
Describe 'GitIndex' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-GitIndexBytes {
            param([object[]] $Entry = @(), [int] $Version = 2, [byte[]] $Extension = @(), [switch] $ZeroChecksum)

            $bytes = [System.Collections.Generic.List[byte]]::new()
            $bigEndian = {
                param([long] $Value, [int] $Size)
                for ($shift = ($Size - 1) * 8; $shift -ge 0; $shift -= 8) {
                    $bytes.Add([byte](($Value -shr $shift) -band 0xFF))
                }
            }
            $bytes.AddRange([System.Text.Encoding]::ASCII.GetBytes('DIRC'))
            & $bigEndian $Version 4
            & $bigEndian $Entry.Count 4

            $previous = [byte[]] @()
            foreach ($item in $Entry) {
                # Defaults: a regular 100644 file at stage 0, no extended flags.
                $spec = @{ Mode = 0x81A4; Stage = 0; Extended = $false }
                if ($item -is [string]) {
                    $spec.Path = $item
                }
                else {
                    foreach ($key in $item.Keys) {
                        $spec[$key] = $item[$key]
                    }
                }
                $path = [System.Text.Encoding]::UTF8.GetBytes($spec.Path)
                $start = $bytes.Count
                $bytes.AddRange([byte[]]::new(24))                 # ctime, mtime, dev, ino
                & $bigEndian $spec.Mode 4
                $bytes.AddRange([byte[]]::new(12 + 20))            # uid, gid, size, object id
                $flags = ($spec.Stage -shl 12) -bor [Math]::Min($path.Length, 0xFFF)
                if ($spec.Extended) {
                    $flags = $flags -bor 0x4000
                }
                & $bigEndian $flags 2
                if ($spec.Extended) {
                    & $bigEndian 0x4000 2                          # skip-worktree
                }

                if ($Version -eq 4) {
                    $common = 0
                    while ($common -lt [Math]::Min($previous.Length, $path.Length) -and
                        $previous[$common] -eq $path[$common]) {
                        $common++
                    }
                    # git's offset varint (varint.c encode_varint).
                    $strip = $previous.Length - $common
                    $varint = [System.Collections.Generic.List[byte]]::new()
                    $varint.Add([byte]($strip -band 0x7F))
                    $rest = $strip -shr 7
                    while ($rest) {
                        $rest--
                        $varint.Insert(0, [byte](0x80 -bor ($rest -band 0x7F)))
                        $rest = $rest -shr 7
                    }
                    $bytes.AddRange($varint)
                    for ($i = $common; $i -lt $path.Length; $i++) {
                        $bytes.Add($path[$i])
                    }
                    $bytes.Add(0)
                }
                else {
                    $bytes.AddRange($path)
                    $padded = ($bytes.Count - $start + 8) -band -bnot 7
                    while ($bytes.Count - $start -lt $padded) {
                        $bytes.Add(0)
                    }
                }
                $previous = $path
            }
            $bytes.AddRange($Extension)

            $checksum = if ($ZeroChecksum) {
                [byte[]]::new(20)
            }
            else {
                [System.Security.Cryptography.SHA1]::HashData($bytes.ToArray())
            }
            $bytes.AddRange([byte[]] $checksum)
            , $bytes.ToArray()
        }

        function New-ExtensionBytes {
            param([string] $Signature, [int] $Length)
            $size = [BitConverter]::GetBytes([uint32] $Length)
            [Array]::Reverse($size)
            , [byte[]] ([System.Text.Encoding]::ASCII.GetBytes($Signature) + $size + [byte[]]::new($Length))
        }
    }

    Context 'reading entries' {
        It 'reads a version-2 index: every path, NUL-padded entries of any length, in index order' {
            $paths = @('a.txt', 'widget/gadget.yml', 'widget/sub/deep/name-that-crosses-a-padding-boundary.md')
            [Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes $paths)).Paths | Should -Be $paths
        }

        It 'reads version-3 extended entries (skip-worktree) and still lists them, as git ls-files does' {
            $bytes = New-GitIndexBytes -Version 3 @('a.txt', @{ Path = 'widget/hidden.txt'; Extended = $true }, 'z.txt')
            [Catzc.Base.Git.GitIndex]::Parse($bytes).Paths | Should -Be @('a.txt', 'widget/hidden.txt', 'z.txt')
        }

        It 'reads a version-4 prefix-compressed index' {
            $paths = @('widget/a.txt', 'widget/ab.txt', 'widget/b/c.txt', 'x.txt')
            [Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes -Version 4 $paths)).Paths | Should -Be $paths
        }

        It 'decodes a multi-byte version-4 strip count (a long previous path)' {
            $long = 'widget/' + ('d' * 200) + '/a.txt'
            $paths = @($long, 'x.txt')
            [Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes -Version 4 $paths)).Paths | Should -Be $paths
        }

        It 'decodes non-ASCII paths as UTF-8, literally' {
            [Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes @('widget/blåbær.txt'))).Paths |
                Should -Be @('widget/blåbær.txt')
        }

        It 'lists an unmerged path once, though the index holds one entry per conflict stage' {
            $bytes = New-GitIndexBytes @('a.txt',
                @{ Path = 'b.txt'; Stage = 1 }, @{ Path = 'b.txt'; Stage = 2 }, @{ Path = 'b.txt'; Stage = 3 }, 'c.txt')
            [Catzc.Base.Git.GitIndex]::Parse($bytes).Paths | Should -Be @('a.txt', 'b.txt', 'c.txt')
        }

        It 'reads an empty index' {
            @([Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes @())).Paths).Count | Should -Be 0
        }

        It 'skips optional extensions after the entries' {
            $bytes = New-GitIndexBytes @('a.txt') -Extension (New-ExtensionBytes 'TREE' 13)
            [Catzc.Base.Git.GitIndex]::Parse($bytes).Paths | Should -Be @('a.txt')
        }

        It 'accepts the all-zero trailer git writes under index.skipHash' {
            [Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes @('a.txt') -ZeroChecksum)).Paths | Should -Be @('a.txt')
        }
    }

    Context 'content hash' {
        It 'keys the parsed index on its bytes: equal bytes, equal hash; different bytes, different hash' {
            $one = New-GitIndexBytes @('a.txt')
            $two = New-GitIndexBytes @('a.txt', 'b.txt')
            [Catzc.Base.Git.GitIndex]::Parse($one).ContentHash |
                Should -Be ([Catzc.Base.Git.GitIndex]::HashContent($one))
            [Catzc.Base.Git.GitIndex]::HashContent($one) |
                Should -Not -Be ([Catzc.Base.Git.GitIndex]::HashContent($two))
        }
    }

    Context 'rejecting what it cannot read correctly' {
        It 'throws on a file that is not a git index' {
            { [Catzc.Base.Git.GitIndex]::Parse([System.Text.Encoding]::ASCII.GetBytes('not an index at all, padded out')) } |
                Should -Throw "*'DIRC' signature*"
        }

        It 'throws on an unsupported index version' {
            { [Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes @('a.txt') -Version 5)) } |
                Should -Throw '*version 5*'
        }

        It 'throws when the checksum does not match (corruption, or a SHA-256 repository)' {
            $bytes = New-GitIndexBytes @('a.txt')
            $bytes[$bytes.Length - 1] = $bytes[$bytes.Length - 1] -bxor 0xFF
            { [Catzc.Base.Git.GitIndex]::Parse($bytes) } | Should -Throw '*checksum does not match*'
        }

        It 'throws on a split index (the link extension) rather than list only its own entries' {
            { [Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes @('a.txt') -Extension (New-ExtensionBytes 'link' 20))) } |
                Should -Throw '*split*'
        }

        It 'throws on a sparse index (a directory entry) rather than list the directory as a file' {
            { [Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes @(@{ Path = 'widget/'; Mode = 0x4000; Extended = $true }) -Version 3)) } |
                Should -Throw '*sparse*'
        }

        It 'throws on a truncated index' {
            $bytes = New-GitIndexBytes @('a.txt', 'b.txt')
            $truncated = [byte[]] ($bytes[0..39] + [System.Security.Cryptography.SHA1]::HashData([byte[]] $bytes[0..39]))
            { [Catzc.Base.Git.GitIndex]::Parse($truncated) } | Should -Throw '*truncated or malformed*'
        }
    }

    Context 'Under (the ls-files pathspec)' {
        BeforeAll {
            $script:index = [Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes @('a.txt', 'widget/gadget.yml',
                        'widget/sub/x.md', 'widgets/y.md')))
        }

        It "returns every path for '.' (and its spellings)" {
            foreach ($all in '.', './', '') {
                $script:index.Under([string[]] @($all)) | Should -Be @('a.txt', 'widget/gadget.yml', 'widget/sub/x.md',
                    'widgets/y.md')
            }
        }

        It 'returns the paths at or under a folder — never a sibling that merely shares its prefix' {
            $script:index.Under([string[]] @('widget')) | Should -Be @('widget/gadget.yml', 'widget/sub/x.md')
        }

        It 'matches a file path exactly, folder separators in either direction, a trailing slash, and a ./ prefix' {
            $script:index.Under([string[]] @('./widget\sub/')) | Should -Be @('widget/sub/x.md')
            $script:index.Under([string[]] @('a.txt')) | Should -Be @('a.txt')
        }

        It 'returns the union of several paths in index order, each once' {
            $script:index.Under([string[]] @('widgets', 'a.txt', 'widget/sub', 'widget/sub/x.md')) |
                Should -Be @('a.txt', 'widget/sub/x.md', 'widgets/y.md')
        }

        It 'returns nothing for an untracked path' {
            @($script:index.Under([string[]] @('gadget'))).Count | Should -Be 0
        }

        It 'lists the entries stored executable (mode 100755), and selects them by path the same way' {
            $mixed = [Catzc.Base.Git.GitIndex]::Parse((New-GitIndexBytes @(
                        @{ Path = 'run.sh'; Mode = 0x81ED }
                        'widget/gadget.yml'
                        @{ Path = 'widget/start.sh'; Mode = 0x81ED }
                        @{ Path = 'widget/link'; Mode = 0xA000 }
                    )))
            $mixed.ExecutablePaths | Should -Be @('run.sh', 'widget/start.sh')
            $mixed.ExecutableUnder([string[]] @('widget')) | Should -Be @('widget/start.sh')
            @($script:index.ExecutablePaths).Count | Should -Be 0
        }

        It 'rejects a path outside the repository or a rooted path' {
            { $script:index.Under([string[]] @('../x')) } | Should -Throw '*outside the repository*'
            { $script:index.Under([string[]] @('/etc/x')) } | Should -Throw '*not a repository-relative path*'
        }
    }
}
