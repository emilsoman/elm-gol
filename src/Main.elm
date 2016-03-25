import Debug
import Graphics.Element exposing (..)
import Window

cellSize = 30
type alias Grid = List (List Bool)

-- Helper that debugs a signal
debugSignal name signal =
  Signal.map (Debug.watch name) signal

-- Calculates the grid dimensions (in terms of cell count)
-- based on the dimensions of the container
gridDimension : Signal (Int, Int)
gridDimension =
  Window.dimensions
  |> Signal.map (\(w,h) -> ((w // cellSize), (h // cellSize)))

-- Returns the initial state of the Grid
--seed : Signal (Int, Int) -> Signal Grid
seed : (Int, Int) -> Grid
seed (w, h) =
  List.repeat h (List.repeat w False)

-- Given a state of the grid, draws an element
-- to represent its state
drawGrid : Grid -> Element
drawGrid grid =
  show grid

--Function that accepts a grid of boolean values
--and generates the next step in the lifetime of the grid
step : Grid -> Grid
step list =
  list

main : Signal Element
main =
  gridDimension
  |> debugSignal "Gridsize"
  |> Signal.map seed
  |> Signal.map drawGrid
