/*
---
catzc:
  immutable:
    with_body_sha: e99d1a6bde0d
  edges:
    docs: "[FileCarrier.cs.md](../../../docs/references/pwsh/catzc-base-languages/types/FileCarrier.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

using System;
using System.Collections.Generic;
using System.Linq;

namespace Catzc.Base.Languages;

public sealed class FileCarrier
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The entry's kebab-case id: a file language of languages.yml, or a named class of files outside any language.
    public string id { get; }

    // Globs that select the entry's files. Empty for a language entry, whose files are the language's extensions.
    public IReadOnlyList<string> files { get; }

    public CarrierKind carrier { get; }

    // The line-comment prefix of a comment head (e.g. #). Null when the head uses a block comment or the carrier is not a comment head.
    public string line { get; }

    // The opening and closing delimiters of a block-comment head (e.g. <!-- and -->). Empty when the head uses a line comment.
    public IReadOnlyList<string> block { get; }

    public Catzc.Base.CodeMeta.HeadAnchor anchor { get; }

    // How many leading lines stay above the head when the anchor is AfterPreamble; zero otherwise.
    public int preamble_lines { get; }

    // The front-matter key path that holds a front-matter carrier's block: catzc at the top level, or a dotted path nesting it under another tool's keys. Null for any other carrier.
    public string key { get; }

    // The ignored top-level key that holds a property carrier's block (e.g. //). Null for any other carrier.
    public string property { get; }

    // Why a file class carries no meta block. Null unless the carrier is None, which needs one.
    public string reason { get; }

    // Globs of files in this class that carry no block, each with the reason. Empty when none is left out.
    public IReadOnlyDictionary<string, string> exclude { get; }

    // Beginnings of old heads the formatter removes before it writes the head: the first line of a comment run, or the start of a property's value. Empty when none is left to strip.
    public IReadOnlyList<string> strip { get; }

    public FileCarrier(string id, string[] files, CarrierKind carrier, string line, string[] block, Catzc.Base.CodeMeta.HeadAnchor anchor,
        int preambleLines, string property, string reason, IDictionary<string, string> exclude, string[] strip = null, string key = null)
    {
        this.key = key;
        this.strip = strip == null ? Array.Empty<string>() : (string[])strip.Clone();
        this.exclude = exclude == null ? new Dictionary<string, string>() : new Dictionary<string, string>(exclude);
        this.id = id;
        this.files = files == null ? Array.Empty<string>() : (string[])files.Clone();
        this.carrier = carrier;
        this.line = line;
        this.block = block == null ? Array.Empty<string>() : (string[])block.Clone();
        this.anchor = anchor;
        preamble_lines = preambleLines;
        this.property = property;
        this.reason = reason;
    }

    // The comment syntax of the entry's meta head, or null when the carrier is not a comment head.
    public Catzc.Base.CodeMeta.HeadForm Form()
    {
        if (carrier != CarrierKind.CommentHead) { return null; }
        return line != null
            ? Catzc.Base.CodeMeta.HeadForm.ForLine(line, anchor, preamble_lines, strip.ToArray())
            : Catzc.Base.CodeMeta.HeadForm.ForBlock(block[0], block[1], anchor, preamble_lines, strip.ToArray());
    }
}
