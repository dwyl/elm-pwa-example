module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as JD
import Json.Encode as JE
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , capture : String
    , message : String
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url "" "", Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Capture String
    | CreateCapture
    | SaveCaptureResult (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        Capture text ->
            ( { model | capture = text }, Cmd.none )

        CreateCapture ->
            ( model, saveCapture model.capture )

        SaveCaptureResult (Ok response) ->
            ( { model | capture = "", message = "Capture saved" }, Cmd.none )

        SaveCaptureResult (Err e) ->
            ( { model | message = "The capture couldn't be saved" }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "DWYL App"
    , body =
        [ main_ [ class "pa2" ]
            [ text model.message
            , h1 [ class "tc " ] [ text "Capture" ]
            , div [ class "h-75" ]
                [ textarea
                    [ onInput Capture
                    , value model.capture
                    , class "db mb2 center w-100 w-60-l h-100 resize-none"
                    , placeholder "write down everything that is on your mind"
                    ]
                    []
                , div [ class "tc" ]
                    [ button [ class "bg-near-white bn", onClick CreateCapture ]
                        [ img [ class "pointer tc center", src "/assets/images/submit.png" ] []
                        ]
                    ]
                ]
            ]
        ]
    }



-- Capture


saveCapture : String -> Cmd Msg
saveCapture capture =
    Http.post
        { url = "https://dwylapp.herokuapp.com/api/captures/create"
        , body = Http.jsonBody (captureEncode capture)
        , expect = Http.expectJson SaveCaptureResult captureDecoder
        }


captureEncode : String -> JE.Value
captureEncode capture =
    JE.object [ ( "text", JE.string capture ) ]


captureDecoder : JD.Decoder String
captureDecoder =
    JD.field "text" JD.string
