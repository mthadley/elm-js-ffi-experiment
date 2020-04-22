module Tests exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "My App"
        [ test "Should pass" <|
            \_ -> Expect.equal (2 + 2) 4
        ]
