An experiment in synchronously calling JavaScript functions using
[Proxies](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy) and
Elm's [json decoders](https://guide.elm-lang.org/effects/json.html).

Should you try to use this pattern in your own programs? **Definitely not**.
This is really just a funny idea I had, and wanted to see if it would actually work.
It sort of does, but it's more of a hack or exploit, rather than a legitimate
alternative to ports or custom elements.
