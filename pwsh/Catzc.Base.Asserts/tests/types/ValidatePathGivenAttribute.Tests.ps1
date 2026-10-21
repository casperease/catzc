<#
---
catzc:
  immutable:
    with_body_sha: "748ab8035f8f"
  edges:
    code: pwsh/Catzc.Base.Asserts/types/ValidatePathGivenAttribute.cs
---
#>

Describe 'ValidatePathGivenAttribute' -Tag 'L0', 'logic' {
    BeforeAll {
        function script:Use-Widget {
            param(
                [Catzc.Base.Asserts.ValidatePathGiven()]
                [string[]] $Path
            )
            if ($PSBoundParameters.ContainsKey('Path')) {
                $Path -join '|'
            }
            else {
                'whole tree'
            }
        }
    }

    It 'refuses an empty list, a null, and a list of only empty strings, naming the cause' {
        { Use-Widget -Path @() } | Should -Throw '*-Path is empty: an empty path list never means the whole tree; leave -Path out for that*'
        { Use-Widget -Path $null } | Should -Throw '*-Path is empty*'
        { Use-Widget -Path '' } | Should -Throw '*-Path is empty*'
        { Use-Widget -Path '', '  ' } | Should -Throw '*-Path is empty*'
    }

    It 'accepts a list with at least one path, and leaves an omitted -Path to the default' {
        Use-Widget -Path 'widgets/a.ps1', '' | Should -BeExactly 'widgets/a.ps1|'
        Use-Widget -Path 'widgets' | Should -BeExactly 'widgets'
        Use-Widget | Should -BeExactly 'whole tree'
    }

    It 'tells a path from none in one call' {
        [Catzc.Base.Asserts.ValidatePathGivenAttribute]::HasPath(@('gadget')) | Should -BeTrue
        [Catzc.Base.Asserts.ValidatePathGivenAttribute]::HasPath(@()) | Should -BeFalse
        [Catzc.Base.Asserts.ValidatePathGivenAttribute]::HasPath(@('', $null)) | Should -BeFalse
    }
}

Describe 'ValidatePathGiven on the whole-tree commands' -Tag 'L1', 'integrity' {
    # Each of these runs over the whole tree when -Path is left out, so an empty -Path is refused before its body runs.
    It '<_> refuses an empty -Path' -ForEach @(
        'Format-Code', 'Format-FileMeta', 'Format-Links', 'Format-MarkdownTitle', 'Format-Types', 'Export-Comments', 'Build-CommentView',
        'Rename-CodeName', 'Invoke-GitCommit', 'Test-Links', 'Test-FileMeta', 'Test-Formatting', 'Test-Comments', 'Test-MarkdownTitle',
        'Test-ScriptAnalyzer', 'Test-Plans', 'Test-ConfigIdentityHygiene', 'Test-LogicTestIdentity', 'Build-Diagrams', 'Test-Diagrams', 'Test-Slides'
    ) {
        $attributes = (Get-Command $_).Parameters['Path'].Attributes
        @($attributes | Where-Object { $_ -is [Catzc.Base.Asserts.ValidatePathGivenAttribute] }).Count | Should -Be 1
    }
}
