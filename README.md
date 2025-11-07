# 🤖 Cline DevOps

> Централизованный репозиторий для Cline AI assistant: rules, workflows, MCP servers, prompt patterns и исследования

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Cline Compatible](https://img.shields.io/badge/Cline-Compatible-blue.svg)](https://cline.bot)

## 📋 Содержание

- [О проекте](#о-проекте)
- [Архитектура](#архитектура)
- [Быстрый старт](#быстрый-старт)
- [Структура](#структура)
- [Использование](#использование)
- [MCP Servers](#mcp-servers)
- [Contributing](#contributing)

## 🎯 О проекте

**Cline DevOps** — это centralized hub для оптимизации работы с [Cline AI coding assistant](https://cline.bot). Репозиторий содержит:

- 📝 **Rules & Instructions** — глобальные и проект-специфичные правила разработки
- 🔄 **Workflows** — автоматизация и git hooks
- 🔌 **MCP Servers** — конфигурации и кастомные Model Context Protocol серверы
- 💡 **Prompt Library** — коллекция проверенных prompt patterns
- 🔬 **Research** — бенчмарки, эксперименты, анализ производительности

## 🏗️ Архитектура

```
cline-devops/
├── rules/              # Правила разработки для Cline
│   ├── global/         # Универсальные стандарты
│   ├── project-specific/
│   └── task-specific/
├── mcp-servers/        # MCP интеграции
│   ├── configs/        # Конфигурации
│   └── custom/         # Кастомные серверы
├── workflows/          # Автоматизация
│   ├── hooks/          # Git hooks
│   └── scripts/        # Utility scripts
├── prompts/            # Библиотека промптов
│   ├── library/
│   ├── chains/
│   └── meta/
└── research/           # Исследования и бенчмарки
```

## 🚀 Быстрый старт

### Prerequisites

- VSCode + [Cline extension](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev)
- Python 3.12+ с [uv](https://github.com/astral-sh/uv)
- Git

### Setup нового проекта

```bash
# 1. Клонировать репозиторий
git clone https://github.com/pv-udpv/cline-devops.git
cd cline-devops

# 2. Запустить setup script для вашего проекта
./workflows/scripts/setup-project.sh my-project /path/to/project

# 3. Настроить MCP servers в VSCode
cp mcp-servers/configs/example-config.json ~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
```

### Manual setup

1. Скопировать `.copilot-instructions.md` из `rules/global/` в корень проекта
2. Настроить project-specific rules в `.cline/project-rules.md`
3. Установить git hooks: `cp workflows/hooks/* .git/hooks/ && chmod +x .git/hooks/*`

## 📁 Структура

### Rules

- **global/** — универсальные стандарты (Python, testing, CLI tools)
- **project-specific/** — правила для конкретных проектов
- **task-specific/** — guidelines для типовых задач (refactoring, debugging, API development)

### MCP Servers

- **configs/** — конфигурации для GitHub, Linear, ClickHouse MCP
- **custom/** — собственные MCP серверы для специфичных интеграций
- **registry.json** — реестр всех доступных MCP серверов

### Workflows

- **hooks/** — pre-commit, pre-push валидация
- **scripts/** — автоматизация (sync rules, deploy MCP, validate context)
- **templates/** — шаблоны задач и checklists

### Prompts

- **library/** — базовые паттерны (refactoring, testing, documentation)
- **chains/** — multi-step prompt sequences
- **meta/** — как писать эффективные промпты для Cline

### Research

- **benchmarks/** — сравнения моделей, анализ стоимости
- **experiments/** — тестирование новых подходов
- **notes/** — daily findings и insights

## 🔧 Использование

### Применение rules в проекте

```bash
# Sync global rules
python workflows/scripts/sync-rules.py \
  --source rules/global \
  --target /path/to/project

# Sync specific task rules
python workflows/scripts/sync-rules.py \
  --source rules/task-specific/api-development.md \
  --target /path/to/project/.cline/
```

### Использование prompt library

```bash
# Просмотр доступных промптов
ls prompts/library/

# Копировать промпт в проект
cp prompts/library/refactoring.md /path/to/project/.cline/prompts/
```

### GitHub Actions интеграция

Репозиторий включает workflows для:
- Валидации rules перед коммитом
- Автоматической синхронизации в проекты
- Тестирования MCP servers

## 🔌 MCP Servers

### Поддерживаемые интеграции

| MCP Server | Status | Use Cases |
|------------|--------|----------|
| GitHub | ✅ Active | Repo management, PRs, issues |
| Linear | ✅ Active | Task tracking, projects |
| ClickHouse | 🚧 Development | Database queries, optimization |
| IPTVPortal | 🚧 Development | API wrapper operations |

### Добавление custom MCP server

```bash
cd mcp-servers/custom
mkdir my-mcp && cd my-mcp
uv init --lib
# Разработка сервера...
uv build

# Регистрация в registry.json
vim ../registry.json
```

## 📊 Best Practices

### Context Management

- Max context: 200K tokens (Claude Sonnet)
- Использовать file summaries для больших кодовых баз
- Приоритет — targeted file reads

### Prompt Optimization

- Code-first: приоритет рабочему коду
- Actionable: конкретные команды и примеры
- Модульность: расширяемая архитектура

### Workflow

1. **Analysis** → понять задачу
2. **Planning** → разбить на шаги
3. **Execution** → реализация с тестами
4. **Validation** → проверка результата

## 🤝 Contributing

Контрибьюции приветствуются! См. [CONTRIBUTING.md](CONTRIBUTING.md)

### Workflow

```bash
# 1. Fork & clone
git checkout -b feature/new-rule

# 2. Добавить изменения
nano rules/task-specific/my-task.md

# 3. Commit (Conventional Commits)
git commit -m "feat(rules): add new task guideline"

# 4. Push & PR
git push origin feature/new-rule
```

## 📝 License

MIT License - see [LICENSE](LICENSE)

## 🔗 Links

- [Cline Documentation](https://docs.cline.bot)
- [MCP Protocol](https://modelcontextprotocol.io)
- [Perplexity Space: Cline Development Lab](https://perplexity.ai/spaces)

---

**Maintained by** [@pv-udpv](https://github.com/pv-udpv)