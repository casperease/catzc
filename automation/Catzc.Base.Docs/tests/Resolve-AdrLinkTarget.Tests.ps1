<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1
    kind: test
---
#>

# Resolve-AdrLinkTarget — a markdown link in a file under docs/adr/, resolved relative to its file
# ([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)) to its path under docs/adr/. Pure path logic: the
# fixture root need not exist. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Resolve-AdrLinkTarget' -Tag 'L0', 'logic', 'ADR-REPO-LINK#2' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'adr'
        function Resolve-Fixture {
            param([string] $From, [string] $Target)
            InModuleScope Catzc.Base.Docs -Parameters @{ Root = $script:root; From = $From; Target = $Target } {
                Resolve-AdrLinkTarget -AdrRoot $Root -From $From $Target
            }
        }
    }

    It 'resolves a sibling, a subfolder, and another domain''s file, dropping the fragment' {
        Resolve-Fixture 'widget/widget-one.md' 'widget-two.md' | Should -Be 'widget/widget-two.md'
        Resolve-Fixture 'widget/widget-one.md' 'sub/widget-three.md#rule-adr-wi-three2' | Should -Be 'widget/sub/widget-three.md'
        Resolve-Fixture 'widget/sub/widget-three.md' '../../gadget/gadget-one.md#context' | Should -Be 'gadget/gadget-one.md'
        Resolve-Fixture 'widget/dora-explains.md' 'widget-one.md' | Should -Be 'widget/widget-one.md'
    }

    It 'returns nothing for an in-page anchor, a URL, a repository-rooted path, or a path that leaves docs/adr/' {
        Resolve-Fixture 'widget/widget-one.md' '#rule-adr-wi-one1' | Should -BeNullOrEmpty
        Resolve-Fixture 'widget/widget-one.md' 'https://example.com/widget.md' | Should -BeNullOrEmpty
        Resolve-Fixture 'widget/widget-one.md' 'mailto:gadget@example.com' | Should -BeNullOrEmpty
        Resolve-Fixture 'widget/widget-one.md' '/docs/adr/gadget/gadget-one.md' | Should -BeNullOrEmpty
        Resolve-Fixture 'widget/widget-one.md' '../../references/gizmo/index.md' | Should -BeNullOrEmpty
    }
}
