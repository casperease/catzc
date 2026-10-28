using System;
using System.Collections.Generic;

namespace Catzc.Azure.Templates;

// One deployment identity of service-connections.yml: the templates it deploys and the role it holds, granted on its subscription.
public sealed class ServiceIdentity : Catzc.Base.Objects.DictionaryRecord
{
    // The identity's key in service-connections.yml, such as landing-zone. Always present.
    public string name { get; }

    // The role segment of its connections' names, two or three lowercase characters. Always present.
    public string role { get; }

    // The templates the identity deploys or previews, in file order. Never empty.
    public IReadOnlyList<string> templates { get; }

    // The roles.yml name of the Azure role the identity holds. Always present.
    public string azure_role { get; }

    // One sentence naming what the identity deploys. Always present.
    public string description { get; }

    public ServiceIdentity(string name, string role, IReadOnlyList<string> templates, string azure_role, string description)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("ServiceIdentity.name is required"); }
        if (string.IsNullOrWhiteSpace(role)) { throw new ArgumentException("ServiceIdentity.role is required"); }
        if (templates == null || templates.Count == 0) { throw new ArgumentException("ServiceIdentity.templates needs at least one template"); }
        if (string.IsNullOrWhiteSpace(azure_role)) { throw new ArgumentException("ServiceIdentity.azure_role is required"); }
        if (string.IsNullOrWhiteSpace(description)) { throw new ArgumentException("ServiceIdentity.description is required"); }
        this.name = name;
        this.role = role;
        this.templates = templates;
        this.azure_role = azure_role;
        this.description = description;
    }
}
