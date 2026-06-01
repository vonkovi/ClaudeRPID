# Data Model (version1)

The authoritative data model: every entity, its fields, and the invariants on those fields.
This is the contract between components and between phases of work.

> **When this doc and the code disagree, this doc wins — fix the code.**
>
> Rename this file to `CLASS_MODEL.md`, `SCHEMA.md`, or `TYPES.md` if that fits your domain
> better. Keep one authoritative data-model doc, whatever it is called.

---

## Entities

### {{EntityName}}

{{One-sentence description of what this entity represents and who owns it.}}

| Field | Type | Description | Invariant |
|-------|------|-------------|-----------|
| `{{field}}` | `{{type}}` | {{what it holds}} | {{constraint, or "—"}} |

**Relationships:** {{how this entity references others — by id, by embedding, etc.}}

---

### {{EntityName 2}}

{{...}}

| Field | Type | Description | Invariant |
|-------|------|-------------|-----------|
| `{{field}}` | `{{type}}` | {{...}} | {{...}} |

---

## Enums / Constants

| Name | Values | Used by |
|------|--------|---------|
| `{{EnumName}}` | {{A, B, C}} | {{entity/field}} |

---

## Cross-Entity Invariants

Constraints that span more than one entity.

- {{e.g. "every X.owner_id must reference an existing Y"}}
