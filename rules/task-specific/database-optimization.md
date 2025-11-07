# Task-Specific Rule: Database Optimization

## Context
Оптимизация SQL запросов, схем и indexes (особенно для ClickHouse).

## Workflow

### 1. Анализ текущей производительности

```sql
-- ClickHouse: анализ query
EXPLAIN
SELECT ...
FROM table
WHERE conditions
SETTINGS log_queries = 1;

-- Проверить system.query_log
SELECT
    query,
    query_duration_ms,
    read_rows,
    read_bytes
FROM system.query_log
WHERE query LIKE '%your_table%'
ORDER BY query_duration_ms DESC
LIMIT 10;
```

### 2. Оптимизация запросов

#### ClickHouse-specific

```sql
-- Плохо: SELECT *
SELECT * FROM large_table;

-- Хорошо: только нужные колонки
SELECT id, name, created_at
FROM large_table
WHERE date >= today() - 7;

-- Плохо: нет PREWHERE
SELECT count()
FROM events
WHERE user_id = 123 AND event_type = 'click';

-- Хорошо: PREWHERE для фильтрации
SELECT count()
FROM events
PREWHERE user_id = 123
WHERE event_type = 'click';
```

#### Indexes

```sql
-- ClickHouse: проверить primary key
SHOW CREATE TABLE my_table;

-- Добавить skipping index
ALTER TABLE my_table
ADD INDEX idx_user_id user_id TYPE minmax GRANULARITY 4;

-- Материализовать index
ALTER TABLE my_table MATERIALIZE INDEX idx_user_id;
```

### 3. Оптимизация схемы

```sql
-- ClickHouse: выбор engine
CREATE TABLE events (
    event_id UInt64,
    user_id UInt32,
    event_type LowCardinality(String),  -- Для enum-подобных
    timestamp DateTime,
    data String
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(timestamp)        -- Месячные партиции
ORDER BY (user_id, timestamp)           -- Primary key
SETTINGS index_granularity = 8192;
```

### 4. Бенчмаркинг

```python
import time
import asyncio
from typing import Callable

async def benchmark_query(
    query: str,
    execute_func: Callable,
    iterations: int = 10,
) -> dict:
    """Benchmark SQL query."""
    times = []
    
    for _ in range(iterations):
        start = time.perf_counter()
        await execute_func(query)
        elapsed = time.perf_counter() - start
        times.append(elapsed)
    
    return {
        "min": min(times),
        "max": max(times),
        "avg": sum(times) / len(times),
        "p50": sorted(times)[len(times) // 2],
    }
```

## Best Practices

### ClickHouse

1. **Partitioning**
   - По времени: `PARTITION BY toYYYYMM(date)`
   - Не более 1000 партиций

2. **Primary Key**
   - Первые колонки: низкая cardinality
   - Последние: высокая cardinality

3. **LowCardinality**
   - Для String с <10K unique values
   - Экономия памяти 30-50%

4. **Materialized Views**
   ```sql
   CREATE MATERIALIZED VIEW daily_stats
   ENGINE = SummingMergeTree()
   ORDER BY (date, user_id)
   AS SELECT
       toDate(timestamp) as date,
       user_id,
       count() as events_count
   FROM events
   GROUP BY date, user_id;
   ```

## Monitoring

```sql
-- Размер таблиц
SELECT
    table,
    formatReadableSize(sum(bytes)) as size,
    sum(rows) as rows
FROM system.parts
WHERE active
GROUP BY table
ORDER BY sum(bytes) DESC;

-- Медленные запросы
SELECT
    query,
    query_duration_ms / 1000 as duration_sec
FROM system.query_log
WHERE query_duration_ms > 1000
ORDER BY query_duration_ms DESC
LIMIT 20;
```