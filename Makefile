# Makefile for dynamic CV / Cover Letter generation
# Mirrors the stages used in .github/workflows/generate.yml for local parity.
#
# Usage examples:
#   make all JOB_TITLE="Video Editor" COMPANY="Acme Studios" INCLUDE_PHONE=true
#   make cv-only JOB_TITLE="Editor" COMPANY="BBC" INCLUDE_PHONE=false
#   make clean

# ---------- Defaults (override on command line or via environment) ----------
JOB_TITLE     ?= Video Editor
COMPANY       ?= Example Company
JOB_TYPE      ?=          # e.g. "full-time", "contract", "internship" (optional)
INCLUDE_PHONE ?= true
CV_ONLY       ?= false
NAME          ?= Manjil Sahani
LOCATION      ?= Swindon, United Kingdom
PHONE         ?= +44 0 0
EMAIL         ?= sahanimanjil17@outlook.com
PORTFOLIO     ?= https://manjilfr.wixsite.com/portfolio
LINKEDIN      ?= https://www.linkedin.com/in/manjil-sahani-0317a624
DATE          ?= $(shell date +"%d %B %Y")

# Derived
# PHONE_IF is either empty or a short text fragment. We avoid complex LaTeX
# commands here so escaping stays simple.
ifeq ($(INCLUDE_PHONE),true)
  PHONE_IF = Phone: $(PHONE) | 
else
  PHONE_IF =
endif

ifeq ($(JOB_TYPE),)
  JOB_TYPE_PHRASE =
else
  JOB_TYPE_PHRASE = ($(JOB_TYPE))
endif

# Output directory
OUTDIR := build
CV_PDF := $(OUTDIR)/CV_$(shell echo "$(JOB_TITLE)" | tr ' /' '__').pdf
CL_PDF := $(OUTDIR)/CL_$(shell echo "$(JOB_TITLE)" | tr ' /' '__')_$(shell echo "$(COMPANY)" | tr ' /' '__').pdf

.PHONY: all cv cl index clean help prepare substitute compile-cv compile-cl

help:
	@echo "Dynamic CV / Cover Letter generator"
	@echo ""
	@echo "Targets:"
	@echo "  all          Build CV + CL + index.html (default)"
	@echo "  cv           Build CV only"
	@echo "  cl           Build Cover Letter only"
	@echo "  cv-only      Alias for cv (sets CV_ONLY=true)"
	@echo "  index        Generate a simple index.html that links the PDFs"
	@echo "  clean        Remove build/"
	@echo ""
	@echo "Variables (override with VAR=value):"
	@echo "  JOB_TITLE       Job title (default: $(JOB_TITLE))"
	@echo "  COMPANY         Company name (default: $(COMPANY))"
	@echo "  JOB_TYPE        Optional type e.g. full-time / contract"
	@echo "  INCLUDE_PHONE   true|false (default: $(INCLUDE_PHONE))"
	@echo "  CV_ONLY         true|false – skip cover letter"
	@echo "  NAME, LOCATION, PHONE, EMAIL, PORTFOLIO, LINKEDIN, DATE"

all: prepare substitute
ifeq ($(CV_ONLY),true)
	@$(MAKE) compile-cv
else
	@$(MAKE) compile-cv compile-cl
endif
	@$(MAKE) index
	@echo "Done. Outputs in $(OUTDIR)/"

cv: prepare substitute compile-cv
	@echo "CV ready: $(CV_PDF)"

cl: prepare substitute compile-cl
	@echo "Cover letter ready: $(CL_PDF)"

cv-only:
	@$(MAKE) cv CV_ONLY=true

# ---------- Stages (kept identical in spirit to the CI workflow) ----------
prepare:
	@mkdir -p $(OUTDIR)
	@echo "Prepared $(OUTDIR)/"

# Substitute placeholders into temporary .tex files
# Use '#' as sed delimiter to avoid clashes with '|' and '/' in values
substitute:
	@echo "Substituting parameters..."
	@sed -e 's#{{NAME}}#$(NAME)#g' \
	     -e 's#{{LOCATION}}#$(LOCATION)#g' \
	     -e 's#{{PHONE_IF}}#$(PHONE_IF)#g' \
	     -e 's#{{PHONE}}#$(PHONE)#g' \
	     -e 's#{{EMAIL}}#$(EMAIL)#g' \
	     -e 's#{{PORTFOLIO}}#$(PORTFOLIO)#g' \
	     -e 's#{{LINKEDIN}}#$(LINKEDIN)#g' \
	     cv.tex > $(OUTDIR)/cv_filled.tex
	@sed -e 's#{{JOB_TITLE}}#$(JOB_TITLE)#g' \
	     -e 's#{{COMPANY}}#$(COMPANY)#g' \
	     -e 's#{{JOB_TYPE_PHRASE}}#$(JOB_TYPE_PHRASE)#g' \
	     -e 's#{{NAME}}#$(NAME)#g' \
	     -e 's#{{LOCATION}}#$(LOCATION)#g' \
	     -e 's#{{PHONE_IF}}#$(PHONE_IF)#g' \
	     -e 's#{{EMAIL}}#$(EMAIL)#g' \
	     -e 's#{{PORTFOLIO}}#$(PORTFOLIO)#g' \
	     -e 's#{{LINKEDIN}}#$(LINKEDIN)#g' \
	     -e 's#{{DATE}}#$(DATE)#g' \
	     cl.tex > $(OUTDIR)/cl_filled.tex

compile-cv:
	@echo "Compiling CV..."
	@cd $(OUTDIR) && pdflatex -interaction=nonstopmode -jobname=$(basename $(notdir $(CV_PDF))) cv_filled.tex > /dev/null
	@# second pass for references if any
	@cd $(OUTDIR) && pdflatex -interaction=nonstopmode -jobname=$(basename $(notdir $(CV_PDF))) cv_filled.tex > /dev/null || true
	@echo "  → $(CV_PDF)"

compile-cl:
	@echo "Compiling Cover Letter..."
	@cd $(OUTDIR) && pdflatex -interaction=nonstopmode -jobname=$(basename $(notdir $(CL_PDF))) cl_filled.tex > /dev/null
	@cd $(OUTDIR) && pdflatex -interaction=nonstopmode -jobname=$(basename $(notdir $(CL_PDF))) cl_filled.tex > /dev/null || true
	@echo "  → $(CL_PDF)"

index:
	@echo "Generating index.html..."
	@echo '<!DOCTYPE html>' > $(OUTDIR)/index.html
	@echo '<html lang="en"><head><meta charset="utf-8"><title>Application Pack – $(JOB_TITLE) @ $(COMPANY)</title>' >> $(OUTDIR)/index.html
	@echo '<style>body{font-family:system-ui,sans-serif;max-width:720px;margin:2rem auto;padding:0 1rem;line-height:1.5} h1{margin-bottom:.2em} .meta{color:#555;margin-bottom:1.5rem} a{color:#06c} .card{border:1px solid #ddd;border-radius:8px;padding:1rem;margin:1rem 0}</style>' >> $(OUTDIR)/index.html
	@echo '</head><body>' >> $(OUTDIR)/index.html
	@echo '<h1>Application Pack</h1>' >> $(OUTDIR)/index.html
	@echo '<p class="meta"><strong>$(NAME)</strong> · $(JOB_TITLE) at $(COMPANY)' >> $(OUTDIR)/index.html
	@if [ -n "$(JOB_TYPE)" ]; then echo " ($(JOB_TYPE))" >> $(OUTDIR)/index.html; fi
	@echo '</p>' >> $(OUTDIR)/index.html
	@echo '<div class="card"><h2>Curriculum Vitae</h2><p><a href="$(notdir $(CV_PDF))">Download CV (PDF)</a></p></div>' >> $(OUTDIR)/index.html
	@if [ "$(CV_ONLY)" != "true" ]; then \
	  echo '<div class="card"><h2>Cover Letter</h2><p><a href="$(notdir $(CL_PDF))">Download Cover Letter (PDF)</a></p></div>' >> $(OUTDIR)/index.html; \
	fi
	@echo '<p style="margin-top:2rem;font-size:.9em;color:#666">Generated on $(DATE)</p>' >> $(OUTDIR)/index.html
	@echo '</body></html>' >> $(OUTDIR)/index.html
	@echo "  → $(OUTDIR)/index.html"

clean:
	rm -rf $(OUTDIR)
	@echo "Cleaned."
