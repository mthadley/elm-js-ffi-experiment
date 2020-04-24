module ElmFfi exposing (Error(..))

import Json.Decode


{-| The types of errors that can happen when calling a foreign function:

  - `JsonDecodeError`: There was a problem decoding the function's return value.
  - `FunctionCallError`: The function threw some kind of error.

-}
type Error
    = JsonDecodeError Json.Decode.Error
    | FunctionCallError String
