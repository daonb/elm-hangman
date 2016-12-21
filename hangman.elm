import Html exposing (Html, div, h1, h2, input, text, ul, li)
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
  = Guess String


mapLetter : Letter -> (List Letter, Int, Char) -> (List Letter, Int, Char)
mapLetter letter (letters, hits, guess) =
    let
        hit = (letter.letter == guess) && (not letter.guessed)
        new_letter = case hit of
            False -> letter
            True -> { letter | guessed = True }
        new_letters = letters ++ [ new_letter ]
        new_hits = case hit of
            False -> hits
            True -> hits + 1
    in
       (new_letters, new_hits, guess)


update : Msg -> Model -> Model
update msg model =
  case msg of
    Guess guess_str ->
        case String.uncons (String.reverse guess_str) of
            Just (c, rest) -> cleanUpdate c model
            Nothing -> model

cleanUpdate : Char -> Model -> Model
cleanUpdate guess model =
    let
        (new_letters, hits, same_guess) =
            List.foldl mapLetter ([], 0, guess) model.letters
        new_misses = case hits > 0 of
            True -> model.misses
            False -> model.misses + 1
    in
        { model |
            misses = new_misses,
            letters = new_letters
        }


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [
      h1 [] [ text "Hangman" ]
      , h2 [] [ text (toString model.misses) ]
      , stage model
      , input [ placeholder "Guess", onInput Guess ] []
      , div [] [ text "TBD" ]
    ]

ulStyle =
  style
    [ ("list-style-type", "none") ,
      ("width", "100%"),
      ("margin", "2em auto")]
liStyle =
  style
    [ ("float", "left") ]

stage: Model-> Html Msg
stage model =
    ul [ ulStyle ] (List.map letter_view model.letters)

letter_view: Letter -> Html Msg
letter_view letter =
    let
        the_letter =
            case letter.guessed of
                True -> String.fromChar letter.letter
                False -> "-"
    in
        li [ liStyle ] [text the_letter]

