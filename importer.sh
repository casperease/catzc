# ---
# catzc:
#   immutable:
#     with_body_sha: b2f4855b8a9b
#     repo_status: locked
#     path: importer.sh
#     source: automation/Catzc.Base.RootConfig/assets/root/importer.sh
#     kind: script
#     language: bash
#     filetype: sh
#     generator: automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
# ---

# shellcheck shell=bash
# importer.sh — brings catzc to a bash (or zsh) session. catzc's commands are PowerShell, so this defines one dispatcher,
# `cats`, that runs any catzc command through pwsh with the repository's importer loaded
# (ADR-AUTO-ENGINE, docs/adr/automation/execution-engines.md):
#
#   source ./importer.sh                                  # must be sourced, not run
#   cats                                                  # lists the catzc commands
#   cats Get-RepositoryRoot
#   cats Test-Automation -Modules Catzc.Base.Repository -MaxLevel 2
#
# An argument that starts with '-' passes through as a parameter name; every other argument after the command is passed
# as one PowerShell literal, quoted the PowerShell way, so a value with spaces or a quote stays one value. Every call
# starts pwsh non-interactively and imports catzc, so it pays the import time; for many commands in a row, start pwsh
# and dot-source importer.ps1 instead.
#
# CATZC_IMPORTER names the PowerShell entry `cats` loads; unset, it is this repository's importer.ps1. A test run sets
# it to a build's Import-Catzc.ps1, so a bash session drives the build.

# Sourced only: `return` works at the top level of a sourced file and fails in a script that was run.
(return 0 2>/dev/null) || {
    echo "importer.sh must be sourced, not run: source ./importer.sh" >&2
    exit 1
}

# The repository root: the folder of this file, in the form pwsh reads (C:/... under Git Bash on Windows).
if [ -n "${ZSH_VERSION:-}" ]; then
    # zsh's own form for the sourced file's path; this branch runs only under zsh, where it is valid.
    # shellcheck disable=SC2296
    _catzc_root="$(cd "$(dirname "${(%):-%x}")" && pwd)"
else
    _catzc_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
if command -v cygpath >/dev/null 2>&1; then
    _catzc_root="$(cygpath -m "$_catzc_root")"
fi

# One PowerShell single-quoted literal: a quote inside is doubled.
_catzc_literal() {
    printf "'%s'" "$(printf '%s' "$1" | sed "s/'/''/g")"
}

# cats [Command] [arguments...] — runs a catzc command through pwsh; with no arguments, lists the catzc commands.
cats() {
    _catzc_pwsh="$(command -v pwsh)" || {
        echo "cats: pwsh is not on PATH; catzc runs on PowerShell 7 (https://aka.ms/powershell)." >&2
        return 127
    }
    _catzc_load=". $(_catzc_literal "${CATZC_IMPORTER:-$_catzc_root/importer.ps1}") *> \$null"
    if [ "$#" -eq 0 ]; then
        "$_catzc_pwsh" -NoProfile -NonInteractive -Command \
            "$_catzc_load; Get-Command -Module 'Catzc.*' -CommandType Function | Sort-Object Name | ForEach-Object Name"
        return
    fi
    _catzc_text="$1"
    shift
    for _catzc_argument in "$@"; do
        case "$_catzc_argument" in
            -*) _catzc_text="$_catzc_text $_catzc_argument" ;;
            *) _catzc_text="$_catzc_text $(_catzc_literal "$_catzc_argument")" ;;
        esac
    done
    "$_catzc_pwsh" -NoProfile -NonInteractive -Command "$_catzc_load; $_catzc_text"
}
