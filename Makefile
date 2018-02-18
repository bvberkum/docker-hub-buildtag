default: all
	
include templates.mk

sh-template = { echo 'cat <<EOM' ; echo "$$$(1)" ; echo 'EOM' ; } |  ENV=./.package.sh sh -i -


/ := ./

$/%.html: $/%.md
	pandoc $< -t html > $@

$/%.md: $/%.txt
	@$(call sh-template,ReadMe_md) > $@

#$/%.rst: $/%.txt
#	@$(call sh-template,ReadMe_rst) > $@

$/ReadMe-fig1.gv:
	{ echo 'cat <<EOM' ; echo "$$FIG1_DIGRAPH" ; echo 'EOM' ; } |  ENV=./.package.sh sh -i -
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

build: $(ASSETS) $(DOCS) $(TRGT)

doc: $(DOCS) $(ASSETS)

all: $(TRGT)

STRGT = default doc all build
.PHONY: $(STRGT)
