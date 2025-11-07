# Prompt: API Wrapper Development

## Goal
Создать type-safe Python wrapper для REST API

## Context
Применять для:
- Reverse engineering недокументированных API
- Создания SDK для сторонних сервисов
- Автоматизации рутинных задач

## Instructions

1. **Архитектура**
   ```
   api_wrapper/
   ├── __init__.py
   ├── client.py         # Main client
   ├── models.py         # Pydantic models
   ├── endpoints/        # Endpoint groups
   │   ├── __init__.py
   │   ├── users.py
   │   └── content.py
   ├── exceptions.py     # Custom exceptions
   └── utils.py          # Helpers
   ```

2. **Ключевые компоненты**
   - Pydantic models для request/response
   - httpx.AsyncClient для async requests
   - Retry logic с exponential backoff
   - Rate limiting
   - Custom exceptions

3. **Имплементация**
   - Начать с base client
   - Добавить authentication
   - Создать endpoint groups
   - Добавить error handling

## Expected Output

```python
# models.py
from pydantic import BaseModel, Field

class User(BaseModel):
    id: int
    username: str
    email: str | None = None
    created_at: str = Field(alias="createdAt")
    
    model_config = {"populate_by_name": True}

# client.py
import httpx
from typing import Any

class APIClient:
    def __init__(
        self,
        base_url: str,
        api_key: str | None = None,
        timeout: float = 30.0,
    ):
        self.base_url = base_url.rstrip("/")
        self._client = httpx.AsyncClient(
            timeout=timeout,
            headers=self._build_headers(api_key),
        )
    
    def _build_headers(self, api_key: str | None) -> dict[str, str]:
        headers = {"User-Agent": "MyWrapper/1.0"}
        if api_key:
            headers["Authorization"] = f"Bearer {api_key}"
        return headers
    
    async def _request(
        self,
        method: str,
        endpoint: str,
        **kwargs: Any,
    ) -> dict[str, Any]:
        url = f"{self.base_url}/{endpoint.lstrip('/')}"
        response = await self._client.request(method, url, **kwargs)
        response.raise_for_status()
        return response.json()
    
    async def close(self) -> None:
        await self._client.aclose()

# endpoints/users.py
from ..client import APIClient
from ..models import User

class UsersEndpoint:
    def __init__(self, client: APIClient):
        self._client = client
    
    async def get(self, user_id: int) -> User:
        data = await self._client._request("GET", f"/users/{user_id}")
        return User.model_validate(data)
    
    async def list(self, limit: int = 10) -> list[User]:
        data = await self._client._request(
            "GET",
            "/users",
            params={"limit": limit},
        )
        return [User.model_validate(u) for u in data["users"]]
```

## Best Practices

- Всегда валидировать ответы через Pydantic
- Использовать async/await для I/O
- Добавлять retry logic для нестабильных API
- Логировать все requests с structlog
- Писать integration тесты с mock responses