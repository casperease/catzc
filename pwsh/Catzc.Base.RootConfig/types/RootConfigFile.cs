using System;
using System.Collections;

namespace Catzc.Base.RootConfig;

public sealed class RootConfigFile : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly char[] WildcardCharacters = { '*', '?', '[' };

    public string target { get; }

    // Authored source file copied out to the target (repo-relative). Exactly one of source/generator.
    public string source { get; }

    public string generator { get; }

    // The authored files a generator renders from, named in the generated-file head. Only a generator entry has any; empty otherwise.
    public string[] sources { get; }

    // The id of the file-carriers entry that says where the generated-file head goes. Default: the entry of the target's file language.
    public string carrier { get; }

    // Is this file managed at all? Opt-out is the default: false leaves the target hand-authored and committed.
    public bool optIn { get; }

    public bool committed { get; }

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
    }
}
