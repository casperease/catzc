# ---
# catzc:
#   derived:
#     path: bash/tests/catzc-base-repository/repository.bats
#     folder: tests/catzc-base-repository
#     name: repository
#     filetype: bats
#     kind: test
#     language: bash
#     track: bash
#     module: bash
#     moduletype: bash
# ---

# Black-box tests of Catzc.Base.Repository, in Bash.
#
# Each test calls catzc the way a Bash user does: setup loads the engine's entry, the repository's importer.sh
# (CATZC_ENGINE_ENTRY), and the test runs a command through its cats dispatcher, which loads the run's PowerShell entry
# (CATZC_IMPORTER: the repository's importer.ps1 in a source run, the build's Import-Catzc.ps1 in a build run).
# Invoke-BashTest sets the contract and CATZC_REPOSITORY_ROOT for the bats run.

setup() {
    if [ -z "${CATZC_ENGINE_ENTRY:-}" ] || [ -z "${CATZC_REPOSITORY_ROOT:-}" ]; then
        echo "CATZC_ENGINE_ENTRY or CATZC_REPOSITORY_ROOT is not set; run the Bash tests through Invoke-BashTest" >&2
        return 1
    fi
    # shellcheck source=/dev/null
    source "$CATZC_ENGINE_ENTRY"
}

# Makes two spellings of one folder compare equal: forward slashes, no trailing slash, and on Windows (where cygpath
# is) the mixed C:/ form with no case difference.
normalize_path() {
    local path="${1//\\//}"
    if command -v cygpath >/dev/null 2>&1; then
        path="$(cygpath -m "$path" | tr '[:upper:]' '[:lower:]')"
    fi
    printf '%s' "${path%/}"
}

# Checks that the engine, through cats, reports the repository root the test contract names.
assert_repository_root() {
    run cats Get-RepositoryRoot
    [ "$status" -eq 0 ] || {
        echo "cats Get-RepositoryRoot failed with exit $status: $output" >&2
        return 1
    }
    local got want
    got="$(normalize_path "$(printf '%s' "$output" | tr -d '\r' | tail -n 1)")"
    want="$(normalize_path "$CATZC_REPOSITORY_ROOT")"
    [ "$got" = "$want" ] || {
        echo "Get-RepositoryRoot printed '$got', want '$want'" >&2
        return 1
    }
}

@test "repository root" {
    assert_repository_root
}

@test "integrity: repository root" {
    assert_repository_root
}
