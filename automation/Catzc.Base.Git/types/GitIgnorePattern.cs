// One pattern line inside a gitignore.yml zone — a verbatim git wildmatch pattern with an optional trailing
// note (rendered as an aligned inline comment). A zone's `patterns` list accepts either a bare string (just
// the pattern) or a `{ pattern, note }` mapping; GitIgnoreZone normalizes both into this record. The pattern
// text is never rewritten — what the registry says is what .gitignore gets.
//
// Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
// over its own properties and its constructor uses the base's extraction helpers.

using System;
using System.Collections;

namespace Catzc.Base.Git;

public sealed class GitIgnorePattern : Catzc.Base.Objects.DictionaryRecord
{
    // The git wildmatch pattern, verbatim (including any leading '!' un-ignore or '/' anchor). Required.
    public string pattern { get; }

    // Optional short note rendered as an aligned trailing comment on the pattern's line.
    public string note { get; }

    public GitIgnorePattern(string bare)
    {
        if (string.IsNullOrWhiteSpace(bare)) { throw new ArgumentException("a gitignore pattern must be a non-empty string"); }
        pattern = bare;
        note = null;
    }

    public GitIgnorePattern(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("GitIgnorePattern requires a string or a { pattern, note } mapping"); }
        pattern = Req(d, "pattern");
        note = OptStr(d, "note");
    }
}
