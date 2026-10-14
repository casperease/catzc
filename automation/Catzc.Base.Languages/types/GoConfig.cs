// The Go test-workspace settings (configs/go.yml), and the single declaration of their sensible defaults: every
// key is optional, and an omitted key behaves exactly like its default, so no function restates a value
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). New-GoWorkspace renders
// the repository-root go.work and each <root>/tests/<folder>/go.mod from it, and Invoke-GoTest runs the tests in
// <root>/tests/<folder>/. Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Languages.GoConfig),
// so Get-Config -Config go returns this typed record. Property names mirror the YAML keys (snake_case,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The go directive is not
// a setting here: it is the go tool's pin in tools.yml, the one Go version.
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - only the known keys ('root', 'module_root', 'dependencies') — an unknown key (a typo) fails at load;
//   - 'root' is the Go root folder, repository-relative: slash-separated segments of letters, digits, '.', '_' and
//     '-', no leading or trailing slash, no '.' or '..' segment. Omitted, it resolves per repository (ResolveRoot):
//     'go' when the repository has a go/ folder (a Go root track), else '.go', the dot-prefixed tooling folder
//     ([ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4));
//   - 'module_root' is the module-path prefix: lowercase slash-separated segments, no leading or trailing slash
//     (default catzc/go/tests);
//   - 'dependencies' maps a module path (with a dot in its first segment) to a semantic version vX.Y.Z; empty by
//     default, and kept in ordinal path order so a rendering never depends on the file's key order.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class GoConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The Go root when the repository has this folder: a Go root track.
    public const string DefaultRoot = "go";

    // The Go root otherwise: the dot-prefixed tooling folder.
    public const string FallbackRoot = ".go";

    public const string DefaultModuleRoot = "catzc/go/tests";

    private const string Failed = "go config validation failed:\n";
    private static readonly string[] AllowedKeys = { "root", "module_root", "dependencies" };
    private static readonly Regex Root = new Regex(@"^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$");
    private static readonly Regex ModuleRoot = new Regex(@"^[a-z0-9][a-z0-9._-]*(/[a-z0-9][a-z0-9._-]*)*$");
    private static readonly Regex DependencyPath = new Regex(@"^[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+(/[A-Za-z0-9._~-]+)*$");
    private static readonly Regex DependencyVersion = new Regex(@"^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z.-]+)?(\+incompatible)?$");

    // The declared Go root folder, repository-relative ('/'-separated). Null when the file declares none; ResolveRoot
    // then applies the default.
    public string root { get; }

    // The module-path prefix: a folder <root>/tests/<folder>/ is the Go module <module_root>/<folder>.
    public string module_root { get; }

    // The test dependencies every go.mod requires, module path -> version, in ordinal path order. Empty when the
    // file declares none.
    public IReadOnlyDictionary<string, string> dependencies { get; }

    public GoConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
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

            if (raw.Contains("root") && raw["root"] != null)
            {
                string value = Convert.ToString(raw["root"], CultureInfo.InvariantCulture);
                bool dotSegment = Array.Exists(value.Split('/'), s => s == "." || s == "..");
                if (raw["root"] is string && Root.IsMatch(value) && !dotSegment) { root = value; }
                else
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture,
                        "invalid root '{0}' (a repository-relative folder: '/'-separated segments, no leading or trailing slash, no '.' or '..' segment, e.g. 'go')", value));
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

    // The Go root folder for a repository, repository-relative: the declared root, else 'go' when the repository has
    // a go/ folder, else '.go'.
    public string ResolveRoot(string repositoryRoot)
    {
        if (root != null) { return root; }
        if (string.IsNullOrWhiteSpace(repositoryRoot))
        {
            throw new ArgumentException("GoConfig.ResolveRoot requires the repository root");
        }
        return Directory.Exists(Path.Combine(repositoryRoot, DefaultRoot)) ? DefaultRoot : FallbackRoot;
    }
}
