BeforeAll {
    $script:object = [pscustomobject]@{ Name = 'test'; Value = 42 }
    $script:nested = [pscustomobject]@{
        parent = [pscustomobject]@{
            child = [pscustomobject]@{
                etc = [pscustomobject]@{ value = 'found' }
            }
        }
    }
}

Describe 'Assert-HaveProperty' -Tag 'L0', 'logic' {
    It 'passes when property exists' {
        { Assert-HaveProperty $object 'Name' } | Should -Not -Throw
    }

    It 'throws when property is missing' {
        { Assert-HaveProperty $object 'Missing' } | Should -Throw
    }

    It 'passes for a deep nested path that exists' {
        { Assert-HaveProperty $nested 'parent.child.etc.value' } | Should -Not -Throw
    }

    It 'throws naming the deepest reachable segment when the leaf is missing' {
        { Assert-HaveProperty $nested 'parent.child.etc.nope' } |
            Should -Throw "*'parent.child.etc.nope'*"
    }

    It 'throws naming the missing intermediate segment (no null-reference)' {
        { Assert-HaveProperty $nested 'parent.missing.etc.value' } |
            Should -Throw "*'parent.missing'*"
    }
}
