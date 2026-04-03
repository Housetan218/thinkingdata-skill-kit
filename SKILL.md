---
name: thinkingdata-analysis-entry
description: Use when a teammate needs to log into the ThinkingData backend, establish authentication, identify the correct project and product scope, and enter the SQL-based analysis workflow without getting lost in dashboards.
---

# ThinkingData Analysis Entry

## Overview

This skill standardizes the first segment of ThinkingData work: login, auth validation, project identification, structure probing, and SQL entry. The core rule is simple: do not start from dashboard readouts; start from project structure and SQL. When SQL is needed, prefer the verified WebSocket direct-run path before falling back to browser-page execution.

## When to Use

- Need to begin a new ThinkingData task from scratch
- Logged into backend but do not know the next safe step
- Need to hand a reusable process to another operator
- Need to avoid mixing projects, products, or dashboard-only metrics

Do not use this skill as the final metric-calibration guide for every retention or conversion rate. It is the entry skill, not the full metric-definition skill.

## Fixed Entry Points

- Login page: `https://taadmin.unbing.cn/oauth/#/login`
- Backend host: `https://taadmin.unbing.cn`
- SQL page: `https://taadmin.unbing.cn/#/tga/ide/-1?tab=result`

## Standard Flow

1. Log into the real browser first.
2. Confirm backend access and visible project switcher.
3. Reuse the logged-in browser state in automation or attach to a logged-in browser session.
4. Read `localStorage` and validate it contains:
   - `ACCESS_TOKEN`
   - `REFRESH_TOKEN`
   - `TA_MASTER_PROPS`
   - `TA_AUTHS`
5. Use `Authorization: Bearer <ACCESS_TOKEN>` for backend APIs.
6. Identify the project before writing SQL.
7. Probe structure first:
   - `space/getSpaceTree`
   - `entity/listEntities`
   - `event/reportsearch`
8. Confirm product identity field.
9. Prefer direct SQL execution through the verified WebSocket backend.
10. Fall back to SQL page + Ace editor only when direct-run is blocked.
11. If browser-page execution is used, download CSV instead of scraping result tables.

## Core Rules

- Dashboards are for naming map and metric calibration only.
- Main data path is `project structure -> product identity -> SQL`.
- Preferred SQL path is `WebSocket direct-run -> result payload`.
- Browser SQL page is fallback, not default.
- Aggregated projects must be split by product before formal queries.
- Event-table queries should include `"$part_date"` by default.
- Do not assume all projects use the same “test user” or “production user” field.

## Preferred SQL Path

Use the bundled direct-run script first.

Read the token from the logged-in backend shell:

```js
localStorage.getItem('ACCESS_TOKEN')
localStorage.getItem('LOGIN_NAME')
```

Then run the bundled script from the installed skill directory:

```bash
TD_ACCESS_TOKEN='<current ACCESS_TOKEN>' \
node scripts/run_sql_via_ws.js \
  123 \
  /absolute/path/to/query.sql
```

Direct-run facts already verified:

- WebSocket URL pattern:

```text
wss://taadmin.unbing.cn/v1/ta-websocket/query/<ACCESS_TOKEN>
```

- Wire format:

```json
["data", { "requestId": "WS_SQLIDE@@...", "...": "..." }, { "channel": "ta" }]
```

- Final result is read directly from `result.data.rows`.

## Browser Fallback Pattern

Write SQL with Ace:

```js
window.ace.edit('ta-sql-ace-editor').setValue(sql, -1)
```

Find action buttons by visible text:

```js
[...document.querySelectorAll('button')].find(x => (x.innerText || '').trim() === '计算')
[...document.querySelectorAll('button')].find(x => (x.innerText || '').trim() === '全量下载')
```

If browser fallback is used, download CSV and read the downloaded file. Do not scrape result table DOM.

## Project Checkpoints

- `123` is LiCoWa iOS
- `125` is LiCoWa Android
- `160` and `170` are aggregated projects
- `171` is a special project and should not default to `bundle_id`

Treat these mappings as operational hints. Check the current runbook before formal output.

## Common Mistakes

- Starting from dashboard numbers and treating them as raw truth
- Writing SQL before checking project structure
- Reusing one project’s filter logic on another project
- Defaulting to browser SQL page when WebSocket direct-run is already available
- Injecting Chinese filter text directly and getting encoding corruption
- Scraping result tables instead of downloading CSV

## Encoding Rule

If Chinese literals become unstable through shell or browser automation, switch to:

- `base64 + TextDecoder` for SQL injection
- `from_utf8(from_hex(...))` for SQL-side string constants when needed

## Reference

Read these bundled runbooks before using the skill:

- [login-to-analysis-architecture-flow.md](runbooks/login-to-analysis-architecture-flow.md)
- [data-acquisition-methods.md](runbooks/data-acquisition-methods.md)
- [performance-baseline.md](runbooks/performance-baseline.md)
