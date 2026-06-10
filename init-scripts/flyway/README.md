Flyway migrations for the project.

- `V3__add_recaudo_affiliation_columns.sql` : añade `eps_id`, `rol_afiliado`, `categoria_ibc` a `recaudos`.
- `U3__remove_recaudo_affiliation_columns.sql` : rollback manual/undo para eliminar las columnas.

Usage:

If you use Flyway, copy this folder into your configured `flyway.locations` (for example `filesystem:./init-scripts/flyway`) and run the usual Flyway commands:

Example local run:

```bash
# apply migrations
flyway -url=jdbc:postgresql://localhost:5432/nexosalud -user=postgres -password=postgres migrate

# to undo (only supported on Flyway Pro/Enterprise) or run the undo SQL manually:
# flyway undo
psql -h localhost -U postgres -d nexosalud -f init-scripts/flyway/U3__remove_recaudo_affiliation_columns.sql
```

If you don't use Flyway, you can apply `V3__add_recaudo_affiliation_columns.sql` manually with `psql`.
