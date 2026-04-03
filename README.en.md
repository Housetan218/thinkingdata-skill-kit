# ThinkingData Skill Kit

This package distributes the `thinkingdata-analysis-entry` skill to teammates.

## Contents

- `install.sh`
  - Recommended terminal installer
- `install.command`
  - macOS double-click installer, may be blocked by Gatekeeper
- `thinkingdata-analysis-entry/`
  - The skill bundle
  - Includes `SKILL.md`, `scripts/`, and `runbooks/`
- `使用说明.txt`
  - Quick Chinese usage note

## Recommended Usage

For long-term GitHub usage, the recommended approach is to clone this repository directly into the skill directory.

If your environment uses `~/.agents/skills/`:

```bash
git clone <repo-url> ~/.agents/skills/thinkingdata-analysis-entry
```

If your environment uses `~/.codex/skills/`:

```bash
git clone <repo-url> ~/.codex/skills/thinkingdata-analysis-entry
```

Update later:

```bash
git -C ~/.agents/skills/thinkingdata-analysis-entry pull
```

## After Cloning

1. Reopen Codex
2. Start a new session
3. Type:

```text
Please use the thinkingdata-analysis-entry skill. First only verify login state and list visible projects. Do not open SQL yet. Wait for my project, date, metric, and output format before running any query.
```

## What the Skill Does

- Reuses an already logged-in ThinkingData backend session
- Reads `ACCESS_TOKEN`
- Confirms project and product scope
- Prefers SQL WebSocket direct execution
- Falls back to the browser SQL page when needed

## Recommended Start Prompt

Do not start with a vague request like "help me start analysis".

Use this instead:

```text
Please use the thinkingdata-analysis-entry skill. First only verify login state and list visible projects. Do not open SQL yet. Wait for my project, date, metric, and output format before running any query.
```

If the target is already known, provide all four items:

- project or product
- date or date range
- metric
- output format

Example:

```text
Please use the thinkingdata-analysis-entry skill. Project 123, date 2026-04-01, metrics are new users and active users, output as a daily report, and prefer the WebSocket SQL direct-run path.
```

## Prerequisites

- You must already be logged into the ThinkingData backend in a real browser
- The package does not create a login session for you
- Tokens are for the current session only and must not be committed

## Compatibility Mode

If someone downloads the zip instead of cloning the repository, they can still use:

```bash
bash install.sh
```

or:

```bash
bash install.sh --codex-home
```

## Directory Layout

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
