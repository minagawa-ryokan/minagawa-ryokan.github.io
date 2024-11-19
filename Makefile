ALL := $(patsubst %/article.md,%,$(shell find -name 'article.md'))

.PHONY: all
all:	$(addsuffix /article.html,$(ALL)) \
	$(addsuffix /index.html,$(ALL)) \
	$(addsuffix /README.md,$(ALL))

article.html: article.md meta.json article.html.rb
	mkdir -p $(dir $@)

	MNGW_ROOT=./ \
	MNGW_DIR=$(dir $@) \
		ruby article.html.rb < $< > $@

%/article.html: %/article.md %/meta.json article.html.rb
	mkdir -p $(dir $@)

	MNGW_ROOT=./ \
	MNGW_DIR=$(dir $@) \
		ruby article.html.rb < $< > $@

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
