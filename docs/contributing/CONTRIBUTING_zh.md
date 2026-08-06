# 参与开发

## 选择语言

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/CONTRIBUTING.md) | [English](./CONTRIBUTING_en.md) | [Español](./CONTRIBUTING_es.md) | **已选择** | [Français](./CONTRIBUTING_fr.md) | [Deutsch](./CONTRIBUTING_de.md) |

感谢您关注本项目。

## 开始之前

- 对可复现的错误请创建 Issue。
- 使用 Discussions 的 Q&A 分类提出使用问题。
- 在实施较大改动前先讨论方案。

## 实现

项目包含两个行为一致的原生实现：

- `src/convert-opencck-cidr.ps1` — Windows；
- `src/convert-opencck-cidr.sh` — macOS 和 Linux。

除非明确说明平台差异，否则转换逻辑的变更必须同时应用到两个实现。

面向用户的消息支持俄语和英语。添加或修改消息时，请同时更新两种本地化。

## 分支

```text
feature/add-cidr6-support
fix/windows-path-handling
docs/update-linux-guide
```

## 提交

建议使用 Conventional Commits：

```text
feat: add local JSON input
fix: preserve CIDR prefix during conversion
docs: clarify platform requirements
test: cover duplicate CIDR entries
chore: update GitHub workflow
```

## 本地检查

Windows：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

macOS 和 Linux：

```bash
./tests/run-tests.sh
```

## Pull Request

请说明：

- 该改动解决的问题；
- 验证结果的方法；
- 受影响的平台；
- 两个实现是否保持同步；
- 俄语和英语消息是否保持同步；
- 是否需要更新文档。

请勿提交私有配置、密钥、令牌、个人服务器地址或生成的路由列表。
