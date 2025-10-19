# Azure Budget Governance at Scale 🚦💸

![Redaction Badge](https://img.shields.io/badge/REDACTED-no%20secrets%2C%20IPs%2C%20or%20tenant%20info-green)

> **Redaction statement:** This repository intentionally contains **no** live secrets, IP addresses, tenant names/IDs, or customer identifiers. Values that would be sensitive in a real environment are replaced with placeholders like `{SUBSCRIPTION_ID}`, `{TEAMS_WEBHOOK_URL}`, and `{RG_NAME}`.

## 👋 Overview

This repo documents and templates a production implementation to **govern Azure spend** across many subscriptions by **automating Budgets, Alerts, and Notifications** with **PowerShell** and **Azure DevOps (YAML)**. It’s designed for enterprise estates (10s–100s of subs) and focuses on **repeatability, guardrails, and zero manual drift**.

### 🎯 Goals
- Create or update **Azure Budgets** per subscription, cost center, or tag.
- Send **threshold alerts** to email/Teams.
- Enforce **tag standards** used for cost reporting.
- Offer a **re-runnable** pipeline + idempotent scripts.
- Provide an **operational runbook**, **cutover checklist**, and **rollback** plan.

## 🧱 Repository structure

```
.
├─ README.md
├─ RUNBOOK.md
├─ .gitignore
├─ docs/
│  ├─ OVERVIEW.md
│  ├─ ARCHITECTURE.md
│  ├─ CUTOVER_CHECKLIST.md
│  ├─ ROLLBACK.md
│  └─ SECURITY.md
└─ scripts/
   ├─ Discover-Subscriptions.ps1
   ├─ Set-Budget.ps1
   ├─ Enforce-Tags.ps1
   ├─ Notify-Teams.ps1
   └─ json/
      └─ budget-template.json
```

## 🗺️ Lifecycle (SDLC/Operations)

1. **Discover** → enumerate subscriptions & required tags.
2. **Plan** → agree budget amounts & thresholds per scope.
3. **Build** → wire DevOps pipeline and parameterise scripts.
4. **Test** → run in pilot subs; verify alerts and RBAC.
5. **Cutover** → apply to all prod subscriptions in waves.
6. **Operate** → monthly review, drift checks, rotation.
7. **Optimise** → tune thresholds & automate recommendations.
8. **Decommission** → archive configs when subs are closed.

## 🧩 High-level flow (Mermaid)

```mermaid
flowchart LR
  A[Azure DevOps Pipeline<br/>(manual/scheduled)] --> B[Discover-Subscriptions.ps1]
  B --> C[Set-Budget.ps1<br/>create/update budgets]
  C --> D[Azure Budget + Action Groups]
  D --> E[Notify-Teams.ps1<br/>webhook/email]
  B --> F[Enforce-Tags.ps1<br/>governance checks]
  F --> G[Compliance Report]
```

## 🚀 Quick start

1. Install prerequisites (Cloud Shell or workstation): `Az.Accounts`, `Az.Billing`, `Az.Resources`.
2. Authenticate: `Connect-AzAccount` (use device code/service connection in CI).
3. Update `scripts/json/budget-template.json` thresholds/labels.
4. Run discovery:
   ```powershell
   ./scripts/Discover-Subscriptions.ps1 -ManagementGroupId "{MG_ID}"
   ```
5. Apply budgets:
   ```powershell
   ./scripts/Set-Budget.ps1 -InputCsv ./output/subscriptions.csv -Amount 5000 -TimeGrain Monthly -Thresholds 50,75,90,100
   ```
6. Wire Teams notifications (optional in CI):
   ```powershell
   ./scripts/Notify-Teams.ps1 -WebhookUrl "{TEAMS_WEBHOOK_URL}" -Title "Budget rollout complete"
   ```

> **Note:** All placeholders must be replaced in your fork. No secret material is tracked here.

## 📜 License & Attribution
MIT. Authored for demonstration from real enterprise work, redacted for public sharing.
