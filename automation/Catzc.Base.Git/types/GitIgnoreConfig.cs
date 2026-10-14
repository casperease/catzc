// The gitignore registry (configs/gitignore.yml) and its validity rules: a required 'sections' list of
// explained pattern groups, each validated by GitIgnoreSection, with unique section ids. Constructing an
// instance validates the registry (collecting every malformed section into one error) and exposes the parsed
// sections to the renderer (New-GitIgnore). Registered as the `gitignore` config's type override in
// Catzc.Base.Config/configs/configs.yml. See [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md) and
// [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Git;

public sealed class GitIgnoreConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The sections, in registry (and render) order.
    public IReadOnlyList<GitIgnoreSection> sections { get; }

    private static readonly string[] AllowedKeys = { "sections" };

    public GitIgnoreConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string topKey = key == null ? string.Empty : key.ToString();
                if (Array.IndexOf(AllowedKeys, topKey) < 0)
                {
                    errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", topKey, string.Join(", ", AllowedKeys)));
                }
            }
        }
        List<GitIgnoreSection> list = new List<GitIgnoreSection>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        object obj = (raw != null && raw.Contains("sections")) ? raw["sections"] : null;
        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string)
        {
            errors.Add("'sections' must be a list with at least one entry");
        }
        else
        {
            foreach (object item in seq)
            {
                IDictionary entry = item as IDictionary;
                if (entry == null) { errors.Add("each 'sections' entry must be a mapping"); continue; }

                GitIgnoreSection section;
                try { section = new GitIgnoreSection(entry); }
                catch (ArgumentException ex) { errors.Add(ex.Message); continue; }

                if (!seen.Add(section.id)) { errors.Add(string.Format("duplicate section id '{0}'", section.id)); continue; }
                list.Add(section);
            }
            if (errors.Count == 0 && list.Count == 0)
            {
                errors.Add("'sections' must be a list with at least one entry");
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("gitignore config validation failed:\n" + string.Join("\n", errors));
        }
        sections = list;
    }
}
