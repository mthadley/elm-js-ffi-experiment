module ElmFfi exposing (Error(..))

import Json.Decode


type Error
    = JsonDecodeError Json.Decode.Error
