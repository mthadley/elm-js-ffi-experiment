module Main exposing (main)

import Browser
import ElmFfi
import Generated.ExampleApi as ExampleApi
import Html exposing (..)
import Json.Decode as Decode


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Flags =
    { exampleApi : Decode.Value }


type alias Model =
    { exampleApi : Result Decode.Error ExampleApi.Api
    }


init : Flags -> ( Model, Cmd Msg )
init { exampleApi } =
    ( Model (Decode.decodeValue ExampleApi.decode exampleApi)
    , Cmd.none
    )



-- VIEW


view : Model -> Html Msg
view model =
    main_
        []
        [ case model.exampleApi of
            Ok api ->
                div []
                    [ text <| Debug.toString (ExampleApi.randomNumber api)
                    , text <| Debug.toString (ExampleApi.formatRelativeTime api 2 "day")
                    ]

            Err err ->
                text <| "Failed to initialize program: " ++ Decode.errorToString err
        ]



-- UPDATE


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )
