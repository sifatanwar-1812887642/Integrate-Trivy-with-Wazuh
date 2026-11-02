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

## Evidence screenshots

The screenshots below are taken from the project report. To display them directly in this README, upload each image to GitHub (for example, by dragging it into a GitHub Issue draft) and replace the corresponding `PASTE_IMAGE_URL_...` placeholder with the generated image URL. The image files are not yet hosted in this repository, so these placeholders must be replaced before the images will render.

### 1. Trivy installation and setup

| Evidence | Screenshot |
|---|---|
| WinGet package search | `PASTE_IMAGE_URL_FIGURE_02` |
| Trivy installation | `PASTE_IMAGE_URL_FIGURE_03` |
| Trivy version verification | `PASTE_IMAGE_URL_FIGURE_04` |
| Vulnerability database download | `PASTE_IMAGE_URL_FIGURE_05` |

### 2. Vulnerability scanning and findings

| Evidence | Screenshot |
|---|---|
| Baseline vulnerability scan | `PASTE_IMAGE_URL_FIGURE_06` |
| Targeted scan of `C:\\ClickFixAgent` | `PASTE_IMAGE_URL_FIGURE_07` |
| Vulnerability summary | `PASTE_IMAGE_URL_FIGURE_08` |
| Severity counts | `PASTE_IMAGE_URL_FIGURE_09` |
| Detailed vulnerability table | `PASTE_IMAGE_URL_FIGURE_10` |
| PowerShell vulnerability records | `PASTE_IMAGE_URL_FIGURE_11` |
| Additional HIGH-severity findings | `PASTE_IMAGE_URL_FIGURE_12` |

### 3. Wazuh integration and alert validation

| Evidence | Screenshot |
|---|---|
| Synthetic CRITICAL event used for rule testing (not a real finding) | `PASTE_IMAGE_URL_FIGURE_14` |
| Wazuh dashboard alert for rule `100552` | `PASTE_IMAGE_URL_FIGURE_15` |
| Expanded Wazuh alert details | `PASTE_IMAGE_URL_FIGURE_16` |
| Additional alert details | `PASTE_IMAGE_URL_FIGURE_17` |

> **Note:** Figure 1 and Figure 13 did not contain embedded screenshot images in the supplied report. The evidence index documents all 15 extracted screenshots and their intended placement.

## Scope and limitations

- This repository documents Trivy-to-Wazuh integration only.
- The evidence confirms forwarding and alert generation for one selected CVE record.
- It does not prove unattended, continuous scan-to-alert automation.
- The CRITICAL rule test used a synthetic event, not a real vulnerability finding.
- OpenEDR and ELK were not installed or integrated in this project.

## Repository contents

- `docs/technical-report.md` — implementation, validation, results, and limitations.
- `docs/evidence-index.md` — placement guide for the 15 screenshots embedded in the original report.
- `configs/windows/wazuh-agent-localfile.xml` — Wazuh Agent log collection snippet.
- `configs/wazuh/local_rules.xml` — custom Wazuh rules.
- `scripts/windows/scan-and-export.ps1` — reference PowerShell workflow.

## Verification

On Windows PowerShell: `trivy --version`, `Get-Service WazuhSvc`, and `Test-NetConnection 10.0.2.6 -Port 1514`.

On the manager: `sudo systemctl status wazuh-manager` and search `/var/ossec/logs/alerts/alerts.json` for `CVE-2026-58280`.

See the [technical report](docs/technical-report.md) and [screenshot evidence index](docs/evidence-index.md).

This is an educational lab. Scan only systems you own or are authorized to assess.
