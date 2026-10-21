# ---
# catzc:
#   immutable:
#     with_body_sha: "6dce2ee47ab0"
# ---

"""Black-box tests of Catzc.Base.Repository.

Each test starts the engine as its own process the way the run's engine contract says — CATZC_ENGINE_EXECUTABLE, with
the CATZC_ENGINE_START arguments, which load the run's entry (the repository's importer.ps1 in a source run, the
build's Import-Catzc.ps1 in a build run) — and asserts on what the engine prints. Invoke-PythonTest sets the contract
and CATZC_REPOSITORY_ROOT for the uv commands it runs.
"""

import json
import os
import subprocess
import sys
from pathlib import PurePath

import pytest


def require_env(name: str) -> str:
    """Return an environment variable the test contract names, failing the test when it is not set."""
    value = os.environ.get(name, "")
    if not value:
        pytest.fail(f"{name} is not set; run the Python tests through Invoke-PythonTest")
    return value


def run_engine(command: str) -> str:
    """Start the engine the contract names, which loads the entry with its output discarded, run the command, and
    return what the command printed, trimmed."""
    executable = require_env("CATZC_ENGINE_EXECUTABLE")
    start = json.loads(require_env("CATZC_ENGINE_START"))
    if not isinstance(start, list) or not start:
        pytest.fail("CATZC_ENGINE_START is not a JSON array of arguments")
    arguments = list(start)
    arguments[-1] = arguments[-1].replace("{command}", command, 1)
    # Bounds one engine start, an import plus one command, by the contract's engine start limit.
    timeout = int(require_env("CATZC_ENGINE_TIMEOUT_SECONDS"))
    completed = subprocess.run(
        [executable, *arguments],
        capture_output=True,
        text=True,
        timeout=timeout,
        check=False,
    )
    if completed.returncode != 0:
        pytest.fail(f"the engine failed to run {command!r} with exit {completed.returncode}:\n{completed.stdout}{completed.stderr}")
    return completed.stdout.strip()


def normalize_path(path: str) -> str:
    """Make two spellings of one folder compare equal: forward slashes, no trailing slash, and on Windows no case
    difference."""
    normalized = PurePath(path).as_posix().rstrip("/")
    if sys.platform == "win32":
        normalized = normalized.lower()
    return normalized


def assert_repository_root() -> None:
    """Check that the engine reports the repository root the test contract names."""
    want = require_env("CATZC_REPOSITORY_ROOT")
    got = run_engine("Get-RepositoryRoot")
    assert normalize_path(got) == normalize_path(want), f"Get-RepositoryRoot printed {got!r}, want {want!r}"


def test_repository_root() -> None:
    """The engine, started from its entry script, reports the repository root."""
    assert_repository_root()


def test_integrity_repository_root() -> None:
    """The same check as an integrity test, so it also runs against the build in the build run."""
    assert_repository_root()
