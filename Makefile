ALL := $(patsubst %/article.html,%,$(shell find -name 'article.html'))

.PHONY: all
all: $(addsuffix /index.html,$(ALL))

$(addsuffix /index.html,$(ALL)): index.html.erb
	mkdir -p $(dir $@)

	MNGW_DIR=$(dir $@) \
		erb -T - $< | \
		perl -pe 's/(id="$(subst /,\/,$(patsubst %/index.html,%,$@))")/\1 data-target="true"/g' \
		> $@
