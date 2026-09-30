# Dynamic CV & Cover Letter Generator

Generate a tailored **CV** and **Cover Letter** (PDF) for any job by supplying a few parameters.  
Works **locally** via `make` and in **GitHub Actions** via a manual workflow dispatch.  
Optionally host the pack on **GitHub Pages** or **email** the PDFs.

The same `Makefile` targets are used in both environments so local and CI behaviour stay in parity.

---

## Quick start (local)

### Prerequisites
- `make`
- A working TeX Live installation with at least:
  - `pdflatex`
  - packages: `geometry`, `enumitem`, `titlesec`, `hyperref`, `xcolor`, `parskip`, `fontawesome5` (optional)

On Ubuntu/Debian:
```bash
sudo apt-get install texlive-latex-base texlive-latex-recommended \
  texlive-latex-extra texlive-fonts-recommended lmodern make
```

### Build
```bash
# Full pack (CV + Cover Letter + index.html)
make all \
  JOB_TITLE="Senior Video Editor" \
  COMPANY="BBC Studios" \
  JOB_TYPE="full-time" \
  INCLUDE_PHONE=true

# CV only
make cv-only JOB_TITLE="Editor" COMPANY="Netflix" INCLUDE_PHONE=false

# Just the cover letter
make cl JOB_TITLE="Post-Production Editor" COMPANY="Independent"

# Clean
make clean
```

Outputs land in `build/`:
- `CV_<Job_Title>.pdf`
- `CL_<Job_Title>_<Company>.pdf` (unless `CV_ONLY=true`)
- `index.html` – simple landing page with download links

---

## Parameters

| Variable         | Description                                      | Default                          |
|------------------|--------------------------------------------------|----------------------------------|
| `JOB_TITLE`      | Role you are applying for                        | `Video Editor`                   |
| `COMPANY`        | Target company                                   | `Example Company`                |
| `JOB_TYPE`       | Optional (full-time, contract, internship…)      | empty                            |
| `INCLUDE_PHONE`  | `true` / `false` – show phone on CV & CL         | `true`                           |
| `CV_ONLY`        | `true` / `false` – skip cover letter             | `false`                          |
| `NAME`           | Your full name                                   | `Manjil Sahani`                  |
| `LOCATION`       | City / country                                   | `Swindon, United Kingdom`        |
| `PHONE`          | Phone number (only used when `INCLUDE_PHONE=true`)| `+44 0 0`                       |
| `EMAIL`          | Email address                                    | `sahanimanjil17@outlook.com`     |
| `PORTFOLIO`      | Portfolio URL                                    | (your Wix site)                  |
| `LINKEDIN`       | LinkedIn URL                                     | (your LinkedIn)                  |
| `DATE`           | Date string for the index page                   | today’s date                     |

Edit the personal details either on the command line or permanently inside the `Makefile` / workflow.

---

## GitHub Actions (CI/CD)

1. Push this repository to GitHub.
2. Go to **Actions → Generate CV & Cover Letter → Run workflow**.
3. Fill in the inputs:

   | Input              | Type    | Purpose                                      |
   |--------------------|---------|----------------------------------------------|
   | `job_title`        | string  | Job title                                   |
   | `company`          | string  | Company name                                 |
   | `job_type`         | string  | Optional type (full-time etc.)               |
   | `include_phone`    | boolean | Show phone number                            |
   | `host_on_github`   | boolean | Deploy the pack to GitHub Pages              |
   | `send_email`       | boolean | Email the PDFs (requires secrets)            |
   | `cv_only`          | boolean | Generate CV only                             |

4. The workflow:
   - Installs a minimal TeX Live
   - Runs the **exact same** `make all …` targets you use locally
   - Always uploads the `build/` folder as a downloadable artifact (kept 14 days)
   - Optionally deploys to **GitHub Pages**
   - Optionally sends an email with the PDFs attached

### Enabling GitHub Pages
- Repository Settings → Pages → Source = **GitHub Actions**
- First successful run with `host_on_github = true` will publish the site.
- The site URL will appear in the deploy job summary.

### Enabling email
Add the following **repository secrets** (Settings → Secrets and variables → Actions):

| Secret           | Example / notes                                      |
|------------------|------------------------------------------------------|
| `SMTP_SERVER`    | `smtp.office365.com` / `smtp.gmail.com` / etc.       |
| `SMTP_PORT`      | `587` (STARTTLS) or `465` (SSL)                      |
| `SMTP_USERNAME`  | your SMTP login                                      |
| `SMTP_PASSWORD`  | app password / SMTP password                         |
| `EMAIL_FROM`     | address the SMTP server allows you to send from      |
| `EMAIL_TO`       | recipient (yourself, a recruiter, etc.)              |

Then set `send_email = true` when you run the workflow.

---

## How the templates work

- `cv.tex` and `cl.tex` contain `{{PLACEHOLDER}}` tokens.
- The `substitute` Make target (and the identical step in CI) runs `sed` to inject the parameters.
- `pdflatex` is called twice per document for safety.
- An `index.html` is generated that links both PDFs and shows the job/company metadata.

You can freely edit the prose in `cv.tex` / `cl.tex`.  
Just keep the `{{…}}` placeholders if you still want them filled automatically.

---

## Project layout

```
.
├── cv.tex                          # CV template
├── cl.tex                          # Cover-letter template
├── Makefile                        # Local + CI build logic
├── README.md
└── .github/workflows/generate.yml  # Manual workflow_dispatch
```

---

## Tips

- **Different jobs, same repo**: just re-run the workflow (or `make`) with new `JOB_TITLE` / `COMPANY`.  
  Each run produces uniquely named PDFs, so they never overwrite each other.
- **Phone number**: the supplied number (`+44 0 0`) looks like a placeholder – update `PHONE` in the Makefile or workflow (or pass it on the command line).
- **Font Awesome**: the CV optionally uses `\usepackage{fontawesome5}`. If the package is missing the build still succeeds; icons simply won’t appear.
- **Parity**: every CI stage that builds documents calls the same Make targets you use locally.  
  If it works with `make all …` on your machine it will work in Actions.

---

## Licence

Personal use – adapt freely for your own applications.
