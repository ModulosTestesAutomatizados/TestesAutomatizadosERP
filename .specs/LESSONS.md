# LESSONS - auto-maintained by scripts/lessons.py

> Machine-owned. Do NOT hand-edit. Changes are overwritten on the next `lessons.py` write.
> Canonical state lives in `.specs/lessons.json`. Edit lessons only via the script.
> promote_threshold=2 distinct features · window_days=45 · quarantine_threshold=2

## Confirmed (load these at Specify/Design)

Corroborated across multiple features. Safe to apply as guidance.

_none_

## Candidates (under observation - do NOT load as guidance yet)

Seen once or not yet corroborated. Tracked, not trusted.

### L-001 - Mascare strings e comentários Pascal em uma única passagem antes de extrair cláusulas uses para o inventário AST.
- signal: `ac_gap` · recurrence: 1 feature(s) · scope: `docs/MAPEAMENTO_AST_USES_UNITS` · harmful: 0
- features: portal-navegacao-sincronizacao
- evidence: validation.md:12; PORTAL-28; Documentacoes/tools/portal-iteration/check.mjs:12 (docs/MAPEAMENTO_AST_USES_UNITS)
- last seen: 2026-10-14T18:29:02Z

### L-002 - Normalize strings dos metadados antes de serializar JSON para hashes que consideram CRLF e LF equivalentes.
- signal: `ac_gap` · recurrence: 1 feature(s) · scope: `Documentacoes/config` · harmful: 0
- features: conhecimento-agentes
- evidence: KNOW-03 (Documentacoes/config)
- last seen: 2026-10-19T10:26:55Z

## Quarantined (failed when applied - ignore)

A confirmed lesson that recurred alongside failure. Kept for the maintainer to review.

_none_
