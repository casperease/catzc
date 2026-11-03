using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

// Where one language's package manager fetches from: a name, an address and the environment variable that holds its credential.
public sealed class PackageSource
{
    public const string Key = "package_source";

    private static readonly string[] AllowedKeys = { "name", "url", "credential_env" };
    private static readonly Regex Name = new Regex(@"^[a-z][a-z0-9_-]*$");
    private static readonly Regex Variable = new Regex(@"^[A-Za-z_][A-Za-z0-9_]*$");
    private static readonly Regex RegistryHost = new Regex(@"^[a-z0-9]([a-z0-9.-]*[a-z0-9])?(:[0-9]+)?(/[a-z0-9._-]+)*$");

    public static readonly PackageSource PyPI = new PackageSource("pypi", "https://pypi.org/simple", "");

    public static readonly PackageSource GoProxy = new PackageSource("goproxy", "https://proxy.golang.org", "");

    public static readonly PackageSource Npm = new PackageSource("npm", "https://registry.npmjs.org", "");

    public static readonly PackageSource PSGallery = new PackageSource("psgallery", "https://www.powershellgallery.com/api/v2", "");

    public static readonly PackageSource NuGet = new PackageSource("nuget", "https://api.nuget.org/v3/index.json", "");

    public static readonly PackageSource GitHubReleases = new PackageSource("github", "https://github.com", "");

    // The one non-https form: a registry host, which a Bicep module reference (br:) names without a scheme.
    public static readonly PackageSource BicepRegistry = new PackageSource("mcr", "mcr.microsoft.com/bicep", "");

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // A short lowercase word that names the source in the tool's own settings (a uv index, a PSResource repository).
    public string name { get; }

    public string url { get; }

    // The environment variable that holds the credential; empty when the source needs none. The value is never stored.
    public string credential_env { get; }

    public PackageSource(string name, string url, string credential_env)
    {
        this.name = name;
        this.url = url;
        this.credential_env = credential_env ?? "";
    }

    public static PackageSource Read(object value, PackageSource fallback, List<string> errors)
    {
        if (value == null) { return fallback; }
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid package_source (must be a map of name, url and credential_env)");
            return fallback;
        }
        int before = errors.Count;
        foreach (object k in map.Keys)
        {
            string key = Convert.ToString(k, CultureInfo.InvariantCulture);
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "package_source: unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }

        string sourceName = Text(map, "name") ?? fallback.name;
        if (!Name.IsMatch(sourceName))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture,
                "invalid package_source.name '{0}' (a short lowercase word: letters, digits, '-' or '_', starting with a letter)", sourceName));
        }

        string address = Text(map, "url") ?? fallback.url;
        bool registryForm = !fallback.url.StartsWith("https://", StringComparison.Ordinal);
        if (registryForm ? !RegistryHost.IsMatch(address) : !IsHttps(address))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture,
                "invalid package_source.url '{0}' ({1})", address,
                registryForm ? "a registry host, e.g. mcr.microsoft.com/bicep" : "an absolute https url, e.g. https://feed.example.com/simple"));
        }

        string credential = Text(map, "credential_env") ?? "";
        if (credential.Length > 0 && !Variable.IsMatch(credential))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture,
                "invalid package_source.credential_env '{0}' (the name of an environment variable, never its value)", credential));
        }

        return errors.Count > before ? fallback : new PackageSource(sourceName, address, credential);
    }

    private static string Text(IDictionary map, string key)
    {
        object v = map.Contains(key) ? map[key] : null;
        string text = v == null ? null : Convert.ToString(v, CultureInfo.InvariantCulture);
        return string.IsNullOrWhiteSpace(text) ? null : text;
    }

    private static bool IsHttps(string address)
    {
        Uri uri;
        return Uri.TryCreate(address, UriKind.Absolute, out uri) && uri.Scheme == Uri.UriSchemeHttps && uri.Host.Length > 0;
    }
}
