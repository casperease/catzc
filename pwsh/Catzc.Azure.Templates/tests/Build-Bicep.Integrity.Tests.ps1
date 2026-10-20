<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
    folder: tests
    name: build-bicep-integrity-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Build-Bicep.Integrity.Tests.ps1.md](docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.Integrity.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-ONECATEGORY
      - ADR-AUTO-TEST-INTEGRITYREADSFILES
      - ADR-AUTO-TEST-GENERICTEMPLATETESTS
      - ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS
---
#>

Describe 'Shipped template integrity' -Tag 'L0', 'integrity' {
    BeforeAll {
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

    It 'every shipped template resolves a short_name' {
        $noShortName | Should -BeNullOrEmpty -Because "a template must resolve a short_name, derived from its folder or overridden in its optional options.yml (the Azure id segment, ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS):`n$($noShortName -join "`n")"
    }

    It 'short_names are globally unique across shipped templates' {
        $dupeShortNames | Should -BeNullOrEmpty -Because "short_name is the Azure id segment — no two templates may share one:`n$($dupeShortNames -join "`n")"
    }

    It 'every shipped template has at least one slot (a configuration file under a subscription folder)' {
        $noSlots | Should -BeNullOrEmpty -Because "a template with no config under configuration/<subscription>/ deploys nothing:`n$($noSlots -join "`n")"
    }

    It 'every shipped template is structurally valid WITHOUT building it (Assert-BicepTemplate, no -Build)' {
        $validationError | Should -BeNullOrEmpty -Because "shipped templates must satisfy Assert-BicepTemplate (no build):`n$validationError"
    }
}
