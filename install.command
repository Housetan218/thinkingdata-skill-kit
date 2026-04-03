#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="${SCRIPT_DIR}"
TARGET_BASE="${HOME}/.agents/skills"
if [[ ! -d "${HOME}/.agents/skills" && -d "${HOME}/.codex/skills" ]]; then
  TARGET_BASE="${HOME}/.codex/skills"
fi
TARGET_DIR="${TARGET_BASE}/thinkingdata-analysis-entry"

if [[ ! -f "${SRC_DIR}/SKILL.md" ]]; then
  osascript -e 'display dialog "未找到 SKILL.md，请确认安装包结构完整。" buttons {"好的"} default button "好的"'
  exit 1
fi

mkdir -p "${TARGET_DIR}"
cp "${SRC_DIR}/SKILL.md" "${TARGET_DIR}/SKILL.md"
mkdir -p "${TARGET_DIR}/scripts" "${TARGET_DIR}/runbooks"
cp -R "${SRC_DIR}/scripts/." "${TARGET_DIR}/scripts/"
cp -R "${SRC_DIR}/runbooks/." "${TARGET_DIR}/runbooks/"

osascript -e 'display dialog "ThinkingData skill 安装完成。\n\n安装位置：'"${TARGET_DIR}"'\n\n下一步：\n1. 重新打开 Codex\n2. 输入：请使用 thinkingdata-analysis-entry skill，帮我开始数数后台分析任务。" buttons {"好的"} default button "好的"'
