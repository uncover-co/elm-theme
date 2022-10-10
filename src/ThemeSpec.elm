module ThemeSpec exposing
    ( lightTheme, darkTheme, theme, themeSpec, ThemeSpec, ThemeSpecData, ThemeSpecColor
    , sample
    , fonts, base, primary, secondary, success, warning, danger, ThemeSpecColorVars
    )

{-| ThemeSpec is a theme specification that can be used across a variety of projects to quickly theme them based on CSS variables. Themes are scoped and multiple can be used at the same time in an application. ThemeSpec is fully compatible with darkmode and any theme can have dark variants.

@docs lightTheme, darkTheme, theme, themeSpec, ThemeSpec, ThemeSpecData, ThemeSpecColor


# Theme Sample

@docs sample


# Theme Variables

@docs fonts, base, primary, secondary, success, warning, danger, ThemeSpecColorVars

-}

import Color exposing (Color)
import Html as H
import Html.Attributes as HA
import ThemeProvider exposing (Theme)


{-| Used for turning a `ThemeSpec` into a `Theme` used by [elm-theme-provider](https://package.elm-lang.org/packages/uncover-co/elm-theme-provider/latest/).
-}
toThemeProviderTheme : ThemeSpecData -> List ( String, String ) -> Theme
toThemeProviderTheme data extra =
    let
        colorChannels : Color -> String
        colorChannels color =
            let
                c : { red : Float, green : Float, blue : Float, alpha : Float }
                c =
                    Color.toRgba color
            in
            [ c.red, c.green, c.blue ]
                |> List.map (\c_ -> c_ * 255 |> ceiling |> String.fromInt)
                |> String.join " "

        colorVars : String -> Color -> List ( String, String )
        colorVars name color =
            [ ( name, Color.toCssString color )
            , ( name ++ "-ch", colorChannels color )
            ]

        colorSpec : String -> ThemeSpecColor -> List ( String, String )
        colorSpec name color =
            [ colorVars (name ++ "-bg") color.bg
            , colorVars (name ++ "-fg") color.fg
            , colorVars (name ++ "-aux") color.aux
            ]
                |> List.concat
    in
    [ [ ( "font-title", data.fonts.title )
      , ( "font-text", data.fonts.text )
      , ( "font-code", data.fonts.code )
      ]
    , colorSpec "base" data.colors.base
    , colorSpec "primary" data.colors.primary
    , colorSpec "secondary" data.colors.secondary
    , colorSpec "success" data.colors.success
    , colorSpec "warning" data.colors.warning
    , colorSpec "danger" data.colors.danger
    , extra
    ]
        |> List.concat
        |> List.map (Tuple.mapFirst ((++) "tmspc-"))
        |> ThemeProvider.fromList


{-| -}
type ThemeSpec
    = ThemeSpec
        { theme : ThemeProvider.Theme
        , data : ThemeSpecData
        }


{-| -}
type alias ThemeSpecData =
    { fonts :
        { title : String
        , text : String
        , code : String
        }
    , colors :
        { base : ThemeSpecColor
        , primary : ThemeSpecColor
        , secondary : ThemeSpecColor
        , success : ThemeSpecColor
        , warning : ThemeSpecColor
        , danger : ThemeSpecColor
        }
    }


{-| -}
type alias ThemeSpecColor =
    { bg : Color
    , fg : Color
    , aux : Color
    }


{-| -}
themeSpec : ThemeSpecData -> List ( String, String ) -> ThemeSpec
themeSpec data extra =
    ThemeSpec
        { theme = toThemeProviderTheme data extra
        , data = data
        }


{-| -}
theme : ThemeSpec -> Theme
theme (ThemeSpec spec) =
    spec.theme



-- Default Themes


{-| -}
lightTheme : ThemeSpec
lightTheme =
    themeSpec
        { fonts =
            { title = "system-ui, sans-serif"
            , text = "system-ui, sans-serif"
            , code = "monospace"
            }
        , colors =
            { base =
                { bg = Color.rgb255 253 253 253
                , fg = Color.rgb255 62 62 62
                , aux = Color.rgb255 150 150 150
                }
            , primary =
                { bg = Color.rgb255 0 141 235
                , fg = Color.rgb255 95 185 244
                , aux = Color.rgb255 255 255 255
                }
            , secondary =
                { bg = Color.rgb255 91 111 125
                , fg = Color.rgb255 141 160 174
                , aux = Color.rgb255 255 255 255
                }
            , success =
                { bg = Color.rgb255 68 183 1
                , fg = Color.rgb255 115 209 60
                , aux = Color.rgb255 255 255 255
                }
            , warning =
                { bg = Color.rgb255 230 157 0
                , fg = Color.rgb255 249 188 34
                , aux = Color.rgb255 255 255 255
                }
            , danger =
                { bg = Color.rgb255 220 49 50
                , fg = Color.rgb255 248 102 103
                , aux = Color.rgb255 255 255 255
                }
            }
        }
        []


{-| -}
darkTheme : ThemeSpec
darkTheme =
    themeSpec
        { fonts =
            { title = "system-ui, sans-serif"
            , text = "system-ui, sans-serif"
            , code = "monospace"
            }
        , colors =
            { base =
                { bg = Color.rgb255 37 40 48
                , fg = Color.rgb255 227 227 227
                , aux = Color.rgb255 110 114 120
                }
            , primary =
                { bg = Color.rgb255 0 153 255
                , fg = Color.rgb255 145 190 243
                , aux = Color.rgb255 255 255 255
                }
            , secondary =
                { bg = Color.rgb255 21 22 26
                , fg = Color.rgb255 255 255 255
                , aux = Color.rgb255 255 255 255
                }
            , success =
                { bg = Color.rgb255 74 200 0
                , fg = Color.rgb255 119 223 59
                , aux = Color.rgb255 27 74 0
                }
            , warning =
                { bg = Color.rgb255 251 179 0
                , fg = Color.rgb255 255 215 114
                , aux = Color.rgb255 91 65 0
                }
            , danger =
                { bg = Color.rgb255 255 77 79
                , fg = Color.rgb255 242 156 156
                , aux = Color.rgb255 91 0 1
                }
            }
        }
        []



-- CSS Variables


namespace : String
namespace =
    "tmspc"


{-| `var(--tmspc-font-title)`
-}
fonts :
    { title : String
    , text : String
    , code : String
    }
fonts =
    { title = "var(--" ++ namespace ++ "-font-title)"
    , text = "var(--" ++ namespace ++ "-font-text)"
    , code = "var(--" ++ namespace ++ "-font-code)"
    }


{-| -}
type alias ThemeSpecColorVars =
    { bg : String
    , bgChannels : String
    , fg : String
    , fgChannels : String
    , aux : String
    , auxChannels : String
    }


toColorVars : String -> ThemeSpecColorVars
toColorVars name =
    { bg = "var(--" ++ namespace ++ "-" ++ name ++ "-bg)"
    , fg = "var(--" ++ namespace ++ "-" ++ name ++ "-fg)"
    , aux = "var(--" ++ namespace ++ "-" ++ name ++ "-aux)"
    , bgChannels = "var(--" ++ namespace ++ "-" ++ name ++ "-bg-ch)"
    , fgChannels = "var(--" ++ namespace ++ "-" ++ name ++ "-fg-ch)"
    , auxChannels = "var(--" ++ namespace ++ "-" ++ name ++ "-aux-ch)"
    }


{-| -}
base : ThemeSpecColorVars
base =
    toColorVars "base"


{-| -}
primary : ThemeSpecColorVars
primary =
    toColorVars "primary"


{-| -}
secondary : ThemeSpecColorVars
secondary =
    toColorVars "secondary"


{-| -}
success : ThemeSpecColorVars
success =
    toColorVars "success"


{-| -}
warning : ThemeSpecColorVars
warning =
    toColorVars "warning"


{-| -}
danger : ThemeSpecColorVars
danger =
    toColorVars "danger"


{-| -}
sample : H.Html msg
sample =
    let
        colorVars : List ThemeSpecColorVars
        colorVars =
            [ primary
            , secondary
            , success
            , warning
            , danger
            ]

        colorSample : ThemeSpecColorVars -> H.Html msg
        colorSample color =
            H.div
                [ HA.style "display" "flex"
                , HA.style "flex-direction" "column"
                , HA.style "gap" "8px"
                , HA.style "text-align" "center"
                , HA.style "grid-column" "span 1 / span 1"
                ]
                [ H.div
                    [ HA.style "background" color.bg
                    , HA.style "border-radius" "4px"
                    , HA.style "box-shadow" ("0 0 6px rgb(" ++ color.bgChannels ++ " / .8)")
                    , HA.style "color" color.aux
                    , HA.style "padding" "8px 12px"
                    ]
                    [ H.text "Button" ]
                , H.div
                    [ HA.style "color" color.fg
                    , HA.style "border" ("3px solid " ++ color.fg)
                    , HA.style "border-radius" "4px"
                    , HA.style "padding" "8px 12px"
                    ]
                    [ H.text "Text" ]
                , H.div
                    [ HA.style "background" ("rgb( " ++ color.fgChannels ++ " / 0.1)")
                    , HA.style "border-radius" "4px"
                    , HA.style "color" color.fg
                    , HA.style "padding" "8px 12px"
                    ]
                    [ H.text "Text" ]
                ]
    in
    H.article
        [ HA.style "padding" "20px"
        , HA.style "background" ("linear-gradient(rgba(0,0,0,0.1), rgba(0,0,0,0.1)), " ++ base.bg)
        ]
        [ H.section
            [ HA.style "border-radius" "4px"
            , HA.style "padding" "20px"
            , HA.style "background" base.bg
            , HA.style "box-shadow" "0 0 8px rgba(0, 0, 0, 0.1)"
            , HA.style "font-family" fonts.text
            , HA.style "color" base.fg
            ]
            [ H.div
                [ HA.style "display" "grid"
                , HA.style "grid-template-columns" "repeat(2, minmax(0, 1fr))"
                , HA.style "gap" "20px"
                , HA.style "width" "100%"
                ]
                (H.div
                    [ HA.style "grid-column" "span 1 / span 1"
                    , HA.style "display" "flex"
                    , HA.style "flex-direction" "column"
                    , HA.style "gap" "8px"
                    ]
                    [ H.h1
                        [ HA.style "font-family" fonts.title
                        , HA.style "color" base.fg
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
                        , HA.style "color" base.aux
                        , HA.style "font-family" fonts.code
                        ]
                        [ H.text "Use accessibility ratings for making sure your theme works for everyone." ]
                    ]
                    :: List.map colorSample colorVars
                )
            ]
        ]
