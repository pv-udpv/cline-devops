# Prompt: Code Refactoring

## Goal
Рефакторинг кода с сохранением функциональности и улучшением качества

## Context
Применять, когда:
- Код работает, но сложен для понимания
- Есть дублирование логики
- Нужно улучшить производительность
- Требуется привести к стандартам

## Instructions

1. **Анализ текущего кода**
   - Понять предназначение функции/модуля
   - Определить зависимости
   - Найти существующие тесты

2. **План рефакторинга**
   - Вынести magic numbers в константы
   - Разбить длинные функции (более 50 строк)
   - Улучшить именование
   - Добавить type hints
   - Удалить мёртвый код

3. **Реализация**
   - Начать с малых изменений
   - Запускать тесты после каждого шага
   - Сохранять коммиты часто

4. **Валидация**
   - Все тесты проходят
   - `mypy` без ошибок
   - `ruff check` без ошибок
   - Производительность не ухудшилась

## Expected Output

```python
# Before
def process(data):
    result = []
    for item in data:
        if item > 0:
            result.append(item * 2)
    return result

# After
from typing import Sequence

MULTIPLIER = 2

def process_positive_values(
    data: Sequence[int | float],
) -> list[int | float]:
    """Process positive values by multiplying them.
    
    Args:
        data: Sequence of numeric values
    
    Returns:
        List of doubled positive values
    """
    return [
        item * MULTIPLIER
        for item in data
        if item > 0
    ]
```

## Common Patterns

### Extract Function
```python
# Длинная функция → несколько коротких

def _validate_input(data: dict) -> None:
    ...

def _transform_data(data: dict) -> ProcessedData:
    ...

def _save_result(result: ProcessedData) -> None:
    ...

def main_function(data: dict) -> None:
    _validate_input(data)
    processed = _transform_data(data)
    _save_result(processed)
```

### Replace Magic Number
```python
# Плохо
if age > 18:
    ...

# Хорошо
LEGAL_AGE = 18
if age > LEGAL_AGE:
    ...
```

### Simplify Conditionals
```python
# Плохо
if is_valid:
    return True
else:
    return False

# Хорошо
return is_valid
```