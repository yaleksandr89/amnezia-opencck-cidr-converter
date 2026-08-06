# 安全策略

## 选择语言

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/SECURITY.md) | [English](./SECURITY_en.md) | [Español](./SECURITY_es.md) | **已选择** | [Français](./SECURITY_fr.md) | [Deutsch](./SECURITY_de.md) |

## 支持的版本

安全修复仅针对项目的最新发布版本提供。

| 版本 | 是否支持 |
|---|---|
| 最新版本 | 是 |
| 较旧版本 | 否 |

## 哪些问题属于漏洞

安全问题包括但不限于：

- 通过输入 URL、路径或命令行参数执行任意命令；
- 绕过 HTTPS 或 `iplist.opencck.org` 域名验证；
- 未经用户明确指定，将结果写入意外位置；
- 将 OpenCCK 响应内容作为可执行代码处理；
- 生成会静默添加输入数据中不存在路由的结果；
- 篡改发布压缩包或以不安全方式发布压缩包。

普通转换错误、使用问题和功能请求可以发布到 GitHub Issues 或 Discussions，但不得包含敏感信息。

## 报告漏洞

如果仓库提供 GitHub Private Vulnerability Reporting，请优先使用：

1. 打开 **Security and quality**。
2. 进入 **Advisories**。
3. 选择 **Report a vulnerability**。
4. 提交报告，不要在公开 Issue 中发布技术细节。

如果无法使用私密报告，请创建一个不包含利用细节的最小公开 Issue，并请求私密沟通渠道。

请勿公开：

- 可用的 exploit；
- 应用程序私有配置；
- 密钥、密码或令牌；
- 个人服务器地址；
- 在修复发布前可能被用于利用漏洞的其他信息。

## 报告内容

如有可能，请提供：

- 发布版本或 commit SHA；
- 操作系统及运行环境版本：PowerShell 或 Bash；
- 影响说明；
- 最小复现步骤；
- 预期行为和实际行为；
- 已脱敏的输入示例；
- 已知的可能修复方案。

## 报告处理

项目维护者会在条件允许时确认并审查报告，不保证固定 SLA。

在公开详细信息前，请与项目维护者协调披露。项目不提供漏洞奖励计划。
