"""A generated file's stamp, put on by the one head renderer (ADR-REPO-FILEMETA-COMPOSEDFILES): a writer of the kit names the files it
wrote and its row in the writer registry, and one cats run stamps them all through Set-GeneratedFileHead, so the kit never words a head."""

import subprocess
from pathlib import Path

import yaml

from .module_paths import MODULES_TRACK, REPO, module_file

ENTRY = REPO / MODULES_TRACK / ".internal" / "assets" / "Invoke-CatzcCommand.ps1"
# The entry script bounds its own run by the run lock's budget; the call outlives it only by the time its process takes to end.
EXIT_GRACE_SECONDS = 10


def _quoted(text):
    """A PowerShell single-quoted string of the text, its quotes doubled."""
    return "'" + str(text).replace("'", "''") + "'"


def _relative(path):
    """The path from the repository root, in forward slashes."""
    return Path(path).resolve().relative_to(REPO).as_posix()


def command(paths, writer):
    """The entry script's call: one Set-GeneratedFileHead line per path, all of them run in its one imported session."""
    lines = [f"Set-GeneratedFileHead -Path {_quoted(_relative(path))} -Writer {_quoted(writer)}" for path in paths]
    return ["pwsh", "-NoProfile", "-File", str(ENTRY), *lines]


def budget_seconds():
    """The run lock's budget of timeouts.yml, the most seconds the entry script's run may take."""
    timeouts = yaml.safe_load(module_file("Catzc.Base.Timeouts", "configs", "timeouts.yml").read_text(encoding="utf-8"))
    return int(timeouts["run_lock"]["budget_seconds"])


def stamp(paths, writer):
    """Stamp every path inside the repository with its writer's head; a path outside it is no file of ours and is left alone. A refused
    stamp stops the writer, naming the entry script's last lines; returns the paths stamped."""
    inside = [Path(path) for path in paths if Path(path).resolve().is_relative_to(REPO)]
    if not inside:
        return []
    run = subprocess.run(
        command(inside, writer),
        cwd=REPO,
        capture_output=True,
        text=True,
        encoding="utf-8",
        timeout=budget_seconds() + EXIT_GRACE_SECONDS,
        check=False,
    )
    if run.returncode != 0:
        tail = " | ".join((run.stdout + run.stderr).strip().splitlines()[-5:])
        raise SystemExit(f"stamp: Set-GeneratedFileHead refused the {writer} head of {len(inside)} file(s): {tail}")
    return inside
