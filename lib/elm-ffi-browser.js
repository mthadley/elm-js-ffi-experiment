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
  if (!spec.parameters.length) return fn();

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
