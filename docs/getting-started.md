# Getting Started with Cline DevOps

## Установка

### Prerequisites

1. **VSCode + Cline extension**
   ```bash
   code --install-extension saoudrizwan.claude-dev
   ```

2. **Python 3.12+ и uv**
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

3. **Git**
   ```bash
   git --version
   ```

### Клонирование репозитория

```bash
git clone https://github.com/pv-udpv/cline-devops.git
cd cline-devops
```

## Quick Start

### 1. Setup нового проекта

```bash
./workflows/scripts/setup-project.sh my-project /path/to/project
```

Это создаст:
- `.copilot-instructions.md` с глобальными правилами
- `.cline/project-rules.md` для проект-специфичных настроек
- Virtual environment с uv
- Git hooks

### 2. Настройка VSCode

1. Копировать рекомендуемые настройки:
   ```bash
   cp integrations/vscode/settings.json .vscode/
   cp integrations/vscode/extensions.json .vscode/
   ```

2. Установить рекомендуемые extensions

3. Настроить MCP servers в Cline settings

### 3. Первый запрос к Cline

Открыть Cline в VSCode и написать:

```
Проверь структуру проекта и создай базовый pyproject.toml
```

Cline использует `.copilot-instructions.md` автоматически.

## Основные возможности

### Использование prompt library

```bash
# Просмотр доступных промптов
ls prompts/library/

# Использование в Cline
"Сделай refactoring функции X по prompts/library/refactoring.md"
```

### Sync rules в проект

```bash
python workflows/scripts/sync-rules.py \
  --source rules/global \
  --target /path/to/project \
  --dry-run=false
```

### Работа с MCP servers

См. [mcp-servers/README.md](../mcp-servers/README.md)

## Следующие шаги

- [Архитектура](architecture.md)
- [Contributing](../CONTRIBUTING.md)
- [Troubleshooting](troubleshooting.md)