"""The sister .md of every minimap PNG, written by render.py from the same data the PNG is drawn from.

A sister file sits next to its PNG with the same stem (<stem>.grid.png -> <stem>.grid.md). It opens with its path as the
H1 (ADR-REPO-FORMAT#6), names the slide and the view, says what the minimap shows, and gives every lit cell or lit group
its reason: what lit it (the file, or the ADR code), the steps that placed it on the map, and how the slide's ADR codes
selected it, following the highlight's own order (Get-WorldMapHighlight, Get-ValueChainHighlight). A cell lit only by
passing mentions is marked touched. Nothing is lit without a reason and no reason stands without a lit cell: write()
checks both per minimap and fails the run on a mismatch. Links are reference-style, relative to the .md's folder, and
checked for existence on write; keywords link to the glossary.

VIEWS maps each view to its title and its two sections (what it shows, why it is lit) and its keywords; the title, the
selection, the terms the cited ADRs define and the link definitions are shared.
"""

import os
import re
import textwrap
from pathlib import Path

REPO = Path(__file__).resolve().parents[3]
GLOSSARY = "docs/adr/glossary.md"
WRAP = 140
# The defined terms the world map is built on (ADR-DSGN-TRACK#1, #6, #9, #10, #12).
WORLD_TERMS = ["world map", "track", "file language", "cell", "lit cell"]
# The defined terms the value-chain map is built on (ADR-DSGN-TRACK#10, #12, #14-#16).
CHAIN_TERMS = ["value-chain map", "value-chain stack", "value-chain concern", "cell", "lit cell"]
KIND_WORDS = {"help": "header", "comment": "body comment", "text": "text"}


class Context:
    """What every sister file reads: both maps, the printed labels, the ADR files and the glossary."""

    def __init__(self, world, chain, labels, references):
        self.world = world
        self.chain = chain
        self.buckets = labels["buckets"]
        self.chain_labels = labels["value_chain"]
        self.adr_files = references["adr_files"]
        self.glossary = references["glossary"]
        self.cell_count = {(c["track"], c["file_language"]): c["file_count"] for c in world["cells"]}
        self.chain_count = {(c["stack"], c["concern"]): c["adr_count"] for c in chain["cells"]}
        headings = re.findall(r"^### (.+)$", (REPO / GLOSSARY).read_text(encoding="utf-8"), flags=re.M)
        self.anchors = {h.strip(): re.sub(r"[^a-z0-9 -]", "", h.strip().lower()).replace(" ", "-") for h in headings}
        self.declarations = {name: self._declaration(name) for name in ("variants", "languages")}
        no_track, no_language = list(self.buckets)
        self.no_track, self.no_language = no_track, no_language
        self.bucket_terms = {key: self._bucket_term(label) for key, label in self.buckets.items()}

    def _declaration(self, config):
        found = [f["path"] for f in self.world["files"] if f["path"].endswith(f"/configs/{config}.yml")]
        if len(found) != 1:
            raise SystemExit(f"describe: expected one configs/{config}.yml on the world map, found {found}")
        return found[0]

    def _bucket_term(self, label):
        """The glossary term a bucket label names: its singular, e.g. 'Root files' -> 'root file'."""
        singular = label.lower()[:-1] if label.lower().endswith("s") else label.lower()
        if singular not in self.anchors:
            raise SystemExit(f"describe: the bucket label '{label}' names no glossary term ('{singular}')")
        return singular

    def printed(self, name):
        return self.buckets.get(name, name)

    def cell_name(self, track, language):
        return f"{self.printed(track)} × {self.printed(language)}"


class Links:
    """The reference-style links of one sister file: one numbered definition per distinct destination."""

    def __init__(self, ctx, md_dir):
        self.ctx = ctx
        self.md_dir = md_dir
        self.labels = {}

    def to(self, text, target, anchor=None):
        """`[text][n]` for a repository path (optionally with an anchor), checked for existence."""
        path = REPO / target.lstrip("/")
        if not path.exists():
            raise SystemExit(f"describe: link target does not exist: {target}")
        rel = os.path.relpath(path, self.md_dir).replace("\\", "/") + (f"#{anchor}" if anchor else "")
        label = self.labels.setdefault(rel, str(len(self.labels) + 1))
        return f"[{text}][{label}]"

    def adr(self, citation):
        """A citation (ADR-<CODE> or ADR-<CODE>#n) linked to its ADR file, or to the rule's anchor."""
        code, _, rule = citation.partition("#")
        if code not in self.ctx.adr_files:
            raise SystemExit(f"describe: {code} is not an ADR code of docs/adr/index.md")
        return self.to(citation, self.ctx.adr_files[code], f"rule-{code.lower()}{rule}" if rule else None)

    def term(self, term):
        return self.to(term, GLOSSARY, self.ctx.anchors[term])

    def definitions(self):
        return [f"[{label}]: {rel}" for rel, label in self.labels.items()]


def plural(n, word):
    return f"{n} {word}" if n == 1 else f"{n} {word}s"


def para(text):
    return textwrap.wrap(text, WRAP, break_long_words=False, break_on_hyphens=False)


def item(text):
    return textwrap.wrap(text, WRAP, initial_indent="- ", subsequent_indent="  ", break_long_words=False, break_on_hyphens=False)


def listing(parts):
    return parts[0] if len(parts) == 1 else ", ".join(parts[:-1]) + " and " + parts[-1]


# ---------------------------------------------------------------- the world map's reasons


def site_words(sites):
    """Citation sites as `path` line n (kind), one per site."""
    return listing([f"`{s['path']}` line {s['line']} ({KIND_WORDS[s['kind']]})" for s in sites])


def file_reason(links, reason):
    """Why one file is lit, in the highlight's order: the request that selects it, then the basis and its sites."""
    request = links.adr(reason["requested"]) if reason["requested"] else None
    basis = reason["basis"]
    if basis == "adr-file":
        text = f"selected by {request}: an ADR file of the `{reason['domain']}` ADR domain, the ADR domain of that code"
    elif basis == "citations":
        text = f"selected by {request}: the file cites it at {site_words(reason['sites'])}"
    elif basis == "files.yml":
        text = (
            f"selected by {request}: a root file carries the citations of its owner module's files (files.yml), "
            f"which cite it at {site_words(reason['sites'])}"
        )
    elif basis == "globset":
        text = (
            f"selected by {request}: a pipeline that cites nothing itself carries its globset's citations, "
            f"which cite it at {site_words(reason['sites'])}"
        )
    elif basis == "path":
        text = "requested by its path"
    elif basis == "pin":
        text = f"a reviewed pin of maps.yml for {request}: {reason['note']}"
    else:
        raise SystemExit(f"describe: no reason text for the basis '{basis}'")
    return text + (" (a passing mention only)" if reason["mention"] else "")


def placement(ctx, links, cell):
    """The steps that put a lit cell's files in it: the root folder and the extension (ADR-DSGN-TRACK#1, #6, #7, #8)."""
    files = cell["files"]
    if not files:
        return "A reviewed pin of maps.yml lights this cell; it holds no lit file."
    if cell["track"] == ctx.no_track:
        row = f"each file sits directly in the repository root, so it is a root file ({links.adr('ADR-DSGN-TRACK#7')})"
    else:
        roots = sorted({f.split("/")[0] for f in files})
        row = f"the root folder {listing([f'`{r}/`' for r in roots])} names the track {cell['track']} ({links.adr('ADR-DSGN-TRACK#1')})"
    extensions = sorted({os.path.splitext(f)[1].lower() or "(none)" for f in files})
    shown = listing([f"`{e}`" if e != "(none)" else "no extension" for e in extensions])
    if cell["file_language"] == ctx.no_language:
        column = f"the extension {shown} names no file language, so it is an unlisted file ({links.adr('ADR-DSGN-TRACK#8')})"
    else:
        column = f"the extension {shown} names the file language {cell['file_language']} ({links.adr('ADR-DSGN-TRACK#6')})"
    return f"Placed: {row}; {column}."


def reasons_by_file(cell):
    by_file = {}
    for reason in cell["reasons"]:
        by_file.setdefault(reason["path"], []).append(reason)
    return by_file


def check_world(stem, highlight):
    for cell in highlight["cells"]:
        name = f"{cell['track']} x {cell['file_language']}"
        reasoned = {r["path"] for r in cell["reasons"] if r["path"]}
        if not cell["reasons"]:
            raise SystemExit(f"describe: {stem}: the lit cell {name} has no reason")
        if reasoned != set(cell["files"]):
            raise SystemExit(f"describe: {stem}: in {name}, lit files {sorted(set(cell['files']) - reasoned)} have no reason and "
                             f"reasons {sorted(reasoned - set(cell['files']))} have no lit file")
        if any(r["path"] is None and r["basis"] != "pin" for r in cell["reasons"]):
            raise SystemExit(f"describe: {stem}: in {name}, a reason names no file and is no pin")


def grid_shows(ctx, links, highlight, extras):
    cells = highlight["cells"]
    rows, cols = len(ctx.world["tracks"]), len(ctx.world["file_languages"])
    lines = para(
        f"The grid crosses the {rows} tracks with the {cols} file languages of the world map and lights {plural(len(cells), 'cell')}. "
        "A cell lit only by passing mentions (citations in body comments, not in a file's header or text) is touched: drawn pale."
    )
    lines.append("")
    for c in cells:
        total = ctx.cell_count[(c["track"], c["file_language"])]
        touched = ", touched" if c["touched"] else ""
        lines.append(f"- {ctx.cell_name(c['track'], c['file_language'])}: {c['file_count']} lit of {plural(total, 'file')}{touched}")
    return lines


def grid_why(ctx, links, highlight, extras):
    lines = ["## Why each cell is lit"]
    for cell in highlight["cells"]:
        touched = ", touched" if cell["touched"] else ""
        lines += ["", f"### {ctx.cell_name(cell['track'], cell['file_language'])} ({plural(cell['file_count'], 'lit file')}{touched})", ""]
        lines += para(f"{placement(ctx, links, cell)} Lit ({links.adr('ADR-DSGN-TRACK#12')}) by:")
        lines.append("")
        for path, reasons in reasons_by_file(cell).items():
            what = links.to(path, path) if path else "the cell"
            lines += item(f"{what}: " + "; ".join(file_reason(links, r) for r in reasons) + ".")
    return lines


def tree_shows(ctx, links, highlight, extras):
    groups = extras["groups"]
    lit = sum(len(g["files"]) for g in groups)
    lines = para(
        f"The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under "
        f"`docs/adr/` by ADR domain), and lights {plural(lit, 'file')} in {plural(len(groups), 'group')}. A lit ADR file is framed; "
        "a file lit only by passing mentions is drawn pale."
    )
    lines.append("")
    for g in groups:
        lines.append(f"- {g['label']} ({g['folder']}): {plural(len(g['files']), 'lit file')}")
    return lines


def tree_why(ctx, links, highlight, extras):
    by_path = {}
    for cell in highlight["cells"]:
        for path, reasons in reasons_by_file(cell).items():
            if path:
                by_path[path] = (cell, reasons)
    lines = ["## Why each group is lit"]
    for g in extras["groups"]:
        lines += ["", f"### {g['label']} ({plural(len(g['files']), 'lit file')})", ""]
        lines += para(f"The group holds the files of {g['folder']}; each sits in its world-map cell and is lit by:")
        lines.append("")
        for path in g["files"]:
            if path not in by_path:
                raise SystemExit(f"describe: the lit tree file {path} has no reason")
            cell, reasons = by_path[path]
            text = "; ".join(file_reason(links, r) for r in reasons)
            lines += item(f"{links.to(path, path)}, in the cell {ctx.cell_name(cell['track'], cell['file_language'])}: {text}.")
    return lines


def world_keywords(ctx, links, highlight):
    cells = highlight["cells"]
    terms = list(WORLD_TERMS)
    for key, term in ctx.bucket_terms.items():
        if any(key in (c["track"], c["file_language"]) for c in cells):
            terms.append(term)
    lines = [f"- {links.term(term)}" for term in terms]
    for track in sorted({c["track"] for c in cells} - set(ctx.buckets)):
        lines.append(f"- {links.to(track, ctx.declarations['variants'])}: a track")
    for language in sorted({c["file_language"] for c in cells} - set(ctx.buckets)):
        lines.append(f"- {links.to(language, ctx.declarations['languages'])}: a file language")
    return lines


# ---------------------------------------------------------------- the value-chain map's reasons


def check_chain(stem, highlight):
    for cell in highlight["cells"]:
        reasoned = {r["adr"] for r in cell["reasons"]}
        if not cell["reasons"] or reasoned != set(cell["adrs"]):
            raise SystemExit(f"describe: {stem}: the lit value-chain cell {cell['stack']} x {cell['concern']} has ADRs {cell['adrs']} "
                             f"but reasons for {sorted(reasoned)}")


def chain_shows(ctx, links, highlight, extras):
    cells = highlight["cells"]
    rows, cols = ctx.chain["stacks"], ctx.chain["concerns"]
    lines = para(
        f"{ctx.chain_labels['title']}. The grid crosses the {len(rows)} rows of the value-chain stack ({', '.join(rows)}) with the "
        f"{len(cols)} value-chain concerns ({', '.join(cols)}), shades each cell by the ADRs it holds, and lights "
        f"{plural(len(cells), 'cell')}."
    )
    lines.append("")
    for c in cells:
        total = ctx.chain_count[(c["stack"], c["concern"])]
        lines.append(f"- {c['stack']} × {c['concern']}: {c['adr_count']} lit of {plural(total, 'ADR')}")
    return lines


def chain_reason(links, r):
    concerns = listing(r["concerns"])
    if r["override"]:
        how = f"its own value-chain concerns ({concerns}) override its ADR domain's default ({listing(r['domain_concerns'])})"
    else:
        how = f"its value-chain concerns ({concerns}) are its ADR domain's default"
    return (
        f"selected by {links.adr(r['requested'])}; its ADR domain `{r['domain']}` sits on the {r['stack']} row of the value-chain "
        f"stack ({links.adr('ADR-DSGN-TRACK#14')}); {how}, so it lights the {r['concern']} column ({links.adr('ADR-DSGN-TRACK#15')})"
    )


def chain_why(ctx, links, highlight, extras):
    lines = ["## Why each cell is lit"]
    for cell in highlight["cells"]:
        lines += ["", f"### {cell['stack']} × {cell['concern']} ({plural(cell['adr_count'], 'ADR')})", ""]
        lines += para(f"Lit ({links.adr('ADR-DSGN-TRACK#12')}) by:")
        lines.append("")
        for r in cell["reasons"]:
            lines += item(f"{links.adr(r['adr'])}: {chain_reason(links, r)}.")
    return lines


def chain_keywords(ctx, links, highlight):
    return [f"- {links.term(term)}" for term in CHAIN_TERMS]


# The views: title, what the minimap shows, why each cell or group is lit, the keywords, and the reason check.
VIEWS = {
    "grid": ("Grid", grid_shows, grid_why, world_keywords, check_world),
    "tree": ("Tree", tree_shows, tree_why, world_keywords, check_world),
    "chain": ("Value-chain", chain_shows, chain_why, chain_keywords, check_chain),
}


def write(ctx, md_path, slide, view, highlight, extras):
    """Write one sister .md; a lit cell without a reason, or a reason without a lit cell, fails the run."""
    md_path = Path(md_path)
    title, shows, why, keywords, check = VIEWS[view]
    stem = slide["stem"]
    check(stem, highlight)
    links = Links(ctx, md_path.parent)
    rel = md_path.resolve().relative_to(REPO).as_posix()
    out = [f"# {rel}", "", f"`{title} minimap: {stem}`", ""]
    out += [f"![{title} minimap of {stem}]({md_path.stem}.png)", ""]
    codes = [links.adr(code) for code in highlight["requested"]]
    out += para(
        f"The {title.lower()} minimap of the slide `{stem}` ({slide['lens']} lens). The slide supports {listing(codes)}; the highlight "
        "of those ADR codes selects what is lit, and each reason below names the code that selects it."
    )
    out += ["", "## What the minimap shows", ""]
    out += shows(ctx, links, highlight, extras)
    out += [""] + why(ctx, links, highlight, extras)
    out += ["", "## Keywords", ""]
    out += keywords(ctx, links, highlight)
    defined = sorted(
        (g for g in ctx.glossary if any(g["defined_by"] == c or g["defined_by"].split("#")[0] == c for c in highlight["requested"])),
        key=lambda g: g["term"],
    )
    if defined:
        out += ["", "Terms the cited ADRs define:", ""]
        out += [f"- {links.term(g['term'])}, defined by {links.adr(g['defined_by'])}" for g in defined]
    out += [""] + links.definitions()
    md_path.write_text("\n".join(out) + "\n", encoding="utf-8", newline="\n")


def facts(ctx, slide, world_lit, chain_lit, groups):
    """A slide's sidebar facts: the lit cells and groups of its three minimaps, and their file names."""
    stem = slide["stem"]
    return {
        "files": {view: {"png": f"{stem}.{view}.png", "md": f"{stem}.{view}.md"} for view in VIEWS},
        "grid": [
            {"cell": ctx.cell_name(c["track"], c["file_language"]), "lit_files": c["file_count"], "touched": c["touched"]}
            for c in world_lit["cells"]
        ],
        "tree": [{"group": g["label"], "folder": g["folder"], "lit_files": len(g["files"])} for g in groups],
        "chain": [{"cell": f"{c['stack']} × {c['concern']}", "adrs": c["adrs"]} for c in chain_lit["cells"]],
    }
