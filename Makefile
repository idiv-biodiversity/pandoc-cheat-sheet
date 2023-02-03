.PHONY: all clean default print
.SILENT: print

default: all

SOURCES_DOT = $(wildcard *.dot)
SOURCES_MD = $(wildcard *-cheat-sheet.md)
SOURCES_YML = $(wildcard *-cheat-sheet.yml)

OBJECTS_DOT_SVG = $(SOURCES_DOT:.dot=.svg)
OBJECTS_HTML = $(SOURCES_MD:.md=.html)
OBJECTS_PDF = $(SOURCES_MD:.md=.pdf)
OBJECTS_TEX = $(SOURCES_MD:.md=.tex)

META_URL_COLOR = "urlcolor"
META_LINK_COLOR = "linkcolor"
META_MONO_COLOR = "monospacecolor"
PRINT_COLOR = "black"

OBJECTS = \
	$(OBJECTS_DOT_SVG) \
	$(OBJECTS_HTML) \
	$(OBJECTS_PDF) \
	$(OBJECTS_TEX)

all: $(OBJECTS)

$(OBJECTS):

$(OBJECTS_HTML): $(OBJECTS_DOT_SVG)

$(OBJECTS_PDF): $(OBJECTS_DOT_SVG)

PANDOC = pandoc
PANDOC_PDF_ENGINE = xelatex

PANDOC_FLAGS = \
	--standalone \
	--from=markdown+yaml_metadata_block

PANDOC_HTML_FLAGS = \
	$(PANDOC_FLAGS) \
	--template=cheat-sheet.html

PANDOC_TEX_FLAGS = \
	$(PANDOC_FLAGS) \
	--template=cheat-sheet.tex \

PANDOC_PDF_FLAGS = \
	$(PANDOC_TEX_FLAGS) \
	--pdf-engine=$(PANDOC_PDF_ENGINE) \

PANDOC_PRINT_FLAGS = \
    --metadata=$(META_LINK_COLOR):$(PRINT_COLOR) \
    --metadata=$(META_MONO_COLOR):$(PRINT_COLOR) \
    --metadata=$(META_URL_COLOR):$(PRINT_COLOR) \

%.svg: %.dot
	dot -Tsvg -o $@ $<

%.html: %.md %.yml cheat-sheet.html
	$(PANDOC) $(PANDOC_HTML_FLAGS) -o $@ $*.yml $<

%.pdf: %.md %.yml cheat-sheet.tex
	$(PANDOC) $(PANDOC_PDF_FLAGS) -o $@ $*.yml $<

%.tex: %.md %.yml cheat-sheet.tex
	$(PANDOC) $(PANDOC_TEX_FLAGS) -o $@ $*.yml $<

print:
	$(foreach file, $(SOURCES_YML), \
		echo Creating printer friendly pdf for $(patsubst %.yml, %, $(file)); \
		$(PANDOC) $(PANDOC_TEX_FLAGS) $(PANDOC_PRINT_FLAGS) -o $(patsubst %.yml, %_print.pdf, $(file)) $(file) $(patsubst %.yml, %.md, $(file)); \
	)\

clean:
	rm -f $(OBJECTS)
