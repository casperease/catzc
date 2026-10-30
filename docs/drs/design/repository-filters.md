# Design: Repository filters — named views over the model, and the lamp language

## Rules: DDR-FILTER

### Rule DDR-FILTER-VIEWOVERMODEL

A **filter** is a named view over the repository's hard model: it selects tracks, aspects, generated targets and globs, and it never
redefines any of them. Tracks and aspects partition the files and never overlap ([DDR-TRACK](tracks.md), [DDR-ASPECT](module-aspects.md));
filters may overlap, because they answer what a reader wants to see, not what a file is.

- [Context](#context)
- [Decision](#decision)

### Rule DDR-FILTER-FILTERDECLAREDONCE

The filters are declared once, in one ordered list, each a name and its selectors in the dotted snake normal form, a prefix selecting
everything below it. A filter carries the model's own sets (include and exclude patterns), never a list of files, so a file is classified by
the same patterns the model holds the moment it exists. A renderer (an editor's lamps, a command that lists a view) reads the declaration
and resolves nothing of its own.

- [Decision](#decision)

### Rule DDR-FILTER-TOTALUNION

A **lamp** is a filter a reader switches on (lit), off, or to **veto**, one click stepping it round off, on, veto. The view is the **total
union** of the lit lamps minus the zones of the vetoed lamps: a file is shown while at least one lit lamp claims it, so putting a lamp out
hides only the files no other lit lamp claims, while a vetoed lamp hides every file it claims even when a lit lamp claims it too. Every lamp
takes part the same way, the open lamp included: its sets are the files the reader has open, and it is always lit, so it keeps them in view
whatever else is out; only a veto hides over another lamp, and every lamp lit shows everything. A reader may add **language lamps**, one per
tagged language of the languages config, its sets one include per extension, taking part exactly like a filter lamp.

- [Decision](#decision)
- [Consequences](#consequences)

### Rule DDR-FILTER-EVERYFILECLAIMED

Every file on disk is claimed by at least one filter. A file no lamp claims is shown and counted as **unaccounted**, never silently hidden,
and a renderer re-checks after each change that each file is shown or hidden exactly as the union decides.

- [Consequences](#consequences)

### Rule DDR-FILTER-CONDITION

Each lamp has a **condition**, the highest fact over the files it claims by one precedence: `failed` over `unstaged` over `staged` over
`committed`, `committed` when no claimed file has a fact, and `empty` for a lamp whose sets include nothing (no file open, no language
typed). A file's facts are its change (none, staged or unstaged) and its fault (none or failed); a fact's file need not be on disk, so a
deleted file is a change. The condition is independent of the switch: an unlit lamp still shows that its domain is broken or changed.

- [Context](#context)
- [Decision](#decision)

### Rule DDR-FILTER-STATEALWAYSSHOWN

A lamp's state is one lookup, switch × condition, and nothing else: lit and unlit look different; committed is green, local work in progress
is the blue-grey range (staged dark, unstaged lighter), failed red, empty neutral grey. The files a lamp claims show the same mapping, so a
lamp and its files never disagree. A reader never has to guess why a file is missing or where the work is.

Red always wins. A file's Error is remembered with the time it was first seen, and lapses only when the file reports a non-error set, is
edited or saved, or changes on disk after that time; a closed view and a quiet checker never release it, and a remembered Error stays
visible wherever the reader looks for errors.

- [Consequences](#consequences)

### Rule DDR-FILTER-ENGINEADAPTSSOURCES

The lamp language (the inputs, the total union, the coverage and the condition) is engine-neutral, and every engine runs the shared vectors
`pwsh/Base.Globs/tests/assets/lamp-vectors.yml`. An engine only adapts its own sources into facts and computes no identity of its own: the
editor reads the facts its git integration and diagnostics already hold, and a test failure through the test-result files
`out/test-results/<test file>.result.json`, a failed result counting while its run started after the test file and every file of the module
it tests.

- [Decision](#decision)
- [Consequences](#consequences)

### Rule DDR-FILTER-WORKINGVIEW

The lamps a reader has lit are their **working view**: the subset of the repository they treat as their store of truth while they work. A
working view is a value, not a habit of the editor: the same filters and switches answer as a list of files in any engine, so a review, an
export or a session without diagnostics works in the same subset the reader sees.

- [Context](#context)
- [Consequences](#consequences)

## Context

The repository is large, and most of it is not what a reader works on at a given moment: generated pages, vendored code, tool settings,
output. Tracks and aspects say what each file is, and they must stay a partition for the globsets, pipelines and bundles that rest on them.
A reader's question is different: which files belong in front of me now, and how is each part doing. That question allows overlap (a
generated page is also documentation), changes with the task, and grows with the reader: a newcomer lights what they explore, an experienced
reader settles into a small working view and stays in it, and wants to see work in progress and failures even in the parts filtered away.

## Decision

Filters are a layer of their own above the hard model, with a small language over them that decides a view. The union needs no rank, pin or
natural state: a reader lights what they want in their tree, and the combination of the lit lamps is what they see.

The language is small enough for any engine. No engine re-reads the index, computes a domain identity or parses a test report; the durable
globset identity stays with the pipelines.

## Consequences

- A new view is a declaration line, never code, and every renderer shows it the same way.
- One rule settles every overlap: a file's lamps are its signature, and it shows while any of them is lit, so a renderer can say why a file
  is hidden (every lamp claiming it is out).
- The coverage check makes a stale or incomplete declaration visible at once: a file outside every filter is a finding, not a gap in the
  tree.
- A failure or a change is visible on its lamp whether the lamp is lit or not, and lapses by itself: a fixed, edited or changed file drops
  its remembered Error, an edit after a failing run outdates its marker, a commit clears the blue-grey.
- Every engine answers the shared vectors, so a working view is reproducible: the same filters and switches give the same files in the
  editor, in a listing command and in a review.
- An editor engine owns the `files.exclude` rows it adds and lists them in the settings beside them, and the settings generator carries
  those rows through, so a regenerated settings file keeps the working view and its check judges only the generated part.
- An engine writes as few `files.exclude` entries as the shown files allow, because the editor passes them to its search and watcher
  processes.
- Filters never feed a pipeline, an identity or a bundle; those rest on tracks and aspects alone, so a view can change freely without
  re-keying anything.
