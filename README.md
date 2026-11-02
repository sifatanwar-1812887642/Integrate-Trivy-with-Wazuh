# Integrate Trivy with Wazuh

A practical lab demonstrating Trivy vulnerability findings collected by a Windows Wazuh Agent and forwarded to an Ubuntu Wazuh Manager.

## Lab environment

| Component | Details |
|---|---|
| Wazuh Manager | Ubuntu, `10.0.2.6` |
| Scanned endpoint | Windows 11, `10.0.2.15` |
| Network | VirtualBox NAT Network |
| Trivy | `0.76.1` |
| Wazuh Agent | `WazuhSvc` |
| Scan target | `C:\\ClickFixAgent` |

## Verified result

A selected HIGH finding, `CVE-2026-58280`, was forwarded and generated Wazuh rule `100552` (alert level 10) for agent `002`. The validated event was read from `C:\\ProgramData\\Trivy\\vulnerabilities-replay.jsonl`.

## Scope and limitations

- This repository documents Trivy-to-Wazuh integration only.
- The evidence confirms forwarding and alert generation for one selected CVE record.
- It does not prove unattended, continuous scan-to-alert automation.
- The CRITICAL rule test used a synthetic event, not a real vulnerability finding.
- OpenEDR and ELK were not installed or integrated in this project.

## Repository contents

- `docs/technical-report.md` — implementation, validation, results, and limitations.
- `docs/evidence-index.md` — placement guide for the 15 screenshots embedded in the original report. The image binaries are not yet stored in this repository.
- `configs/windows/wazuh-agent-localfile.xml` — Wazuh Agent log collection snippet.
- `configs/wazuh/local_rules.xml` — custom Wazuh rules.
- `scripts/windows/scan-and-export.ps1` — reference PowerShell workflow.

## Verification

On Windows PowerShell: `trivy --version`, `Get-Service WazuhSvc`, and `Test-NetConnection 10.0.2.6 -Port 1514`.

On the manager: `sudo systemctl status wazuh-manager` and search `/var/ossec/logs/alerts/alerts.json` for `CVE-2026-58280`.

See the [technical report](docs/technical-report.md) and [screenshot evidence index](docs/evidence-index.md).

This is an educational lab. Scan only systems you own or are authorized to assess.
