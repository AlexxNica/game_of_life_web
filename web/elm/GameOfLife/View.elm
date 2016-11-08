module GameOfLife.View exposing (view)

import GameOfLife.Types exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes as H exposing (..)

view : Model -> Html Msg
view model =
  div []
    [ controlPanel model
    , boardView model.board
    ]

controlPanel : Model -> Html Msg
controlPanel model =
  div [ class "row" ]
    [ div [ class "col-md-2" ] [text ("generationNumber " ++ (toString model.board.generationNumber))]
    , div [ class "col-md-1" ] [ connectButtonView model.channelState ]
    , div [ class "col-md-2" ] [ tickerButton model.ticker.state ]
    , div [ class "col-md-2" ]  [ (tickerSlider model.tickerSliderPosition)
                                , text <| toString model.tickerSliderPosition ]
    ]

tickerSlider : Int -> Html  Msg
tickerSlider tickerSliderPosition =
  input
    [ type' "range"
    , H.min "100"
    , H.max "5000"
    , value <| toString tickerSliderPosition
    , onInput UpdateTickerInterval
    ] []

boardView : Board -> Html Msg
boardView board =
  div [ class "row"]
    [div [ class "boardContainer col-md-12" ]
      [ div [ class "board", boardStyle board.size]
          (aliveCellsView board.aliveCells)
      ]]

aliveCellsView : List Point -> List (Html Msg)
aliveCellsView aliveCells =
    List.map aliveCellView aliveCells

boardStyle : Point -> Attribute Msg
boardStyle (x,y) =
  style
    [ ("width", toString(x) ++ "em")
    , ("height", toString(y) ++ "em")
    ]

aliveCellView : Point -> Html Msg
aliveCellView cell =
  i [class "cell fa fa-bug", cellStyle cell] []

cellStyle : Point -> Attribute Msg
cellStyle (x,y) =
  style
    [ ("bottom", toString(y) ++ "em")
    , ("left", toString(x) ++ "em")
    ]

connectButtonView : ChannelState -> Html Msg
connectButtonView state =
  case state of
    Disconnected  -> button [ onClick JoinChannel, buttonClass state ]   [ text "Connect" ]
    Connected     -> button [ onClick LeaveChannel, buttonClass state ]  [ text "Disconnect" ]
    Connecting    -> button [ buttonClass state ] [ text "Connecting.." ]
    Disconnecting -> button [ buttonClass state ] [ text "Disonnecting.." ]

buttonClass : ChannelState -> Attribute Msg
buttonClass state =
  class (case state of
          Disconnected  -> "btn btn-success"
          Connected     -> "btn btn-danger"
          _             -> "btn btn-warning")

tickerButton : TickerState -> Html Msg
tickerButton state =
  case state of
    Started -> button [ class "btn btn-danger", onClick StopTicker ] [text "Stop"]
    RequestingStop -> button [ class "btn btn-warning", onClick StopTicker ] [text "Requesting stop"]
    Stopped -> button [ class "btn btn-success", onClick StartTicker ] [text "Start"]
    RequestingStart -> button [ class "btn btn-warning", onClick StartTicker ] [text "Requesting start"]
    _       -> button [ class "hide" ] []
