#!/bin/bash

# Claude Code Configuration Installer
# Repository: https://github.com/Junyong34/AI-PlayBook

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Claude Code 설정 설치 시작...${NC}"
echo ""

# 백업 여부 확인
if [ -d ~/.claude ]; then
    echo -e "${YELLOW}⚠️  기존 ~/.claude 디렉토리가 존재합니다.${NC}"
    read -p "백업 후 덮어쓰시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BACKUP_DIR=~/.claude.backup.$(date +%Y%m%d_%H%M%S)
        echo -e "${BLUE}📦 기존 설정을 ${BACKUP_DIR}로 백업 중...${NC}"
        mv ~/.claude "$BACKUP_DIR"
        echo -e "${GREEN}✅ 백업 완료: $BACKUP_DIR${NC}"
    else
        echo -e "${RED}❌ 설치를 취소합니다.${NC}"
        exit 1
    fi
fi

# 임시 디렉토리에 클론
echo -e "${BLUE}📥 저장소 다운로드 중...${NC}"
TEMP_DIR=$(mktemp -d)
git clone --depth 1 git@github.com:Junyong34/AI-PlayBook.git "$TEMP_DIR" 2>/dev/null || {
    echo -e "${RED}❌ Git clone 실패. SSH 키가 설정되어 있는지 확인하세요.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
}

# ~/.claude 디렉토리 생성
echo -e "${BLUE}📁 디렉토리 구조 생성 중...${NC}"
mkdir -p ~/.claude/agents ~/.claude/commands ~/.claude/rules ~/.claude/hooks ~/.claude/skills

# 파일 복사
echo -e "${BLUE}📋 설정 파일 복사 중...${NC}"

# .claude 디렉토리 내용 복사
if [ -d "$TEMP_DIR/.claude" ]; then
    # CLAUDE.md 복사
    [ -f "$TEMP_DIR/.claude/CLAUDE.md" ] && cp "$TEMP_DIR/.claude/CLAUDE.md" ~/.claude/ && echo "  ✓ CLAUDE.md"

    # settings.json 복사
    [ -f "$TEMP_DIR/.claude/settings.json" ] && cp "$TEMP_DIR/.claude/settings.json" ~/.claude/ && echo "  ✓ settings.json"

    # agents 복사
    if [ -d "$TEMP_DIR/.claude/agents" ] && [ -n "$(ls -A $TEMP_DIR/.claude/agents/*.md 2>/dev/null)" ]; then
        cp "$TEMP_DIR/.claude/agents/"*.md ~/.claude/agents/ 2>/dev/null
        AGENT_COUNT=$(ls -1 ~/.claude/agents/*.md 2>/dev/null | wc -l | tr -d ' ')
        echo "  ✓ agents/ ($AGENT_COUNT개)"
    fi

    # commands 복사
    if [ -d "$TEMP_DIR/.claude/commands" ] && [ -n "$(ls -A $TEMP_DIR/.claude/commands/*.md 2>/dev/null)" ]; then
        cp "$TEMP_DIR/.claude/commands/"*.md ~/.claude/commands/ 2>/dev/null
        CMD_COUNT=$(ls -1 ~/.claude/commands/*.md 2>/dev/null | wc -l | tr -d ' ')
        echo "  ✓ commands/ ($CMD_COUNT개)"
    fi

    # rules 복사
    if [ -d "$TEMP_DIR/.claude/rules" ] && [ -n "$(ls -A $TEMP_DIR/.claude/rules/*.md 2>/dev/null)" ]; then
        cp "$TEMP_DIR/.claude/rules/"*.md ~/.claude/rules/ 2>/dev/null
        RULE_COUNT=$(ls -1 ~/.claude/rules/*.md 2>/dev/null | wc -l | tr -d ' ')
        echo "  ✓ rules/ ($RULE_COUNT개)"
    fi

    # hooks 복사
    if [ -d "$TEMP_DIR/.claude/hooks" ] && [ -n "$(ls -A $TEMP_DIR/.claude/hooks/*.md 2>/dev/null)" ]; then
        cp "$TEMP_DIR/.claude/hooks/"*.md ~/.claude/hooks/ 2>/dev/null
        HOOK_COUNT=$(ls -1 ~/.claude/hooks/*.md 2>/dev/null | wc -l | tr -d ' ')
        echo "  ✓ hooks/ ($HOOK_COUNT개)"
    fi

    # skills 복사
    if [ -d "$TEMP_DIR/.claude/skills" ] && [ -n "$(ls -A $TEMP_DIR/.claude/skills/*.md 2>/dev/null)" ]; then
        cp "$TEMP_DIR/.claude/skills/"*.md ~/.claude/skills/ 2>/dev/null
        SKILL_COUNT=$(ls -1 ~/.claude/skills/*.md 2>/dev/null | wc -l | tr -d ' ')
        echo "  ✓ skills/ ($SKILL_COUNT개)"
    fi
fi

# 정리
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}✅ 설치 완료!${NC}"
echo ""
echo -e "${BLUE}📂 설치 위치: ~/.claude/${NC}"
echo ""
echo -e "${BLUE}📋 설치된 내용:${NC}"
ls -lah ~/.claude/ | grep -v "^total" | grep -v "^\."
echo ""

# commands 목록 표시
if [ -n "$(ls -A ~/.claude/commands/*.md 2>/dev/null)" ]; then
    echo -e "${BLUE}🎯 사용 가능한 커맨드:${NC}"
    for cmd in ~/.claude/commands/*.md; do
        CMD_NAME=$(basename "$cmd" .md)
        echo "   /$CMD_NAME"
    done
    echo ""
fi

echo -e "${YELLOW}💡 Claude Code 실행:${NC}"
echo "   claude"
echo ""
echo -e "${YELLOW}💡 터미널 alias 추가 (선택사항):${NC}"
echo "   echo 'alias c=\"claude\"' >> ~/.zshrc && source ~/.zshrc"
echo ""
