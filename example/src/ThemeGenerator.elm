module ThemeGenerator exposing (Model, Msg, init, update, view)

import Color
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import SolidColor
import SolidColor.Accessibility
import Theme


type alias Model =
    Theme.ThemeData


init : Model
init =
    Theme.lightTheme
        |> Theme.toThemeData


type Msg
    = DoNothing
    | Update ThemeColor ThemeColorDetail String


type ThemeColor
    = Base
    | Primary
    | Secondary
    | Neutral
    | Success
    | Danger
    | Warning


type ThemeColorDetail
    = Background
    | Foreground
    | Aux


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoNothing ->
            model

        Update color detail value ->
            case color of
                Base ->
                    { model | base = updateColor model.base detail value }

                Primary ->
                    { model | primary = updateColor model.primary detail value }

                Secondary ->
                    { model | secondary = updateColor model.secondary detail value }

                Neutral ->
                    { model | neutral = updateColor model.neutral detail value }

                Success ->
                    { model | success = updateColor model.success detail value }

                Danger ->
                    { model | danger = updateColor model.danger detail value }

                Warning ->
                    { model | warning = updateColor model.warning detail value }


updateColor : Theme.ThemeColorSet -> ThemeColorDetail -> String -> Theme.ThemeColorSet
updateColor colorSet detail value =
    case detail of
        Background ->
            { colorSet | background = fromHex value }

        Foreground ->
            { colorSet | foreground = fromHex value }

        Aux ->
            { colorSet | aux = fromHex value }


view : Model -> H.Html Msg
view model =
    let
        theme : Theme.Theme
        theme =
            Theme.new model

        colorVars : List ( ThemeColor, Theme.ThemeColorSet, Theme.ThemeColorSetValues )
        colorVars =
            [ ( Neutral, model.neutral, Theme.neutral )
            , ( Primary, model.primary, Theme.primary )
            , ( Secondary, model.secondary, Theme.secondary )
            , ( Success, model.success, Theme.success )
            , ( Warning, model.warning, Theme.warning )
            , ( Danger, model.danger, Theme.danger )
            ]

        baseBg : SolidColor.SolidColor
        baseBg =
            toSolidColor model.base.background

        baseFg : SolidColor.SolidColor
        baseFg =
            toSolidColor model.base.foreground

        baseAux : SolidColor.SolidColor
        baseAux =
            toSolidColor model.base.aux
    in
    Theme.provider theme
        []
        [ H.article
            [ HA.style "padding" "20px"
            , HA.style "background" ("linear-gradient(rgba(0,0,0,0.1), rgba(0,0,0,0.1)), " ++ Theme.baseBackground)
            ]
            [ H.section
                [ HA.style "border-radius" "4px"
                , HA.style "padding" "20px"
                , HA.style "background" Theme.baseBackground
                , HA.style "box-shadow" "0 0 8px rgba(0, 0, 0, 0.1)"
                , HA.style "font-family" Theme.fontText
                , HA.style "color" Theme.baseForeground
                ]
                [ H.div
                    [ HA.style "display" "grid"
                    , HA.style "grid-template-columns" "repeat(2, minmax(0, 1fr))"
                    , HA.style "gap" "20px"
                    , HA.style "width" "100%"
                    ]
                    (H.div
                        [ HA.style "display" "flex"
                        , HA.style "flex-direction" "column"
                        , HA.style "gap" "8px"
                        , HA.style "padding-bottom" "12px"
                        ]
                        [ H.h1
                            [ HA.style "font-family" Theme.fontHeading
                            , HA.style "color" Theme.baseForeground
                            , HA.style "font-size" "20px"
                            , HA.style "margin" "0"
                            ]
                            [ H.text "Theme Sample"
                            ]
                        , H.p
                            [ HA.style "margin" "0" ]
                            [ H.text "All theme colors and contrasts are displayed here." ]
                        , H.p
                            [ HA.style "margin" "0"
                            , HA.style "font-size" "14px"
                            , HA.style "color" Theme.baseAux
                            , HA.style "font-family" Theme.fontCode
                            ]
                            [ H.text "Use accessibility ratings for making sure your theme works for everyone." ]
                        ]
                        :: H.div []
                            [ input baseBg (Update Base Background)
                            , input baseFg (Update Base Foreground)
                            , a11yStatus baseFg baseBg
                            , input baseAux (Update Base Aux)
                            , a11yStatus baseAux baseBg
                            ]
                        :: List.map (colorSample baseBg Update) colorVars
                    )
                ]
            ]
        ]


input : SolidColor.SolidColor -> (String -> Msg) -> H.Html Msg
input color msg =
    H.div []
        [ H.input
            [ HA.type_ "color"
            , HA.value (SolidColor.toHex color)
            , HE.onInput msg
            ]
            []
        , H.p [ HA.style "font-size" "12px" ] [ H.text (SolidColor.toHex color) ]
        , H.p [ HA.style "font-size" "12px" ] [ H.text (SolidColor.toRGBString color) ]
        ]


toSolidColor : Color.Color -> SolidColor.SolidColor
toSolidColor color =
    color
        |> Color.toRgba
        |> (\{ red, green, blue } -> ( red * 255, green * 255, blue * 255 ))
        |> SolidColor.fromRGB


fromSolidColor : SolidColor.SolidColor -> Color.Color
fromSolidColor color =
    color
        |> SolidColor.toRGB
        |> (\( r, g, b ) -> Color.rgb255 (floor r) (floor g) (floor b))


fromHex : String -> Color.Color
fromHex hex =
    SolidColor.fromHex hex
        |> Result.map fromSolidColor
        |> Result.withDefault Color.black


toHex : Color.Color -> String
toHex color =
    color
        |> toSolidColor
        |> SolidColor.toHex


a11yStatus : SolidColor.SolidColor -> SolidColor.SolidColor -> H.Html msg
a11yStatus fg bg =
    H.div []
        [ case SolidColor.Accessibility.checkContrast { fontSize = 12, fontWeight = 500 } fg bg of
            SolidColor.Accessibility.Inaccessible ->
                H.text "X"

            SolidColor.Accessibility.AA ->
                H.text "AA"

            SolidColor.Accessibility.AAA ->
                H.text "AAA"
        , H.text " "
        , H.text (String.fromFloat <| SolidColor.Accessibility.contrast fg bg)
        ]


colorSample : SolidColor.SolidColor -> (ThemeColor -> ThemeColorDetail -> String -> Msg) -> ( ThemeColor, Theme.ThemeColorSet, Theme.ThemeColorSetValues ) -> H.Html Msg
colorSample baseBg msg ( themeColor, color_, color ) =
    let
        bg : SolidColor.SolidColor
        bg =
            toSolidColor color_.background

        fg : SolidColor.SolidColor
        fg =
            toSolidColor color_.foreground

        aux : SolidColor.SolidColor
        aux =
            toSolidColor color_.aux
    in
    H.div
        [ HA.style "display" "flex"
        , HA.style "gap" "8px"
        ]
        [ H.div
            [ HA.style "display" "flex"
            , HA.style "flex-direction" "column"
            , HA.style "gap" "8px"
            , HA.style "text-align" "center"
            ]
            [ H.div
                [ HA.style "background" color.background
                , HA.style "border-radius" "4px"
                , HA.style "box-shadow" ("0 0 6px " ++ color.backgroundWithAlpha 0.8 ++ ")")
                , HA.style "color" color.aux
                , HA.style "padding" "8px 12px"
                ]
                [ H.text "Aux on Background"
                , a11yStatus aux bg
                ]
            , H.div
                [ HA.style "color" color.foreground
                , HA.style "border" ("3px solid " ++ color.foreground)
                , HA.style "border-radius" "4px"
                , HA.style "padding" "8px 12px"
                ]
                [ H.text "Foreground on Base Background"
                , a11yStatus fg baseBg
                ]
            ]
        , H.div
            [ HA.style "display" "flex"
            , HA.style "flex-direction" "column"
            , HA.style "gap" "8px"
            ]
            [ input bg (msg themeColor Background)
            , input fg (msg themeColor Foreground)
            , input aux (msg themeColor Aux)
            ]
        ]
