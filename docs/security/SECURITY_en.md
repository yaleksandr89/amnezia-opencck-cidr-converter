# Security

## Choose a language

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/SECURITY.md) | **Selected** | [Español](./SECURITY_es.md) | [中文](./SECURITY_zh.md) | [Français](./SECURITY_fr.md) | [Deutsch](./SECURITY_de.md) |

This is a small project maintained by one person. If you find a security issue, please report it without publishing the details before a fix is available.

## What should be reported privately

- arbitrary command execution through a URL, path, or argument;
- bypassing HTTPS or `iplist.opencck.org` domain validation;
- writing the result to a path the user did not select;
- adding routes that were not present in the input;
- tampering with or publishing an unsafe release archive.

Regular conversion bugs, usage questions, and feature requests can be posted in [Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues) or [Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions).

## How to report

GitHub Private Vulnerability Reporting is preferred:

1. Open **Security and quality**.
2. Go to **Advisories**.
3. Select **Report a vulnerability**.
4. Describe the issue without creating a public Issue.

If the private form is unavailable, create a short public Issue without exploit code or sensitive details and ask for a private contact channel.

## What to include

When possible, include:

- release version or commit SHA;
- operating system and runtime;
- a short description of the impact;
- minimal reproduction steps;
- sanitized sample input.

Do not publish keys, tokens, private configurations, or personal server addresses.

## What happens next

I will try to acknowledge the report, reproduce the issue, and prepare a fix. The project has no guaranteed SLA or bounty program. Please coordinate disclosure of technical details until a fix is available.
