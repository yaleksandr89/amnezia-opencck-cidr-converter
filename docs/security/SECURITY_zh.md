# 安全说明

## 选择语言

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/SECURITY.md) | [English](./SECURITY_en.md) | [Español](./SECURITY_es.md) | **已选择** | [Français](./SECURITY_fr.md) | [Deutsch](./SECURITY_de.md) |

这是一个由个人维护的小型项目。如果您发现安全问题，请在修复发布前不要公开技术细节。

## 建议私下报告的问题

- 通过 URL、路径或参数执行任意命令；
- 绕过 HTTPS 或 `iplist.opencck.org` 域名校验；
- 将结果写入用户未选择的位置；
- 输出中出现输入数据里不存在的路由；
- 发布包被篡改或以不安全方式发布。

普通转换错误、使用问题和功能建议可以发布到 [Issues](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/issues) 或 [Discussions](https://github.com/yaleksandr89/amnezia-opencck-cidr-converter/discussions)。

## 如何报告

优先使用 GitHub Private Vulnerability Reporting：

1. 打开 **Security and quality**。
2. 进入 **Advisories**。
3. 点击 **Report a vulnerability**。
4. 在不创建公开 Issue 的情况下描述问题。

如果没有私密报告表单，请创建一个不包含 exploit 或敏感细节的简短 Issue，并请求私下联系渠道。

## 建议提供的信息

如条件允许，请提供：

- 发布版本或 commit SHA；
- 操作系统和运行环境；
- 影响的简要说明；
- 最小复现步骤；
- 已脱敏的输入示例。

请勿公开密钥、令牌、私有配置或个人服务器地址。

## 后续处理

我会尽量确认报告、复现问题并准备修复。项目不承诺固定 SLA，也没有漏洞奖励计划。在修复发布前，请协商技术细节的公开时间。
