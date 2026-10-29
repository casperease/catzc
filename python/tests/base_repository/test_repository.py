"""Black-box tests of Catzc.Base.Repository.

The engine starts as its own process the way the run's engine contract says — CATZC_ENGINE_EXECUTABLE, with the
CATZC_ENGINE_START arguments, which load the run's entry (the repository's importer.ps1 in a source run, the build's
Import-Catzc.ps1 in a build run) — and the tests assert on what the engine prints. The conftest's one start answers every
command once per test run, and every test asserting on a command reads the one answer (ADR-AUTO-TEST-ONEIMPORTPERCASE).
Invoke-PythonTest sets the contract and CATZC_REPOSITORY_ROOT for the uv commands it runs.
"""

import os
import sys
from pathlib import PurePath

import pytest


def require_env(name: str) -> str:
    """Return an environment variable the test contract names, failing the test when it is not set."""
    value = os.environ.get(name, "")
    if not value:
        pytest.fail(f"{name} is not set; run the Python tests through Invoke-PythonTest")
    return value


def normalize_path(path: str) -> str:
    """Make two spellings of one folder compare equal: forward slashes, no trailing slash, and on Windows no case
    difference."""
    normalized = PurePath(path).as_posix().rstrip("/")
    if sys.platform == "win32":
        normalized = normalized.lower()
    return normalized


def assert_repository_root(engine_answers: dict[str, str]) -> None:
    """Check that the engine reports the repository root the test contract names."""
    want = require_env("CATZC_REPOSITORY_ROOT")
    got = engine_answers["root"]
    assert normalize_path(got) == normalize_path(want), f"Get-RepositoryRoot printed {got!r}, want {want!r}"


def test_repository_root(engine_answers: dict[str, str]) -> None:
    """The engine, started from its entry script, reports the repository root."""
    assert_repository_root(engine_answers)


def test_integrity_repository_root(engine_answers: dict[str, str]) -> None:
    """The same check as an integrity test, so it also runs against the build in the build run."""
    assert_repository_root(engine_answers)
