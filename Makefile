ALL := \
  top \
  about \
  lineup \
  news \
  news/c105 \
  news/tenshinokokuhaku-experimental \
  schedule \
  games \
  games/tenshinokokuhaku \
  games/hinjanohokori \
  games/hitonomukuro \
  music \
  music/dont-let-me-remember \
  music/minagawa-teiri-ch \
  memorial \
  memorial/2024-11-10 \
  skeb \
  skeb/2024-11-09 \
  skeb/2024-10-16 \
  skeb/2024-10-12 \
  skeb/2024-09-06 \
  skeb/2024-08-18 \
  skeb/2024-08-06 \
  skeb/2024-07-13 \
  skeb/2024-02-16 \
  skeb/2023-08-24 \
  skeb/2023-06-23 \
  skeb/2023-05-17

.PHONY: all
all: $(addsuffix /index.html,$(ALL))

$(addsuffix /index.html,$(ALL)): index.html
	mkdir -p $(dir $@)
	perl -pe 's/(id="$(subst /,\/,$(patsubst %/index.html,%,$@))")/\1 data-target="true"/g' $< > $@
