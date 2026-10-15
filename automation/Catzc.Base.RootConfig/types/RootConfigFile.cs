/*
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/types/RootConfigFile.cs
    kind: csharp-type
    module: Catzc.Base.RootConfig
    adrs:
      - ADR-AUTO-PATH
---
*/

// A wildcard target is allowed only on a generator entry, and every record it returns must match the target pattern.
// [comment:1](/docs/references/automation/catzc-base-rootconfig/types/RootConfigFile.cs.md#comment1)

using System;
using System.Collections;

namespace Catzc.Base.RootConfig;

public sealed class RootConfigFile : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly char[] WildcardCharacters = { '*', '?', '[' };

    // A wildcard pattern here names a set of files, and only a generator entry may use one.
    // [comment:2](/docs/references/automation/catzc-base-rootconfig/types/RootConfigFile.cs.md#comment2)
    public string target { get; }

    // Authored source file copied out to the target (repo-relative). Exactly one of source/generator.
    public string source { get; }

    // Exactly one of source or generator supplies the content; the constructor rejects both and neither.
    // [comment:3](/docs/references/automation/catzc-base-rootconfig/types/RootConfigFile.cs.md#comment3)
    public string generator { get; }

    // The authored files a generator renders from, named in the generated-file head. Only a generator entry has any; empty otherwise.
    public string[] sources { get; }

    // The id of the file-carriers entry that says where the generated-file head goes. Default: the entry of the target's file language.
    public string carrier { get; }

    // Is this file managed at all? Opt-out is the default: false leaves the target hand-authored and committed.
    public bool optIn { get; }

    // True only for files git or the bootstrap reads before the importer runs, since a fresh clone needs them tracked.
    // [comment:4](/docs/references/automation/catzc-base-rootconfig/types/RootConfigFile.cs.md#comment4)
    public bool committed { get; }

    // Requires source, requires committed false, and forbids a declared carrier, as a link carries no generated content.
    // [comment:5](/docs/references/automation/catzc-base-rootconfig/types/RootConfigFile.cs.md#comment5)
    public bool copyAsLink { get; }

    public RootConfigFile(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("RootConfigFile requires a dictionary"); }
        target = Req(d, "target");
        source = OptStr(d, "source");
        generator = OptStr(d, "generator");
        sources = StrArr(d, "sources");
        carrier = OptStr(d, "carrier");
        optIn = Flag(d, "optIn");
        committed = Flag(d, "committed");
        copyAsLink = Flag(d, "copyAsLink");

        if ((source == null) == (generator == null))
        {
            throw new ArgumentException(string.Format(
                "root config entry '{0}' must declare exactly one of 'source' or 'generator'", target));
        }
        if (target.IndexOfAny(WildcardCharacters) >= 0 && generator == null)
        {
            throw new ArgumentException(string.Format(
                "root config entry '{0}' has a wildcard target but no 'generator' — only a generator renders a set of files", target));
        }
        if (sources.Length > 0 && generator == null)
        {
            throw new ArgumentException(string.Format(
                "root config entry '{0}' lists 'sources' but no 'generator' — a source copy-in names its one file with 'source'", target));
        }
        if (copyAsLink && source == null)
        {
            throw new ArgumentException(string.Format(
                "root config entry '{0}' declares copyAsLink but no 'source' — a generator renders content and has no single file to link to", target));
        }
        if (copyAsLink && committed)
        {
            throw new ArgumentException(string.Format(
                "root config entry '{0}' declares copyAsLink with committed true — a tracked target must be a real file, never a link", target));
        }
        if (copyAsLink && carrier != null)
        {
            throw new ArgumentException(string.Format(
                "root config entry '{0}' declares copyAsLink and must not declare 'carrier' — a link carries no generated content", target));
        }
    }
}
