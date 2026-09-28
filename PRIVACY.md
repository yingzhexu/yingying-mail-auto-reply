# 隐私与发布检查 / Privacy and Release Review

**检查对象 / Reviewed version:** 1.3.2 · 2026-09-28

## 中文

### 发布内容检查

本次只计划发布 `Sources/Main.m`、`Scripts/build.sh`、`Info.plist`、`ReplyPilot.entitlements`、`AppIcon.icns`、`README.md`、`PRIVACY.md`、`LICENSE` 与 `.gitignore`。检查了这些文本文件中的硬编码凭据、令牌格式、真实邮箱地址、个人用户目录、绝对本机路径和非预期网络地址；也检查了图标及编译后应用包的可读字符串。**未发现嵌入的 API Key、邮箱密码、用户邮件内容、运行日志或私人本机路径。** 源码中的 `@outlook.com` 等是邮箱提供商后缀，`name@example.com` 和 `customer@example.com` 是界面及文档示例；默认 DeepSeek 地址是公开 API 地址。

仓库不包含 `build/`、`.app`、`.dmg`、`.zip`、运行时 `activity.log`、钥匙串导出、用户设置文件或邮件数据库。DMG 和源码 ZIP 作为 Release 下载附件提供；它们也只从上述经过筛选的文件及应用包制作。`.gitignore` 额外排除常见密钥、环境文件、日志和构建产物，防止后续误加。

这是**针对当前发布文件的静态检查**，不代表对所有运行环境、第三方 AI 服务或未来修改作出绝对无泄漏保证。发布前如更换图标、代码、脚本或打包材料，应重新检查。

### 运行时数据流向

1. 应用通过 macOS Apple Events 请求控制系统“邮件”，读取目标邮箱的账户和近期邮件，并在获准后发送回复。目标邮箱应已在本机 Mail 中登录。
2. 只有发件人在白名单中、且未被自动邮件过滤器跳过的邮件，才会将内容发送到用户填写的 **HTTPS AI 服务地址**。普通模式发送发件人、主题和最多 16,000 字正文；定时汇总模式发送该发件人本次范围内的所有相关邮件正文，内容较多时会分段发送给 AI 汇总。当前不读取附件内容。API Key 以 Bearer 凭据发送给该地址。配置自定义地址时，请自行确认服务商可信及其隐私政策。
3. API Key 按服务域名保存在本机钥匙串。邮箱地址、白名单、规则、日程、启用状态和去重 ID 保存在本机用户设置中。应用不会把这些运行时数据写回 GitHub 仓库。
4. 本机 `~/Library/Application Support/YINGYING邮件自动回复/activity.log` 保存时间、处理结果、收件人、主题和完整的拟发送回复正文。它是明文日志，可能含敏感邮件信息。建议只在受信任的 Mac 上运行，并按需要定期查看和清理。
5. 代码未集成分析、广告或遥测 SDK。除选定的 AI 服务和系统“邮件”所用邮件服务外，未发现其他主动发送邮件内容的网络路径。

### 已知限制

AI 可能判断或撰写错误；白名单规则和自动邮件过滤不能保证避免所有误发。系统“邮件”接受发送命令不代表服务器最终投递。当前 DMG 为临时签名，未经 Apple 公证。此次检查未在其他 Mac 上验证真实邮箱授权、第三方 AI 响应或实际投递。

---

## English

### Publication review

The publication set is limited to `Sources/Main.m`, `Scripts/build.sh`, `Info.plist`, `ReplyPilot.entitlements`, `AppIcon.icns`, `README.md`, `PRIVACY.md`, `LICENSE`, and `.gitignore`. Text files were reviewed for embedded credentials, token patterns, real mailbox addresses, user-home paths, absolute local paths, and unexpected network destinations. Readable strings in the icon and compiled app bundle were also checked. **No embedded API Key, mailbox password, user message content, activity log, or private local path was found.** Provider suffixes such as `@outlook.com` are code logic; `name@example.com` and `customer@example.com` are UI and documentation examples; the default DeepSeek endpoint is public.

The repository excludes `build/`, app bundles, DMGs, ZIPs, runtime logs, Keychain exports, user preference files, and Mail databases. The DMG and source ZIP are distributed as Release assets and are assembled only from the selected project files and app bundle. `.gitignore` additionally excludes common key files, environment files, logs, and build output to reduce accidental future inclusion.

This is a **static review of the current publication files**, not an absolute guarantee about every runtime environment, third-party AI provider, or future change. Repeat the review when code, icon, scripts, or packaging inputs change.

### Runtime data flows

1. The app uses macOS Apple Events to control Mail, read accounts and recent messages, and send replies after permission is granted. The mailbox must already be configured in Mail on that Mac.
2. Only messages from allowlisted senders that pass the automatic-mail filters are sent to the user-configured **HTTPS AI endpoint**. Standard mode sends the sender, subject, and at most 16,000 characters of the body. Scheduled digest mode sends all relevant message bodies for that sender, in segments when needed. Attachment contents are not read. The API Key is sent to that endpoint as a Bearer credential. Review the provider and its privacy policy before entering a custom URL.
3. API Keys live in the local Keychain by provider host. Mailbox address, allowlist, rules, schedules, enablement, and deduplication IDs live in local user defaults. Runtime data is not written back to this GitHub repository.
4. `~/Library/Application Support/YINGYING邮件自动回复/activity.log` stores timestamps, processing results, recipients, subjects, and full drafted replies in plain text. It may contain sensitive mail information. Run the app only on a trusted Mac and review or remove the log as appropriate.
5. No analytics, advertising, or telemetry SDK is integrated. The review found no other code path that intentionally sends message contents over the network beyond the chosen AI endpoint and the mail service used by Mail.

### Known limits

AI decisions and drafts can be wrong; allowlists and automatic-mail filters cannot guarantee that every mistaken reply is prevented. Mail accepting a send command does not prove server delivery. The DMG is ad hoc signed and not Apple notarized. This review did not verify live mailbox permissions, third-party AI responses, or delivery on another Mac.
