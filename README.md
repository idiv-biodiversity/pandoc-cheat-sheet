Pandoc Cheat Sheet Templates
============================

This project contains cheat sheet templates to be used with pandoc. Cheat sheets try to fit as much content as possible onto few pages. Both the LaTeX and the HTML template utilize **columns** to achieve that.

<!-- toc -->

- [Variables](#variables)
- [Usage](#usage)
  * [PDF](#pdf)
  * [HTML](#html)
  * [Makefile](#makefile)
  * [git submodule](#git-submodule)

<!-- tocstop -->

Variables
---------

The variables are more or less what you expect from the default pandoc templates.

Some variables have been purposefully removed to keep both the template codes and the output comparatively simple. The original templates were very general, but for a cheat sheet we don't need that much functionality. Notable removals from the default templates include:

- abstract
- table of contents
- bibliography
- everything regarding LaTeX beamer

There have only been a very few additions. An example variable template containing these can be found in the `example-variables.yml` file. This file contains comments to explain why these variables should be used as default.

Usage
-----

The templates support both PDF documents and HTML web pages. This way, you can easily create both with just a single input file. The examples use Markdown as the input file format.

### PDF

Create the PDF cheat sheet:

```bash
pandoc                                \
  --standalone                        \
  --from=markdown+yaml_metadata_block \
  --template=cheat-sheet.tex          \
  --pdf-engine=xelatex                \
  -o my-topic-cheat-sheet.pdf         \
  my-topic-cheat-sheet.yml            \
  my-topic-cheat-sheet.md
```

### HTML

Create the HTML cheat sheet:

```bash
pandoc                                \
  --standalone                        \
  --from=markdown+yaml_metadata_block \
  --template=cheat-sheet.html         \
  -o my-topic-cheat-sheet.html        \
  my-topic-cheat-sheet.yml            \
  my-topic-cheat-sheet.md
```

You can open this page locally or put in on a web server.

### Makefile

Because these pandoc command-lines are long and cumbersome to write, there is also a very generic `Makefile` contained in this repository. Assuming your input file ends in `-cheat-sheet.md`, e.g. `my-topic-cheat-sheet.md`, then you just need to type `make` to create all cheat sheet variants.

Anytime you change either one of the sources, i.e. your Markdown file, the YAML metadata file or one of the templates, just retype `make` and it will rebuild the files whose sources changed.

### git submodule

This is how you would create a fresh project and add cheat sheet as a git submodule:

```bash
# create a new project
mkdir topic-cheat-sheet
cd topic-cheat-sheet
git init

# create dummy content
echo '# cheat sheet about topic' > topic-cheat-sheet.md
git stage topic-cheat-sheet.md

# add submodule
git submodule add https://github.com/idiv-biodiversity/pandoc-cheat-sheet.git

# link the cheat sheet files into your project
ln -s -t . pandoc-cheat-sheet/cheat-sheet.* pandoc-cheat-sheet/Makefile
git stage cheat-sheet.* Makefile

# copy the metadata template to your project
cp pandoc-cheat-sheet/example-variables.yml topic-cheat-sheet.yml
git stage topic-cheat-sheet.yml

# ignore the cheat sheet products
echo topic-cheat-sheet.html >> .gitignore
echo topic-cheat-sheet.pdf  >> .gitignore
git stage .gitignore

# create the cheat sheets
make

# done, review the cheat sheets and make a git commit whet you're ready:
# - firefox topic-cheat-sheet.html
# - evince topic-cheat-sheet.pdf
# - git commit -m 'initial commit'
```
