module GameOfLife.IO exposing (..)

import GameOfLife.Types exposing (..)

import Json.Decode as JD exposing ((:=))

boardUpdateDecoder : JD.Decoder Board
boardUpdateDecoder =
    JD.object3 Board
        ("generationNumber" := JD.int)
        ("size" := pointDecoder)
        ("aliveCells" := JD.list pointDecoder)

pointDecoder : JD.Decoder Point
pointDecoder =
  JD.tuple2 (,) JD.int JD.int