#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { generateElmModule } = require("../lib/generate-elm-module.js");
const yargs = require("yargs");

function main(args) {
  const spec = JSON.parse(fs.readFileSync(args.specPath, "utf8"));

  const moduleSrc = generateElmModule(spec);

  if (args["dry-run"]) {
    console.log(moduleSrc);
    return;
  }

  const outputFilePath =
    path.resolve(spec.outputDir, spec.moduleName.replace(/\./g, "/")) + ".elm";

  const outputFolder = path.dirname(outputFilePath);

  if (!fs.existsSync(outputFolder))
    fs.mkdirSync(path.dirname(outputFilePath), { recursive: true });

  fs.writeFileSync(outputFilePath, moduleSrc);
}

const args = yargs
  .scriptName("elm-ffi")
  .usage("$0 [args] <secPath>")
  .command(
    "* <specPath>",
    "Generate the Elm module from interface specification.",
    cmd => {
      cmd
        .positional("specPath", {
          type: "string",
          describe: "The interface specification to generate."
        })
        .option("d", {
          alias: "dry-run",
          default: false,
          type: "boolean",
          describe: "Prints the module instead of writing it to the outputDir."
        });
    },
    args => main(args)
  )
  .help().argv;
