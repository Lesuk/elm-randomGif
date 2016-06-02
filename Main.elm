module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task
import Styles


main =
  Html.program
    { init = init "oops"
    , update = update
    , view = view
    , subscriptions = subscriptions
    }



-- MODEL

type alias Model =
  { topic : String
  , gifUrl : String
  , isFetching : Bool
  }

init : String -> (Model, Cmd Msg)
init topic =
  let
    defaultGif =
      "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1836550/dots24.gif"
  in
    (Model topic defaultGif False, getRandomGif topic)



-- UPDATE

type Msg
  = HandleInputChange String
  | MorePlease
  | FetchSucceed String
  | FetchFail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    HandleInputChange value ->
      ({model | topic = value, isFetching = True}, getRandomGif value)

    MorePlease ->
      ({model | isFetching = True}, getRandomGif model.topic)

    FetchSucceed newUrl ->
      ({model | gifUrl = newUrl, isFetching = False}, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)



-- VIEW

view : Model -> Html Msg
view model =
  let
    defaultGif =
      "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1836550/dots24.gif"
    img_src =
      if model.isFetching then defaultGif else model.gifUrl
  in
    div []
        [ input [onInput HandleInputChange] []
        , button [onClick MorePlease] [ text "More, please!" ]
        , br [] []
        , img [src img_src] []
        ]



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP

getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)

decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string
