// The root-config registry (configs/rootconfig.yml) and its validity rules: a required 'files' list of
// managed root-file entries, each validated by RootConfigFile, with unique targets. Constructing an instance
// validates the registry (collecting every malformed entry into one error) and exposes the parsed entries to
// the generator (Build-RootConfig). Registered as the `rootconfig` config's type override in
// Catzc.Base.Config/configs/configs.yml. See docs/adr/configuration/module-config-loading.md and
// docs/adr/repository/generated-root-configs.md.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.RootConfig;

public sealed class RootConfigFiles
{
    // Managed root-file entries, in registry order.
    public IReadOnlyList<RootConfigFile> files { get; }

    public RootConfigFiles(IDictionary raw)
    {
        List<string> errors = new List<string>();
        List<RootConfigFile> list = new List<RootConfigFile>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        object obj = (raw != null && raw.Contains("files")) ? raw["files"] : null;
        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string)
        {
            errors.Add("'files' must be a list with at least one entry");
        }
        else
        {
            foreach (object item in seq)
            {
                IDictionary entry = item as IDictionary;
                if (entry == null) { errors.Add("each 'files' entry must be a mapping"); continue; }

                RootConfigFile f;
                try { f = new RootConfigFile(entry); }
                catch (ArgumentException ex) { errors.Add(ex.Message); continue; }

                if (!seen.Add(f.target)) { errors.Add(string.Format("duplicate target '{0}'", f.target)); continue; }
                list.Add(f);
            }
            if (errors.Count == 0 && list.Count == 0)
            {
                errors.Add("'files' must be a list with at least one entry");
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("rootconfig config validation failed:\n" + string.Join("\n", errors));
        }
        files = list;
    }
}
