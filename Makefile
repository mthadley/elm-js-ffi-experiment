OUT = dist
ELM_MAIN = $(OUT)/index.js
ELM_FILES = $(shell find src -iname "*.elm")
GENERATED_ELM_FILES = $(shell jq -r '.outputDir + "/" + .moduleName | gsub("\\."; "/") + ".elm"' src/example-api.json)

.PHONY: all
all: $(ELM_MAIN) $(OUT)/index.html $(OUT)/elm-ffi-browser.js $(OUT)/example-api.json

$(ELM_MAIN): $(ELM_FILES) $(GENERATED_ELM_FILES) node_modules
	yes | elm make src/Main.elm $(CFLAGS) --output $@

$(OUT)/%: src/%
	@cp $< $@

$(OUT)/%.js: lib/%.js
	@cp $< $@

node_modules: package.json package-lock.json
	npm install
	touch $@

src/Generated/%: src/example-api.json lib/generate-elm-module.js bin/elm-ffi.js
	bin/elm-ffi.js $<

.PHONY: watch
watch:
	@find src | entr -c make

.PHONY: clean
clean:
	@rm -fr $(OUT) elm-stuff node_modules result src/Generated
