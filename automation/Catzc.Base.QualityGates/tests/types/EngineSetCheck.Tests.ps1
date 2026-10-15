<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
    kind: test
---
#>

# EngineSetCheck maps the engine-set check's settings and matches its phrases against the engine names it is given —
# widget, gadget and sprocket stand in for the model's engines
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) — so no engine name or count is a
# literal of the check ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)).
Describe 'EngineSetCheck' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:names = [string[]] @('widget', 'gadget', 'sprocket')
    }

    It 'takes gate mode and no phrases when nothing is given' -Tag 'ADR-AUTO-DEFAULT#6' {
        $check = [Catzc.Base.QualityGates.EngineSetCheck]::new($null)
        $check.IsReport | Should -BeFalse
        $check.count_phrases.Count | Should -Be 0
        $check.name_phrases.Count | Should -Be 0
        $check.FindProse('widget and gadget, both engines', $names).Count | Should -Be 0
    }

    It 'fills {count} with number words and {name} with the engine names it is given' -Tag 'ADR-AUTO-ENGINE#1' {
        $check = [Catzc.Base.QualityGates.EngineSetCheck]::new([ordered]@{
                mode          = 'report'
                count_phrases = @('\b{count} engines\b')
                name_phrases  = @('\b{name}(?: and {name})+\b')
            })
        $check.IsReport | Should -BeTrue
        $found = $check.FindProse("Two engines.`nWidget and gadget.`nThree engines.`n3 engines.", $names)
        $found.Count | Should -Be 2
        $found[0].Item2 | Should -Be 'Two engines'
        $found[1].Item2 | Should -Be 'Widget and gadget'
        $found[1].Item1 | Should -Be 13
    }

    It 'finds a C# literal list of two or more engine names on one line' -Tag 'ADR-AUTO-ENGINE#1' {
        $source = (@('var a = "widget";', 'var b = new[] { "gadget", "sprocket" };') -join "`n")
        $found = [Catzc.Base.QualityGates.EngineSetCheck]::FindCSharpLists($source, $names)
        $found.Count | Should -Be 1
        $found[0].Item2 | Should -BeLike '*(gadget, sprocket)*'
    }

    It 'rejects a phrase without its placeholder, a malformed pattern, and a phrase list that is not a list' -Tag 'ADR-PRIN-CONFIG#4' {
        { [Catzc.Base.QualityGates.EngineSetCheck]::new([ordered]@{ count_phrases = @('engines') }) } | Should -Throw '*no {count} placeholder*'
        { [Catzc.Base.QualityGates.EngineSetCheck]::new([ordered]@{ name_phrases = @('({name}') }) } | Should -Throw '*not a valid regular expression*'
        { [Catzc.Base.QualityGates.EngineSetCheck]::new([ordered]@{ name_phrases = '{name}' }) } | Should -Throw '*must be a list*'
        { [Catzc.Base.QualityGates.EngineSetCheck]::new([ordered]@{ gadget = 1 }) } | Should -Throw "*unknown key 'gadget'*"
    }
}
