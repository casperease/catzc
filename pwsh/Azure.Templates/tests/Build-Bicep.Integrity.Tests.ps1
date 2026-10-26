<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.Integrity.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Shipped template integrity' -Tag 'L0', 'integrity' {
    BeforeAll {
        # Discovery throws on a naming, schema or identity violation; capturing the outcome lets each facet report cleanly instead of aborting the block.
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

        # Full structural validation without -Build, with every problem reported in one message.
        $script:validationError = $null
        try {
            Assert-BicepTemplate
        }
        catch {
            $script:validationError = $_.Exception.Message
        }
    }

    It 'discovery succeeds — shipped folders/files are named so Get-BicepTemplates finds them' {
        $discoveryError |
            Should -BeNullOrEmpty -Because "Get-BicepTemplates must discover infrastructure/templates/ without error:`n$discoveryError"
    }

    It 'at least one shipped template is discovered (guards the checks below against a silent no-op)' {
        $templates.Count |
            Should -BeGreaterThan 0 -Because 'the repository ships at least one bicep template under infrastructure/templates/'
    }

    It 'every shipped template resolves a short_name' {
        $noShortName |
            Should -BeNullOrEmpty -Because "a template must resolve a short_name, derived from its folder or overridden in its optional options.yml (the Azure id segment, ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS):`n$($noShortName -join "`n")"
    }

    It 'short_names are globally unique across shipped templates' {
        $dupeShortNames |
            Should -BeNullOrEmpty -Because "short_name is the Azure id segment — no two templates may share one:`n$($dupeShortNames -join "`n")"
    }

    It 'every shipped template has at least one slot (a configuration file under a subscription folder)' {
        $noSlots |
            Should -BeNullOrEmpty -Because "a template with no config under configuration/<subscription>/ deploys nothing:`n$($noSlots -join "`n")"
    }

    It 'every shipped template is structurally valid WITHOUT building it (Assert-BicepTemplate, no -Build)' {
        # No -Build on purpose: compiling production templates is the pipeline's step, and end-to-end build is covered by the fixture-based L2 tests.
        $validationError |
            Should -BeNullOrEmpty -Because "shipped templates must satisfy Assert-BicepTemplate (no build):`n$validationError"
    }
}

Describe 'Every slot compiles through the .bicepparam path to the same parameters' -Tag 'L2', 'integrity' {
    It 'renders every shipped yml slot both ways, and the compiled .bicepparam holds the values the ConvertTo-Json file holds' {
        $bicep = Resolve-ToolExecutable -Tool bicep
        if (-not ($bicep.Found -and $bicep.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $folder = Join-Path $TestDrive 'both-ways'
        $null = New-Item -ItemType Directory -Path $folder -Force
        $templates = Get-BicepTemplates
        $differ = [System.Collections.Generic.List[string]]::new()
        $slots = [System.Collections.Generic.List[object]]::new()
        $count = 0
        foreach ($template in $templates) {
            foreach ($slot in @($template.slots | Where-Object { $_.format -eq 'yml' })) {
                $descriptor = Get-BicepTemplateConfiguration $template.name $slot.environment -Slot $slot.slot -Customer $slot.customer
                $descriptor.ParametersFile.parameters = InModuleScope Catzc.Azure.Templates -Parameters @{ Parameters = $descriptor.ParametersFile.parameters } {
                    param($Parameters)
                    Resolve-BicepParameterAddresses -Parameters $Parameters -ConfigFile 'shipped.yml'
                }
                $before = $descriptor.ParametersFile | ConvertTo-Json -Depth 10 |
                    ConvertFrom-Json -AsHashtable -DateKind String
                $using = [System.IO.Path]::GetRelativePath($folder, $template.main).Replace('\', '/')
                $source = Join-Path $folder "$count.bicepparam"
                $compiled = Join-Path $folder "$count.json"
                [System.IO.File]::WriteAllText($source, (ConvertTo-BicepParam -Descriptor $descriptor -Using $using))
                $slots.Add([pscustomobject]@{
                        Label    = "$($template.name)/$($slot.customer)/$($slot.name)"
                        Before   = $before
                        Source   = $source
                        Compiled = $compiled
                    })
                $count++
            }
        }
        # Each compile is its own bicep process, about 1.6 s apiece, so they run side by side, four at a time on a shared devbox.
        $bicepPath = $bicep.Path
        $jobs = foreach ($entry in $slots) {
            $source = $entry.Source
            $compiled = $entry.Compiled
            Start-ThreadJob -ThrottleLimit 4 -ScriptBlock {
                $output = & $using:bicepPath build-params $using:source --outfile $using:compiled 2>&1
                [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = $output -join "`n" }
            }
        }
        $finished = @($jobs | Wait-Job -Timeout 120)
        if ($finished.Count -ne $jobs.Count) {
            $jobs | Remove-Job -Force
            throw "bicep build-params: $($jobs.Count - $finished.Count) of $($jobs.Count) compiles did not finish inside 120 s"
        }
        for ($index = 0; $index -lt $slots.Count; $index++) {
            $result = Receive-Job $jobs[$index]
            if ($result.ExitCode -ne 0) {
                $jobs | Remove-Job -Force
                throw "bicep build-params of $($slots[$index].Label) failed with exit code $($result.ExitCode):`n$($result.Output)"
            }
            $after = Get-Content $slots[$index].Compiled -Raw | ConvertFrom-Json -AsHashtable -DateKind String
            if (($slots[$index].Before.parameters | ConvertTo-Json -Depth 20 -Compress) -cne ($after.parameters | ConvertTo-Json -Depth 20 -Compress)) {
                $differ.Add($slots[$index].Label)
            }
        }
        $jobs | Remove-Job -Force
        $count | Should -BeGreaterThan 0
        $differ |
            Should -BeNullOrEmpty -Because 'the compiled .bicepparam must hold exactly the values of the ConvertTo-Json parameters file'
    }
}
