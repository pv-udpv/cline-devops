# Contributing to Cline DevOps

## Как внести вклад

### 1. Fork & Clone

```bash
git clone https://github.com/YOUR_USERNAME/cline-devops.git
cd cline-devops
```

### 2. Создать ветку

```bash
git checkout -b feature/new-feature
# или
git checkout -b fix/bug-fix
```

### 3. Внести изменения

- Добавить/изменить правила в `rules/`
- Добавить prompt patterns в `prompts/`
- Создать MCP server в `mcp-servers/custom/`

### 4. Commit

Использовать [Conventional Commits](https://www.conventionalcommits.org/):

```bash
git commit -m "feat(rules): add new Python standard"
git commit -m "fix(mcp): correct ClickHouse connection"
git commit -m "docs: update README with examples"
```

**Типы коммитов:**
- `feat`: новая функциональность
- `fix`: исправление багов
- `docs`: документация
- `refactor`: рефакторинг
- `test`: тесты
- `chore`: рутинные задачи

### 5. Push & Pull Request

```bash
git push origin feature/new-feature
```

Создать PR на GitHub с описанием изменений.

## Стандарты кода

### Python

- Python 3.12+
- Package manager: `uv`
- Форматирование: `ruff format`
- Линтинг: `ruff check`
- Type checking: `mypy`

### Markdown

- Использовать heading hierarchy (H1 → H2 → H3)
- Code blocks с указанием языка
- Ссылки в формате `[text](url)`

### Структура rules

```markdown
# Rule Name

## Context
Когда применять это правило

## Guidelines
- Конкретные инструкции
- Примеры кода

## Examples
```

### Структура prompts

```markdown
# Prompt: Task Name

## Goal
Что должен сделать Cline

## Context
Дополнительная информация

## Instructions
1. Шаг 1
2. Шаг 2

## Expected Output
Формат результата
```

## Review Process

1. Automated checks (GitHub Actions)
2. Manual review by maintainers
3. Testing в реальном проекте
4. Merge to main

## Вопросы?

Открыть [issue](https://github.com/pv-udpv/cline-devops/issues) или связаться с [@pv-udpv](https://github.com/pv-udpv)