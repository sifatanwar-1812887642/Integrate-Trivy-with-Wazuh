# Technical Report — Trivy Vulnerability Detection with Wazuh

## 1. Objective

Integrate Trivy vulnerability scanning on a Windows endpoint with Wazuh log collection and severity-based alerting on an Ubuntu Wazuh Manager.

## 2. Lab topology

- Wazuh Manager: Ubuntu, `10.0.2.6`
- Scanned endpoint: Windows 11, `10.0.2.15`
- VirtualBox network: NAT Network
- Trivy version: `0.76.1`
- Wazuh Agent service: `WazuhSvc`

## 3. Install and verify Trivy

Trivy was installed on Windows with Windows Package Manager:

```powershell
winget search trivy
winget install AquaSecurity.Trivy
```

Open a new PowerShell session if the command is not yet on PATH, then verify:

```powershell
trivy --version
```

Verified version: `0.76.1`.

## 4. Scan the application directory

The application directory was scanned for vulnerabilities and the result saved as JSON:

```powershell
trivy fs --scanners vuln --format json --output C:\trivy-report.json C:\ClickFixAgent
Test-Path C:\trivy-report.json
```

The report contained dependency findings in .NET runtime package manifests. The two Release dependency files each contained 23 findings; the Debug dependency file contained zero.

## 5. Review findings

Load the JSON report and inspect vulnerability identifiers, packages, versions, and severities:

```powershell
$r = Get-Content C:\trivy-report.json -Raw | ConvertFrom-Json
$r.Results | ForEach-Object {
    $_.Vulnerabilities | Select-Object VulnerabilityID, PkgName, InstalledVersion, FixedVersion, Severity
}
```

The selected real finding for forwarding was `CVE-2026-58280`, severity `HIGH`, affecting `Microsoft.NETCore.App.Runtime.win-x64` version `8.0.29`.

## 6. Wazuh Agent log collection

The Windows Agent configuration file is:

`C:\Program Files (x86)\ossec-agent\ossec.conf`

Add the XML snippets from [wazuh-agent-localfile.xml](../configs/windows/wazuh-agent-localfile.xml) inside the existing `<ossec_config>` element. These entries tell the agent to monitor the Trivy JSONL files using the JSON log format.

Restart and verify the agent:

```powershell
Restart-Service -Name WazuhSvc
Get-Service WazuhSvc
Test-NetConnection 10.0.2.6 -Port 1514
```

## 7. Custom Wazuh rules

On the Ubuntu Wazuh Manager (`10.0.2.6`), add the rules from [local_rules.xml](../configs/wazuh/local_rules.xml) to:

`/var/ossec/etc/rules/local_rules.xml`

Validate and restart:

```bash
sudo /var/ossec/bin/wazuh-logtest
sudo systemctl restart wazuh-manager
sudo systemctl status wazuh-manager
```

Rule mapping:

| Rule ID | Severity | Level |
|---|---|---:|
| 100550 | Trivy JSON parent rule | 3 |
| 100551 | CRITICAL | 12 |
| 100552 | HIGH | 10 |
| 100553 | MEDIUM | 7 |

The CRITICAL rule was validated using a synthetic test event only; it is not a real scan result.

## 8. Forwarding validation and actual alert

The selected event was prepared as a one-line JSONL record and made available in the monitored replay file:

`C:\ProgramData\Trivy\vulnerabilities-replay.jsonl`

During this validation, the record was appended while the Wazuh Agent service was stopped, and the service was then restarted. The Wazuh Manager received the event, decoded it as JSON, and matched custom rule `100552`.

Verified actual alert:

| Field | Value |
|---|---|
| CVE | CVE-2026-58280 |
| Severity | HIGH |
| Package | Microsoft.NETCore.App.Runtime.win-x64 |
| Installed version | 8.0.29 |
| Agent hostname | DESKTOP-EC88LQC |
| Agent ID / IP | 002 / 10.0.2.15 |
| Decoder | json |
| Rule ID | 100552 |
| Alert level | 10 |
| Event location | C:\ProgramData\Trivy\vulnerabilities-replay.jsonl |
| Event timestamp | 2026-11-01T09:51:57.065+0000 |

Manager-side verification:

```bash
sudo grep -F '"vulnerability_id":"CVE-2026-58280"' /var/ossec/logs/alerts/alerts.json | tail
```

In the Wazuh dashboard, open Threat Hunting → Events and search:

```text
rule.id: 100552
```

The verified dashboard result was one alert for the selected HIGH CVE, at Level 10.

## 9. Remediation recommendation

Confirm the application's target framework and deployment requirements. Update the affected .NET runtime to a compatible patched version; the Trivy record listed `8.0.32` among fixed versions for the 8.0 line. Rebuild/redeploy the application, test it, and run Trivy again to confirm the finding is resolved.

## 10. Limitations and honest scope

- The evidence demonstrates successful forwarding and alert generation for one selected real CVE record.
- The event location shows that the replay JSONL file was used during validation.
- The evidence does not establish unattended, continuous scan-to-alert automation.
- Only one real vulnerability record was forwarded and verified.
- The CRITICAL rule test was synthetic and is excluded from real scan results.
- This project covers Trivy-to-Wazuh integration only. OpenEDR and ELK Stack were not installed or integrated.

## 11. Conclusion

The lab demonstrated Trivy scanning on a Windows endpoint and successful collection, forwarding, JSON decoding, and Wazuh alert generation for the selected HIGH finding `CVE-2026-58280`. The event was received from Windows agent `002` (`10.0.2.15`) and matched custom rule `100552` at Level 10.

## 12. Evidence checklist

Add the original screenshots from the lab where available:

1. Trivy installation and version.
2. Trivy scan command and report file.
3. Vulnerability summary from the JSON report.
4. Windows Wazuh Agent localfile configuration.
5. Ubuntu custom rules.
6. Agent connectivity and service status.
7. Wazuh dashboard alert details for rule 100552.
8. Manager archives/alerts verification.

Do not create or label placeholder images as real evidence.
