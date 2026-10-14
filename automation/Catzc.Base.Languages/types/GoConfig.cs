// The Go test-workspace settings (configs/go.yml), and the single declaration of their sensible defaults: every
// key is optional, and an omitted key behaves exactly like its default, so no function restates a value
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). New-GoWorkspace renders
// the root go.work and each go/tests/<folder>/go.mod from it. Registered in Catzc.Base.Config/configs/configs.yml
// (type: Catzc.Base.Languages.GoConfig), so Get-Config -Config go returns this typed record. Property names mirror
// the YAML keys (snake_case, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - only the known keys ('go_version', 'module_root', 'dependencies') — an unknown key (a typo) fails at load;
//   - 'go_version' is a Go language version for the go directive: 1.N or 1.N.P (default 1.24);
//   - 'module_root' is the module-path prefix: lowercase slash-separated segments, no leading or trailing slash
//     (default catzc/go/tests);
//   - 'dependencies' maps a module path (with a dot in its first segment) to a semantic version vX.Y.Z; empty by
//     default, and kept in ordinal path order so a rendering never depends on the file's key order.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class GoConfig : Catzc.Base.Objects.DictionaryRecord
{
    public const string DefaultGoVersion = "1.24";
    public const string DefaultModuleRoot = "catzc/go/tests";

    private const string Failed = "go config validation failed:\n";
    private static readonly string[] AllowedKeys = { "go_version", "module_root", "dependencies" };
    private static readonly Regex GoVersion = new Regex(@"^1\.(0|[1-9][0-9]*)(\.(0|[1-9][0-9]*))?$");
    private static readonly Regex ModuleRoot = new Regex(@"^[a-z0-9][a-z0-9._-]*(/[a-z0-9][a-z0-9._-]*)*$");
    private static readonly Regex DependencyPath = new Regex(@"^[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+(/[A-Za-z0-9._~-]+)*$");
    private static readonly Regex DependencyVersion = new Regex(@"^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z.-]+)?(\+incompatible)?$");

    // The go directive written into go.work and every go.mod.
    public string go_version { get; }

    // The module-path prefix: a folder go/tests/<folder>/ is the Go module <module_root>/<folder>.
    public string module_root { get; }

    // The test dependencies every go.mod requires, module path -> version, in ordinal path order. Empty when the
    // file declares none.
    public IReadOnlyDictionary<string, string> dependencies { get; }

    public GoConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        go_version = DefaultGoVersion;
        module_root = DefaultModuleRoot;
        SortedDictionary<string, string> requires = new SortedDictionary<string, string>(StringComparer.Ordinal);

        if (raw != null)
        {
            foreach (object k in raw.Keys)
            {
                string key = Convert.ToString(k, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }

            if (raw.Contains("go_version") && raw["go_version"] != null)
            {
                string value = Convert.ToString(raw["go_version"], CultureInfo.InvariantCulture);
                if (raw["go_version"] is string && GoVersion.IsMatch(value)) { go_version = value; }
                else
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture,
                        "invalid go_version '{0}' (a quoted Go language version: 1.N or 1.N.P, e.g. '1.24')", value));
                }
            }

            if (raw.Contains("module_root") && raw["module_root"] != null)
            {
                string value = Convert.ToString(raw["module_root"], CultureInfo.InvariantCulture);
                if (ModuleRoot.IsMatch(value)) { module_root = value; }
                else
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture,
                        "invalid module_root '{0}' (lowercase slash-separated segments, no leading or trailing slash, e.g. 'catzc/go/tests')", value));
                }
            }

            if (raw.Contains("dependencies") && raw["dependencies"] != null)
            {
                IDictionary map = raw["dependencies"] as IDictionary;
                if (map == null)
                {
                    errors.Add("invalid dependencies (must be a map of module path to version, e.g. { example.com/widget: v1.2.3 })");
                }
                else
                {
                    foreach (DictionaryEntry entry in map)
                    {
                        string path = Convert.ToString(entry.Key, CultureInfo.InvariantCulture) ?? "";
                        string version = Convert.ToString(entry.Value, CultureInfo.InvariantCulture) ?? "";
                        bool valid = true;
                        if (!DependencyPath.IsMatch(path))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture,
                                "invalid dependencies key '{0}' (a module path with a dot in its first segment, e.g. example.com/widget)", path));
                            valid = false;
                        }
                        if (!DependencyVersion.IsMatch(version))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture,
                                "invalid dependencies.{0} '{1}' (a semantic version vX.Y.Z)", path, version));
                            valid = false;
                        }
                        if (valid) { requires[path] = version; }
                    }
                }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        dependencies = requires;
    }
}
