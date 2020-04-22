OUT = dist
ELM_MAIN = $(OUT)/index.js
ELM_FILES = $(shell find src -iname "*.elm")

.PHONY: all
all: $(ELM_MAIN) $(OUT)/index.html $(OUT)/elm-ffi-browser.js $(OUT)/example-api.json

$(ELM_MAIN): $(ELM_FILES) node_modules src/Generated/ExampleApi.elm
	yes | elm make src/Main.elm $(CFLAGS) --output $@

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
	@rm -fr $(OUT) elm-stuff node_modules result src/Generated
