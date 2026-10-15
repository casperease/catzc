<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/Test-Pipelines.ps1
    kind: gate-function
    module: Catzc.Azure.DevOps
    visibility: public
    relatives:
      page: docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md
      test: automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PIPE-NAME
      - ADR-PIPE-NAME#{1-4,6,7}
  config:
    synopsis: 'Quality gate: checks the pipelines/ tree against the naming-and-placement contract.'
    description: |-
      Classifies every YAML under pipelines/ with Get-AdoYamlFiles (offline — structure heuristics, no ADO
      call), applies the deterministic [ADR-PIPE-NAME](/docs/adr/pipelines/pipeline-naming-and-placement.md) rules,
      collects every violation, and ends with Write-QualityGateReport
      ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): the report lands in
      out/test-pipelines/, and the gate throws once listing every violation (or returns the result with -PassThru).

      Rules enforced (each violation names its rule code, as '[<rule>] pipelines/<file>: <message>'):

        [ADR-PIPE-NAME#6](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name6)  Executable YAML is
        `.yaml`; there is no `.yml` under pipelines/ (config is `.yml`, but
                        it lives outside pipelines/).
        [ADR-PIPE-NAME#2](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name2)  Pipelines live FLAT
        in pipelines/. Every `.yaml` is either at the root or directly in a
                        per-kind template folder — never deeper, never in another subfolder. A file whose
                        STRUCTURE is a pipeline (trigger/pr/…) must be at the root, not inside a template folder.
        [ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3)  Template folders are
        the closed set steps/ jobs/ stages/ variables/ extends/, and a
                        fragment's structural kind matches its folder (a steps template lives in steps/, …).
        [ADR-PIPE-NAME#1](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name1)  A root pipeline's
        filename starts with its type — cron | ci | cd | cde | deploy | input.
        [ADR-PIPE-NAME#4](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name4)  Templates are
        referenced by absolute path (`/pipelines/<kind>/<name>.yaml`), never a
                        relative path.

      Invoke-AdoScript.ps1 is a `.ps1`, not YAML, so it never enters the scan
      ([ADR-PIPE-NAME#7](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name7)). A file that
      fails to parse is reported as a violation so a broken pipeline cannot slip through silently.
    parameters:
      Path: The pipelines/ directory to check. Defaults to `<repo>/pipelines`.
      OutputFolder: The report base folder. Defaults to Write-QualityGateReport's (out/test-pipelines).
      PassThru: Return the gate result { Subject; IssueCount; Issues; ReportPath; Files } instead of throwing on violations.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-Pipelines
      - (Test-Pipelines -PassThru).Issues
---
#>

function Test-Pipelines {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Path,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $pipelinesRoot = if ($Path) {
        $Path
    }
    else {
        Join-Path (Get-RepositoryRoot) 'pipelines'
    }
    Assert-PathExist $pipelinesRoot -PathType Container

    $typePrefixes = @('cron', 'ci', 'cd', 'cde', 'deploy', 'input')
    $templateFolders = @('steps', 'jobs', 'stages', 'variables', 'extends')
    # The structural kind we expect a fragment folder to hold (extends/ is whole-pipeline — any body).
    $folderKind = @{ steps = 'Steps'; jobs = 'Jobs'; stages = 'Stages'; variables = 'Variables' }

    $records = @(Get-AdoYamlFiles -Path $pipelinesRoot)
    $violations = [System.Collections.Generic.List[string]]::new()

    function New-Violation {
        param($RelativePath, $Rule, $Message)
        "[$Rule] pipelines/${RelativePath}: $Message"
    }

    foreach ($record in $records) {
        $rel = $record.RelativePath
        $dir = ($record.RelativeDirectory -replace '\\', '/').Trim('/')
        $name = Split-Path $rel -Leaf
        $extension = [System.IO.Path]::GetExtension($name).ToLowerInvariant()
        $segments = @()
        if ($dir) {
            $segments = @($dir -split '/')
        }
        $topFolder = if ($segments.Count -ge 1) {
            $segments[0]
        }
        else {
            ''
        }

        # A parse failure is itself a violation — a pipeline that ADO cannot read is not compliant.
        if ($record.ParseError) {
            $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME:parse' -Message "YAML failed to parse: $($record.ParseError)"))
            continue
        }

        if ($extension -eq '.yml') {
            $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#6' -Message "Executable pipeline YAML must be '.yaml', not '.yml'."))
            continue
        }

        if ($segments.Count -eq 0) {
            $prefix = ($name -split '-', 2)[0]
            if ($prefix -notin $typePrefixes) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#1' -Message "Pipeline name must start with a type ($($typePrefixes -join ' | ')); got '$prefix'."))
            }
        }
        else {
            if ($topFolder -notin $templateFolders) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#3' -Message "Template folder '$topFolder' is not one of: $($templateFolders -join ' | ')."))
            }
            elseif ($segments.Count -gt 1) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#2' -Message "Templates live directly in '$topFolder/', not nested deeper ('$dir/')."))
            }
            else {
                if ($record.Classification -eq 'Pipeline') {
                    $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#2' -Message "A pipeline (trigger/pr/… shape) must live flat in pipelines/, not inside '$topFolder/'."))
                }
                elseif ($folderKind.ContainsKey($topFolder) -and $record.TemplateType -and "$($record.TemplateType)" -ne $folderKind[$topFolder]) {
                    $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#3' -Message "A '$($record.TemplateType)' template does not belong in '$topFolder/' (expected $($folderKind[$topFolder]))."))
                }
            }
        }

        foreach ($ref in (Get-PipelineTemplateReference -Path $record.Path)) {
            if ($ref -notmatch '^/pipelines/') {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPE-NAME#4' -Message "Template reference '$ref' must be an absolute path starting with /pipelines/."))
            }
        }
    }

    Write-QualityGateReport -Subject pipelines -Title Test-Pipelines -Issues $violations.ToArray() `
        -Facts ([ordered]@{ Files = $records.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
