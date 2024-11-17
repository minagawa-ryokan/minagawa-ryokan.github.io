ALL := $(patsubst %/article.html,%,$(shell find -name 'article.html'))

.PHONY: all
all: $(addsuffix /index.html,$(ALL))

%/article.html: %/article.md %/meta.json article.rb
	mkdir -p $(dir $@)
	MNGW_DIR=$(dir $@) ruby article.rb < $< > $@

index.html: article.html index.html.erb
	mkdir -p $(dir $@)

	MNGW_ROOT=./ \
	MNGW_DIR=$(dir $@) \
		erb -T - index.html.erb | \
		perl -pe 's/(id="$(subst /,\/,$(patsubst %/index.html,%,$@))")/\1 data-target="true"/g' \
		> $@

%/index.html: %/article.html index.html.erb
	mkdir -p $(dir $@)

	MNGW_ROOT=./ \
	MNGW_DIR=$(dir $@) \
		erb -T - index.html.erb | \
		perl -pe 's/(id="$(subst /,\/,$(patsubst %/index.html,%,$@))")/\1 data-target="true"/g' \
		> $@
