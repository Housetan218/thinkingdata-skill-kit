# Teammate Usage Guide

## What This Skill Solves

This skill helps analysts and operators use ThinkingData in a repeatable way:
- reuse login state
- avoid re-exploring the same project basics
- prefer SQL/SPL over dashboard-only workflows
- output data in a consistent business format

## Startup Flow

1. Start Codex.
2. Ensure the reusable browser login state is available.
3. Ask Codex to use `thinkingdata-analysis-entry`.
4. State the target project, subproject if known, date range, timezone, and metric request.

## Typical Requests

- "Initialize project 170 and build the local dossier."
- "For project 125, query 2026-03-30 daily summary in UTC+8."
- "Check whether this project already has a verified D1 retention template."
- "Update the dossier if the country field logic changed."

## What The User Should Provide

Best case:
- project ID or exact product name
- date or date range
- timezone
- target metric list
- output format preference

If unknown:
- provide any alias or screenshot text that identifies the project

## What Codex Should Do

- confirm target scope
- reuse dossier if it exists
- initialize only when required
- run SQL/SPL as the main data path
- use Playwright CLI as the default browser executor
- use Browser Use CLI only as fallback browser-side acceleration
- produce formatted output plus a short analysis line
- write back newly confirmed project knowledge

## Common Mistakes To Avoid

- using another project's metric definition
- defaulting to example IDs
- trusting dashboards before SQL logic is confirmed
- reinitializing the whole project every time
- ignoring timing breakdowns when the process is slow
