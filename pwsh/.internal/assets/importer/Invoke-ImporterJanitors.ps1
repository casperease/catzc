function Invoke-ImporterJanitors {
    # .SYNOPSIS
    #     Runs the post-import janitors in their fixed order, from the opt-in deep clean to the commit of what changed.
    # .DESCRIPTION
    #     Every janitor is a fast no-op on a clean tree and guarded by presence, so the bootstrap sandbox runs a subset.
    # .PARAMETER CleanClone
    #     Run the whitelisted deep clean (Reset-GitCleanFxd) first, so the janitors below rematerialise what it removed.
    # .PARAMETER ShowStateChanges
    #     Show the type-cache janitor's end-state report (the importer passes its -Verbose).
    [CmdletBinding()]
    param(
        [switch] $CleanClone,
        [switch] $ShowStateChanges
    )

    # Opt-in deep clean (-CleanClone): the whitelisted git clean -fxd (Reset-GitCleanFxd) deletes only the
    # auto-controlled generated artifacts and keeps — reported — any untracked file that is not the
    # automation's to delete. Deliberately the FIRST janitor, so the regenerating janitors below
    # rematerialise what it removed in the same run. Guarded: absent in the bootstrap sandbox.
    if ($CleanClone -and (Get-Command Reset-GitCleanFxd -ErrorAction Ignore)) {
        Reset-GitCleanFxd
    }

    # Before the re-renders, so a hand edit is reported before a render overwrites it.
    Invoke-GeneratedFilesJanitor

    # Tidy superseded type assemblies (.compiled stays a clean -1/+1 diff) — see Invoke-TypeCacheJanitor.
    Invoke-TypeCacheJanitor -ShowReport:$ShowStateChanges

    # A build janitor re-renders only when the changed set or a missing output makes its writer due; the writers it
    # considers, in order, and
    # the lists are generated-files.yml's (at_import).
    $atImport = @(if (Get-Command Get-Config -ErrorAction Ignore) {
            (Get-Config -Config generated-files).writers.Values | Where-Object { $_.at_import } |
                ForEach-Object { $_.name }
        })
    $due = Get-DueWriterRow -Name $atImport
    $saveStamp = Get-Command Save-GeneratedWriterStamp -ErrorAction Ignore
    # Keep the generated ADR pages current (Catzc.Base.Docs): `docs/drs/index.md` from drs.yml and
    # `docs/drs/glossary.md` from the glossary sources — committed so GitHub has them, rebuilt BEFORE
    # Build-Readme (the docs/drs README is generated from the index). See
    # [ADR-REPO-README](/docs/drs/repository/generated-readmes.md).
    #
    # Keep the generated contract pages current (Catzc.Base.Contracts): docs/references/contracts/<unit>.md from the
    # contract assets' header comments — committed so GitHub has them. See
    # [ADR-REPO-README](/docs/drs/repository/generated-readmes.md).
    #
    # Keep the generated README copy-ins current (Catzc.Base.Docs). Fast no-op when nothing changed — Build-Readme
    # rewrites a README only when its composed content differs (compared EOL-insensitively), so a clean tree costs
    # only a few small file reads. Guarded: absent in the bootstrap sandbox, like Clear-ModuleTypeCache.
    #
    # Keep the managed .gitkeep files current (Catzc.Base.Docs). Every .gitkeep is a committed copy of the
    # one shared template, pointing at its folder's generated README — reproduced here so a template change
    # propagates, and a fast no-op on a clean tree. See [ADR-REPO-README](/docs/drs/repository/generated-readmes.md).
    #
    # Keep the generated cspell dictionaries current (Catzc.Base.QualityGates). They are derived from
    # configs/terminology.yml — gitignored, not committed — so the registry is the single source of truth and
    # cspell still resolves them at fixed paths. Fast no-op when nothing changed (writes only on drift).
    #
    # Keep the managed root config files current (Catzc.Base.RootConfig). Every opted-in root file is
    # reproduced from its single in-repo source of truth — an authored source copied out with a generated-file
    # header (e.g. the root PSScriptAnalyzerSettings.psd1 from .internal/assets), or a generator's rendered
    # output (e.g. New-Importer for importer.ps1). Rewrites only on drift, so a clean tree is a fast no-op.
    # Guarded: absent in the bootstrap sandbox. See [ADR-REPO-ROOTCFG](/docs/drs/repository/generated-root-configs.md).
    foreach ($writer in $atImport) {
        if ((Get-Command $writer -ErrorAction Ignore) -and (Test-WriterDue -Name $writer -Row $due)) {
            & $writer -Silent | Out-Null
            # The writer ran: its input stamp is stored, so it is not due again until one of its inputs changes.
            if ($saveStamp) {
                & $saveStamp -Name $writer
            }
        }
    }

    # Reconcile the session PATH to whatever tools are actually present — including tools installed outside the
    # installer layer (e.g. nvm-managed node) — and report any running from a non-owned location on one line.
    # Session-only, self-skips in CI. The importer is dot-sourced, so its PATH nudges land in the caller's live
    # session. The janitor announces each nudge like any function, but at every shell open the same nudges are part
    # of the load record
    # ([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](/docs/drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)):
    # the importer's -Verbose decides whether they are shown, so a plain import prints only the Loaded line. The
    # quieting is the session-wide information preference, restored in the finally
    # ([ADR-PWSH-ANNOUNCE-UNANNOUNCEDCHANGES](/docs/drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-unannouncedchanges)): a common parameter
    # would reach only the janitor's own scope, not the writer chokepoint in Catzc.Base.Writers. Guarded: absent in
    # the bootstrap sandbox (Catzc.Tooling.Core).
    if (Get-Command Sync-SessionTools -ErrorAction Ignore) {
        $informationPreference = $global:InformationPreference
        if (-not $ShowStateChanges) {
            $global:InformationPreference = 'SilentlyContinue'
        }
        try {
            Sync-SessionTools
        }
        finally {
            $global:InformationPreference = $informationPreference
        }
    }

    # Publish the agent hook when its source changed — after the PATH reconciliation, so `dotnet` is the owned SDK.
    Invoke-AgentHookJanitor

    Invoke-EditorExtensionJanitor
}
