// The gitignore registry (configs/gitignore.yml) and its validity rules: a required 'zones' list of
// explained pattern groups, each validated by GitIgnoreZone, with unique zone ids. Constructing an instance
// validates the registry (collecting every malformed zone into one error) and exposes the parsed zones to
// the renderer (New-GitIgnore). Registered as the `gitignore` config's type override in
// Catzc.Base.Config/configs/configs.yml. See docs/adr/automation/module-config-loading.md and
// docs/adr/repository/generated-root-configs.md.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Git;

public sealed class GitIgnoreConfig
{
    // The zones, in registry (and render) order.
    public IReadOnlyList<GitIgnoreZone> zones { get; }

    public GitIgnoreConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        List<GitIgnoreZone> list = new List<GitIgnoreZone>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        object obj = (raw != null && raw.Contains("zones")) ? raw["zones"] : null;
        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string)
        {
            errors.Add("'zones' must be a list with at least one entry");
        }
        else
        {
            foreach (object item in seq)
            {
                IDictionary entry = item as IDictionary;
                if (entry == null) { errors.Add("each 'zones' entry must be a mapping"); continue; }

                GitIgnoreZone zone;
                try { zone = new GitIgnoreZone(entry); }
                catch (ArgumentException ex) { errors.Add(ex.Message); continue; }

                if (!seen.Add(zone.id)) { errors.Add(string.Format("duplicate zone id '{0}'", zone.id)); continue; }
                list.Add(zone);
            }
            if (errors.Count == 0 && list.Count == 0)
            {
                errors.Add("'zones' must be a list with at least one entry");
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("gitignore config validation failed:\n" + string.Join("\n", errors));
        }
        zones = list;
    }
}
