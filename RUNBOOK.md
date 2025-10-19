# RUNBOOK — Azure Budget Governance

## Purpose
Operate and support the budget governance automation safely in production.

## Preconditions
- Operator has Reader on management group and Contributor on target subs (or delegated Budget write).
- Service principal for CI has least-privilege roles: `Reader` + `Cost Management Contributor` + scoped `Tag Contributor` if using tag fix-ups.

## Standard Operation
1. **Initiate**: Trigger the pipeline (manual or scheduled monthly).
2. **Discovery**: Review `output/subscriptions.csv` and compliance report artefacts.
3. **Change Window**: Ensure standard change is logged if rolling out beyond pilot.
4. **Execution**: Run Set-Budget with agreed parameters or pipeline variables.
5. **Verification**:
   - Budgets present in portal (`Cost Management > Budgets`).
   - Alerts created and action groups wired.
   - Test overage alert using a temp 1% threshold in a test sub.
6. **Notification**: Confirm Teams/email notifications fire and are formatted.
7. **Handover**: Record run in ops notes and attach artefacts.

## Smoke Tests
- `Get-AzConsumptionBudget -Scope /subscriptions/<id>` returns the new or updated budget.
- Teams card posted to the channel within 60s of completion.

## Routine Maintenance
- Rotate webhook/creds quarterly.
- Review thresholds quarterly with Finance.
- Update tag allowlist when new cost centers appear.

## Known Issues & Remedies
- **403 on budgets**: Assign `Cost Management Contributor` at subscription scope.
- **Policy denies tag writes**: Exclude the automation principal from deny effect or use `modify` policy with remediation.
- **Teams webhook blocked**: Route via internal notifier or email action group.

## Rollback Summary
See `docs/ROLLBACK.md` for scripted rollback to prior state.
