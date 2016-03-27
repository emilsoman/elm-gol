module Grid (drawGrid, nextGrid) where
import Graphics.Element exposing (spacer, flow, right, down, color, Element)
import Color exposing (black, blue)
import List.Extra

drawCell : Int -> Bool -> Element
drawCell cellSize cellStatus =
  spacer cellSize cellSize
  |> color (if cellStatus then black else blue)

appendCell : Int -> Bool -> Element -> Element
appendCell cellSize cellStatus element =
  flow right [element, (drawCell cellSize cellStatus)]


drawRow : Int -> List Bool -> Element
drawRow cellSize list =
  List.foldl (appendCell cellSize) (spacer 0 0) list

appendRow : Int -> List Bool -> Element -> Element
appendRow cellSize row element =
  flow down [element, (drawRow cellSize row)]

sumWhenTrue : Bool -> Int -> Int
sumWhenTrue status sum =
  if status then sum+1 else sum

cellAt : Int -> Int -> List (List Bool) -> Bool
cellAt x y grid =
  let
    row = (Maybe.withDefault [] (List.head (List.drop y grid)))
  in
    Maybe.withDefault False (List.head (List.drop x row))

getNeighboringIndices : (Int, Int) -> (Int, Int) -> List (Int, Int)
getNeighboringIndices (x, y) (maxX, maxY) =
  List.Extra.lift2 (,) [x-1 .. x+1] [y-1 .. y+1]
  |> List.filter (\item -> item /= (x,y))
  |> List.filter (\(x',y') -> (List.member x' [0 .. maxX]) && (List.member y' [0 .. maxY]) )

getLiveNeighbourCount : Int -> Int -> List (List Bool) -> Int
getLiveNeighbourCount x y grid =
  let
    maxX = List.length (Maybe.withDefault [] (List.head grid))
    maxY = List.length grid
    neighbouring_indices = getNeighboringIndices (x, y) (maxX, maxY)
    neighbours = List.map (\(x,y) -> cellAt x y grid) neighbouring_indices
  in
    List.foldl sumWhenTrue 0 neighbours

nextRow : List Bool -> List (List Bool) -> List (List Bool)
nextRow row accumulatorGrid =
  accumulatorGrid

transformCell : List (List Bool) -> Int -> Int -> Bool -> Bool
transformCell grid y x state =
  let
    liveNeighbours = getLiveNeighbourCount x y grid
  in
    (liveNeighbours == 3) || (liveNeighbours == 2 && state)

transformRow : List (List Bool) -> Int -> List Bool -> List Bool
transformRow grid y row =
  List.indexedMap (transformCell grid y) row

nextGrid : List (List Bool) -> List (List Bool)
nextGrid grid =
  List.indexedMap (transformRow grid) grid

drawGrid : Int -> List (List Bool) -> Element
drawGrid cellSize grid =
  List.foldl (appendRow cellSize) (spacer 0 0) grid
