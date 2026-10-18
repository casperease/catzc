# cspell:ignore nnamespace npublic nusing
# Set-CSharpFileScopedNamespace is private (non-exported), so it is invoked via InModuleScope.
Describe 'Set-CSharpFileScopedNamespace' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:apply = {
            param($Content, $Namespace)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $Content; N = $Namespace } {
                param($C, $N)
                Set-CSharpFileScopedNamespace -Content $C -Namespace $N
            }
        }
    }

    It 'inserts the namespace after the using block, before the type' {
        $src = "using System;`nusing System.Text;`n`npublic class Foo { }`n"
        $out = & $script:apply $src 'Catzc.Base.Objects'
        $out | Should -BeExactly "using System;`nusing System.Text;`n`nnamespace Catzc.Base.Objects;`n`npublic class Foo { }`n"
    }

    It 'inserts after a leading comment block when there are no usings' {
        $src = "// a bare enum`npublic enum Kind { A, B }`n"
        $out = & $script:apply $src 'Catzc.Azure.Firewall'
        $out | Should -BeExactly "// a bare enum`n`nnamespace Catzc.Azure.Firewall;`n`npublic enum Kind { A, B }`n"
    }

    It 'corrects a wrong file-scoped namespace in place' {
        $src = "namespace Wrong.Name;`n`npublic class Foo { }`n"
        $out = & $script:apply $src 'Catzc.Base.Objects'
        $out | Should -BeExactly "namespace Catzc.Base.Objects;`n`npublic class Foo { }`n"
    }

    It 'is a no-op when the namespace is already correct' {
        $src = "using System;`n`nnamespace Catzc.Base.Objects;`n`npublic class Foo { }`n"
        $out = & $script:apply $src 'Catzc.Base.Objects'
        $out | Should -BeExactly $src
    }

    It 'leaves a block-scoped namespace untouched (never double-declares)' {
        $src = "namespace Some.Block`n{`n    public class Foo { }`n}`n"
        $out = & $script:apply $src 'Catzc.Base.Objects'
        $out | Should -BeExactly $src
    }

    It 'preserves a file with no trailing newline (adds none)' {
        $src = "// x`npublic class Foo { }"
        $out = & $script:apply $src 'M'
        $out | Should -BeExactly "// x`n`nnamespace M;`n`npublic class Foo { }"
    }
}
