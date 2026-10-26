# pwsh/Tooling.Python/configs/generated.yml

The generated-targets declaration of the Python toolchain. `Get-GeneratedTarget` reads every module's `generated.yml`, and this one names
what the toolchain writes, so that none of it is taken for an authored file.

## Targets

- **`python/.venv/**`** and **`python/uv.lock`** — the environment and the lock file that uv builds.
- **`**/.ruff_cache/**`** — the cache of the ruff checker.
