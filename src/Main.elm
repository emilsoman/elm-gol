import Window
import Grid exposing (drawGrid, nextGrid)
import SeedGenerator exposing (seedGrid)
import Time

cellSize = 30
frequency = Time.millisecond
seed = 1989 -- The seed that represents the initial state of the grid

-- Calculates the grid dimensions (in terms of cell count)
-- based on the dimensions of the container
gridDimension : Signal (Int, Int)
gridDimension =
  Window.dimensions
  |> Signal.map (\(w,h) -> ((w // cellSize), (h // cellSize)))

-- Generate the state of initial grid based on seed and the window dimensions
getInitialSeed : Int -> Signal (Int, Int) -> Signal (List (List Bool))
getInitialSeed seed windowDimension =
  Signal.map (\(w,h) -> (seedGrid w h seed)) windowDimension

-- Gives the state of the new grid from its previous state
step : List (List Bool) -> List (List Bool) -> List (List Bool)
step currentGrid oldGrid =
  if List.isEmpty oldGrid then currentGrid else (nextGrid oldGrid)

-- Emits the initial grid for every x unit of time
tickingGrid : Signal (List (List Bool)) -> Signal (List (List Bool))
tickingGrid grid =
  Signal.sampleOn (Time.every frequency) grid

-- Renders the latest state of the grid
main =
  let
    initialSeed = getInitialSeed seed gridDimension
    grid = Signal.foldp step [] (tickingGrid initialSeed)
  in
  Signal.map (drawGrid cellSize) grid
