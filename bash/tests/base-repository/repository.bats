# Black-box tests of Catzc.Base.Repository, in Bash.
#
# Each test calls catzc the way a Bash user does: setup loads the engine's entry, the repository's importer.sh
# (CATZC_ENGINE_ENTRY), and the test runs a command through its cats dispatcher, which loads the run's PowerShell entry
# (CATZC_IMPORTER: the repository's importer.ps1 in a source run, the build's Import-Catzc.ps1 in a build run).
# Invoke-BashTest sets the contract and CATZC_REPOSITORY_ROOT for the bats run.

_require_contract() {
    if [ -z "${CATZC_ENGINE_ENTRY:-}" ] || [ -z "${CATZC_REPOSITORY_ROOT:-}" ]; then
        echo "CATZC_ENGINE_ENTRY or CATZC_REPOSITORY_ROOT is not set; run the Bash tests through Invoke-BashTest" >&2
        return 1
    fi
    # shellcheck source=/dev/null
    source "$CATZC_ENGINE_ENTRY"
}

# One cats call starts pwsh and imports catzc, so setup_file makes it once, saves its exit code and output, and both
# tests assert on that saved call (ADR-AUTO-TEST-ONEIMPORTPERCASE).
setup_file() {
    _require_contract || return 1
    local code=0
    # bats runs setup_file under errexit, so a failing call is caught here and its code saved.
    cats Get-RepositoryRoot >"$BATS_FILE_TMPDIR/root.out" 2>&1 || code=$?
    echo "$code" >"$BATS_FILE_TMPDIR/root.status"
}

setup() {
    _require_contract
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
    local status output
    status="$(cat "$BATS_FILE_TMPDIR/root.status")"
    output="$(cat "$BATS_FILE_TMPDIR/root.out")"
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
