# Design: Repository filters — named views over the model, and the working view

## Rules: DDR-FILTER

### Rule DDR-FILTER-VIEWOVERMODEL

A **filter** is a named view over the repository's hard model: it selects tracks, aspects, generated targets and globs, and it never
redefines any of them. Tracks and aspects partition the files and never overlap ([DDR-TRACK](tracks.md), [DDR-ASPECT](module-aspects.md));
filters may overlap, because they answer what a reader wants to see, not what a file is.

- [Context](#context)
- [Decision](#decision)

### Rule DDR-FILTER-DECLAREDONCE

The filters are declared once, in one ordered list, each a name and its selectors in the dotted snake normal form, a prefix selecting
everything below it. A filter carries the model's own sets (include and exclude patterns), never a list of files, so a file is classified by
the same patterns the model holds the moment it exists. A renderer (an editor's switches, a command that lists a view) reads the declaration
and resolves nothing of its own.

- [Decision](#decision)

### Rule DDR-FILTER-NATURALSTATE

Every filter declares its **natural state**, on or off: the state a fresh view starts in and a reset returns to. Most filters rest off,
filtering their segment away, so the repository opens small; a reader turns on the segments they want in their tree while they work.

- [Context](#context)
- [Decision](#decision)

### Rule DDR-FILTER-RANKDECIDES

The declaration order is the **rank**, highest first. When several filters claim a file, the highest-ranked of them decides: shown while it
is on, hidden while it is off. A lower-ranked filter has no say over that file. One order settles every overlap, so no pair of filters needs
a rule of its own and every file has one deciding filter.

- [Decision](#decision)
- [Consequences](#consequences)

### Rule DDR-FILTER-PINSWHILEON

A filter may name an **always-include** list: files it keeps in the tree while it is on, above the rank. A pin keeps the one file a reader
needs (an index among generated pages) without lifting a whole filter over another.

- [Decision](#decision)

### Rule DDR-FILTER-EVERYFILECLAIMED

Every file on disk is claimed by at least one filter, and a renderer re-checks after each change that each file is shown or hidden exactly
as the rank and the pins decide. A file no filter claims, or one shown against its deciding filter, is reported, never silently shown.

- [Consequences](#consequences)

### Rule DDR-FILTER-WORKINGVIEW

The filters a reader has on are their **working view**: the subset of the repository they treat as their store of truth while they work. A
working view is a value, not a habit of the editor: the same filters and states answer as a list of files in the toolset, so a review, an
export or a session without diagnostics works in the same subset the reader sees.

- [Context](#context)
- [Consequences](#consequences)

### Rule DDR-FILTER-STATEALWAYSSHOWN

A filter's state is always visible where it is switched: an off filter shows that it is actively filtering, an on filter shows a steady mark
that reminds the reader the segment is in their tree, and an on filter that a higher-ranked filter overrules for some files shows that too.
A reader never has to guess why a file is missing.

- [Consequences](#consequences)

## Context

The repository is large, and most of it is not what a reader works on at a given moment: generated pages, vendored code, tool settings,
output. Tracks and aspects say what each file is, and they must stay a partition for the globsets, pipelines and bundles that rest on them.
A reader's question is different: which files belong in front of me now. That question allows overlap (a generated page is also
documentation), changes with the task, and grows with the reader: a newcomer turns on what they explore, an experienced reader settles into
a small working view and stays in it.

## Decision

Filters are a layer of their own above the hard model. They are declared once as named selections over tracks, aspects and generated
targets, carried as the model's own patterns, and they start in their natural state, mostly off. Overlaps are settled by one rank, the
declaration order, with a per-filter always-include list for the single files a reader keeps; the rule for a file reads: a pin of an on
filter shows it, otherwise its highest-ranked claiming filter decides, and a file no filter claims is reported. The rank order, the pins and
the natural states are configuration, settled by trying them; the mechanism is fixed.

A filter that is on is the reader's choice to keep a segment in view; an off filter is the repository's default of keeping it out. That is
why the off state is the active one and the on state is a steady reminder: what is shown is what the reader asked for.

## Consequences

- A new view is a declaration line, never code, and every renderer shows it the same way.
- Every file has one deciding filter, so a renderer can say why a file is hidden and which filter overrules another.
- The coverage check makes a stale or incomplete declaration visible at once: a file outside every filter is a finding, not a gap in the
  tree.
- A working view is reproducible: the same filters and states give the same files in the editor, in a listing command and in a review, so
  the subset a reader works in is a value they can name and share.
- Filters never feed a pipeline, an identity or a bundle; those rest on tracks and aspects alone, so a view can change freely without
  re-keying anything.
