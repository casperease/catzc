"""A generated file's stamp, put on by the one head renderer (ADR-REPO-FILEMETA-COMPOSEDFILES): a writer of the kit names the files it
wrote and its row in the writer registry, and one cats run stamps them all through Set-GeneratedFileHead, so the kit never words a head."""

import subprocess
from pathlib import Path

import yaml

from .module_paths import MODULES_TRACK, REPO, module_file

ENTRY = REPO / MODULES_TRACK / ".internal" / "assets" / "Invoke-CatzcCommand.ps1"
# The entry script bounds its own run by the run lock's budget; the call outlives it only by the time its process takes to end.
EXIT_GRACE_SECONDS = 10
# Windows ends a process's command line at 32,767 characters; a call stays under this safe share of it.
COMMAND_LINE_BUDGET = 30000


def _quoted(text):
    """A PowerShell single-quoted string of the text, its quotes doubled."""
    return "'" + str(text).replace("'", "''") + "'"


def _relative(path):
    """The path from the repository root, in forward slashes."""
    return Path(path).resolve().relative_to(REPO).as_posix()


def _line(relatives, writer):
    """One command line for the writer: its paths as a PowerShell array, each stamped through Set-GeneratedFileHead, whose -Path is one
    string."""
    array = ", ".join(_quoted(relative) for relative in relatives)
    return f"@({array}) | ForEach-Object {{ Set-GeneratedFileHead -Path $_ -Writer {_quoted(writer)} }}"


def commands(paths, writer):
    """The entry script's calls: each carries one line for the writer with its paths as an array, and a call is closed before its command
    line passes COMMAND_LINE_BUDGET, so any number of paths fits; one call when they all do."""
    relatives = [_relative(path) for path in paths]
    head = ["pwsh", "-NoProfile", "-File", str(ENTRY)]
    overhead = sum(len(part) + 1 for part in head) + len(_line([], writer)) + 3
    calls, chunk, size = [], [], overhead
    for relative in relatives:
        cost = len(_quoted(relative)) + 2
        if chunk and size + cost > COMMAND_LINE_BUDGET:
            calls.append([*head, _line(chunk, writer)])
            chunk, size = [], overhead
        chunk.append(relative)
        size += cost
    if chunk:
        calls.append([*head, _line(chunk, writer)])
    return calls


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
    timeout = budget_seconds() + EXIT_GRACE_SECONDS
    for call in commands(inside, writer):
        run = subprocess.run(call, cwd=REPO, capture_output=True, text=True, encoding="utf-8", timeout=timeout, check=False)
        if run.returncode != 0:
            tail = " | ".join((run.stdout + run.stderr).strip().splitlines()[-5:])
            raise SystemExit(f"stamp: Set-GeneratedFileHead refused the {writer} head of {len(inside)} file(s): {tail}")
    return inside
