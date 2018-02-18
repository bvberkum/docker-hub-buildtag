default: all
	
include templates.mk

sh-template = { echo 'cat <<EOM' ; echo "$$$(1)" ; echo 'EOM' ; } |  ENV=./.package.sh sh -i -


/ := ./

$/%.html: $/%.md
	pandoc $< -t html > $@

$/%.md: $/%.txt
	@$(call sh-template,ReadMe_md) > $@

$/ReadMe-fig1.gv:
	@$(call sh-template,FIG1_DIGRAPH) > $@

$/.git/hooks/pre-commit:
	@$(call sh-template,pre_commit) > $@
	chmod +x $@
	
	
$/assets/%.png: $/%.gv
	@mkdir -vp $$(dirname $@)
	dot -Tpng -o$@ $<

$/assets/%.svg: $/%.gv
	@mkdir -vp $$(dirname $@)
	dot -Tsvg -o$@ $<


$/.package.sh: $/package.yml
	@htd package update


DOCS = $/ReadMe.md $/ReadMe.html 
ASSETS = $/assets/ReadMe-fig1.svg
TRGT = $/.git/hooks/pre-commit $/ReadMe-fig1.gv $(DOCS)
TOOLING = $/Makefile $/.package.sh

$(TRGT): $(TOOLING) templates.mk
$(ASSETS): $(TOOLING)

check: $(TOOLING)
	git-versioning check

build: $(ASSETS) $(DOCS) $(TRGT)
	sh ./build.sh

doc: $(DOCS) $(ASSETS)

all: check $(TRGT)

STRGT = check default doc all build
.PHONY: $(STRGT)
