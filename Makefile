ENVIRONMENT ?= development
OUT = dist
ELM_MAIN = $(OUT)/index.js
ELM_FILES = $(shell find src -iname "*.elm")

.PHONY: all
all: $(ELM_MAIN) $(OUT)/index.html $(OUT)/elm-ffi-browser.js $(OUT)/example-api.json

ifeq ($(ENVIRONMENT), production)
CFLAGS = --optimize
else
CFLAGS = --debug
endif

$(ELM_MAIN): $(ELM_FILES) node_modules src/Generated/ExampleApi.elm
	yes | elm make src/Main.elm $(CFLAGS) --output $@
ifeq ($(ENVIRONMENT), production)
	npx terser --mangle \
		--compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9]" \
		-o $@ -- $@
endif

$(OUT)/%: src/%
	@cp $< $@

$(OUT)/%.js: lib/%.js
	@cp $< $@

node_modules: package.json package-lock.json
	npm install
	touch $@

src/Generated/ExampleApi.elm: src/example-api.json lib/generate-elm-module.js bin/elm-ffi.js
	bin/elm-ffi.js $<

.PHONY: test
test:
	@elm-test

.PHONY: watch
watch:
	@find src | entr -c make

.PHONY: format
format:
	@elm-format --yes src/ tests/

.PHONY: clean
clean:
	@rm -fr $(OUT) elm-stuff node_modules result
