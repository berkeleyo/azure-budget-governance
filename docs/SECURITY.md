# SECURITY

- No secrets, IPs, tenant IDs, or customer names stored in repo.
- Webhook URLs, subscription IDs, and emails are parameters or pipeline secrets.
- Principle of least privilege for automation identity.
- Optional: store secrets in Azure Key Vault and reference via DevOps variable groups.
