module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task


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
  , defaultGif : String
  , isFetching : Bool
  }

init : String -> (Model, Cmd Msg)
init topic =
  let
    defaultGif =
      "http://www.chefdtv.com/wp-content/themes/culinier-theme/images/loader.gif"
  in
    (Model topic defaultGif defaultGif False, getRandomGif topic)



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
    img_src =
      if model.isFetching then model.defaultGif else model.gifUrl
  in
    div [ class "container"]
        [ div [ class "row" ]
              [ div [ class "ten columns" ]
                    [ label [for "tagInput"] [ text "Search random Gif by name" ]
                    , input [ onInput HandleInputChange, value model.topic, class "u-full-width", id "tagInput", type' "search" ] []
                    ]
              , div [ class "two columns" ]
                    [ button [onClick MorePlease, style [("margin-top", "29px")], class "u-pull-right"] [ text "One More!" ] ]
              ]
        , div [ class "row" ]
              [ div [ class "column" ]
                    [ div [ style [("max-width", "700px"), ("margin", "0 auto")]]
                          [ img [src img_src, style [("display", "block"), ("margin", "auto")]] [] ]
                    ]
              ]
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
