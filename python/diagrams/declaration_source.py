# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""A diagram's files and carriers: the stem of a diagram, its source beside the png or in an article's block, reading and writing the
source, moving a diagram between carriers, and loading and saving a declaration."""

import re
from pathlib import Path

from . import minimaps
from .declaration_constants import SHORTHAND, SLIDE, SOURCE
from .declaration_dump import dump
from .declaration_expand import drawn, undrawn
from .declaration_normalise import normalise
from .declaration_vocabulary import DeclarationError
from .drawio_png import DEFAULTS
from .kit_yaml import load_yaml

# ---- the declaration: read, validate, normalise -------------------------------------------------------------------


def diagram_of(path):
    """A diagram's stem, `<page-folder>/.assets/<name>`, from the stem itself or either file of its pair."""
    path = Path(path)
    for suffix in (SOURCE, SLIDE):
        if path.name.endswith(suffix):
            return path.with_name(path.name[: -len(suffix)])
    return path


def source_of(diagram):
    """The diagram's one source, `<name>.drawio.yml`."""
    stem = diagram_of(diagram)
    return stem.with_name(stem.name + SOURCE)


def slide_of(diagram):
    """The diagram's drawing, `<name>.drawio.png`, put from its source."""
    stem = diagram_of(diagram)
    return stem.with_name(stem.name + SLIDE)


CARRIERS = ("file", "article")  # where a declaration lives: <name>.drawio.yml beside the png, or a `yml drawio` block in its article
FENCE = "yml drawio"  # the info string of an article's declaration block, the way a mermaid block is fenced


def carrier_of(diagram):
    """A diagram's carrier, derived from what is on disk: `<name>.drawio.yml` beside its png is the file carrier; a `yml drawio` block above
    its image in an article is the article carrier; neither (a new diagram before its first put) takes renderer.carrier. A diagram with
    both is a finding (carrier_findings) and reads as the file."""
    stem = diagram_of(diagram)
    if source_of(stem).is_file():
        return "file"
    if any(blocks_in(page.read_text(encoding="utf-8"), stem.name) for page in articles(stem)):
        return "article"
    return DEFAULTS["renderer"]["carrier"]


REFERENCE = re.compile(r"^ {0,3}\[([^\]]+)\]:\s*(?:\./)?\.assets/([^/\s]+)\.drawio\.png\s*$", re.MULTILINE)


def references(text):
    """A page's reference definitions that point at a diagram beside it: label, case-folded as Markdown folds it, to the diagram's name."""
    return {label.lower(): name for label, name in REFERENCE.findall(text)}


def image_of(text, name):
    """The pattern of an image of `.assets/<name>.drawio.png` in a page: inline, or a reference whose definition names the same png."""
    labels = [re.escape(label) for label, target in references(text).items() if target == name]
    inline = r"\((?:\./)?\.assets/" + re.escape(name) + r"\.drawio\.png\)"
    return r"!\[[^\]]*\](?:" + inline + (r"|\[(?i:" + "|".join(labels) + r")\]" if labels else "") + ")"


def blocks_in(text, name):
    """The `yml drawio` blocks of a page that sit directly above an image of `.assets/<name>.drawio.png`, inline or by reference, only
    blank lines between, each as the (start, end) of its body in the text."""
    pattern = re.compile(
        r"^```" + re.escape(FENCE) + r"[ \t]*\n((?:(?!```).*\n)*)```[ \t]*\n(?:[ \t]*\n)*" + image_of(text, name),
        re.MULTILINE,
    )
    return [(m.start(1), m.end(1)) for m in pattern.finditer(text)]


def articles(diagram):
    """The pages that may carry a diagram's declaration: the Markdown beside its `.assets`, never a slide, whose body the deck shows."""
    stem = diagram_of(diagram)
    return [page for page in sorted(stem.parent.parent.glob("*.md")) if not page.name.endswith(".slide.md")]


def article_block(diagram):
    """The one block in the diagram's article that declares it: (page, start, end). The articles are the pages beside its `.assets`; no
    block, or a block in two places, fails naming the pages."""
    stem = diagram_of(diagram)
    found = [(page, *span) for page in articles(stem) for span in blocks_in(page.read_text(encoding="utf-8"), stem.name)]
    if len(found) != 1:
        pages = ", ".join(sorted({p.name for p, _, _ in found})) or "none"
        raise DeclarationError(
            f"{stem}: the article carrier needs exactly one `{FENCE}` block above its image, found {len(found)} ({pages})"
        )
    return found[0]


def declared(diagram):
    """Whether the diagram has its declaration in its carrier."""
    if carrier_of(diagram) == "file":
        return source_of(diagram).is_file()
    try:
        article_block(diagram)
        return True
    except DeclarationError:
        return False


def read_source(diagram):
    """The declaration's text from its carrier, and where it lives (the file, or the article page)."""
    if carrier_of(diagram) == "file":
        source = source_of(diagram)
        if not source.is_file():
            raise DeclarationError(f"{diagram}: no {source.name}, the diagram's one source")
        return source.read_text(encoding="utf-8"), source
    page, start, end = article_block(diagram)
    return page.read_text(encoding="utf-8")[start:end], page


def write_source(diagram, text):
    """Write the declaration's text into its carrier: the file whole, or the article's block in place, the rest of the page as it was."""
    if carrier_of(diagram) == "file":
        source_of(diagram).write_text(text, encoding="utf-8", newline="\n")  # LF on every platform, as the formatter keeps it
        return source_of(diagram)
    page, start, end = article_block(diagram)
    whole = page.read_text(encoding="utf-8")
    page.write_text(whole[:start] + text.rstrip("\n") + "\n" + whole[end:], encoding="utf-8", newline="\n")
    return page


def carrier_findings(diagram):
    """A diagram declared in both carriers: the file beside its png and a block in its article. Empty when it has one."""
    stem = diagram_of(diagram)
    blocks = [p.name for p in articles(stem) if blocks_in(p.read_text(encoding="utf-8"), stem.name)]
    if source_of(stem).is_file() and blocks:
        return [f"declared in both carriers: {source_of(stem).name} and a `{FENCE}` block in {', '.join(blocks)}"]
    return []


def article_stems(root):
    """The stems of the diagrams declared in an article under the root: each `yml drawio` block directly above an image embedding
    `.assets/<name>.drawio.png`, as `<page folder>/.assets/<name>`. A slide is never a carrier."""
    pattern = re.compile(
        r"^```"
        + re.escape(FENCE)
        + r"[ \t]*\n(?:(?!```).*\n)*```[ \t]*\n(?:[ \t]*\n)*!\[[^\]]*\](?:\((?:\./)?\.assets/([^/)]+)\.drawio\.png\)|\[([^\]]+)\])",
        re.MULTILINE,
    )
    stems = set()
    for page in Path(root).rglob("*.md"):
        if page.name.endswith(".slide.md"):
            continue
        text = page.read_text(encoding="utf-8")
        labels = references(text)
        for inline, label in pattern.findall(text):
            name = inline or labels.get(label.lower())  # a reference naming no diagram's png is no stem
            if name:
                stems.add(page.parent / ".assets" / name)
    return stems


def image_in(page, name):
    """The spans of the images in a page's text that embed `.assets/<name>.drawio.png`, inline or by reference."""
    text = page.read_text(encoding="utf-8")
    return [m.start() for m in re.compile(r"^" + image_of(text, name), re.MULTILINE).finditer(text)]


def rekeyed(text, old, new):
    """drawio.yml's text with every roles: entry keyed by the stem `old`, or by a stem under the folder `old`, keyed by `new`
    instead, edited line by line so every comment and every other entry stays as written; the one editor a diagram move uses."""
    lines = text.split("\n")
    entry = re.compile(r"^(  )(" + re.escape(old) + r")(?=:|/)")
    section = None
    for i, line in enumerate(lines):
        if line and not line.startswith((" ", "#")):
            section = re.match(r"^([a-z_]+):", line)
            section = section.group(1) if section else None
        elif section == "roles":
            lines[i] = entry.sub(lambda m: m.group(1) + new, line, count=1)
    return "\n".join(lines)


IGNORE_LINE = re.compile(r"^[ \t]*#[ \t]*cspell:ignore[ \t]+(.*?)[ \t]*$", re.MULTILINE)  # a yml's cspell ignore comment
PAGE_IGNORE = re.compile(r"^<!-- cspell:ignore[ \t]+(.*?)[ \t]*-->[ \t]*$", re.MULTILINE)  # a page's own cspell ignore comment


def with_page_ignores(whole, words):
    """A page's text with the words added to its own `<!-- cspell:ignore … -->` comment, made under the title when it has none, so a
    word a declaration told cspell to ignore stays ignored once the declaration is a block of the page."""
    if not words:
        return whole
    found = PAGE_IGNORE.search(whole)
    if found:
        held = found.group(1).split()
        merged = held + [w for w in words if w not in held]
        return whole[: found.start()] + f"<!-- cspell:ignore {' '.join(merged)} -->" + whole[found.end() :]
    lines = whole.split("\n")
    title = next((i for i, line in enumerate(lines) if line.startswith("# ")), -1)
    return "\n".join(
        lines[: title + 1]
        + ([""] if title >= 0 else [])
        + [f"<!-- cspell:ignore {' '.join(words)} -->"]
        + ([] if title >= 0 else [""])
        + lines[title + 1 :]
    )


def without_page_ignores(whole, body):
    """The page's ignore words the block body uses, and the page's text with each word the rest of the page no longer uses dropped from
    its comment; a comment left empty goes with the blank line after it."""
    found = PAGE_IGNORE.search(whole)
    if not found:
        return [], whole
    uses = lambda text, w: re.search(r"(?<![A-Za-z])" + re.escape(w) + r"(?![A-Za-z])", text, re.IGNORECASE) is not None
    held = found.group(1).split()
    rest = whole[: found.start()] + whole[found.end() :]
    taken = [w for w in held if uses(body, w)]
    kept = [w for w in held if w not in taken or uses(rest, w)]
    if kept:
        return taken, whole[: found.start()] + f"<!-- cspell:ignore {' '.join(kept)} -->" + whole[found.end() :]
    return taken, whole[: found.start()] + re.sub(r"^\n\n?", "", whole[found.end() :])


def carry(diagram, carrier):
    """Move a diagram's declaration to the other carrier: the yml beside its png becomes a `yml drawio` block directly above the image in
    its one article, or the block becomes the yml; nothing is recorded, since the carrier is what is on disk. The move is all or nothing: it refuses a diagram
    already in that carrier, declared twice or not at all, and restores every file when the declaration it reads back differs."""
    stem = diagram_of(diagram)
    if carrier not in CARRIERS:
        raise DeclarationError(f"{stem}: carry takes {' or '.join(CARRIERS)}, not '{carrier}'")
    if carrier_of(stem) == carrier:
        raise DeclarationError(f"{stem}: already in the {carrier} carrier")
    twice = carrier_findings(stem)
    if twice:
        raise DeclarationError(f"{stem}: {'; '.join(twice)}")
    text, where = read_source(stem)
    before = normalise(load_yaml(text) or {}, where=str(where))
    # A file's comment head is the file's own, never part of the declaration, so the block takes the body alone.
    lines = text.split("\n")
    body = "\n".join(lines[next((i for i, line in enumerate(lines) if line.strip() and not line.startswith("#")), len(lines)) :])
    # The words a yml tells cspell to ignore move to the page's own comment; a comment inside a code block would not be read.
    words = [w for found in IGNORE_LINE.findall(text) for w in found.split()]
    body = IGNORE_LINE.sub("", body).strip("\n") + "\n"
    saved = {}
    if carrier == "article":
        pages = [(page, at) for page in articles(stem) for at in image_in(page, stem.name)]
        if len(pages) != 1:
            names = ", ".join(sorted({p.name for p, _ in pages})) or "none"
            raise DeclarationError(
                f"{stem}: the article carrier needs exactly one article image of {stem.name}.drawio.png beside .assets, found {len(pages)} ({names})"
            )
        page, at = pages[0]
        whole = page.read_text(encoding="utf-8")
        saved[page] = whole
        saved[source_of(stem)] = text
        changes = [(page, with_page_ignores(whole[:at] + f"```{FENCE}\n{body}```\n\n" + whole[at:], words)), (source_of(stem), None)]
    else:
        page, start, end = article_block(stem)
        whole = page.read_text(encoding="utf-8")
        saved[page] = whole
        saved[source_of(stem)] = None
        # The block runs from its fence line to the blank lines that end at the image, which stays where it was.
        opening = whole.rfind(f"```{FENCE}", 0, start)
        after = re.match(r"```[ \t]*\n(?:[ \t]*\n)*", whole[end:])
        assert after, f"the drawio block of {page} closes with a fence"
        taken, rest = without_page_ignores(whole[:opening] + whole[end + after.end() :], body)
        changes = [(source_of(stem), (f"# cspell:ignore {' '.join(taken)}\n\n" if taken else "") + body), (page, rest)]
    try:
        for path, new in changes:
            if new is None:
                path.unlink()
            else:
                path.write_text(new, encoding="utf-8", newline="\n")
        after_text, after_where = read_source(stem)
        if carrier_findings(stem) or normalise(load_yaml(after_text) or {}, where=str(after_where)) != before:
            raise DeclarationError(f"{stem}: the declaration read back from the {carrier} carrier differs, so nothing was moved")
    except Exception:
        for path, old in saved.items():
            if old is None:
                path.unlink(missing_ok=True)
            else:
                path.write_text(old, encoding="utf-8", newline="\n")
        raise
    # The png is what Build-Diagrams takes for a diagram whose declaration sits in an article: the stem alone names no file.
    return read_source(stem)[1], stem.with_name(stem.name + SLIDE)


def load(folder):
    """The declaration of a diagram, from its carrier."""
    text, where = read_source(folder)
    return normalise(load_yaml(text) or {}, where=str(where))


def save(folder, declaration):
    """Write a declaration into the diagram's carrier. The drawing carries no description, so a declaration read back by get keeps the
    description the source already has."""
    if declared(folder):
        text, where = read_source(folder)
        held = normalise(load_yaml(text) or {}, where=str(where))
        if not declaration.get("description"):
            declaration = {**declaration, "description": held["description"]}
        # The drawing carries the ADR codes of `about:` in its subtitle; a drawing without them keeps the source's.
        about = {
            "lens": declaration["about"]["lens"],
            **{key: declaration["about"][key] or held["about"][key] for key in minimaps.ABOUT_KEYS},
        }
        proves = declaration["about"].get("proves") or held["about"].get("proves")  # the drawing never carries the proof file
        if proves:
            about["proves"] = proves
        zoom = declaration["about"].get("zoom") or held["about"].get("zoom")  # a drawing read back keeps the source's zoom level
        if zoom:
            about["zoom"] = zoom
        point = declaration["about"].get("point") or held["about"].get("point")  # the drawing never carries the point of the tree
        if point:
            about["point"] = point
        occupants = declaration["about"].get("occupants") or held["about"].get("occupants")  # the drawing never carries the occupants
        if occupants:
            about["occupants"] = occupants
        declaration = {**declaration, "about": about, "content": undrawn(declaration["content"], held)}
        # The drawing carries a row only as its expansion: when the drawing still draws what the source's rows expand to, the source
        # keeps its rows (the layout is the drawing's); when it draws something else, the drawing wins.
        generated = held["content"].get("generated") or set()
        if generated:
            old, new = drawn(held["content"]), drawn(declaration["content"])
            mine = lambda d: (
                {k: d[key].get(k) for key in ("groups", "glyphs") for k in generated if k in d[key]},
                [e for e in d["edges"] if dict(e)["from"] in generated and dict(e)["to"] in generated],
            )
            if mine(old) == mine(new):
                kept = {k: held["content"][k] for k in SHORTHAND + ("generated",) if k in held["content"]}
                declaration = {**declaration, "content": {**declaration["content"], **kept}}
    write_source(folder, dump(declaration))
