Describe 'Get-ListenDiff over real git' -Tag 'L2', 'logic', 'ADR-AUTO-TEST-PROCESSTRIPWIRE' {
    BeforeAll {
        $script:skip = if (Get-Command git -ErrorAction Ignore) {
            $null
        }
        else {
            'tool_git_missing'
        }
        $script:write = {
            param([string] $Name, [string] $Text)
            $path = Join-Path $TestDrive $Name
            [System.IO.File]::WriteAllText($path, $Text)
            $path
        }
        # Get-ListenDiff is private to the module, so it runs inside it.
        $script:diff = {
            param([string] $Before, [string] $After)
            InModuleScope Catzc.Tooling.Listen -Parameters @{ Old = $Before; New = $After } {
                param($Old, $New)
                Get-ListenDiff -Before $Old -After $New
            }
        }
    }

    It 'starts at the first hunk, with the removed and the added line' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $diff = & $script:diff (& $script:write 'old.md' "# Widget`n`nOne part.`n") (& $script:write 'new.md' "# Widget`n`nTwo parts.`n")
        $diff | Should -BeLike '@@*'
        $diff | Should -BeLike '*-One part.*+Two parts.*'
    }

    It 'yields an empty string for two equal files' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        & $script:diff (& $script:write 'same-a.md' "# Gadget`n") (& $script:write 'same-b.md' "# Gadget`n") | Should -BeExactly ''
    }

    It 'diffs a missing side as an empty file: all added, or all removed' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $path = & $script:write 'one.md' "# Gizmo`n"
        & $script:diff '' $path | Should -BeLike '*+# Gizmo*'
        & $script:diff $path (Join-Path $TestDrive 'absent.md') | Should -BeLike '*-# Gizmo*'
    }
}
