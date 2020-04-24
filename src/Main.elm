module Main exposing (main)

import Browser
import ElmFfi
import Generated.ExampleApi as ExampleApi
import Html exposing (..)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as Decode


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = \msg model -> ( update msg model, Cmd.none )
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Flags =
    { exampleApi : Decode.Value }


type alias Model =
    { exampleApi : Result Decode.Error ExampleApi.Api
    , locale : String
    }


init : Flags -> ( Model, Cmd Msg )
init { exampleApi } =
    ( { exampleApi = Decode.decodeValue ExampleApi.decode exampleApi
      , locale = "en"
      }
    , Cmd.none
    )



-- VIEW


view : Model -> Html Msg
view model =
    main_
        []
        [ h1 [] [ text "Calling Foreign JavaScript Functions" ]
        , section []
            [ h2 [] [ text "Settings" ]
            , label []
                [ text "Locale"
                , select
                    [ Events.on "change"
                        (Decode.at [ "target", "value" ] Decode.string
                            |> Decode.map SelectLocale
                        )
                    ]
                    ([ ( "English", "en" )
                     , ( "French", "fr" )
                     , ( "Japanese", "ja" )
                     ]
                        |> List.map
                            (\( label, value ) ->
                                option [ Attributes.value value ] [ text label ]
                            )
                    )
                ]
            ]
        , section []
            [ h2 [] [ text "Output" ]
            , case model.exampleApi of
                Ok api ->
                    table []
                        [ thead []
                            [ tr []
                                [ th [] [ text "Function" ]
                                , th [] [ text "Output" ]
                                ]
                            ]
                        , tbody []
                            [ tr []
                                [ td [] [ text "Intl.NumberFormat" ]
                                , td []
                                    [ ExampleApi.formatCurrency api model.locale 4000
                                        |> Result.withDefault ""
                                        |> text
                                    ]
                                ]
                            , tr []
                                [ td [] [ text "Intl.formatRelativeTime" ]
                                , td []
                                    [ ExampleApi.formatRelativeTime api model.locale 5 "days"
                                        |> Result.withDefault ""
                                        |> text
                                    ]
                                ]
                            ]
                        ]

                Err err ->
                    text <| "Failed to initialize foreign api: " ++ Decode.errorToString err
            ]
        ]



-- UPDATE


type Msg
    = SelectLocale String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SelectLocale locale ->
            { model | locale = locale }
