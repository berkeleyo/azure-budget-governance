# ROLLBACK

## Strategy
Budgets are safe to remove and re-create. If a rollout misconfigures values, execute rollback to restore prior definitions captured in artefacts (or disable alerts temporarily).

## Scripted Rollback
Use `Set-Budget.ps1` with the `-Remove` switch for the affected subscriptions, or apply a captured JSON of previous state.
