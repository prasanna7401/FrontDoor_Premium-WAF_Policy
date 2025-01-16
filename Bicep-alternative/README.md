# FrontDoor Premium - Web Application Firewall Policy management - Bicep
 Contains ADO Script to perform Custom rule modification in Front Door Web Application Firewall policy using Bicep.

### Introduction

This repository contains Bicep Code deployment to manage AFD WAF Policy Custom Rules. There are two pipelines used for this,
- [Deployment Pipeline](./1_deployment_pipeline.yml) - Runs on demand to manage custom rule configuration related to Allowed IPs. This pipeline shows a detailed change with information about the IP being added, along with its description using the CSV file.
- [Integrity Check Pipeline](./2_integrity_check_pipeline.yml) - Runs every 1hr to overwrite any unapproved changes made directly in the Azure Portal, with the configuration defined in this repository.

---

### Managed Resources

1. WAF Policy:
    - Production: `prodpolicy`
    - Dev/Test: `devtestpolicy`

2. Custom Rules:
    - Production: [prodpolicy/AllowedIPList](/allowed_ip_csv/originalpolicy.csv)
    - Dev/Test: [devtestpolicy/AllowedIPList](/allowed_ip_csv/devtestpolicy.csv)
