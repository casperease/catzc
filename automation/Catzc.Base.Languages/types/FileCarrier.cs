// The properties are snake_case because they mirror the YAML keys; FileCarriersConfig validates an entry and builds one.
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8),
// [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
// [comment:1](/docs/references/automation/catzc-base-languages/types/FileCarrier.cs.md#comment1)

using System;
using System.Collections.Generic;

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

    // The ignored top-level key that holds a property carrier's block (e.g. //). Null for any other carrier.
    public string property { get; }

    // The path template of a sidecar carrier, where {base} is the file's path without its last extension. Null for any other carrier.
    public string sidecar { get; }

    // Why a file class carries no meta block. Null unless the carrier is None, which needs one.
    public string reason { get; }

    public FileCarrier(string id, string[] files, CarrierKind carrier, string line, string[] block, Catzc.Base.CodeMeta.HeadAnchor anchor,
        int preambleLines, string property, string sidecar, string reason)
    {
        this.id = id;
        this.files = files == null ? Array.Empty<string>() : (string[])files.Clone();
        this.carrier = carrier;
        this.line = line;
        this.block = block == null ? Array.Empty<string>() : (string[])block.Clone();
        this.anchor = anchor;
        preamble_lines = preambleLines;
        this.property = property;
        this.sidecar = sidecar;
        this.reason = reason;
    }

    // The comment syntax of the entry's meta head, or null when the carrier is not a comment head.
    public Catzc.Base.CodeMeta.HeadForm Form()
    {
        if (carrier != CarrierKind.CommentHead) { return null; }
        return line != null
            ? Catzc.Base.CodeMeta.HeadForm.ForLine(line, anchor, preamble_lines)
            : Catzc.Base.CodeMeta.HeadForm.ForBlock(block[0], block[1], anchor, preamble_lines);
    }
}
