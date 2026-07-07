<#
.SYNOPSIS
    Checks the pipelines/ tree against the naming-and-placement contract (ADR-PIPENAME) and returns the
    violations — the query half of the pipeline-layout gate.
.DESCRIPTION
    Classifies every YAML under pipelines/ with Get-AdoYamlFiles (offline — structure heuristics, no ADO
    call) and applies the deterministic ADR-PIPENAME rules, returning one record per violation. It reports;
    it does not throw — Assert-Pipelines is the throwing gate that wraps it.

    Rules enforced (each violation carries its rule code):

      ADR-PIPENAME:6  Executable YAML is `.yaml`; there is no `.yml` under pipelines/ (config is `.yml`, but
                      it lives outside pipelines/).
      ADR-PIPENAME:2  Pipelines live FLAT in pipelines/. Every `.yaml` is either at the root or directly in a
                      per-kind template folder — never deeper, never in another subfolder. A file whose
                      STRUCTURE is a pipeline (trigger/pr/…) must be at the root, not inside a template folder.
      ADR-PIPENAME:3  Template folders are the closed set steps/ jobs/ stages/ variables/ extends/, and a
                      fragment's structural kind matches its folder (a steps template lives in steps/, …).
      ADR-PIPENAME:1  A root pipeline's filename starts with its type — cron | ci | cd | cde | deploy | input.
      ADR-PIPENAME:4  Templates are referenced by absolute path (`/pipelines/<kind>/<name>.yaml`), never a
                      relative path.

    Invoke-AdoScript.ps1 is a `.ps1`, not YAML, so it never enters the scan (ADR-PIPENAME:7). A file that
    fails to parse is reported as a violation so a broken pipeline cannot slip through silently.
.PARAMETER Path
    The pipelines/ directory to check. Defaults to `<repo>/pipelines`.
.OUTPUTS
    [pscustomobject[]] One per violation: { File (repo-relative), Rule, Message }. Empty when the tree is
    compliant.
.EXAMPLE
    Test-Pipelines
.EXAMPLE
    Test-Pipelines | Format-Table File, Rule, Message
#>
function Test-Pipelines {
    [CmdletBinding()]
    [OutputType([pscustomobject[]])]
    param(
        [string] $Path
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
    $violations = [System.Collections.Generic.List[pscustomobject]]::new()

    function New-Violation {
        param($RelativePath, $Rule, $Message)
        [pscustomobject]@{
            File    = "pipelines/$RelativePath"
            Rule    = $Rule
            Message = $Message
        }
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
            $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPENAME:parse' -Message "YAML failed to parse: $($record.ParseError)"))
            continue
        }

        # ADR-PIPENAME:6 — executable YAML under pipelines/ is `.yaml`, never `.yml`.
        if ($extension -eq '.yml') {
            $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPENAME:6' -Message "Executable pipeline YAML must be '.yaml', not '.yml'."))
            continue
        }

        if ($segments.Count -eq 0) {
            # --- Root of pipelines/ : this is a pipeline entry point. ---
            # ADR-PIPENAME:1 — filename starts with a valid type token.
            $prefix = ($name -split '-', 2)[0]
            if ($prefix -notin $typePrefixes) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPENAME:1' -Message "Pipeline name must start with a type ($($typePrefixes -join ' | ')); got '$prefix'."))
            }
        }
        else {
            # --- Inside a subfolder : must be a per-kind template folder, one level deep. ---
            # ADR-PIPENAME:3 — the folder is in the closed set, and no deeper nesting.
            if ($topFolder -notin $templateFolders) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPENAME:3' -Message "Template folder '$topFolder' is not one of: $($templateFolders -join ' | ')."))
            }
            elseif ($segments.Count -gt 1) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPENAME:2' -Message "Templates live directly in '$topFolder/', not nested deeper ('$dir/')."))
            }
            else {
                # ADR-PIPENAME:2 — a structural pipeline has no business inside a template folder.
                if ($record.Classification -eq 'Pipeline') {
                    $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPENAME:2' -Message "A pipeline (trigger/pr/… shape) must live flat in pipelines/, not inside '$topFolder/'."))
                }
                # ADR-PIPENAME:3 — a fragment's structural kind matches its folder (extends/ exempt).
                elseif ($folderKind.ContainsKey($topFolder) -and $record.TemplateType -and "$($record.TemplateType)" -ne $folderKind[$topFolder]) {
                    $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPENAME:3' -Message "A '$($record.TemplateType)' template does not belong in '$topFolder/' (expected $($folderKind[$topFolder]))."))
                }
            }
        }

        # ADR-PIPENAME:4 — template references are absolute (/pipelines/<kind>/<name>.yaml).
        foreach ($ref in (Get-PipelineTemplateReference -Path $record.Path)) {
            if ($ref -notmatch '^/pipelines/') {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-PIPENAME:4' -Message "Template reference '$ref' must be an absolute path starting with /pipelines/."))
            }
        }
    }

    $violations.ToArray()
}
