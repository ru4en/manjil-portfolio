# manjil-portfolio

CI/CD workflow for generating a CV and cover letter from templates.

## Manual GitHub workflow

Use **Actions → "CV and Cover Letter CI/CD" → Run workflow** and provide:

- `job_title`
- `company`
- `job_option_type`
- `include_phone` (boolean)
- `host_on_github` (boolean)
- `send_email` (boolean)
- `cv_only` (boolean)
- `recipient_email` (optional)

The workflow will:

1. Generate files from templates:
   - `site/cv.md`
   - `site/cover_letter.md` (unless `cv_only=true`)
   - `site/index.md` (links to generated files)
2. Upload generated files as a build artifact.
3. Optionally send files via email when `send_email=true`.
4. Optionally deploy files to GitHub Pages when `host_on_github=true`.

## Required secrets for email

Set these repository secrets if you want email sending:

- `SMTP_SERVER`
- `SMTP_PORT`
- `SMTP_USERNAME`
- `SMTP_PASSWORD`
- `SMTP_FROM`
- `DEFAULT_EMAIL_TO` (used when `recipient_email` is not passed)
