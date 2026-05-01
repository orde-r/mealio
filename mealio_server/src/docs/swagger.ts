import fs from "fs";
import path from "path";
import YAML from "yaml";

const openApiSpecPath = path.resolve(process.cwd(), "src/docs/openapi.yaml");

const openApiDocument = YAML.parse(fs.readFileSync(openApiSpecPath, "utf8"));

export { openApiDocument, openApiSpecPath };
