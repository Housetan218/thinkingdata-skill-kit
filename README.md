# ThinkingData Skill Kit

Language:

- 中文说明: [README.zh-CN.md](README.zh-CN.md)
- English guide: [README.en.md](README.en.md)

Recommended GitHub usage:

```bash
git clone <repo-url> ~/.agents/skills/thinkingdata-analysis-entry
```

If your Codex environment uses `~/.codex/skills/`:

```bash
git clone <repo-url> ~/.codex/skills/thinkingdata-analysis-entry
```

Update later:

```bash
git -C ~/.agents/skills/thinkingdata-analysis-entry pull
```

After cloning:

```text
请使用 thinkingdata-analysis-entry skill。先只检查登录态和项目列表，不要打开 SQL；等我给你项目、日期、指标后再执行查询。
```

This repository now includes:

- root skill entry: `SKILL.md`
- runbooks: `runbooks/`
- references and templates: `references/`
- helper scripts: `scripts/`

Playwright CLI is the default browser executor. Browser Use CLI is fallback browser-side help only. The main data path remains ThinkingData SQL/SPL plus WebSocket execution.
