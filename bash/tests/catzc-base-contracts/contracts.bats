# Black-box tests of Catzc.Base.Contracts, in Bash.
#
# Each test calls catzc the way a Bash user does: setup loads the engine's entry (CATZC_ENGINE_ENTRY), and the test runs a
# command through its cats dispatcher. Invoke-BashTest sets the contract and CATZC_REPOSITORY_ROOT for the bats run.

setup() {
    if [ -z "${CATZC_ENGINE_ENTRY:-}" ] || [ -z "${CATZC_REPOSITORY_ROOT:-}" ]; then
        echo "CATZC_ENGINE_ENTRY or CATZC_REPOSITORY_ROOT is not set; run the Bash tests through Invoke-BashTest" >&2
        return 1
    fi
    # shellcheck source=/dev/null
    source "$CATZC_ENGINE_ENTRY"
}

@test "a contract root lists one checked asset per pipeline file it applies to" {
    run cats Get-Contract -Root ado
    [ "$status" -eq 0 ] || {
        echo "Get-Contract exited $status: $output" >&2
        return 1
    }
    # Every pipeline file the asset applies to is one more row of the same asset.
    local count
    count="$(grep -c '\.ado/pipelines/' <<<"$output" || true)"
    [ "$count" -gt 1 ] || {
        echo "Get-Contract listed $count rows of the pipeline asset, want more than one: $output" >&2
        return 1
    }
}
