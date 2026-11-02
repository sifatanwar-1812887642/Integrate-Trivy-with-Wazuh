# Screenshot Evidence Index

The original academic report contains 15 embedded screenshots. This index maps each screenshot to the relevant implementation stage so the evidence can be placed consistently in the repository documentation.

> **Asset status:** The screenshots are present in the original file `Trivy_Wazuh_CVE_Report_Academic.docx`, but the image binaries have not yet been committed to this repository. The entries below are an evidence-placement guide, not links to uploaded images. Do not treat a missing image as proof of a step.

## Screenshot placement

| Report figure | Screenshot file extracted from the report | Recommended location / purpose |
|---|---|---|
| Figure 2 | `366b08b68c9cdacc37a3401aceeb0e44a20fd7c4.png` | Trivy package search in WinGet; installation preparation |
| Figure 3 | `21c304f5df3b78e6121c585e4b71ab3c14504026.png` | Trivy installation |
| Figure 4 | `988c30ba1fcac4e433c377baf060955106cd16d4.png` | Installed Trivy version (`0.76.1`) |
| Figure 5 | `05e26776fa15f9d54cf6349f3ae5708da55591e4.png` | Vulnerability database download |
| Figure 6 | `fe4e7f1b2e4429cf6ef5da3e567047af768be78f.png` | Baseline filesystem scan |
| Figure 7 | `2c818a3600e25db9b9cf3c70b8ee9013309eeff4.png` | Targeted scan of `C:\\ClickFixAgent` |
| Figure 8 | `801b562595660e084a2820e203de1cc54a9f8d73.png` | Vulnerability summary / findings |
| Figure 9 | `de851212405d4f11711135e003a026d4e5056e25.png` | Severity counts |
| Figure 10 | `a2e861ec2d76c34471e19b9de18620b02cc534e4.png` | Detailed vulnerability table |
| Figure 11 | `5ea4ce8ed5058f23a64c22ffda281d0d1acb78c2.png` | PowerShell vulnerability records |
| Figure 12 | `d4533a33e6d7446e2203528f92bb176aefbc04be.png` | Additional HIGH-severity findings |
| Figure 14 | `4e28ab3f9d6312f126f914940c12ab41f09c3771.png` | Wazuh logtest with a **synthetic CRITICAL event**; label as a rule test, not a real finding |
| Figure 15 | `df626e35727d533b6026af9d40cd3934f6e4f9fb.png` | Wazuh dashboard alert for rule `100552` |
| Figure 16 | `0a5c572a8bb7bf9c721d1bc5300e4edad4023e09.png` | Expanded Wazuh alert details |
| Figure 17 | `82b109fcd8ab8882b18978c59d6af2570cdefb1a.png` | Additional expanded alert details |

Figures 1 and 13 were placeholders in the source report; no embedded screenshots were available for them.

## Evidence interpretation

- Figures 2–5 support Trivy installation and initial setup.
- Figures 6–12 support the scan and vulnerability-analysis stages.
- Figure 14 is a synthetic rule-validation test only.
- Figures 15–17 support the observed Wazuh alert and its details.
- The verified integration result remains the selected HIGH finding `CVE-2026-58280` (rule `100552`, alert level 10). The evidence does not establish unattended continuous scanning.
