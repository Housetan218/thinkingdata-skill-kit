---
name: thinkingdata-analysis-entry
description: Use when working with ThinkingData/数数 to initialize a project, confirm metric definitions, run SQL or SPL queries, or generate product data summaries without relying on dashboard-only workflows.
---

# ThinkingData Analysis Entry

## Overview

This skill standardizes the ThinkingData workflow for Codex.

Core rule: use reusable browser login state for entry, use project initialization to lock scope and metric definitions, use Playwright CLI as the default browser executor, and use SQL/WebSocket execution as the default query path. Dashboards are reference material, not the main data path.

Supporting files:
- `runbooks/login-to-analysis-architecture-flow.md`
- `runbooks/data-acquisition-methods.md`
- `runbooks/project-initialization.md`
- `runbooks/project-workflow.md`
- `runbooks/performance-baseline.md`
- `references/project-index-template.md`
- `references/project-dossier-template.md`
- `references/sql-template-library.md`
- `references/timing-log-standard.md`
- `references/teammate-usage.md`
- `scripts/run_sql_via_ws.js`
- `scripts/scaffold_project_kit.sh`
- `scripts/record_timing_log.sh`

## Default Flow

1. Confirm there is a reusable logged-in browser session.
2. Identify the target project and subproject. Never default to `123` or `125`.
3. Check whether the project dossier already exists locally.
4. If the dossier is missing or outdated, run initialization first.
5. Confirm metric definitions before querying. Do not assume retention, save rate, or "valid/new/active user" fields are cross-project consistent.
6. Prefer SQL or SPL execution for data extraction.
7. Use dashboards only for mapping, comparison, or definition cross-checks.
8. Output data in the requested template plus a short analytical readout.
9. Write back any newly confirmed field mapping, metric formula, or project-specific exception into the local dossier.

## Architecture

- Browser layer: reusable logged-in browser session; Playwright CLI is the default browser executor, and Browser Use CLI is fallback support.
- Execution layer: ThinkingData SQL page plus WebSocket/server execution path is the main query channel.
- Knowledge layer: local project dossiers record project list, subprojects, fields, metrics, templates, and exceptions.
- Output layer: query result plus short product-aware summary.

## Hard Rules

- Do not start from dashboards when SQL/SPL can answer directly.
- Do not reuse another project's metric definition without confirmation.
- Do not assume every subproject uses the same event table or field naming.
- Do not leave a query hanging on the SQL page without an explicit progress check.
- Do not silently substitute example project IDs.
- Do not use Playwright default blank session as proof that every reusable browser session is logged out.
- Do not iterate through stale historical `ACCESS_TOKEN` values as a normal recovery step. If the live logged-in session is unavailable or invalid, open the real web login page first and ask the user to complete login recovery there.
- Do not rely on project-switcher DOM alone to prove project availability after login; prefer authenticated project-list APIs.
- Do not treat copied Chrome profile state or `--save-storage` output as a verified login recovery path.
- Do not assume `REFRESH_TOKEN` alone has a standardized auto-renew path in this workflow unless it has been explicitly verified for the current live session.

## Initialization Standard

Initialization creates or refreshes the local dossier for one target project.

Required outputs:
- `overview.md`: project name, project ID, subprojects, common timezone, core business context
- `fields.md`: core event names, user dimensions, country/platform/version fields, project-specific custom fields
- `metrics.md`: exact definitions for new users, active users, retention, save/use rates, and any custom ratios
- `output-template.md`: preferred output wording, sorting, and date/timezone style
- `query-templates.md`: reusable SQL/SPL snippets and verification notes

Initialization is mandatory only when one of these is true:
- first time touching the project
- subproject list is unclear
- metric definitions are unclear
- query result conflicts with known reports
- project owner says the product recently changed logic

If the dossier is already complete and recent, skip re-initialization and query directly.

## Login Recovery vs Table Exploration

Recovering login state and exploring tables are different decisions.

Login recovery only restores access.
It does not by itself justify re-initializing a project or re-exploring tables.

Default rule after login recovery:
- read the local dossier first
- reuse existing SQL/SPL templates if the dossier is still trustworthy
- do not automatically start full table exploration

Run partial or full table exploration only when one of these is true:
- the project is new
- the dossier is incomplete
- a required metric is still unverified
- subproject mapping is unclear
- field mapping is unclear
- production-user filtering is still pending
- results conflict with trusted historical outputs
- the product owner says tracking logic changed
- the user explicitly requests re-exploration

If exploration is needed, prefer partial exploration first. Do not jump to full re-initialization unless the uncertainty is broad.

## Query Strategy

Preferred order:
1. Reuse an existing validated SQL/SPL template for the same project and metric.
2. If missing, adapt a nearby project template after checking field differences.
3. If still unclear, inspect project definitions and tables first, then draft SQL.
4. For browser-side work, prefer Playwright CLI first.
5. Only if Playwright is blocked or unstable, use Browser Use CLI to recover page state.

## Execution Gate

Do not enter SQL execution until these four items are explicit or have been confirmed from context:

- `projectId` or exact product scope
- date or date range and timezone
- metric or analysis question
- expected output shape

If any item is missing:
- stop after auth validation
- summarize the confirmed project scope
- tell the operator what is still missing
- wait for the next instruction

Do not open the SQL page just to keep moving. Do not write exploratory SQL when the business target is still undefined.

If auth is missing before this stage:
- open the ThinkingData login page in a real browser first
- let the user complete login there
- only then re-check live auth state

## Output Standard

Every result should contain:
- project name
- timezone used
- absolute date
- requested metrics
- a short interpretation
- any assumptions or unresolved definition risk

Example output shape:

```text
《LiCoWa iOS》 UTC+8
2026-04-01（三）
新增 2,341，活跃 9,480
前一日次留 20.23%
...
简析：新增回落，越南与菲律宾贡献靠前，美国保持稳定。
```

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
  <project_id> \
  /absolute/path/to/query.sql
```

Use only a current token from a live logged-in session. Do not promote old localStorage residues into the formal query path unless the user explicitly asks for token-forensics debugging.

When extracting auth values from browser tooling, normalize the output first. Do not mistake wrapper text such as `KEY=value` or escaped/raw transport noise for the actual token value.

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

## Fast Failure Checks

Stop and repair the path if any of these occur:
- SQL page opens but no project context is confirmed
- query has no execution status update for several minutes
- returned data conflicts sharply with known verified numbers
- field names were borrowed from another project without confirmation
- dashboard numbers are used as truth while SQL logic is still unverified

## Browser Execution Order

Browser tool priority is fixed:

1. Playwright CLI first
2. Browser Use CLI fallback

Use Playwright CLI for:
- login-state verification
- checking whether a reusable real browser session exists
- opening and recovering pages
- project and subproject confirmation
- stable scripted browser actions
- download, console, network, and snapshot-based debugging

Use Browser Use CLI only when:
- Playwright is temporarily unstable
- a lightweight page-state check is enough
- a quick browser recovery action is faster than rebuilding the Playwright flow

Do not treat Browser Use CLI as the default browser executor.

## Browser Use Recommended Cases

Recommended:
- confirm whether the current browser session is still logged in
- reopen the login page, project page, or SQL page quickly
- recover after the browser loses the right tab or page context
- verify which project or subproject is currently visible in the page
- inspect the current page state before deciding the next SQL action
- perform lightweight clicks, typing, tab switching, screenshots, or page reads
- act as a fallback browser layer when the normal browser tool is unstable

## Browser Use Not Recommended Cases

Do not use Browser Use CLI when the bottleneck is already on the ThinkingData server side.

Not recommended:
- replacing SQL or SPL as the main data extraction path
- waiting on long server-side query execution and expecting browser automation to speed it up
- inferring metric definitions from page text alone
- copying one project's metric logic into another without dossier confirmation
- relying on dashboards as the source of truth when SQL logic is still unverified

## Where It Actually Saves Time

Browser Use CLI can shorten:
- login-state confirmation
- page recovery after browser confusion
- SQL page entry and context verification
- project-switch and page-state checks during initialization

It does not materially shorten:
- server-side SQL runtime
- queue time inside ThinkingData
- metric-definition calibration work
- analyst interpretation and writeback work

## Playwright Recommended Cases

Use Playwright CLI by default for:
- first-pass login-state verification
- distinguishing default automation session from reusable real-browser session
- opening login, project, and SQL pages in a deterministic way
- repeated page actions that need stable selectors or waits
- debugging with page, console, network, and download evidence
- any browser workflow that may later need to be scripted and repeated by teammates

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

Known examples:

- `123` is LiCoWa iOS
- `125` is LiCoWa Android
- `160` and `170` are aggregated projects
- `171` is a special project and should not default to `bundle_id`

Treat these mappings as examples and operational hints, not defaults. The actual task may belong to any visible project. Confirm the real project before formal output.

## Common Mistakes

- Starting from dashboard numbers and treating them as raw truth
- Writing SQL before checking project structure
- Reusing one project’s filter logic on another project
- Defaulting to browser SQL page when WebSocket direct-run is already available
- Opening the SQL page before project/date/metric/output are clear
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
- [project-initialization.md](runbooks/project-initialization.md)
- [project-workflow.md](runbooks/project-workflow.md)
- [performance-baseline.md](runbooks/performance-baseline.md)
- [project-index-template.md](references/project-index-template.md)
- [project-dossier-template.md](references/project-dossier-template.md)
- [sql-template-library.md](references/sql-template-library.md)
- [timing-log-standard.md](references/timing-log-standard.md)
- [teammate-usage.md](references/teammate-usage.md)

## Update Discipline

After any successful new discovery, update the dossier with:
- new subproject mapping
- confirmed field mapping
- metric formula corrections
- product-specific special handling
- preferred output wording
