# ThinkingData Skill Kit

用于把 `thinkingdata-analysis-entry` skill 分发给其他同事安装使用。

## 包含内容

- `install.sh`
  - 终端安装脚本，推荐使用
- `install.command`
  - macOS 双击安装入口，可能被系统拦截
- `SKILL.md`
  - skill 入口
- `runbooks/`
  - 流程文档与执行规范
- `references/`
  - 项目索引模板、项目档案模板、SQL 模板库、耗时日志规范、同事使用说明
- `scripts/`
  - WebSocket SQL 执行、项目脚手架、耗时日志写入脚本
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
- 建立或更新项目 dossier
- 沉淀项目级 SQL 模板与耗时日志

## Browser Use CLI 定位

默认浏览器执行器是 Playwright CLI。

Playwright CLI 负责：

- 登录态主检查
- 真实浏览器会话接管
- 页面进入与恢复
- 需要稳定等待、下载、日志、快照时的页面动作

Browser Use CLI 可以加速：

- 登录态确认
- 页面打开与恢复
- 当前项目/子项目页面状态确认
- 初始化时的轻量页面操作

Browser Use CLI 不负责：

- 作为默认浏览器执行层
- 替代 SQL/SPL 主查询链路
- 缩短 ThinkingData 服务端执行耗时
- 替代项目口径确认

登录失效时的标准动作：

- 直接弹出/打开真实浏览器登录页，让用户先登录
- 再重新检查当前真实浏览器登录态
- 不把历史 token 枚举当成正式查询前置流程

登录恢复后，不会默认重新初始化项目。

默认顺序是：

1. 先恢复登录态
2. 先读本地 dossier / SQL 模板
3. 只有项目知识不可信时才补探表
4. 能局部探表就不做全量初始化

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
请使用 thinkingdata-analysis-entry skill。项目 <projectId>，日期 2026-04-01，指标是新增和活跃，按日报格式输出；优先走 WebSocket SQL 直连。
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

- 你需要先准备一个可复用的已登录浏览器会话
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
├── references/
├── runbooks/
├── scripts/
└── 使用说明.txt
```
