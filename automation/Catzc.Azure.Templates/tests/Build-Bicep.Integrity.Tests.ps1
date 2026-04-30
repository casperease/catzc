# Integrity for the SHIPPED bicep templates (infrastructure/templates/): that they are NAMED so discovery
# finds them, and that their CONTENTS meet easily-verifiable structural constraints — WITHOUT building them.
# Actually compiling a production template is the PIPELINE'S build phase, not an integrity test; e2e build
# coverage lives in the FIXTURE-based L2 'real az' logic tests (Build-Bicep.*.Tests.ps1, which mock
# Get-BicepTemplatesRoot to tests/assets/templates/ and build a sample-* asset). This file binds to the real
# infrastructure/templates/ + configs (it does NOT mock the Get-BicepTemplatesRoot / Resolve-ConfigEntry
# seams — binding to the real assets is the whole point of an integrity test, ADR-TEST:1) and is generic: it
# DISCOVERS the set and asserts invariants that hold for EVERY shipped template, binding to no template name
# and no production-derived value (ADR-TEST:17).
#
# One read-only scan in BeforeAll; the It blocks assert facets of it (ADR-TEST:16/18/20). Both engines run here:
# Get-BicepTemplates (discovery — folders/files named right, options schema, identity references) and
# Assert-BicepTemplate (the consolidated validator, every problem in one message). Neither builds.
# NB: Get-BicepTemplates returns a comma-wrapped array — assign it (an @()-wrap nests it one level) and
# iterate with foreach (test-automation Gotchas).
Describe 'Shipped template integrity' -Tag 'L0', 'integrity' {
    BeforeAll {
        # Discovery is itself a check: it enforces the naming conventions, options.yml schema, and the
        # cross-layer identity references, throwing on violation. Capture the outcome rather than let a
        # failure abort the whole block, so each facet below reports cleanly.
        $script:discoveryError = $null
        $script:templates = @()
        try {
            $script:templates = Get-BicepTemplates
        }
        catch {
            $script:discoveryError = $_.Exception.Message
        }

        # Headline content constraints, collected across the discovered set for one-message failures.
        $script:noShortName = [System.Collections.Generic.List[string]]::new()
        $script:noSlots = [System.Collections.Generic.List[string]]::new()
        foreach ($template in $script:templates) {
            if ([string]::IsNullOrWhiteSpace($template.short_name)) {
                $script:noShortName.Add($template.name)
            }
            if (@($template.slots).Count -eq 0) {
                $script:noSlots.Add($template.name)
            }
        }
        $script:dupeShortNames = @(
            $script:templates | Group-Object { $_.short_name } | Where-Object { $_.Count -gt 1 } |
                ForEach-Object { "$($_.Name): $((@($_.Group | ForEach-Object { $_.name })) -join ', ')" }
        )

        # Full structural validation WITHOUT building (no -Build): main.bicep present, options.yml schema +
        # short_name, env-class, identity references, and parameter alignment — every problem in one message.
        $script:validationError = $null
        try {
            Assert-BicepTemplate
        }
        catch {
            $script:validationError = $_.Exception.Message
        }
    }

    It 'discovery succeeds — shipped folders/files are named so Get-BicepTemplates finds them' {
        $discoveryError | Should -BeNullOrEmpty -Because "Get-BicepTemplates must discover infrastructure/templates/ without error:`n$discoveryError"
    }

    It 'at least one shipped template is discovered (guards the checks below against a silent no-op)' {
        $templates.Count | Should -BeGreaterThan 0 -Because 'the repository ships at least one bicep template under infrastructure/templates/'
    }

    It "every shipped template's options.yml declares a short_name" {
        $noShortName | Should -BeNullOrEmpty -Because "options.yml must declare short_name (the Azure id segment — ADR azure/naming-standard, ADR-NAMING:2):`n$($noShortName -join "`n")"
    }

    It 'short_names are globally unique across shipped templates' {
        $dupeShortNames | Should -BeNullOrEmpty -Because "short_name is the Azure id segment — no two templates may share one:`n$($dupeShortNames -join "`n")"
    }

    It 'every shipped template has at least one slot (a configuration file under a subscription folder)' {
        $noSlots | Should -BeNullOrEmpty -Because "a template with no config under configuration/<subscription>/ deploys nothing:`n$($noSlots -join "`n")"
    }

    It 'every shipped template is structurally valid WITHOUT building it (Assert-BicepTemplate, no -Build)' {
        # Deliberately no -Build: this validates the files (main.bicep, options schema, identity references,
        # parameter alignment); it does NOT compile production bicep. Compiling production templates is the
        # pipeline's build phase; e2e build is covered by the fixture-based L2 'real az' logic tests.
        $validationError | Should -BeNullOrEmpty -Because "shipped templates must satisfy Assert-BicepTemplate (no build):`n$validationError"
    }
}
