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

Describe 'Test-HaveProperty' -Tag 'L0', 'logic' {
    It 'returns $true when property exists' {
        Test-HaveProperty $object 'Name' | Should -BeTrue
    }

    It 'returns $false when property is missing' {
        Test-HaveProperty $object 'Missing' | Should -BeFalse
    }

    It 'returns $true for a deep nested path that exists' {
        Test-HaveProperty $nested 'parent.child.etc.value' | Should -BeTrue
    }

    It 'returns $false when a leaf segment is missing' {
        Test-HaveProperty $nested 'parent.child.etc.nope' | Should -BeFalse
    }

    It 'returns $false when an intermediate segment is missing (no throw)' {
        Test-HaveProperty $nested 'parent.missing.etc.value' | Should -BeFalse
    }
}
