# The platform is a parameter, so the Windows and the Unix branches both run on whichever system runs the tests.
Describe 'Catzc.Tooling.Inspiration.InspirationRoot' -Tag 'L0', 'logic' {
    Context 'ToNative' {
        It 'maps a Git Bash drive path to a drive path on Windows' {
            [Catzc.Tooling.Inspiration.InspirationRoot]::ToNative('/c/widgets/catzc', $true) |
                Should -BeExactly 'C:/widgets/catzc'
            [Catzc.Tooling.Inspiration.InspirationRoot]::ToNative('/d', $true) | Should -BeExactly 'D:/'
        }

        It 'maps a pwsh drive path to forward slashes on Windows' {
            [Catzc.Tooling.Inspiration.InspirationRoot]::ToNative('C:\widgets\catzc', $true) |
                Should -BeExactly 'C:/widgets/catzc'
        }

        It 'leaves a /c/ path alone elsewhere, where it is a real path' {
            [Catzc.Tooling.Inspiration.InspirationRoot]::ToNative('/c/widgets/catzc', $false) |
                Should -BeExactly '/c/widgets/catzc'
        }

        It 'leaves a path that only starts like a drive alone' {
            [Catzc.Tooling.Inspiration.InspirationRoot]::ToNative('/gadget/catzc', $true) |
                Should -BeExactly '/gadget/catzc'
        }
    }

    Context 'ResolveWorkspace' {
        It 'resolves the anchor identically from both shell views of the repository root on Windows' {
            $fromPwsh = [Catzc.Tooling.Inspiration.InspirationRoot]::ResolveWorkspace('{workspace}/gadget',
                'C:\widgets\catzc', $true)
            $fromBash = [Catzc.Tooling.Inspiration.InspirationRoot]::ResolveWorkspace('{workspace}/gadget',
                '/c/widgets/catzc', $true)
            $fromPwsh | Should -BeExactly 'C:/widgets/gadget'
            $fromBash | Should -BeExactly $fromPwsh
        }

        It 'resolves the anchor against a Unix repository root' {
            [Catzc.Tooling.Inspiration.InspirationRoot]::ResolveWorkspace('{workspace}/gadget/docs',
                '/srv/widgets/catzc/', $false) |
                Should -BeExactly '/srv/widgets/gadget/docs'
        }

        It 'resolves against a repository root one level below the filesystem root' {
            [Catzc.Tooling.Inspiration.InspirationRoot]::ResolveWorkspace('{workspace}/gadget', 'C:\catzc', $true) |
                Should -BeExactly 'C:/gadget'
            [Catzc.Tooling.Inspiration.InspirationRoot]::ResolveWorkspace('{workspace}/gadget', '/catzc', $false) |
                Should -BeExactly '/gadget'
        }

        It 'throws when the repository root has no parent or is unset' {
            { [Catzc.Tooling.Inspiration.InspirationRoot]::ResolveWorkspace('{workspace}/gadget', 'C:\', $true) } |
                Should -Throw '*has no parent folder*'
            { [Catzc.Tooling.Inspiration.InspirationRoot]::ResolveWorkspace('{workspace}/gadget', '/', $false) } |
                Should -Throw '*has no parent folder*'
            { [Catzc.Tooling.Inspiration.InspirationRoot]::ResolveWorkspace('{workspace}/gadget', '', $false) } |
                Should -Throw '*repository root is not set*'
        }

        It 'throws on a root that is not anchored' {
            { [Catzc.Tooling.Inspiration.InspirationRoot]::ResolveWorkspace('gadget', '/srv/widgets/catzc', $false) } |
                Should -Throw '*is not anchored*'
        }
    }

    Context 'IsWorkspaceAnchored' {
        It 'is true only for a leading {workspace}/ segment' {
            [Catzc.Tooling.Inspiration.InspirationRoot]::IsWorkspaceAnchored('{workspace}/gadget') | Should -BeTrue
            [Catzc.Tooling.Inspiration.InspirationRoot]::IsWorkspaceAnchored('{workspace}') | Should -BeFalse
            [Catzc.Tooling.Inspiration.InspirationRoot]::IsWorkspaceAnchored('gadget/{workspace}/widget') |
                Should -BeFalse
        }
    }

    Context 'Violations' {
        It 'accepts a workspace-anchored and a repository-relative root' {
            [Catzc.Tooling.Inspiration.InspirationRoot]::Violations('root', '{workspace}/gadget', $true).Count |
                Should -Be 0
            [Catzc.Tooling.Inspiration.InspirationRoot]::Violations('root', 'widgets/gadget', $true).Count |
                Should -Be 0
        }

        It 'rejects the anchor where it is not allowed' {
            [Catzc.Tooling.Inspiration.InspirationRoot]::Violations('path', '{workspace}/gadget', $false) |
                Should -BeLike '*has an anchor*'
        }
    }
}
