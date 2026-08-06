# Security policy

## Choose a language

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/SECURITY.md) | **Selected** | [Español](./SECURITY_es.md) | [中文](./SECURITY_zh.md) | [Français](./SECURITY_fr.md) | [Deutsch](./SECURITY_de.md) |

## Supported versions

Security fixes are provided for the latest published version of the project.

| Version | Supported |
|---|---|
| Latest release | Yes |
| Older releases | No |

## What counts as a vulnerability

Security issues include, but are not limited to:

- arbitrary command execution through a URL, path, or command-line argument;
- bypassing HTTPS or `iplist.opencck.org` domain validation;
- writing output to an unexpected location without an explicit user request;
- treating OpenCCK response content as executable code;
- producing output that silently adds routes absent from the input data;
- tampering with or publishing an unsafe release archive.

Regular conversion bugs, usage questions, and feature requests may be posted in GitHub Issues or Discussions when they do not contain sensitive information.

## Reporting a vulnerability

GitHub Private Vulnerability Reporting is preferred when available:

1. Open **Security and quality**.
2. Go to **Advisories**.
3. Select **Report a vulnerability**.
4. Submit the report without publishing technical details in a public Issue.

When private reporting is unavailable, open a minimal public Issue without exploitation details and request a private communication channel.

Do not publish:

- a working exploit;
- private application configurations;
- keys, passwords, or tokens;
- personal server addresses;
- other information that could enable exploitation before a fix is released.

## Report contents

When possible, include:

- the release version or commit SHA;
- the operating system and runtime version: PowerShell or Bash;
- impact description;
- minimal reproduction steps;
- expected and actual behavior;
- a sanitized input example;
- a possible fix, when known.

## Report handling

Reports will be acknowledged and reviewed as time permits. No fixed SLA is guaranteed.

Please coordinate disclosure with the project maintainer before publishing details. The project does not offer a vulnerability reward program.
