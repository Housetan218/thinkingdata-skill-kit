#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${SCRIPT_DIR}"
TARGET_BASE="${HOME}/.agents/skills"
if [[ "${1:-}" == "--codex-home" ]]; then
  TARGET_BASE="${HOME}/.codex/skills"
elif [[ ! -d "${HOME}/.agents/skills" && -d "${HOME}/.codex/skills" ]]; then
  TARGET_BASE="${HOME}/.codex/skills"
fi
TARGET_DIR="${TARGET_BASE}/thinkingdata-analysis-entry"

if [[ ! -f "${SRC_DIR}/SKILL.md" ]]; then
  echo "未找到 SKILL.md，请确认安装包结构完整。"
  exit 1
fi

mkdir -p "${TARGET_DIR}"
cp "${SRC_DIR}/SKILL.md" "${TARGET_DIR}/SKILL.md"
mkdir -p "${TARGET_DIR}/scripts" "${TARGET_DIR}/runbooks"
cp -R "${SRC_DIR}/scripts/." "${TARGET_DIR}/scripts/"
cp -R "${SRC_DIR}/runbooks/." "${TARGET_DIR}/runbooks/"

echo
echo "ThinkingData skill 安装完成。"
echo "安装位置：${TARGET_DIR}/"
echo
echo "下一步："
echo "1. 重新打开 Codex"
echo "2. 输入：请使用 thinkingdata-analysis-entry skill，帮我开始数数后台分析任务。"
echo
echo "提示："
echo "- 默认优先安装到 ~/.agents/skills/"
echo "- 如果你的环境使用 ~/.codex/skills/，请执行：bash install.sh --codex-home"
