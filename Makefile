.PHONY: all clean default

default: all

SOURCES_MD = $(wildcard *-cheat-sheet.md)

OBJECTS_HTML = $(SOURCES_MD:.md=.html)
OBJECTS_PDF = $(SOURCES_MD:.md=.pdf)
OBJECTS_TEX = $(SOURCES_MD:.md=.tex)

OBJECTS = \
	$(OBJECTS_HTML) \
	$(OBJECTS_PDF) \
	$(OBJECTS_TEX)

all: $(OBJECTS)

$(OBJECTS):

PANDOC = pandoc

PANDOC_FLAGS = \
	--standalone \
	--from=markdown+yaml_metadata_block

PANDOC_HTML_FLAGS = \
	$(PANDOC_FLAGS) \
	--template=cheat-sheet.html

PANDOC_TEX_FLAGS = \
	$(PANDOC_FLAGS) \
	--template=cheat-sheet.tex \
	--pdf-engine=xelatex

%.html: %.md %.yml cheat-sheet.html
	$(PANDOC) $(PANDOC_HTML_FLAGS) -o $@ $*.yml $<

%.pdf: %.md %.yml cheat-sheet.tex
	$(PANDOC) $(PANDOC_TEX_FLAGS) -o $@ $*.yml $<

%.tex: %.md %.yml cheat-sheet.tex
	$(PANDOC) $(PANDOC_TEX_FLAGS) -o $@ $*.yml $<

clean:
	rm -f $(OBJECTS)
