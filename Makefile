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

%.svg: %.dot
	dot -Tsvg -o $@ $<

%.html: %.md %.yml cheat-sheet.html
	$(PANDOC) $(PANDOC_HTML_FLAGS) -o $@ $*.yml $<

%.pdf: %.md %.yml cheat-sheet.tex
	$(PANDOC) $(PANDOC_PDF_FLAGS) -o $@ $*.yml $<

%.tex: %.md %.yml cheat-sheet.tex
	$(PANDOC) $(PANDOC_TEX_FLAGS) -o $@ $*.yml $<

print:
	# replacing the linkcolor and adding other colors into the yml file,
	# calling it <file>.yml_print and using it to create the printer friendly file.
	$(foreach file, $(SOURCES_YML), \
		echo Creating printer friendly pdf for $(patsubst %.yml, %, $(file)); \
		sed 's/linkcolor: [A-z]*/\nlinkcolor: black\nurlcolor: black\nmonospacecolor: black/' $(file) > $(file)_print ; \
		$(PANDOC) $(PANDOC_TEX_FLAGS) -o $(patsubst %.yml, %_print.pdf, $(file)) $(file)_print $(patsubst %.yml, %.md, $(file)); \
		echo File $(patsubst %.yml, %_print.pdf, $(file)) created; \
	)\
	# removing the printer friendly yml file
	rm *.yml_print


clean:
	rm -f $(OBJECTS)
