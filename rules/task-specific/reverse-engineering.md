# Task-Specific Rule: Reverse Engineering

## Context
Применять при исследовании недокументированных API, протоколов и форматов данных.

## Workflow

### 1. Сбор информации

```python
# Использовать httpx для анализа requests
import httpx
import json
from pathlib import Path

# Логировать все requests/responses
async def log_request(request: httpx.Request) -> None:
    Path("logs").mkdir(exist_ok=True)
    with open(f"logs/request_{request.method}_{hash(request.url)}.json", "w") as f:
        json.dump({
            "method": request.method,
            "url": str(request.url),
            "headers": dict(request.headers),
            "content": request.content.decode() if request.content else None,
        }, f, indent=2)
```

### 2. Анализ шаблонов

- **URL patterns**: Идентифицировать структуру endpoints
- **Headers**: Аутентификация, rate limiting, versioning
- **Payload format**: JSON, form-data, protobuf?
- **Response structure**: Консистентные поля, error codes

### 3. Создание models

```python
from pydantic import BaseModel, Field
from typing import Any

# Начать с flexible models
class BaseResponse(BaseModel):
    model_config = {"extra": "allow"}  # Разрешить неизвестные поля
    
    status: str | None = None
    data: dict[str, Any] | None = None
    error: str | None = None

# Постепенно уточнять
class UserResponse(BaseModel):
    id: int
    username: str
    email: str | None = None
    # Добавлять поля по мере изучения
```

### 4. Тестирование гипотез

```python
import pytest
from hypothesis import given, strategies as st

@pytest.mark.parametrize("endpoint", [
    "/api/v1/users",
    "/api/v2/users",
])
async def test_endpoint_versions(endpoint: str):
    """Test if different API versions work."""
    response = await client.get(endpoint)
    assert response.status_code in [200, 404]

@given(user_id=st.integers(min_value=1, max_value=1000))
async def test_user_ids(user_id: int):
    """Test range of valid user IDs."""
    response = await client.get(f"/users/{user_id}")
    assert response.status_code in [200, 404]
```

## Tools

### Рекомендуемые библиотеки

```toml
[project.dependencies]
httpx = ">=0.28.0"           # HTTP client
pydantic = ">=2.10.0"        # Data validation
structlog = ">=24.4.0"       # Logging
rich = ">=13.9.0"            # CLI output

[project.optional-dependencies]
dev = [
    "pytest-asyncio",
    "hypothesis",
    "respx",                 # HTTP mocking
]
```

### Browser DevTools

1. Network tab: анализ requests
2. Copy as cURL → конвертировать в Python
3. Preserve log: сохранять при переходах

## Best Practices

1. **Начинать с public endpoints**
   - Проще тестировать
   - Меньше рисков блокировки

2. **Respect rate limits**
   ```python
   import asyncio
   
   async def with_rate_limit(func, delay: float = 1.0):
       await func()
       await asyncio.sleep(delay)
   ```

3. **Документировать находки**
   - Создавать `RESEARCH.md` с наблюдениями
   - Сохранять example responses

4. **Этичность**
   - Проверять Terms of Service
   - Не перегружать серверы
   - Не публиковать конфиденциальные данные