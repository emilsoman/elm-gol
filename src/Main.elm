module Main where
import Html exposing (text)
import Color exposing (rgb)
import Text
import Graphics.Element exposing (..)

main =
  Text.fromString "Hello World"
      |> Text.color (rgb 52 152 219)
      |> Text.italic
      |> Text.bold
      |> Text.height 60
      |> leftAligned
