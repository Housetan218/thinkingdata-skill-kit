# ThinkingData Skill Kit

用于把 `thinkingdata-analysis-entry` skill 分发给其他同事安装使用。

## 包含内容

- `install.sh`
  - 终端安装脚本，推荐使用
- `install.command`
  - macOS 双击安装入口，可能被系统拦截
- `thinkingdata-analysis-entry/`
  - skill 本体
  - 包含 `SKILL.md`、`scripts/`、`runbooks/`
- `使用说明.txt`
  - 中文快速说明

## 推荐使用方式

GitHub 长期使用的推荐方式，不是下载后再运行安装脚本，而是直接把仓库 clone 到 skill 目录。

如果你的环境使用 `~/.agents/skills/`：

```bash
git clone <repo-url> ~/.agents/skills/thinkingdata-analysis-entry
```

如果你的环境使用 `~/.codex/skills/`：

```bash
git clone <repo-url> ~/.codex/skills/thinkingdata-analysis-entry
```

后续更新：

```bash
git -C ~/.agents/skills/thinkingdata-analysis-entry pull
```

## clone 后

1. 重新打开 Codex
2. 新开会话
3. 输入：

```text
请使用 thinkingdata-analysis-entry skill。先只检查登录态和项目列表，不要打开 SQL；等我给你项目、日期、指标后再执行查询。
```

## Skill 能做什么

- 接手已登录的 ThinkingData 后台会话
- 读取 `ACCESS_TOKEN`
- 确认项目和产品范围
- 优先走 SQL WebSocket 直连
- 在需要时回退到浏览器 SQL 页

## 推荐启动方式

不要只说“帮我开始分析任务”。

推荐先用这一句：

```text
请使用 thinkingdata-analysis-entry skill。先只检查登录态和项目列表，不要打开 SQL；等我给你项目、日期、指标后再执行查询。
```

如果你已经知道目标，直接把四项说清：

- 项目或产品
- 日期或日期范围
- 指标
- 输出格式

例如：

```text
请使用 thinkingdata-analysis-entry skill。项目 123，日期 2026-04-01，指标是新增和活跃，按日报格式输出；优先走 WebSocket SQL 直连。
```

## 常见问题

### 打开 SQL 页面后一直没动静

这通常不是 SQL 本身卡住，而是任务定义不完整。

优先检查是否已经明确：

- 项目
- 日期
- 指标
- 输出格式

如果没有全部明确，先不要停留在 SQL 页，回到任务定义层。

## 使用前提

- 你需要先在真实浏览器里登录数数后台
- 安装包不会替你生成登录态
- token 只用于当前会话，不要写入仓库

## 兼容方式

如果同事不是用 Git，而是直接下载压缩包，也可以继续使用：

```bash
bash install.sh
```

或：

```bash
bash install.sh --codex-home
```

## 目录结构

```text
thinkingdata-skill-kit/
├── SKILL.md
├── README.md
├── README.en.md
├── README.zh-CN.md
├── install.command
├── install.sh
├── runbooks/
├── scripts/
└── 使用说明.txt
```
