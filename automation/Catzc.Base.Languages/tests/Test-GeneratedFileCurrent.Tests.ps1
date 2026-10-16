<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/tests/Test-GeneratedFileCurrent.Tests.ps1
    folder: tests
    name: test-generated-file-current-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Test-GeneratedFileCurrent' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:stamp = 'a1' * 32
        $script:other = 'b2' * 32
        $script:file = Join-Path $TestDrive 'widget.md'
    }

    It 'is current when a front-matter head carries the same stamp' {
        [System.IO.File]::WriteAllText($file, "---`ncatzc:`n  immutable:`n    with_body_sha: `"0123456789ab`"`n    with_inputs_sha: `"$stamp`"`n---`n`nbody`n")
        Test-GeneratedFileCurrent $file $stamp | Should -BeTrue
    }

    It 'is current for a comment head and an unquoted value' {
        [System.IO.File]::WriteAllText($file, "# ---`n# catzc:`n#   immutable:`n#     with_inputs_sha: $stamp`n# ---`n")
        Test-GeneratedFileCurrent $file $stamp | Should -BeTrue
    }

    It 'is current for a head inside a JSON property, where the quotes are escaped' {
        [System.IO.File]::WriteAllText($file, "{`n  `"`$comment`": `"catzc:\n  immutable:\n    with_inputs_sha: \`"$stamp\`"\n`"`n}`n")
        Test-GeneratedFileCurrent $file $stamp | Should -BeTrue
    }

    It 'is not current when the stamp differs' {
        [System.IO.File]::WriteAllText($file, "---`ncatzc:`n  immutable:`n    with_inputs_sha: `"$other`"`n---`n")
        Test-GeneratedFileCurrent $file $stamp | Should -BeFalse
    }

    It 'is not current when the head carries no inputs stamp' {
        [System.IO.File]::WriteAllText($file, "---`ncatzc:`n  immutable:`n    with_body_sha: `"0123456789ab`"`n---`n")
        Test-GeneratedFileCurrent $file $stamp | Should -BeFalse
    }

    It 'is not current when the file has no head or does not exist' {
        [System.IO.File]::WriteAllText($file, "plain text`n")
        Test-GeneratedFileCurrent $file $stamp | Should -BeFalse
        Test-GeneratedFileCurrent (Join-Path $TestDrive 'gadget.md') $stamp | Should -BeFalse
    }

    It 'does not read a stamp that sits past the start of the file' {
        [System.IO.File]::WriteAllText($file, ('x' * 5000) + "`nwith_inputs_sha: $stamp`n")
        Test-GeneratedFileCurrent $file $stamp | Should -BeFalse
    }
}
