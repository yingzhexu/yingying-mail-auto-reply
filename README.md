# YINGYING 邮件自动回复 / YINGYING Mail Auto Reply

**版本 / Version: 1.3.2 · macOS 12+ · Intel x86_64 + Apple Silicon arm64**

## 中文说明

### 这是什么

YINGYING 邮件自动回复是一款在 Mac 上运行的原生应用。它通过这台 Mac 自带的“邮件”App 读取指定邮箱的新邮件，先检查发件人是否在你填写的白名单内，再根据你填写的规则，请 AI 判断是否回复及撰写回复。符合条件时，它会通过“邮件”App 在原邮件线程中自动发送，不逐封弹出确认。

**它不直接调用 Microsoft Graph/Outlook API。** Outlook、QQ 等邮箱需要先在运行此应用的 Mac 的系统“邮件”中登录。应用不接收邮箱密码，也不需要 Microsoft 应用 ID。自动检查只在应用打开时运行；退出应用、Mac 关机或离线后不会在云端继续工作。

### 下载与安装

1. 从 [GitHub Releases](https://github.com/yingzhexu/yingying-mail-auto-reply/releases/latest) 下载 Universal DMG，打开后把 `YINGYING邮件自动回复.app` 拖进“应用程序”。也可使用桌面交付的同版本 DMG。
2. 如果此前安装过 `ReplyPilot.app` 或旧版 `YINGYING邮件自动回复.app`，先退出旧应用，再换成新版，避免两个副本同时处理邮件。新版沿用应用标识 `com.replypilot.mail`，同一台 Mac 上的旧设置可继续读取。
3. 此包为临时签名，**未经过 Apple 公证**。macOS 可能阻止首次打开。可在 Finder 中按住 Control 点击应用并选“打开”，或查看“系统设置 → 隐私与安全性”的对应提示。只使用你信任的下载来源。
4. 在目标 Mac 的系统“邮件”中登录要处理的邮箱，确认它可以正常收发。然后打开本应用，输入邮箱完整地址，点“检测邮箱”。首次检测时，macOS 可能询问是否允许本应用控制“邮件”；同意后才能读取账户和发送回复。

复制应用或 DMG 到另一台 Mac **不会复制**邮箱登录、钥匙串密钥或日志。每台 Mac 需要自行完成邮箱登录、API Key 保存和权限授权。

### AI 服务设置

默认地址是 `https://api.deepseek.com/chat/completions`，默认模型是 `deepseek-flash`。填写你的 DeepSeek API Key，然后点“保存密钥”。也可以填写其他服务的 HTTPS 根地址或完整 `/chat/completions` 地址、模型名称和该服务的 API Key。其他服务必须兼容 OpenAI Chat Completions 的 Bearer Key、JSON 请求与 `choices[0].message.content` 返回格式；仅支持 Responses API 或不同认证协议的服务不能直接使用。

API Key 按服务域名保存在这台 Mac 的钥匙串，不写入源码或应用包。普通检查模式会将白名单邮件的发件人、主题和最多 16,000 字的正文发送到所选 AI 服务；定时汇总模式会读取本次范围内的所有相关邮件正文，内容较多时分段发送给 AI 汇总。启动前需要勾选对此数据流向的确认。

### 白名单、规则与自动回复

白名单每行填写一个完整邮箱地址，例如 `customer@example.com`，或一个域名，例如 `@example.com`。规则应写明哪些邮件可以回复、需要包含哪些信息、语气和语言，以及不回复的情况。只有白名单内的邮件才会交给 AI。应用会跳过发给自己的邮件、空正文和常见的自动回复、群发或邮件列表消息，并用邮件 ID 避免重复尝试。AI 判断可能出错，请先用自己的测试邮件检查实际效果，再扩大白名单。

### 检查时间

- **按间隔检查**：输入整数并选择秒、分钟或小时；范围为 30 秒到 24 小时。默认每 30 秒检查，启动后会立即检查一次。
- **每天定时检查**：输入一个或多个 Mac 本地 24 小时时间，例如 `13:00, 23:00`。默认是每天 13:00 和 23:00。启动时不会追发过去的时段；Mac 睡眠期间错过的时段，会在应用唤醒后补检。运行中修改为有效时间会直接生效；状态栏显示下一次触发时间，日志记录实际触发。输入尚未完整时沿用上一次有效时间。定时模式每次最多回看 24 小时；应用关闭期间不检查，也不在下次启动时自动补发。
- **定时汇总回复**：使用相同的定时时间。每次点击“启动自动回复”都会将回看起点重设为当时往前 12 小时；之后分别从每位发件人的上次成功回复时间继续读取。同一发件人在一次定时检查中，相关邮件合并为一封正式回复，并回复到最新一封邮件的线程。两个白名单发件人会分别处理、分别回复。已读邮件也纳入汇总。若 AI 决定不回复，下一次有新邮件时会连同此前未回复的邮件重新汇总。邮件很多时 AI 会先分段整理，再生成最终一封回复；附件内容暂不读取。应用关闭时不检查；重新启动后按新的 12 小时起点处理，已发送邮件不会重复发送。
- **立即汇总并发送**：仅在“定时汇总回复”模式可点。可填写回看时长和单位（分钟、小时或天），范围为 1 分钟至 30 天，默认 30 分钟。按下后立刻读取该时段的相关邮件，按白名单及规则让 AI 判断；需要回复时直接通过系统“邮件”发送，每位发件人最多一封。它可以在定时自动回复尚未启动时单独使用。已发送或发送结果不确定的邮件不会自动重发。回看范围越长，读取和 AI 处理可能越久。

修改邮箱、AI 设置、白名单、规则或时间文本后，自动回复会暂停，需要核对设置并重新启动。

### 运行记录和故障排查

窗口右侧显示最近记录。“打开完整日志”会定位到 `~/Library/Application Support/YINGYING邮件自动回复/activity.log`。日志按时间记录检测结果、AI 判断错误、跳过原因，以及准备发送的收件人、主题、**完整回复正文**和系统“邮件”返回的发送结果。日志是本机明文文件，请按邮件内容的敏感程度保护和清理。若准备发送前无法写入日志，应用会停止自动回复。

“系统‘邮件’已接受发送”只表示 Mail 接受了发送命令，**不代表邮件服务器最终投递**。出现“发送结果待确认”时，请检查系统“邮件”的“发件箱”和“已发送”；为避免重复发送，应用不会自动重发同一封。

点“检测邮箱”后，窗口顶部会立即显示检测状态。如果停在“检测中”，请查看是否有 macOS 自动化授权弹窗。超时或失败时会显示具体错误；完整日志会列出检测到的邮箱地址和 Mail 的读取错误。如果填入的地址未找到，请确认是在**运行应用的这台 Mac** 的系统“邮件”中登录，并检查地址是否完全一致。必要时到“系统设置 → 隐私与安全性 → 自动化”检查本应用对“邮件”的权限。

### 隐私与发布检查

本仓库只包含源码、图标、构建脚本、权限声明和文档；不包含用户邮箱配置、API Key、邮件正文、运行日志、DMG 制作缓存或其他本机数据。API Key 由运行设备的钥匙串保存；邮箱、白名单、规则、检查设置和去重 ID 保存于该设备的用户设置中；完整回复记录保存于该设备的 Application Support。应用没有集成分析或广告 SDK。详细的发布检查范围和已知数据流向见 [PRIVACY.md](PRIVACY.md)。

### 从源码构建

在安装 Apple Command Line Tools 的 Mac 上运行：

```bash
./Scripts/build.sh
```

脚本在 `build/` 下生成双架构 `.app`，目标最低 macOS 12，并执行本地签名及架构检查。临时签名不等于 Apple Developer ID 签名或公证。项目没有完整验证目标 Mac 的自动化权限、第三方 AI 连接或真实发信；请在目标 Mac 上手动验证。

---

## English

### Overview

YINGYING Mail Auto Reply is a native Mac application. It reads new messages from an account configured in the macOS Mail app, checks the sender against an editable allowlist, and asks the selected AI service to decide whether to reply under your rules. When a reply is approved, the app sends it in the original thread through Mail without per-message confirmation.

**It does not call Microsoft Graph or the Outlook API directly.** Add your Outlook, QQ, or other account to the Mail app on the Mac where YINGYING runs. The app never asks for your mailbox password or a Microsoft application ID. Automatic checks run only while the app is open; there is no cloud worker after the app quits or the Mac goes offline.

### Download and installation

1. Download the Universal DMG from [GitHub Releases](https://github.com/yingzhexu/yingying-mail-auto-reply/releases/latest) and drag `YINGYING邮件自动回复.app` into Applications. You can also use the matching DMG supplied on the Desktop.
2. Quit and replace any earlier `ReplyPilot.app` or YINGYING copy before launching the new version. Running two copies could process the same inbox at once. The bundle identifier remains `com.replypilot.mail`, so settings from an earlier version on the same Mac can be read.
3. This build is ad hoc signed and **not Apple notarized**. macOS may block the first launch. In Finder, Control-click the app and choose Open, or review the corresponding prompt in System Settings → Privacy & Security. Install only from a source you trust.
4. Sign in to the target mailbox in macOS Mail on the destination Mac and confirm Mail can send and receive. Enter the full address in YINGYING and click “检测邮箱” (Check mailbox). macOS may ask whether the app can control Mail; this permission is required to read accounts and send replies.

Moving the app or DMG to another Mac does **not** copy mailbox sign-in, Keychain secrets, or logs. Configure those separately on each Mac.

### AI service

The default endpoint is `https://api.deepseek.com/chat/completions`, and the default model is `deepseek-flash`. Enter your DeepSeek API Key and click “保存密钥” (Save key). You may instead enter another provider's HTTPS base URL or full `/chat/completions` URL, its model name, and its API Key. The provider must support OpenAI-compatible Chat Completions with Bearer authentication, a JSON request, and a `choices[0].message.content` response. Responses-only APIs and other authentication protocols are not supported directly.

Keys are stored in the destination Mac's Keychain by provider host, never in the source repository or app bundle. Standard checks send the sender, subject, and up to 16,000 characters of each allowlisted message body to the chosen AI service. Scheduled digest mode sends all relevant message bodies in segments when needed. You must acknowledge this data flow before enabling automation.

### Allowlist and reply rules

Enter one complete address per line, such as `customer@example.com`, or a domain such as `@example.com`. Rules should describe when to reply, required information, language and tone, and when to decline. Only allowlisted messages are sent to the AI service. The app skips self-addressed mail, empty bodies, and common automatic replies, bulk mail, and mailing-list messages. It records message IDs to avoid repeated attempts. AI decisions can be wrong; test with your own messages before expanding the allowlist.

### Schedules

- **Interval:** Choose an integer and seconds, minutes, or hours. The allowed range is 30 seconds to 24 hours. The default is 30 seconds, with an immediate check on start.
- **Daily times:** Enter one or more local Mac times in 24-hour format, such as `13:00, 23:00`. These are the defaults. Starting the app does not replay an earlier slot. A slot missed while the Mac sleeps is checked after wake. Editing to a valid time while running takes effect immediately; the status bar shows the next trigger and the log records actual triggers. While input is incomplete, the last valid schedule remains active. Scheduled checks look back no more than 24 hours. The app does not check while closed or replay missed mail at its next launch.
- **Scheduled digest reply:** Uses the same local times. Every click of Start resets the lookback baseline to the preceding 12 hours; subsequent checks continue from each sender's last successful reply. Read messages are included. At each slot, messages from each allowlisted sender are combined into one formal reply in that sender's newest message thread. Two allowlisted senders are handled separately. If AI declines, unresolved messages are reconsidered when new mail arrives. Large batches are summarized in segments. Attachment contents are not read. The app does not check while closed. Restarting sets a fresh 12-hour baseline, while already sent mail remains deduplicated.
- **Send a digest now:** Available in Scheduled digest mode. Enter a lookback duration in minutes, hours, or days, from 1 minute to 30 days; the default is 30 minutes. Clicking the button immediately checks that period, asks AI to apply the allowlist and rules, and sends up to one combined reply per sender through Mail when AI approves. It works even if scheduled automation has not been started. Previously sent or uncertain sends are not retried automatically. Longer periods may take more time to read and process.

Editing the mailbox, AI settings, allowlist, rules, or schedule text pauses automation until you review the settings and start it again.

### Logs and troubleshooting

The right-hand panel shows recent activity. “打开完整日志” (Open full log) locates `~/Library/Application Support/YINGYING邮件自动回复/activity.log`. The plain-text log records timestamps, checks, AI errors, skip reasons, intended recipient and subject, the **full drafted reply**, and Mail's send result. Protect and remove it according to the sensitivity of your email. If the app cannot write the log before sending, it stops automation.

“Mail accepted send” means Mail accepted the send command; it does **not** prove server delivery. If the result is uncertain, inspect Mail's Outbox and Sent folders. The app does not retry that message automatically, to avoid duplicates.

After clicking Check mailbox, a status appears at the top of the window immediately. If it remains in progress, look for the macOS Automation permission prompt. Errors and detected addresses appear in the full log. If an address is missing, confirm that it is configured in Mail on the **same Mac** and matches exactly. Also check System Settings → Privacy & Security → Automation for permission to control Mail.

### Privacy and release review

This repository contains only source code, the icon, build script, entitlements, and documentation. It contains no user mailbox configuration, API Keys, message bodies, activity logs, DMG staging files, or other local data. Runtime API Keys live in the destination Mac's Keychain; mailbox address, allowlist, rules, schedule, and deduplication IDs live in that Mac's user defaults; full reply records live in Application Support. No analytics or advertising SDK is integrated. See [PRIVACY.md](PRIVACY.md) for the review scope and intentional data flows.

### Build from source

On a Mac with Apple Command Line Tools installed:

```bash
./Scripts/build.sh
```

The script creates a Universal `.app` in `build/`, targets macOS 12+, and checks its local signature and architectures. Ad hoc signing is not Apple Developer ID signing or notarization. The target Mac's Mail permission, third-party AI connection, and real email sending have not been verified as part of this source release; verify them manually on the destination Mac.
