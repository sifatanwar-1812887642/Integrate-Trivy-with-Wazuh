# Integrate Trivy with Wazuh

A practical vulnerability-monitoring lab demonstrating how **Aqua Security Trivy** findings from a Windows endpoint can be collected by a **Wazuh Agent**, forwarded to a Wazuh Manager, decoded as JSON, and raised as severity-based alerts.

## Lab environment

| Component | Details |
|---|---|
| Wazuh Manager | Ubuntu, `10.0.2.6` |
| Scanned endpoint | Windows 11, `10.0.2.15` |
| Network | VirtualBox NAT Network |
| Trivy | `0.76.1` |
| Wazuh Agent | Windows service: `WazuhSvc` |
| Scan target | `C:\\ClickFixAgent` |
| Trivy JSON report | `C:\\trivy-report.json` |

## Architecture

```text
Windows 11 endpoint (10.0.2.15)
  Trivy filesystem/dependency scan
          |
          v
  JSON vulnerability report
          |
          v
  JSONL event file monitored by Wazuh Agent
          |
          | TCP 1514
          v
Ubuntu Wazuh Manager (10.0.2.6)
  JSON decoder -> custom rules (100550-100553)
          |
          v
  Wazuh alerts / Threat Hunting dashboard
```

## Verified result

The lab successfully forwarded and generated a Wazuh alert for the selected **HIGH** finding:

| Field | Verified value |
|---|---|
| CVE | `CVE-2026-58280` |
| Severity | HIGH |
| Package | `Microsoft.NETCore.App.Runtime.win-x64` |
| Installed version | `8.0.29` |
| Wazuh agent | `002` (`10.0.2.15`) |
| Custom rule | `100552` |
| Alert level | `10` |
| Decoder | `json` |

In the validated event, Wazuh read the selected record from `C:\\ProgramData\\Trivy\\vulnerabilities-replay.jsonl`. The replay file was used during validation while the agent service was stopped, then the service was restarted.

## Important scope and limitations

- This repository documents **Trivy-to-Wazuh integration only**.
- The evidence confirms forwarding and alert generation for the selected CVE record.
- It does **not** prove an unattended, continuous scan-to-alert automation pipeline.
- One real vulnerability record (`CVE-2026-58280`) was forwarded and verified.
- The CRITICAL rule was tested with a synthetic event; it is not counted as a real vulnerability result.
- OpenEDR and the ELK Stack were not installed or integrated as part of this project.

## Repository contents

- `docs/technical-report.md` — detailed implementation, validation, results, and limitations.
- `configs/windows/wazuh-agent-localfile.xml` — Wazuh Agent log collection snippets.
- `configs/wazuh/local_rules.xml` — custom severity-based Wazuh rules.
- `scripts/windows/scan-and-export.ps1` — reference PowerShell workflow for scanning and preparing a JSONL event.

## Quick verification

On Windows PowerShell:

```powershell
trivy --version
trivy fs --scanners vuln --format json --output C:\\trivy-report.json C:\\ClickFixAgent
Test-Path C:\\trivy-report.json
Test-NetConnection 10.0.2.6 -Port 1514
Get-Service WazuhSvc
```

On the Ubuntu Wazuh Manager:

```bash
sudo systemctl status wazuh-manager
sudo grep -F '"vulnerability_id":"CVE-2026-58280"' /var/ossec/logs/alerts/alerts.json | tail
```

In the Wazuh dashboard, search for:

```text
rule.id: 100552
```

## Documentation

See [the technical report](docs/technical-report.md) for the detailed steps and evidence interpretation.

## Disclaimer

This is an educational lab. Run scans only against systems and files you own or are authorized to assess.
