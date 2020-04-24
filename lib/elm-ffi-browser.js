/**
 * Creates an "implementation" for your elm-ffi API. This takes two
 * arguments:
 *
 * 1. The API specification, which should be the same configuration
 *    file that was based to the elm-ffi command line too.
 * 2. The actual functions used to implement your API. This should be an
 *    object whose keys match the names of the functions in the spec, and
 *    values that are functions which match the signature described in the
 *    spec for each function.
 */
export function createImplementation(spec, functions) {
  return new Proxy(
    { __api: spec.moduleName },
    {
      get(obj, target) {
        if (target === "__api") return obj[target];

        const fnSpec = spec.functions[target];
        const fn = functions[target];

        if (!(fnSpec && fn))
          throw new Error(`Function spec not found for "${target}"`);

        return makeFnProxy(fnSpec, fn);
      },

      has() {
        return true;
      }
    }
  );
}

function makeFnProxy(spec, fn) {
  if (!spec.parameters.length) {
    try {
      return { value: fn() };
    } catch (e) {
      return { error: e.toString() };
    }
  }

  return new Proxy(
    {},
    {
      get(obj, target) {
        const [nextParam, ...parameters] = spec.parameters;

        return makeFnProxy(
          {
            ...spec,
            parameters
          },
          fn.bind(this, parseParam(nextParam, target))
        );
      },

      has() {
        return true;
      }
    }
  );
}

function parseParam(type, value) {
  switch (type) {
    case "float":
      return Number(value);
    case "int":
      return Number(value);
    case "string":
      return value;
    default:
      throw new TypeError(`"${type}" is not a valid type.`);
  }
}
