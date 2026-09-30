#!/usr/bin/env python3
import argparse
from datetime import datetime, timezone
from pathlib import Path


def parse_bool(value: str) -> bool:
    return value.strip().lower() in {"1", "true", "yes", "y", "on"}


def load_template(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def render(template: str, values: dict[str, str]) -> str:
    return template.format(**values)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate CV and cover letter from templates")
    parser.add_argument("--job-title", required=True)
    parser.add_argument("--company", required=True)
    parser.add_argument("--job-option-type", required=True)
    parser.add_argument("--include-phone", default="false")
    parser.add_argument("--cv-only", default="false")
    parser.add_argument("--output-dir", default="site")
    args = parser.parse_args()

    include_phone = parse_bool(args.include_phone)
    cv_only = parse_bool(args.cv_only)

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    generated_at = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    values = {
        "job_title": args.job_title,
        "company": args.company,
        "job_option_type": args.job_option_type,
        "phone": "+1-111-222-3333" if include_phone else "Not included",
        "generated_at": generated_at,
    }

    cv_content = render(load_template(Path("templates/cv_template.md")), values)
    cv_path = output_dir / "cv.md"
    cv_path.write_text(cv_content, encoding="utf-8")

    cover_letter_path = output_dir / "cover_letter.md"
    if not cv_only:
        cover_letter_content = render(load_template(Path("templates/cover_letter_template.md")), values)
        cover_letter_path.write_text(cover_letter_content, encoding="utf-8")

    index_lines = [
        "# Application Documents",
        "",
        f"- **Company:** {args.company}",
        f"- **Job title:** {args.job_title}",
        f"- **Job option type:** {args.job_option_type}",
        f"- **Generated at:** {generated_at}",
        "",
        "## Files",
        "",
        "- [CV](./cv.md)",
    ]

    if not cv_only:
        index_lines.append("- [Cover letter](./cover_letter.md)")

    (output_dir / "index.md").write_text("\n".join(index_lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
