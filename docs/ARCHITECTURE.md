# ARCHITECTURE

- **Inputs**: Management group or subscription list, budget amounts and thresholds, optional Teams webhook.
- **Processing**: PowerShell scripts using `Az` modules; idempotent operations (create-or-update).
- **Outputs**: Budgets with action groups, notifications, and compliance reports.
- **Security**: No secrets committed; use pipeline variables/Key Vault.

## Roles
- CI service principal: `Reader`, `Cost Management Contributor`.
- Human operator: `Reader` + Change approver.

## Data Flow
1. Enumerate subscriptions (filter by tag or state).
2. For each subscription, ensure budget exists with configured thresholds.
3. Wire alert action (email/Teams) via action group or webhook.
