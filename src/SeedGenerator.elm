module SeedGenerator (seedGrid) where
import Random

seedRow : Int -> Random.Seed -> (List Bool, Random.Seed)
seedRow x seed =
  let
    generator = Random.list x Random.bool
  in
    Random.generate generator seed

addRow n x list seed =
  case n of
    0 -> list
    y ->
      let
        (row, newSeed) = seedRow x seed
      in
        addRow (n-1) x (row::list) newSeed

stillLife =
  [
    [False, False, False, False],
    [False, True, True, False],
    [False, True, True, False],
    [False, False, False, False]
  ]

oscillator =
  [
    [False, False, False, False, False],
    [False, False, True, False, False],
    [False, False, True, False, False],
    [False, False, True, False, False],
    [False, False, False, False, False]
  ]

spaceship =
  [
    [False, False, False, False, False],
    [False, False, True, False, False],
    [False, False, False, True, False],
    [False, True, True, True, False],
    [False, False, False, False, False]
  ]

padGrid : Int -> List Bool -> List Bool
padGrid x row =
  let
    paddingValues = List.repeat (x - (List.length row)) False
  in
    List.append row paddingValues

useTemplate : List (List Bool) -> Int -> Int -> List (List Bool)
useTemplate templateGrid maxX maxY =
  let
    emptyRow = List.repeat maxX False
    paddingRows = List.repeat (maxY - (List.length templateGrid)) emptyRow
    xPaddedGrid = List.map (padGrid maxX) templateGrid
  in
    List.append xPaddedGrid paddingRows

seedGrid : Int -> Int -> Int -> List (List Bool)
seedGrid x y seedInt =
  let
    initialSeed = Random.initialSeed seedInt
  in
    -- Uncomment this line to use one of above templates (stillLife, oscillator, spaceship)
    --useTemplate spaceship x y

    -- Use the random seed as starting state
    -- Comment this line if using a template above
    addRow y x [] initialSeed
