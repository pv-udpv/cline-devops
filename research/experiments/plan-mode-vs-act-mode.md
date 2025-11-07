# Experiment: Plan Mode vs Act Mode

## Hypothesis

Plan Mode должен уменьшить количество ошибок и iterations для сложных задач.

## Methodology

### Test Tasks

1. **Simple**: Создать CRUD API endpoint
2. **Medium**: Refactor legacy code module
3. **Complex**: Reverse engineer и создать API wrapper

### Metrics

- Iterations until completion
- Total tokens used
- Time to completion
- Code quality (manual review)
- Test coverage

## Results

| Task | Mode | Iterations | Tokens | Time (min) | Quality | Coverage |
|------|------|-----------|--------|-----------|---------|----------|
| Simple | Act | 2 | 5K | 3 | 8/10 | 85% |
| Simple | Plan | 3 | 7K | 5 | 9/10 | 90% |
| Medium | Act | 5 | 25K | 15 | 6/10 | 70% |
| Medium | Plan | 4 | 20K | 12 | 8/10 | 85% |
| Complex | Act | 8 | 60K | 45 | 5/10 | 60% |
| Complex | Plan | 5 | 45K | 30 | 9/10 | 90% |

## Conclusions

1. **Plan Mode**: лучше для complex tasks
2. **Act Mode**: быстрее для simple tasks
3. **Trade-off**: Plan Mode использует больше токенов на planning, но меньше на fixes

## Recommendations

- **Simple tasks (<50 LOC)**: Act Mode
- **Medium tasks (50-200 LOC)**: Plan Mode с context awareness
- **Complex tasks (>200 LOC)**: Всегда Plan Mode + task breakdown