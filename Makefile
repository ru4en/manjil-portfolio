# Makefile for dynamic CV / Cover Letter generation
# Mirrors the stages used in .github/workflows/generate.yml for local parity.
#
# Usage examples:
#   make all JOB_TITLE="Video Editor" COMPANY="Acme Studios" INCLUDE_PHONE=true
#   make all JOB_TITLE="Sound Designer" COMPANY="BBC" FOCUS=sound
#   make cv-only JOB_TITLE="Editor" COMPANY="Netflix" FOCUS=editor INCLUDE_PHONE=false
#   make clean
#
# Override any content block on the command line or via environment:
#   make all PROFILE="Custom profile text..." TECHNICAL_SKILLS="Premiere, Resolve..."


# ---------- Defaults (override on command line or via environment) ----------
JOB_TITLE     ?= Video Editor
COMPANY       ?= Example Company
JOB_TYPE      ?=
INCLUDE_PHONE ?= true
CV_ONLY       ?= false
FOCUS         ?= auto

NAME          ?= Manjil Sahani
LOCATION      ?= Swindon, United Kingdom
PHONE         ?= +44 00000000000
EMAIL         ?= sahanimanjil17@outlook.com
PORTFOLIO     ?= https://manjilfr.wixsite.com/portfolio
LINKEDIN      ?= https://www.linkedin.com/in/manjil-sahani-0317a624
DATE          ?= $(shell date +"%d %B %Y")


# ---------- Derived phone / job-type fragments ----------
ifeq ($(INCLUDE_PHONE),true)
  PHONE_IF := Phone: $(PHONE) \quad|\quad 
else
  PHONE_IF :=
endif

ifeq ($(JOB_TYPE),)
  JOB_TYPE_PHRASE :=
else
  JOB_TYPE_PHRASE := ($(JOB_TYPE))
endif


# ---------- Resolve effective focus (command-line FOCUS cannot be overwritten) ----------
# If FOCUS=auto, derive from JOB_TITLE keywords; otherwise use the supplied FOCUS.
EFFECTIVE_FOCUS := $(shell \
  if [ "$(FOCUS)" != "auto" ]; then echo "$(FOCUS)"; \
  else \
    t=$$(echo "$(JOB_TITLE)" | tr '[:upper:]' '[:lower:]'); \
    if echo "$$t" | grep -qE 'sound|audio'; then echo sound; \
    elif echo "$$t" | grep -q director; then echo director; \
    elif echo "$$t" | grep -qE 'editor|post'; then echo editor; \
    else echo general; fi; \
  fi)

# ---------- Content presets (selected by EFFECTIVE_FOCUS) ----------
ifeq ($(EFFECTIVE_FOCUS),editor)
  PROFILE ?= Dedicated and creatively driven video editor with over six years of hands-on experience in post-production, spanning short films, documentaries and advertisements. Passionate about storytelling and skilled at interpreting a director's or client's vision into compelling, emotionally resonant visual narratives. Brings precision, adaptability and strong collaborative energy to every project.
  TECHNICAL_SKILLS ?= Advanced proficiency in Adobe Premiere Pro, Final Cut Pro and DaVinci Resolve. Strong understanding of pacing, continuity, rhythm and narrative structure. Experience with sound editing, foley work and basic colour grading.
  PROFESSIONAL_SKILLS ?= Creative collaboration, adaptability, organisation, attention to detail and the ability to work under tight deadlines.
  OPENING ?= With over six years of post-production experience and a strong academic grounding in film production, I am confident I can contribute immediately to your editorial team.
  BODY ?= My recent work as Main Editor on short films and documentaries has sharpened my ability to shape narrative, maintain continuity and deliver under deadline. I am particularly drawn to $(COMPANY) because of its reputation for high-quality storytelling, and I would welcome the chance to bring both technical precision and creative insight to the role.
  CLOSING ?= Thank you for considering my application. I would be delighted to discuss how my editing experience and collaborative approach can support $(COMPANY)'s upcoming projects. I have attached my CV and portfolio for your review.
else ifeq ($(EFFECTIVE_FOCUS),sound)
  PROFILE ?= Sound specialist and video editor with extensive experience leading production and post-production audio on short films. Skilled at capturing clean location sound, designing immersive soundscapes and delivering polished final mixes that support narrative and emotional intent. Combines technical audio craft with a strong understanding of picture editing.
  TECHNICAL_SKILLS ?= Production sound recording, dialogue editing, foley, sound design, mixing and delivery. Proficient in Adobe Premiere Pro and DaVinci Resolve; comfortable collaborating closely with picture editors. Experience creating immersive soundscapes that enhance mood and narrative.
  PROFESSIONAL_SKILLS ?= Leadership of audio departments, clear communication with directors and editors, problem-solving under production pressure, meticulous attention to detail.
  OPENING ?= As a sound specialist with hands-on experience leading the audio department on short-film productions, I am excited by the opportunity to contribute to $(COMPANY)'s projects.
  BODY ?= In my most recent role as Head of Sound I managed the full audio pipeline -- from location recording through to final mix -- ensuring dialogue, effects and score served the story. I work closely with directors and picture editors and take pride in delivering clean, immersive sound that elevates the finished film.
  CLOSING ?= I would welcome the opportunity to discuss how my audio expertise and collaborative mindset can support $(COMPANY). Thank you for your time and consideration; my CV and portfolio are attached.
else ifeq ($(EFFECTIVE_FOCUS),director)
  PROFILE ?= Creatively driven filmmaker and editor with experience across directing, editing and sound. Combines strong narrative instincts with practical leadership skills gained from managing short-film productions from concept to delivery. Adept at guiding teams while keeping a clear creative vision.
  TECHNICAL_SKILLS ?= Adobe Premiere Pro, Final Cut Pro, DaVinci Resolve, basic colour grading, sound editing and production sound recording. Familiar with the full production pipeline from concept development through to final delivery.
  PROFESSIONAL_SKILLS ?= Leadership, team coordination, scheduling, creative problem-solving, clear communication and the ability to guide a project from concept to delivery.
  OPENING ?= With experience directing short films as well as editing and sound design, I bring a holistic understanding of the production process that I believe would be valuable to $(COMPANY).
  BODY ?= Leading projects from concept to delivery has developed my ability to guide teams, solve problems under pressure and keep a clear creative vision. I am especially interested in opportunities where storytelling craft and practical leadership intersect.
  CLOSING ?= Thank you for reviewing my application. I would be happy to discuss how my directing and post-production experience can contribute to $(COMPANY)'s work. My CV and portfolio are attached.
else
  PROFILE ?= Dedicated filmmaker and editor with over six years of hands-on experience across short films, documentaries and commercials. Combines technical proficiency in post-production with creative storytelling and collaborative leadership. Eager to contribute to projects that value both craft and narrative impact.
  TECHNICAL_SKILLS ?= Advanced proficiency in Adobe Premiere Pro, Final Cut Pro and DaVinci Resolve. Strong understanding of pacing, continuity, rhythm and narrative structure. Experience with sound editing, foley work and basic colour grading.
  PROFESSIONAL_SKILLS ?= Creative collaboration, adaptability, organisation, leadership in post-production contexts and strong communication skills.
  OPENING ?= With a solid foundation in film production and several years of practical experience across editing, sound and directing, I am keen to bring my skills to $(COMPANY).
  BODY ?= I thrive in collaborative environments and enjoy the challenge of turning creative briefs into polished final pieces. My academic training at Solent University together with hands-on project work has given me both technical fluency and a strong storytelling sensibility.
  CLOSING ?= Thank you for considering my application. I look forward to the possibility of discussing how I can contribute to $(COMPANY). My CV and portfolio are attached for your review.
endif

ADDITIONAL_SECTIONS ?=


# ---------- Education & Experience as multi-line define blocks ----------
define EDUCATION
\textbf{Solent University, Southampton}\\
BA (Hons) Film Production \hfill 2021 -- 2024\\
Upper Second-Class Honours (2:1)

\vspace{4pt}
\textbf{New College, Swindon}\\
BTEC National Extended Diploma in Computing \hfill 2019 -- 2021\\
Grade: MMM (Equivalent to 3 A Levels)
endef
export EDUCATION

define EXPERIENCE
\textbf{Head of Sound -- Rotten Tomatoes (FMP Short Film)}\\
September 2023 -- June 2024
\begin{itemize}
\item Led the complete audio department, overseeing both production and post-production sound.
\item Captured high-quality location audio including dialogue, ambience and foley.
\item Designed and implemented soundscapes to enhance mood and narrative depth.
\item Collaborated with the director and editor to ensure audio aligned seamlessly with the visual direction.
\item Delivered a polished final sound mix balancing dialogue, effects and score.
\end{itemize}

\textbf{Main Editor -- Date Night (Short Psychological Thriller)}\\
January 2023 -- May 2023
\begin{itemize}
\item Managed full post-production, including narrative editing, rhythm, sound design and pacing.
\item Worked closely with the director to preserve tone, tension and thematic intent.
\item Ensured smooth storytelling flow through precise scene assembly and continuity management.
\end{itemize}

\textbf{Main Editor -- Dysphoria (Short Documentary)}\\
September 2022 -- January 2023
\begin{itemize}
\item Oversaw the entire edit of a documentary exploring transgender experiences.
\item Structured interviews and story arcs to create a cohesive, respectful narrative.
\item Performed audio cleanup, basic colour correction and visual refinement.
\item Ensured the final film handled sensitive topics with care and authenticity.
\end{itemize}

\textbf{Director -- Hotel Room Horror (Short Horror Film)}\\
September 2022 -- January 2023
\begin{itemize}
\item Directed all phases of production from concept development to final delivery.
\item Led a creative team, organised schedules, conducted casting and managed set operations.
\item Strengthened leadership, communication and problem-solving abilities under production pressures.
\end{itemize}
endef
export EXPERIENCE


# ---------- Output paths ----------
OUTDIR := build
SAFE_JOB   := $(shell echo "$(JOB_TITLE)" | tr ' /' '__')
SAFE_COMP  := $(shell echo "$(COMPANY)" | tr ' /' '__')
CV_PDF := $(OUTDIR)/CV_$(SAFE_JOB).pdf
CL_PDF := $(OUTDIR)/CL_$(SAFE_JOB)_$(SAFE_COMP).pdf


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
	@echo "Key variables (override with VAR=value):"
	@echo "  JOB_TITLE       Job title (default: $(JOB_TITLE))"
	@echo "  COMPANY         Company name (default: $(COMPANY))"
	@echo "  JOB_TYPE        Optional type e.g. full-time / contract"
	@echo "  FOCUS           auto|editor|sound|director|general  (default: auto)"
	@echo "  INCLUDE_PHONE   true|false (default: $(INCLUDE_PHONE))"
	@echo "  CV_ONLY         true|false – skip cover letter"
	@echo "  PROFILE / TECHNICAL_SKILLS / PROFESSIONAL_SKILLS  – full overrides"
	@echo "  NAME, LOCATION, PHONE, EMAIL, PORTFOLIO, LINKEDIN, DATE"
	@echo ""
	@echo "Examples:"
	@echo "  make all JOB_TITLE='Video Editor' COMPANY='Acme' FOCUS=editor"
	@echo "  make all JOB_TITLE='Sound Designer' COMPANY='BBC' FOCUS=sound INCLUDE_PHONE=false"


all: prepare substitute
ifeq ($(CV_ONLY),true)
	@$(MAKE) compile-cv
else
	@$(MAKE) compile-cv compile-cl
endif
	@$(MAKE) index
	@echo "Done. Outputs in $(OUTDIR)/  (focus=$(EFFECTIVE_FOCUS))"


cv: prepare substitute compile-cv
	@echo "CV ready: $(CV_PDF)  (focus=$(EFFECTIVE_FOCUS))"


cl: prepare substitute compile-cl
	@echo "Cover letter ready: $(CL_PDF)  (focus=$(EFFECTIVE_FOCUS))"


cv-only:
	@$(MAKE) cv CV_ONLY=true


prepare:
	@mkdir -p $(OUTDIR)
	@echo "Prepared $(OUTDIR)/  (focus=$(EFFECTIVE_FOCUS))"


# Robust substitution via Python (handles multi-line + special chars)
substitute:
	@echo "Substituting parameters (focus=$(EFFECTIVE_FOCUS))..."
	@export NAME="$(NAME)" \
	       LOCATION="$(LOCATION)" \
	       PHONE_IF="$(PHONE_IF)" \
	       PHONE="$(PHONE)" \
	       EMAIL="$(EMAIL)" \
	       PORTFOLIO="$(PORTFOLIO)" \
	       LINKEDIN="$(LINKEDIN)" \
	       PROFILE="$(PROFILE)" \
	       TECHNICAL_SKILLS="$(TECHNICAL_SKILLS)" \
	       PROFESSIONAL_SKILLS="$(PROFESSIONAL_SKILLS)" \
	       ADDITIONAL_SECTIONS="$(ADDITIONAL_SECTIONS)" \
	       JOB_TITLE="$(JOB_TITLE)" \
	       COMPANY="$(COMPANY)" \
	       JOB_TYPE_PHRASE="$(JOB_TYPE_PHRASE)" \
	       DATE="$(DATE)" \
	       OPENING="$(OPENING)" \
	       BODY="$(BODY)" \
	       CLOSING="$(CLOSING)" \
	       EDUCATION="$$EDUCATION" \
	       EXPERIENCE="$$EXPERIENCE" ; \
	python3 substitute.py cv.tex $(OUTDIR)/cv_filled.tex ; \
	python3 substitute.py cl.tex $(OUTDIR)/cl_filled.tex


compile-cv:
	@echo "Compiling CV..."
	@cd $(OUTDIR) && pdflatex -interaction=nonstopmode -jobname=$(basename $(notdir $(CV_PDF))) cv_filled.tex > /dev/null
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
	@echo ' · focus: $(EFFECTIVE_FOCUS)</p>' >> $(OUTDIR)/index.html
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
