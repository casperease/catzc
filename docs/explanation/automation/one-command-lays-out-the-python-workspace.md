# How the Python workspace is laid out

```text
A maintainer adds a Python folder; one command renders the uv workspace, the tree classifies its files, and the gates hold.

1  A maintainer adds a Python folder   the cause: a new Python folder needs its place in the workspace
2  new_python_project                                the action: one command, in the contract form
3  The workspace root                                zone 1, local: get_repository_file shows python/pyproject.toml
4  The kit's member file                             zone 1, local: get_repository_file shows python/diagrams/pyproject.toml
5  A known file kind                                 zone 2, local, after 3: get_path_file_type names the root file's kind
6  The Python language                               zone 2, local, after 4: get_file_language puts the member's file in Python
7  The root-config drift check                        zone 3, local, after 3: test_generated_files sees no drift for Build-RootConfig
8  The Test-PythonTypes                                    zone 3, local, after 6: test_python_types passes over the workspace
9  The Test-Formatting                               zone 3, local, after 5: test_formatting passes for the Python language

Supports ADR-AUTO-UVPY-UVHANDLESPYTHON, ADR-AUTO-PY-PYWORKSPACE, ADR-AUTO-PY-ONEPYTHONVERSION,
ADR-AUTO-PY-EVERYFILETYPECHECKED and ADR-AUTO-IDIOM-LANGUAGEIDIOM (action lens).
```

uv is the single handler for Python in this repository: it provisions the interpreter, pins it, and runs every Python tool. What uv needs
from the tree is a workspace, and nobody writes that by hand: the workspace is generated and gitignored, rendered from the languages
configuration by one command and written on every import, so the only Python the repository commits is the code itself. This diagram is that
command and the three zones its effects reach: the two files it renders, how the tree then classifies them and holds them to their source,
and the two Python quality gates that pass over the workspace they define.

![How the Python workspace is laid out](.assets/how-the-python-workspace-is-laid-out.drawio.png)

## What the drawing shows

The [rendered action diagram](.assets/how-the-python-workspace-is-laid-out.drawio.png) reads left to right. The head, the circle fragment
numbered 1 above the centre line on the left rim, holds the idea in bold, **A maintainer adds a Python folder**; the stick man drawn over
the drawing hangs from it, his right hand on box 2, the statement `new_python_project`, with `cats` at the hand and nothing drawn between
head and hand. Three arcs cut the frame into three zones. No note carries a chip, since every effect is local, the diagram's default. Zone 1
holds 3, the workspace root rendered with every member and the pinned interpreter, and 4, the kit's member file, each proven by
`get_repository_file` with its path on its own line; the edges out of the statement carry `executes` beside the line. Zone 2 holds 5, the
root file is a known file kind, and 6, the member file belongs to the Python language, proven by `get_path_file_type` and
`get_file_language`; the edge from 3 to 5 and the edge from 4 to 6 carry `effects` in tight pills where they cross the first arc. Zone 3
holds three notes showing their words alone: 7, `Test-GeneratedFiles` sees no drift for the root configs, reached from 3; 8,
`Test-PythonTypes` passes, reached from 6; and 9, `Test-Formatting` passes for Python, reached from 5; each edge carries its `effects` pill
where it crosses the second arc. The edge from 3 to 7 skips the second zone, so it climbs into the top margin, runs across, and drops into 7
clear of the notes between, its pill on the first arc it crosses up there. Under the frame stands the Proof box with the statement in each
engine's words, and the legend band names the Action kinds, operators, marker and transition pill, the Proof box and the map key under the
sidebar.

## Walkthrough

1. **A maintainer adds a Python folder.** The cause is a new Python folder under the one Python root, named in Python's own idiom
   ([ADR-AUTO-IDIOM-LANGUAGEIDIOM](../../drs/automation/idiomatic-names.md#rule-adr-auto-idiom-languageidiom)). It needs a member file, and
   the workspace root must name it.
2. **new_python_project.** The action is one command in the contract form; its one parameter, the target, defaults to every member. It
   renders the workspace files from the languages configuration, pure text and byte-stable, never from a file someone edits by hand
   ([ADR-AUTO-PY-PYWORKSPACE](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-pyworkspace)).
3. **The workspace root.** The first zone holds what the command renders directly. `python/pyproject.toml` is the uv workspace: a virtual
   root naming every member explicitly, carrying the one Python version the tools pin
   ([ADR-AUTO-PY-ONEPYTHONVERSION](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-onepythonversion),
   [ADR-AUTO-UVPY-UVHANDLESPYTHON](../../drs/automation/uv-python-handler.md#rule-adr-auto-uvpy-uvhandlespython)).
4. **The kit's member file.** In the same zone, the same run renders a member file per Python folder; the diagram kit's own,
   `python/diagrams/pyproject.toml`, is the one shown. The two files are parallel effects of one run.
5. **A known file kind.** The second zone holds what the rendered files cause. A file in the tree is classified by the repository's file
   kinds, and `get_path_file_type` on the root file names its kind; this follows the root, so the edge comes from it.
6. **The Python language.** The member file belongs to the Python language, which is how every Python quality gate finds it:
   `get_file_language` on the path puts it there. It follows the member file.
7. **Test-GeneratedFiles for the root configs.** The rendered files are gitignored and written on every import by the root-config writer,
   and `test_generated_files` for that writer finds them in step with their source: a changed configuration without a re-render fails here.
   It follows the root and stands in zone 3 with the other gates, since a gate is what the classified files cause last.
8. **Test-PythonTypes.** The zone 3 holds what the classification causes: the gates run over what the Python language owns.
   `test_python_types` passes over the whole workspace
   ([ADR-AUTO-PY-EVERYFILETYPECHECKED](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfiletypechecked)).
9. **Test-Formatting.** `test_formatting` for the Python language passes as well; it follows the kind the root file was given, since the
   formatter is chosen by language.

## The proof

The drawing never says what the proof does not run. The seven runs below are copied from the accosted file the diagram names, and each
observation on the drawing occurs in them verbatim
([DDR-VISUAL-PROOFISTHEACCOSTEDFILE](../../drs/design/visual-design.md#rule-ddr-visual-proofistheaccostedfile)).

```yml accosted
runs:
  - - get_repository_file: { path: python/pyproject.toml }
  - - get_repository_file: { path: python/diagrams/pyproject.toml }
  - - get_path_file_type: { path: python/pyproject.toml }
  - - get_file_language: { path: python/diagrams/pyproject.toml }
  - - test_generated_files: { generator: Build-RootConfig }
  - - test_python_types:
  - - test_formatting: { language: python }
```

The same runs in PowerShell, rendered from that file by `Get-AccostedFragment`, never written by hand
([ADR-AUTO-ACCOSTED-ARTICLERENDERING](../../drs/automation/accosted-language.md#rule-adr-auto-accosted-articlerendering)):

```powershell
Get-RepositoryFile -Path 'python/pyproject.toml'

Get-RepositoryFile -Path 'python/diagrams/pyproject.toml'

Get-PathFileType -Path 'python/pyproject.toml'

Get-FileLanguage -Path 'python/diagrams/pyproject.toml'

Test-GeneratedFiles -Generator 'Build-RootConfig'

Test-PythonTypes

Test-Formatting -Language 'python'
```

## Notes from the inspection

- The edge from 6 to 8 and the edge from 5 to 9 cross each other between zones 2 and 3. Ordering the notes of a zone by the zone of their
  source, and then by their source's position, would remove most such crossings.
- The subtitle lists five rule codes in one line and the legend band carries nine Action entries; both are correct but heavy. `legend: used`
  would drop the `affects` row here, since no execution is drawn.

### Stronger with new definitions

- `content.order: by-source` beside the declared order, so a zone's notes stand in the order of their sources' positions; 8 and 9 would swap
  and their edges would no longer cross.

## Why it holds

- uv is the single handler for Python, so the workspace root is the one place the interpreter pin and the members are declared
  (ADR-AUTO-UVPY-UVHANDLESPYTHON, ADR-AUTO-PY-ONEPYTHONVERSION).
- The workspace is generated and gitignored, rendered from the languages configuration and drift-checked, so nothing Python-specific is
  committed but the code (ADR-AUTO-PY-PYWORKSPACE).
- Every Python file takes the repository's checks where it lands, so a file is under the gates the moment the tree classifies it
  (ADR-AUTO-PY-EVERYFILETYPECHECKED).
- A Python folder is named in Python's idiom, which is what makes it a member uv can import (ADR-AUTO-IDIOM-LANGUAGEIDIOM).
- Zone by zone the story goes forward: the files, then what the tree makes of them, then the gates over the classified set; no effect points
  back (DDR-VISUAL-ACTIONISALENS).

The gates prove the workspace is well-typed and well-formatted today; whether a member's code is right is its own tests' promise.

## See also

- [uv handles Python](../../drs/automation/uv-python-handler.md),
  [Python test artifacts](../../drs/automation/python/python-test-artifacts.md) and
  [idiomatic names](../../drs/automation/idiomatic-names.md) — the decisions this article explains.
- [Visual design](../../drs/design/visual-design.md) — how an action diagram is drawn.
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
