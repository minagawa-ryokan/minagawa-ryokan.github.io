ALL := $(patsubst %/article.html,%,$(shell find -name 'article.html'))

.PHONY: all
all: $(addsuffix /index.html,$(ALL)) $(addsuffix /README.md,$(ALL))

article.html: article.md meta.json article.rb
	mkdir -p $(dir $@)

	MNGW_ROOT=./ \
	MNGW_DIR=$(dir $@) \
		ruby article.rb < $< > $@

%/article.html: %/article.md %/meta.json article.rb
	mkdir -p $(dir $@)

	MNGW_ROOT=./ \
	MNGW_DIR=$(dir $@) \
		ruby article.rb < $< > $@

index.html: article.html meta.json index.html.erb
	mkdir -p $(dir $@)

	MNGW_ROOT=./ \
	MNGW_DIR=$(dir $@) \
		erb -T - index.html.erb | \
		perl -pe 's/(id="$(subst /,\/,$(patsubst %/index.html,%,$@))")/\1 data-target="true"/g' \
		> $@

%/index.html: %/article.html %/meta.json index.html.erb
	mkdir -p $(dir $@)

	MNGW_ROOT=./ \
	MNGW_DIR=$(dir $@) \
		erb -T - index.html.erb | \
		perl -pe 's/(id="$(subst /,\/,$(patsubst %/index.html,%,$@))")/\1 data-target="true"/g' \
		> $@

README.md: article.md
	cp $< $@

%/README.md: %/article.md
	cp $< $@
