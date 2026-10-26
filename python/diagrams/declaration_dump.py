# cspell:ignore minimaps mxfile pnginfo drsonly mapkey
# cspell:ignore callsite
"""A declaration printed as the source's text: the flow-style YAML writer, its scalars quoted and wrapped at the print width, and the
brief form of an entry."""

from pathlib import Path

import yaml

from . import edge_rules
from .declaration_constants import ABOUT_KEYS, CONTENT_KEYS, KIT, OPERATORS
from .declaration_edges import end_kinds
from .declaration_vocabulary import LIB, DeclarationError, choices


def entry(item, keys, where, what, optional=None):
    if not isinstance(item, dict):
        raise DeclarationError(f"{where}: a {what} is a map of {', '.join(keys)}")
    allowed = tuple(keys) + tuple(optional or ())
    for key in item:
        if key not in allowed:
            choices(f"{where}: {what} key", key, allowed)
    out = {}
    for key in keys:
        if key not in item or item[key] in (None, ""):
            raise DeclarationError(f"{where}: a {what} needs {key}")
        out[key] = item[key] if isinstance(item[key], list) else str(item[key])
    for key, default in (optional or {}).items():
        out[key] = str(item.get(key, default))
    return out


def brief(phrase):
    """A legend phrase as the legend prints it: the name alone, without the explanation in parentheses or after a colon; a flow keeps
    its relation, a commit its state and an operator its meaning, which are the names."""
    if phrase.startswith(
        ("flow: ", "commit: ", "execution: ", "proof: ", "transition: ", "label: ") + tuple(f"{word}: " for word in OPERATORS)
    ):
        return phrase.split(" (")[0] if not phrase.startswith("commit: ") else phrase
    return phrase.split(" (")[0].split(":")[0].strip()


def legend_phrases():
    return tuple(
        [g["phrase"] for g in LIB["glyphs"].values()]
        + [e["phrase"] for e in LIB["edges"].values()]
        + [m["phrase"] for m in LIB["marks"].values()]
    )


def minimal_edge(edge, content):
    """An edge as its source keeps it: the label that its kind pair derives is left out, so a minimal edge stays minimal. A flow edge
    oriented by rank whose label equals its pair's default means the same whether the author wrote it or the kit derived it, so the one
    form drops it; a label of another meaning, an edge of another kind and the edges of a diagram with its own relation are kept."""
    if edge.get("kind", "flow") != "flow" or not edge.get("label") or str(content.get("relation", "") or "").strip():
        return edge
    kinds = end_kinds(content)
    tail, head = kinds.get(edge["from"]), kinds.get(edge["to"])
    derived = edge_rules.default_label(tail, head)
    if edge["label"] == derived and tail not in edge_rules.TRUSTED_KINDS and edge_rules.judge(tail, head, "", "flow", ()) == "ok":
        return {**edge, "label": ""}
    return edge


def dump(declaration):
    """The whole declaration as the text of its source file, keys in the kit's order."""
    content = dict(declaration["content"])
    # A row's written-out cells are its expansion, never the source: the row is written, and they are left out.
    generated = declaration.get("generated") or content.get("generated") or set()
    if generated:
        for key in ("groups", "glyphs"):
            content[key] = [i for i in content[key] if i["id"] not in generated]
        content["edges"] = [e for e in content["edges"] if e["from"] not in generated or e["to"] not in generated]
        content["chips"] = [c for c in content.get("chips") or [] if c["at"] not in generated]
    content["edges"] = [minimal_edge(e, content) for e in content.get("edges", [])]
    ordered = {k: content[k] for k in CONTENT_KEYS if k in content and content[k] not in ([], {}, "", False)}
    out = {"description": declaration["description"]} if declaration.get("description") else {}
    about = declaration.get("about") or {}
    out["about"] = {key: about[key] for key in ABOUT_KEYS if about.get(key)}
    out["content"] = ordered
    layout = {cid: box for cid, box in (declaration.get("layout") or {}).items() if cid not in generated}
    if layout:  # a generated cell's place, and a query slide's pinned band, are the expansion's, never the source's
        out["layout"] = layout
    return flow_yaml(out, print_width())


def print_width(root=None):
    """The longest printed line: max_line_length under [*.md] in the repository root's .editorconfig, read at print time, never copied."""
    path = Path(root or KIT.parents[1]) / ".editorconfig"
    if not path.is_file():
        raise DeclarationError(f"{path}: not found, so the print width ([*.md] max_line_length) cannot be read")
    section = None
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line.startswith("[") and line.endswith("]"):
            section = line[1:-1]
        elif section == "*.md" and "=" in line:
            key, value = (part.strip() for part in line.split("=", 1))
            if key == "max_line_length":
                return int(value)
    raise DeclarationError(f"{path}: the section [*.md] has no max_line_length, the print width")


def flow_yaml(data, width):
    """The data in block style, each leaf mapping or list whose whole line fits the width printed as one flow line in Prettier's form."""
    lines = []
    _block(data, 0, width, lines)
    return "\n".join(lines) + "\n"


def _flow_scalar(value, flow=True):
    # A scalar quoted where yaml.safe_dump quotes it, inside a flow collection (where a plain `,` or `[` would end it) or in block style;
    # a quoted one takes Prettier's double quotes when its text holds no `"` or `\` to escape.
    dumped = yaml.safe_dump([value], default_flow_style=flow, allow_unicode=True, width=10**9).strip()
    text = dumped[1:-1] if flow else dumped[2:]
    if text.startswith("'") and isinstance(value, str) and '"' not in value and "\\" not in value and value.isprintable():
        return f'"{value}"'
    return text


def _flow(node):
    """The node as one flow line, or None when it is not a leaf: a child is a collection or a string of several lines."""
    children = node.values() if isinstance(node, dict) else node
    if any(isinstance(c, (dict, list)) or (isinstance(c, str) and "\n" in c) for c in children):
        return None
    if isinstance(node, dict):
        return "{ " + ", ".join(f"{_flow_scalar(k)}: {_flow_scalar(v)}" for k, v in node.items()) + " }"
    return "[" + ", ".join(_flow_scalar(v) for v in node) + "]"


def _scalar_lines(key, value, indent, width):
    """A scalar under its key, or a list item when the key is None, as Prettier prints it: on the key's or dash's line when it fits, else
    a plain text filled word by word at the width, under the key or beside the dash; any other long scalar as yaml.safe_dump writes it."""
    pad = " " * indent
    lead = "-" if key is None else f"{_flow_scalar(key, flow=False)}:"
    text = _flow_scalar(value, flow=False)
    if "\n" not in text and len(pad + lead) + 1 + len(text) <= width or not isinstance(value, str):
        return [f"{pad}{lead} {text}"]
    words = value.split(" ")
    if _double_quotable(value) and (text[0] in "'\"" or "\n" in value):
        return _quoted_lines(lead, value, pad, width)
    if text[0] in "'\"" or "\n" in value or "" in words:
        wrapped = [value] if key is None else {key: value}
        dumped = yaml.safe_dump(wrapped, sort_keys=False, allow_unicode=True, width=max(width - indent, 20))
        return [pad + line for line in dumped.splitlines() if line != "..."]
    lines = [] if key is None else [f"{pad}{lead}"]
    prefix, line = (f"{pad}- " if key is None else f"{pad}  "), []
    for word in words:
        if line and len(prefix) + len(" ".join(line + [word])) > width:
            lines.append(prefix + " ".join(line))
            prefix, line = f"{pad}  ", []
        line.append(word)
    lines.append(prefix + " ".join(line))
    return lines


def _double_quotable(value):
    # Prettier folds a text into double quotes when nothing in it needs an escape and its words fill back to it: single spaces, and line
    # breaks only between words, so a fold or a blank line reads back as the space or the break it stands for.
    paragraphs = value.split("\n")
    return (
        '"' not in value
        and "\\" not in value
        and value.replace("\n", "").isprintable()
        and bool(paragraphs[0])
        and bool(paragraphs[-1])
        and all(word for p in paragraphs if p for word in p.split(" "))
    )


def _quoted_lines(lead, value, pad, width):
    """A double-quoted text as Prettier prints it: beside the dash, or beside the key when it has line breaks, else under the key; each
    paragraph filled word by word at the width, without the closing quote, and each line break of the text a blank line."""
    beside = lead == "-" or "\n" in value
    lines, prefix, line = ([] if beside else [f"{pad}{lead}"]), (f'{pad}{lead} "' if beside else f'{pad}  "'), []
    for n, paragraph in enumerate(value.split("\n")):
        if n:
            if line:
                lines.append(prefix + " ".join(line))
                prefix, line = f"{pad}  ", []
            lines.append("")
        for word in paragraph.split(" ") if paragraph else []:
            if line and len(prefix) + len(" ".join(line + [word])) > width:
                lines.append(prefix + " ".join(line))
                prefix, line = f"{pad}  ", []
            line.append(word)
    lines.append(prefix + " ".join(line) + '"')
    return lines


def _block(node, indent, width, lines):
    pad = " " * indent
    if isinstance(node, dict):
        for key, value in node.items():
            lead = f"{pad}{_flow_scalar(key)}:"
            if not isinstance(value, (dict, list)):
                lines.extend(_scalar_lines(key, value, indent, width))
            elif not value:
                lines.append(f"{lead} {'{}' if isinstance(value, dict) else '[]'}")
            elif (flow := _flow(value)) and len(lead) + 1 + len(flow) <= width:
                lines.append(f"{lead} {flow}")
            else:
                lines.append(lead)
                _block(value, indent + 2, width, lines)
        return
    for item in node:
        if not isinstance(item, (dict, list)):
            lines.extend(_scalar_lines(None, item, indent, width))
        elif not item:
            lines.append(f"{pad}- {'{}' if isinstance(item, dict) else '[]'}")
        elif (flow := _flow(item)) and indent + 2 + len(flow) <= width:
            lines.append(f"{pad}- {flow}")
        elif isinstance(item, dict):
            inner = []
            _block(item, indent + 2, width, inner)
            lines.append(f"{pad}- {inner[0][indent + 2 :]}")
            lines.extend(inner[1:])
        else:
            lines.append(f"{pad}-")
            _block(item, indent + 2, width, lines)
