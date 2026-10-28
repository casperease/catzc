# pwsh/Tooling.Python/configs/generated.yml

The writer rows of the Python toolchain. `Get-GeneratedTarget` reads every module's `generated.yml`, and this one names what the toolchain
writes, so that none of it is taken for an authored file. Both writers are `untracked`.

## Writers

- **`uv`** — `python/.venv/**` and `python/uv.lock`, the environment and the lock file it builds.
- **`ruff`** — `**/.ruff_cache/**`, the cache of the checker.
