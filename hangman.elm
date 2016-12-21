import Html exposing (Html, div, h1, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String



main =
  Html.beginnerProgram
    { model = initialModel
    , view = view
    , update = update
    }



-- MODEL

type alias Letter =
    { guessed : Bool,
      letter : Char
    }

type alias Model =
  { misses : Int,
    target : String,
    letters : List Letter
  }


toLetter : Char -> Letter
toLetter c =
    Letter False c

initialModel : Model
initialModel =
  { misses = 0, target = "hangman", letters = List.map toLetter ['h','a','n','g','m','a','n'] }



-- UPDATE


type Msg
  = Change String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      model



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [
      h1 [] [ text "Hangman" ]
      , input [ placeholder "Text to reverse", onInput Change ] []
      , div [] [ text "TBD" ]
    ]

