# Prompt: Test Generation

## Goal
Создать комплексные тесты для кода

## Context
Применять, когда:
- Новая функция без тестов
- Нужно увеличить покрытие
- Refactoring требует регрессионных тестов

## Instructions

1. **Анализ функции**
   - Input parameters и типы
   - Expected output
   - Edge cases
   - Возможные исключения

2. **Типы тестов**
   - **Unit tests**: изолированные функции
   - **Integration tests**: взаимодействие компонентов
   - **Property tests**: hypothesis для генерации данных

3. **Структура теста**
   - Arrange: подготовка данных
   - Act: выполнение функции
   - Assert: проверка результата

## Expected Output

```python
import pytest
from hypothesis import given, strategies as st

from mymodule import process_positive_values


class TestProcessPositiveValues:
    """Test suite for process_positive_values."""
    
    def test_empty_input(self):
        """Empty list returns empty list."""
        assert process_positive_values([]) == []
    
    def test_all_positive(self):
        """All positive values are doubled."""
        result = process_positive_values([1, 2, 3])
        assert result == [2, 4, 6]
    
    def test_mixed_values(self):
        """Only positive values are processed."""
        result = process_positive_values([-1, 0, 1, 2])
        assert result == [2, 4]
    
    def test_all_negative(self):
        """All negative values return empty list."""
        result = process_positive_values([-1, -2, -3])
        assert result == []
    
    @pytest.mark.parametrize("input_val,expected", [
        ([1], [2]),
        ([1.5], [3.0]),
        ([100], [200]),
    ])
    def test_parametrized(self, input_val, expected):
        """Parametrized test cases."""
        assert process_positive_values(input_val) == expected
    
    @given(st.lists(st.floats(min_value=0.1)))
    def test_property_all_positive(self, values):
        """Property: output length equals positive input count."""
        result = process_positive_values(values)
        assert len(result) == len(values)
        assert all(r > 0 for r in result)
```

## Test Markers

```python
# pytest.ini
[tool.pytest.ini_options]
markers = [
    "unit: Unit tests",
    "integration: Integration tests",
    "slow: Slow tests",
]

# Usage
@pytest.mark.unit
def test_fast():
    ...

@pytest.mark.integration
@pytest.mark.slow
def test_database():
    ...
```

## Fixtures

```python
@pytest.fixture
def sample_data():
    """Sample data for tests."""
    return [1, 2, 3, 4, 5]

@pytest.fixture
def mock_api(mocker):
    """Mock external API."""
    return mocker.patch("mymodule.api_call")

def test_with_fixtures(sample_data, mock_api):
    mock_api.return_value = {"status": "ok"}
    result = my_function(sample_data)
    assert result is not None
```