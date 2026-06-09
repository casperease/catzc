# Authoring a module reference

This directory holds one **domains-first** reference article per automation module, named `<module-in-kebab>.md` (`Catzc.Azure.Cli` →
`catzc-azure-cli.md`). `index.md` is the reader's guide and the module list; this file is the author's guide. The canonical, correct example
to copy is **`catzc-azure-cli.md`** — when in doubt, match it.

A reference article describes a module by the **domains** (areas of responsibility) it owns, not by walking its functions. The domains are
the stable contract; the function list is an appendix indexed by them.

## Document structure

Every article has these five parts, in this order:

1. **`# <Module name>`** — H1, the exact module name (`# Catzc.Azure.Cli`). One H1 per file.
2. **Lead paragraph** (directly under the title) — what the module _is_, in one or two sentences: its single most important responsibility
   first, what it owns and (where it clarifies the boundary) what it deliberately does **not** own, with links to the governing ADR(s). Lead
   with the thesis, not a feature list.
3. **`## Domains`** — an ordered registry of the responsibilities the module owns. Opens with the **domain overview table** (below), then
   one `### domain:N — <Title>` heading per domain followed by a prose definition of that _one_ responsibility. Order by **importance, most
   important first** (`domain:1` is the headline). This is the vocabulary the rest of the article uses; it talks responsibilities, never
   function names.
4. **`## What the module does`** — human prose that ties the domains together: how they relate, the design rules that shape them, and how
   the module sits against its neighbours. Capabilities and responsibilities — **no function walk-through**.
5. **`## Division`** — the _only_ section that names concrete functions: a one-line intro sentence, then the function table (see below). It
   is the index from "what the module is" to "what it exposes."

**References point one way.** An article cites ADRs (`../../adr/...`) and sibling references (`catzc-*.md`); an ADR or the code never links
back to these articles. (Same rule as the ADR authoring conventions.)

## Domains

- `domain:N` numbering is 1-based, in importance order. `domain:1` is the most important responsibility.
- Each domain is one cohesive area of responsibility. If two would overlap, merge them or re-cut the boundary.
- Keep the `— <Title>` short: the exact domain heading is reused verbatim as the col-1 label in the Division table, so it must read cleanly
  in a table cell.

### The domain overview table

`## Domains` opens with a 3-column index of the domains, placed directly under the `## Domains` heading and before the first `### domain:N`
definition:

```text
| Domain   | Area       | Name                                                                       |
| -------- | ---------- | -------------------------------------------------------------------------- |
| domain:1 | invocation | [Azure CLI invocation](#domain1--azure-cli-invocation)                     |
| domain:2 | connect    | [Session connect and disconnect](#domain2--session-connect-and-disconnect) |
| domain:3 | context    | [Subscription selection and context](#domain3--subscription-selection-and-context) |
```

- **Domain** — the `domain:N` id, in the same order as the definitions below.
- **Area** — a short, one-word keyword for the domain's gist (author-chosen): `invocation`, `connect`, `verify`, …. It is a scan aid, not a
  second title.
- **Name** — the domain's full `— <Title>` text, as a link to its section. The anchor is GitHub's slug of the `### domain:N — Title` heading
  — lowercase, the `:` and `—` dropped, spaces to hyphens — so `domain:1 — Azure CLI invocation` becomes `#domain1--azure-cli-invocation`
  (note the double hyphen left where `—` was). markdownlint's `MD051` is off (its slugger can't reproduce these colon-anchors), so these
  same-file links are **not** auto-checked — get them right by hand.

## The Division table

Exactly **two columns: `Domain` and `Function`**. One function per row.

```text
| Domain                                        | Function                |
| --------------------------------------------- | ----------------------- |
| domain:1 — Azure CLI invocation               | `Invoke-AzCli`          |
|                                               | `Assert-AzCliExtension` |
|                                               | `Test-AzCliExtension`   |
| domain:2 — Session connect and disconnect     | `Connect-AzCli`         |
|                                               | `Disconnect-AzCli`      |
| domain:3 — Subscription selection and context | `Set-AzCliSubscription` |
|                                               | …                       |
```

Rules:

- **One function per row.** Never list two functions in one cell — that is what keeps every row the same width. Even an `Assert-`/`Test-`
  (throw/query) pair goes on two separate rows.
- **The domain label appears once.** Put `domain:N — Title` in col 1 of that domain's **first** function row; the first function goes in col
  2 of that same row. On every **subsequent** row of the domain, col 1 is **blank** — do not repeat the label and do not use a filler marker
  (no `---`, no `»`, nothing).
- **Sub-groups (only where a domain is internally grouped).** Most domains list their functions flat. Where a domain groups them (e.g.
  DevBox's `domain:1 — Tool lifecycle`, grouped by lifecycle verb), col 1 _also_ carries the **sub-group label** on that group's first
  function row, blank after — the same once-then-blank rule, one level down. The domain's _leading_ group takes no label (the domain heading
  row stands in for it); only later sub-groups are labelled. Keep flat unless the function count and natural grouping genuinely warrant it.
- **Every exported function appears exactly once**, under exactly one domain. The set of names in the table must equal the module's public
  functions — no more, no fewer.
- **Order** functions within a domain by their logical grouping (e.g. the primitive first, then throw before query).
- **Configuration files** the module owns are listed in the same table as a `config` sub-group: col 1 = `config` on the first file row
  (blank after), col 2 = the file name in backticks, placed after the functions of the domain that owns them. When config is a domain's
  _only_ content it is that domain's leading group, so the `config` label folds into the domain heading row and just the files appear. A
  module that owns no config has no such rows (`catzc-azure-cli.md` owns none).
- **The Division intro sentence must not claim functions are "listed together"** (e.g. "throwing and querying forms are listed together") —
  each function now has its own row, so that clause is false. Keep the rest of the intro.
- **Do not hand-align the columns.** Write cells with single-space padding; `Format-Markdown` aligns them. Hand-built padding drifts and
  fights the formatter.

Sub-group labels and config rows look like this (DevBox lifecycle verbs; `config` as a trailing sub-group):

```text
| domain:1 — Tool lifecycle | `Assert-Tool`    |
|                           | `Test-Tool`      |
| Install (locked version)  | `Install-Python` |
|                           | `Install-Dotnet` |
| Invoke (assert-then-run)  | `Invoke-Python`  |
|                           | …                |
| config                    | `tools.yml`      |
```

## Formatting & gates

- Prose wraps at **140 columns** (Prettier `proseWrap: always`); **tables are exempt** and may be arbitrarily wide — a wide Division table
  is expected and fine.
- **No raw HTML.** markdownlint `MD033` is on, so `<br>` and other inline HTML are rejected — multi-line cells are not available, which is
  _why_ the table is one function per row instead of `<br>`-separated lists.
- After editing, run, from the repo root:

  ```powershell
  Format-Markdown -Glob 'docs/references/automation/*.md'   # aligns tables, wraps prose
  Test-Markdownlint
  Test-Spelling
  ```

  All three must pass. Prettier is the source of truth for table alignment; run it before committing.

## Adding a new module reference

1. Create `catzc-<module>.md` following the five-part structure above (copy `catzc-azure-cli.md` as the skeleton).
2. Add a row to the table in `index.md` (module name, one-line summary), keeping the foundation-first order.
3. Run the three gates above.
