module Theme exposing
    ( DarkModeStrategy
    , Theme
    , baseAux
    , baseAuxWithAlpha
    , baseBackground
    , baseBackgroundWithAlpha
    , baseForeground
    , baseForegroundWithAlpha
    , dangerAux
    , dangerAuxWithAlpha
    , dangerBackground
    , dangerBackgroundWithAlpha
    , dangerForeground
    , dangerForegroundWithAlpha
    , darkTheme
    , fontCode
    , fontText
    , fontTitle
    , fromTheme
    , globalProvider
    , globalProviderWithDarkMode
    , lightTheme
    , new
    , optimizedTheme
    , optimizedThemeWithDarkMode
    , primaryAux
    , primaryAuxWithAlpha
    , primaryBackground
    , primaryBackgroundWithAlpha
    , primaryForeground
    , primaryForegroundWithAlpha
    , provider
    , providerWithDarkMode
    , sample
    , secondaryAux
    , secondaryAuxWithAlpha
    , secondaryBackground
    , secondaryBackgroundWithAlpha
    , secondaryForeground
    , secondaryForegroundWithAlpha
    , successAux
    , successAuxWithAlpha
    , successBackground
    , successBackgroundWithAlpha
    , successForeground
    , successForegroundWithAlpha
    , toTheme
    , warningAux
    , warningAuxWithAlpha
    , warningBackground
    , warningBackgroundWithAlpha
    , warningForeground
    , warningForegroundWithAlpha
    , withBase
    , withBaseAux
    , withBaseBackground
    , withBaseForeground
    , withDanger
    , withDangerAux
    , withDangerBackground
    , withDangerForeground
    , withExtraValues
    , withFontCode
    , withFontText
    , withFontTitle
    , withFonts
    , withPrimary
    , withPrimaryAux
    , withPrimaryBackground
    , withPrimaryForeground
    , withSecondary
    , withSecondaryAux
    , withSecondaryBackground
    , withSecondaryForeground
    , withSuccess
    , withSuccessAux
    , withSuccessBackground
    , withSuccessForeground
    , withThemeData
    , withWarning
    , withWarningAux
    , withWarningBackground
    , withWarningForeground, classStrategy, systemStrategy
    )

import Color exposing (Color)
import Html as H
import Html.Attributes as HA
import Internal.Hash


{-| -}
type Theme
    = Theme
        { string : String
        , builder : ThemeBuilder
        }


{-| -}
type ThemeBuilder
    = ThemeBuilder
        { data : ThemeData
        , extra : List ( String, String )
        }


{-| -}
type alias ThemeData =
    { fonts : ThemeFonts
    , base : ThemeColorSet
    , primary : ThemeColorSet
    , secondary : ThemeColorSet
    , success : ThemeColorSet
    , warning : ThemeColorSet
    , danger : ThemeColorSet
    }


{-| -}
type alias ThemeFonts =
    { title : String
    , text : String
    , code : String
    }


{-| -}
type alias ThemeColorSet =
    { bg : Color
    , fg : Color
    , aux : Color
    }



-- Builder


{-| -}
new : ThemeData -> ThemeBuilder
new data =
    ThemeBuilder
        { data = data
        , extra = []
        }


{-| -}
fromTheme : Theme -> ThemeBuilder
fromTheme (Theme theme) =
    theme.builder


{-| -}
toTheme : ThemeBuilder -> Theme
toTheme builder =
    Theme
        { builder = builder
        , string = toThemeString builder
        }



-- Builder Transformations


{-| -}
withThemeData : ThemeData -> ThemeBuilder -> ThemeBuilder
withThemeData data (ThemeBuilder theme) =
    ThemeBuilder { theme | data = data }


{-| -}
withExtraValues : List ( String, String ) -> ThemeBuilder -> ThemeBuilder
withExtraValues extra (ThemeBuilder theme) =
    ThemeBuilder { theme | extra = extra }


{-| -}
withFonts : ThemeFonts -> ThemeBuilder -> ThemeBuilder
withFonts v (ThemeBuilder ({ data } as theme)) =
    ThemeBuilder { theme | data = { data | fonts = v } }


{-| -}
withFontTitle : String -> ThemeBuilder -> ThemeBuilder
withFontTitle v (ThemeBuilder ({ data } as theme)) =
    let
        fonts : ThemeFonts
        fonts =
            data.fonts
    in
    ThemeBuilder { theme | data = { data | fonts = { fonts | title = v } } }


{-| -}
withFontText : String -> ThemeBuilder -> ThemeBuilder
withFontText v (ThemeBuilder ({ data } as theme)) =
    let
        fonts : ThemeFonts
        fonts =
            data.fonts
    in
    ThemeBuilder { theme | data = { data | fonts = { fonts | text = v } } }


{-| -}
withFontCode : String -> ThemeBuilder -> ThemeBuilder
withFontCode v (ThemeBuilder ({ data } as theme)) =
    let
        fonts : ThemeFonts
        fonts =
            data.fonts
    in
    ThemeBuilder { theme | data = { data | fonts = { fonts | code = v } } }


{-| -}
withBase : ThemeColorSet -> ThemeBuilder -> ThemeBuilder
withBase v (ThemeBuilder ({ data } as theme)) =
    ThemeBuilder { theme | data = { data | base = v } }


{-| -}
withBaseForeground : Color -> ThemeBuilder -> ThemeBuilder
withBaseForeground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.base
    in
    ThemeBuilder { theme | data = { data | base = { colorSet | fg = v } } }


{-| -}
withBaseBackground : Color -> ThemeBuilder -> ThemeBuilder
withBaseBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.base
    in
    ThemeBuilder { theme | data = { data | base = { colorSet | bg = v } } }


{-| -}
withBaseAux : Color -> ThemeBuilder -> ThemeBuilder
withBaseAux v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.base
    in
    ThemeBuilder { theme | data = { data | base = { colorSet | aux = v } } }


{-| -}
withPrimary : ThemeColorSet -> ThemeBuilder -> ThemeBuilder
withPrimary v (ThemeBuilder ({ data } as theme)) =
    ThemeBuilder { theme | data = { data | primary = v } }


{-| -}
withPrimaryForeground : Color -> ThemeBuilder -> ThemeBuilder
withPrimaryForeground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.primary
    in
    ThemeBuilder { theme | data = { data | primary = { colorSet | fg = v } } }


{-| -}
withPrimaryBackground : Color -> ThemeBuilder -> ThemeBuilder
withPrimaryBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.primary
    in
    ThemeBuilder { theme | data = { data | primary = { colorSet | bg = v } } }


{-| -}
withPrimaryAux : Color -> ThemeBuilder -> ThemeBuilder
withPrimaryAux v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.primary
    in
    ThemeBuilder { theme | data = { data | primary = { colorSet | aux = v } } }


{-| -}
withSecondary : ThemeColorSet -> ThemeBuilder -> ThemeBuilder
withSecondary v (ThemeBuilder ({ data } as theme)) =
    ThemeBuilder { theme | data = { data | secondary = v } }


{-| -}
withSecondaryForeground : Color -> ThemeBuilder -> ThemeBuilder
withSecondaryForeground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.secondary
    in
    ThemeBuilder { theme | data = { data | secondary = { colorSet | fg = v } } }


{-| -}
withSecondaryBackground : Color -> ThemeBuilder -> ThemeBuilder
withSecondaryBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.secondary
    in
    ThemeBuilder { theme | data = { data | secondary = { colorSet | bg = v } } }


{-| -}
withSecondaryAux : Color -> ThemeBuilder -> ThemeBuilder
withSecondaryAux v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.secondary
    in
    ThemeBuilder { theme | data = { data | secondary = { colorSet | aux = v } } }


{-| -}
withSuccess : ThemeColorSet -> ThemeBuilder -> ThemeBuilder
withSuccess v (ThemeBuilder ({ data } as theme)) =
    ThemeBuilder { theme | data = { data | success = v } }


{-| -}
withSuccessForeground : Color -> ThemeBuilder -> ThemeBuilder
withSuccessForeground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.success
    in
    ThemeBuilder { theme | data = { data | success = { colorSet | fg = v } } }


{-| -}
withSuccessBackground : Color -> ThemeBuilder -> ThemeBuilder
withSuccessBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.success
    in
    ThemeBuilder { theme | data = { data | success = { colorSet | bg = v } } }


{-| -}
withSuccessAux : Color -> ThemeBuilder -> ThemeBuilder
withSuccessAux v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.success
    in
    ThemeBuilder { theme | data = { data | success = { colorSet | aux = v } } }


{-| -}
withDanger : ThemeColorSet -> ThemeBuilder -> ThemeBuilder
withDanger v (ThemeBuilder ({ data } as theme)) =
    ThemeBuilder { theme | data = { data | danger = v } }


{-| -}
withDangerForeground : Color -> ThemeBuilder -> ThemeBuilder
withDangerForeground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.danger
    in
    ThemeBuilder { theme | data = { data | danger = { colorSet | fg = v } } }


{-| -}
withDangerBackground : Color -> ThemeBuilder -> ThemeBuilder
withDangerBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.danger
    in
    ThemeBuilder { theme | data = { data | danger = { colorSet | bg = v } } }


{-| -}
withDangerAux : Color -> ThemeBuilder -> ThemeBuilder
withDangerAux v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.danger
    in
    ThemeBuilder { theme | data = { data | danger = { colorSet | aux = v } } }


{-| -}
withWarning : ThemeColorSet -> ThemeBuilder -> ThemeBuilder
withWarning v (ThemeBuilder ({ data } as theme)) =
    ThemeBuilder { theme | data = { data | warning = v } }


{-| -}
withWarningForeground : Color -> ThemeBuilder -> ThemeBuilder
withWarningForeground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.warning
    in
    ThemeBuilder { theme | data = { data | warning = { colorSet | fg = v } } }


{-| -}
withWarningBackground : Color -> ThemeBuilder -> ThemeBuilder
withWarningBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.warning
    in
    ThemeBuilder { theme | data = { data | warning = { colorSet | bg = v } } }


{-| -}
withWarningAux : Color -> ThemeBuilder -> ThemeBuilder
withWarningAux v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.warning
    in
    ThemeBuilder { theme | data = { data | warning = { colorSet | aux = v } } }



-- Values


{-| -}
namespace : String
namespace =
    "tmspc"


{-| -}
cssVar : String -> String
cssVar v =
    "var(--" ++ namespace ++ "-" ++ v ++ ")"


{-| -}
cssVarWithAlpha : String -> Float -> String
cssVarWithAlpha v alpha =
    "var(--" ++ namespace ++ "-" ++ v ++ "-ch / " ++ String.fromFloat alpha ++ ")"


{-| -}
fontTitle : String
fontTitle =
    cssVar "font-title"


{-| -}
fontText : String
fontText =
    cssVar "font-text"


{-| -}
fontCode : String
fontCode =
    cssVar "font-code"


{-| -}
baseForeground : String
baseForeground =
    cssVar "base-fg"


{-| -}
baseForegroundWithAlpha : Float -> String
baseForegroundWithAlpha =
    cssVarWithAlpha "base-fg"


{-| -}
baseBackground : String
baseBackground =
    cssVar "base-bg"


{-| -}
baseBackgroundWithAlpha : Float -> String
baseBackgroundWithAlpha =
    cssVarWithAlpha "base-bg"


{-| -}
baseAux : String
baseAux =
    cssVar "base-aux"


{-| -}
baseAuxWithAlpha : Float -> String
baseAuxWithAlpha =
    cssVarWithAlpha "base-aux"


{-| -}
primaryForeground : String
primaryForeground =
    cssVar "primary-fg"


{-| -}
primaryForegroundWithAlpha : Float -> String
primaryForegroundWithAlpha =
    cssVarWithAlpha "primary-fg"


{-| -}
primaryBackground : String
primaryBackground =
    cssVar "primary-bg"


{-| -}
primaryBackgroundWithAlpha : Float -> String
primaryBackgroundWithAlpha =
    cssVarWithAlpha "primary-bg"


{-| -}
primaryAux : String
primaryAux =
    cssVar "primary-aux"


{-| -}
primaryAuxWithAlpha : Float -> String
primaryAuxWithAlpha =
    cssVarWithAlpha "primary-aux"


{-| -}
secondaryForeground : String
secondaryForeground =
    cssVar "secondary-fg"


{-| -}
secondaryForegroundWithAlpha : Float -> String
secondaryForegroundWithAlpha =
    cssVarWithAlpha "secondary-fg"


{-| -}
secondaryBackground : String
secondaryBackground =
    cssVar "secondary-bg"


{-| -}
secondaryBackgroundWithAlpha : Float -> String
secondaryBackgroundWithAlpha =
    cssVarWithAlpha "secondary-bg"


{-| -}
secondaryAux : String
secondaryAux =
    cssVar "secondary-aux"


{-| -}
secondaryAuxWithAlpha : Float -> String
secondaryAuxWithAlpha =
    cssVarWithAlpha "secondary-aux"


{-| -}
successForeground : String
successForeground =
    cssVar "success-fg"


{-| -}
successForegroundWithAlpha : Float -> String
successForegroundWithAlpha =
    cssVarWithAlpha "success-fg"


{-| -}
successBackground : String
successBackground =
    cssVar "success-bg"


{-| -}
successBackgroundWithAlpha : Float -> String
successBackgroundWithAlpha =
    cssVarWithAlpha "success-bg"


{-| -}
successAux : String
successAux =
    cssVar "success-aux"


{-| -}
successAuxWithAlpha : Float -> String
successAuxWithAlpha =
    cssVarWithAlpha "success-aux"


{-| -}
warningForeground : String
warningForeground =
    cssVar "warning-fg"


{-| -}
warningForegroundWithAlpha : Float -> String
warningForegroundWithAlpha =
    cssVarWithAlpha "warning-fg"


{-| -}
warningBackground : String
warningBackground =
    cssVar "warning-bg"


{-| -}
warningBackgroundWithAlpha : Float -> String
warningBackgroundWithAlpha =
    cssVarWithAlpha "warning-bg"


{-| -}
warningAux : String
warningAux =
    cssVar "warning-aux"


{-| -}
warningAuxWithAlpha : Float -> String
warningAuxWithAlpha =
    cssVarWithAlpha "warning-aux"


{-| -}
dangerForeground : String
dangerForeground =
    cssVar "danger-fg"


{-| -}
dangerForegroundWithAlpha : Float -> String
dangerForegroundWithAlpha =
    cssVarWithAlpha "danger-fg"


{-| -}
dangerBackground : String
dangerBackground =
    cssVar "danger-bg"


{-| -}
dangerBackgroundWithAlpha : Float -> String
dangerBackgroundWithAlpha =
    cssVarWithAlpha "danger-bg"


{-| -}
dangerAux : String
dangerAux =
    cssVar "danger-aux"


{-| -}
dangerAuxWithAlpha : Float -> String
dangerAuxWithAlpha =
    cssVarWithAlpha "danger-aux"



-- Color Sets


{-| -}
type alias ThemeColorSetValues =
    { foreground : String
    , foregroundWithAlpha : Float -> String
    , background : String
    , backgroundWithAlpha : Float -> String
    , aux : String
    , auxWithAlpha : Float -> String
    }


{-| -}
base : ThemeColorSetValues
base =
    { foreground = baseForeground
    , foregroundWithAlpha = baseForegroundWithAlpha
    , background = baseBackground
    , backgroundWithAlpha = baseBackgroundWithAlpha
    , aux = baseAux
    , auxWithAlpha = baseAuxWithAlpha
    }


{-| -}
primary : ThemeColorSetValues
primary =
    { foreground = primaryForeground
    , foregroundWithAlpha = primaryForegroundWithAlpha
    , background = primaryBackground
    , backgroundWithAlpha = primaryBackgroundWithAlpha
    , aux = primaryAux
    , auxWithAlpha = primaryAuxWithAlpha
    }


{-| -}
secondary : ThemeColorSetValues
secondary =
    { foreground = secondaryForeground
    , foregroundWithAlpha = secondaryForegroundWithAlpha
    , background = secondaryBackground
    , backgroundWithAlpha = secondaryBackgroundWithAlpha
    , aux = secondaryAux
    , auxWithAlpha = secondaryAuxWithAlpha
    }


{-| -}
success : ThemeColorSetValues
success =
    { foreground = successForeground
    , foregroundWithAlpha = successForegroundWithAlpha
    , background = successBackground
    , backgroundWithAlpha = successBackgroundWithAlpha
    , aux = successAux
    , auxWithAlpha = successAuxWithAlpha
    }


{-| -}
warning : ThemeColorSetValues
warning =
    { foreground = warningForeground
    , foregroundWithAlpha = warningForegroundWithAlpha
    , background = warningBackground
    , backgroundWithAlpha = warningBackgroundWithAlpha
    , aux = warningAux
    , auxWithAlpha = warningAuxWithAlpha
    }


{-| -}
danger : ThemeColorSetValues
danger =
    { foreground = dangerForeground
    , foregroundWithAlpha = dangerForegroundWithAlpha
    , background = dangerBackground
    , backgroundWithAlpha = dangerBackgroundWithAlpha
    , aux = dangerAux
    , auxWithAlpha = dangerAuxWithAlpha
    }



-- Default Themes


{-| -}
lightTheme : Theme
lightTheme =
    { fonts =
        { title = "system-ui, sans-serif"
        , text = "system-ui, sans-serif"
        , code = "monospace"
        }
    , base =
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
        |> new
        |> toTheme


{-| -}
darkTheme : Theme
darkTheme =
    { fonts =
        { title = "system-ui, sans-serif"
        , text = "system-ui, sans-serif"
        , code = "monospace"
        }
    , base =
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
        |> new
        |> toTheme



-- Sample


{-| -}
sample : H.Html msg
sample =
    let
        colorVars : List ThemeColorSetValues
        colorVars =
            [ primary
            , secondary
            , success
            , warning
            , danger
            ]

        colorSample : ThemeColorSetValues -> H.Html msg
        colorSample color =
            H.div
                [ HA.style "display" "flex"
                , HA.style "flex-direction" "column"
                , HA.style "gap" "8px"
                , HA.style "text-align" "center"
                , HA.style "grid-column" "span 1 / span 1"
                ]
                [ H.div
                    [ HA.style "background" color.background
                    , HA.style "border-radius" "4px"
                    , HA.style "box-shadow" ("0 0 6px " ++ color.backgroundWithAlpha 0.8 ++ ")")
                    , HA.style "color" color.aux
                    , HA.style "padding" "8px 12px"
                    ]
                    [ H.text "Button" ]
                , H.div
                    [ HA.style "color" color.foreground
                    , HA.style "border" ("3px solid " ++ color.foreground)
                    , HA.style "border-radius" "4px"
                    , HA.style "padding" "8px 12px"
                    ]
                    [ H.text "Text" ]
                , H.div
                    [ HA.style "background" (color.foregroundWithAlpha 0.1)
                    , HA.style "border-radius" "4px"
                    , HA.style "color" color.foreground
                    , HA.style "padding" "8px 12px"
                    ]
                    [ H.text "Text" ]
                ]
    in
    H.article
        [ HA.style "padding" "20px"
        , HA.style "background" ("linear-gradient(rgba(0,0,0,0.1), rgba(0,0,0,0.1)), " ++ base.background)
        ]
        [ H.section
            [ HA.style "border-radius" "4px"
            , HA.style "padding" "20px"
            , HA.style "background" base.background
            , HA.style "box-shadow" "0 0 8px rgba(0, 0, 0, 0.1)"
            , HA.style "font-family" fontText
            , HA.style "color" baseForeground
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
                        [ HA.style "font-family" fontTitle
                        , HA.style "color" baseForeground
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
                        , HA.style "color" baseAux
                        , HA.style "font-family" fontCode
                        ]
                        [ H.text "Use accessibility ratings for making sure your theme works for everyone." ]
                    ]
                    :: List.map colorSample colorVars
                )
            ]
        ]



-- Helpers


toThemeString : ThemeBuilder -> String
toThemeString (ThemeBuilder { data, extra }) =
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

        colorSpec : String -> ThemeColorSet -> List ( String, String )
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
    , colorSpec "base" data.base
    , colorSpec "primary" data.primary
    , colorSpec "secondary" data.secondary
    , colorSpec "success" data.success
    , colorSpec "warning" data.warning
    , colorSpec "danger" data.danger
    , extra
    ]
        |> List.concat
        |> List.map (Tuple.mapFirst ((++) "tmspc-"))
        |> List.map (\( k, v ) -> "--" ++ k ++ ":" ++ v)
        |> String.join ";"



-- Providers


{-| Used to propagate themes to an specific scope.

    main : Html msg
    main =
        div []
            [ ThemeProvider.globalProvider defaultTheme

            -- section using the default theme
            , section [] [ .. ]

            -- section using the orange theme
            , ThemeProvider.provider orangeTheme [] [ .. ]
            ]

-}
provider :
    Theme
    -> List (H.Attribute msg)
    -> List (H.Html msg)
    -> H.Html msg
provider theme attrs children =
    provider_
        { light = theme
        , dark = Nothing
        , strategy = SystemStrategy
        }
        |> (\data ->
                data.provider attrs (data.styles :: children)
           )


{-| Used to provide a **Theme** globally. It will be applied to your `body` element and it will be available for use anywhere in your application.

    main : Html msg
    main =
        div []
            [ ThemeProvider.globalProvider lightTheme
            , p [ style "color" "var(--my-theme-accent)" ]
                [ text "I have the `accent` color" ]
            ]

**Note**: You are still able to overwrite this **Theme** locally.

-}
globalProvider : Theme -> H.Html msg
globalProvider theme =
    globalProvider_
        { light = theme
        , dark = Nothing
        , strategy = SystemStrategy
        }


{-| Defines the dark mode strategy.

  - `SystemStrategy` uses the user system settings.
  - `ClassStrategy` uses the presence of a CSS class to determine dark mode.

-}
type DarkModeStrategy
    = SystemStrategy
    | ClassStrategy String


systemStrategy : DarkModeStrategy
systemStrategy =
    SystemStrategy


classStrategy : String -> DarkModeStrategy
classStrategy =
    ClassStrategy


{-| Used to provide a Theme globally with a dark mode alternative. Themes will automatically switch based on the strategy condition.

    main : Html msg
    main =
        div []
            [ ThemeProvider.globalProviderWithDarkMode
                { light = lightTheme
                , dark = darkTheme
                , strategy = ThemeProvider.SystemStrategy
                }
            , p [ style "color" "var(--my-theme-accent)" ]
                [ text "I have the `accent` color" ]
            ]

**Note**: You are still able to overwrite this **Theme** locally.

-}
globalProviderWithDarkMode : { light : Theme, dark : Theme, strategy : DarkModeStrategy } -> H.Html msg
globalProviderWithDarkMode props =
    globalProvider_
        { light = props.light
        , dark = Just props.dark
        , strategy = props.strategy
        }


{-| Used to propagate themes to an specific scope with a dark mode alternative. Themes will automatically switch based on the strategy condition.

    main : Html msg
    main =
        div []
            [ ThemeProvider.globalProviderWithDarkMode
                { light = lightTheme
                , dark = darkTheme
                , strategy = ThemeProvider.SystemStrategy
                }

            -- section using the default light or dark theme
            , section [] [ .. ]

            -- section using the orange light and dark themes
            , ThemeProvider.providerWithDarkMode
                { light = lightOrange
                , dark = darkOrange
                , strategy = ThemeProvider.SystemStrategy
                }
                [] [ .. ]
            ]

-}
providerWithDarkMode :
    { light : Theme, dark : Theme, strategy : DarkModeStrategy }
    -> List (H.Attribute msg)
    -> List (H.Html msg)
    -> H.Html msg
providerWithDarkMode props attrs children =
    provider_
        { light = props.light
        , dark = Just props.dark
        , strategy = props.strategy
        }
        |> (\data ->
                data.provider attrs (data.styles :: children)
           )


{-| -}
type alias OptimizedTheme msg =
    { styles : H.Html msg
    , provider : List (H.Attribute msg) -> List (H.Html msg) -> H.Html msg
    }


{-|

    optimizedTheme =
        optimizedTheme theme

    body []
        [ myTheme.styles
        , myTheme.provider []
            [ ... ]
        ]

-}
optimizedTheme : Theme -> OptimizedTheme msg
optimizedTheme theme =
    provider_
        { light = theme
        , dark = Nothing
        , strategy = SystemStrategy
        }


{-| -}
optimizedThemeWithDarkMode :
    { light : Theme, dark : Theme, strategy : DarkModeStrategy }
    -> OptimizedTheme msg
optimizedThemeWithDarkMode props =
    provider_
        { light = props.light
        , dark = Just props.dark
        , strategy = props.strategy
        }



-- Helpers


hashString : String -> Int
hashString =
    Internal.Hash.hashString 0


toString : Theme -> String
toString (Theme theme) =
    theme.string



-- Default


globalProvider_ :
    { light : Theme
    , dark : Maybe Theme
    , strategy : DarkModeStrategy
    }
    -> H.Html msg
globalProvider_ props =
    H.div []
        [ H.node "style"
            []
            [ H.text ("body { " ++ toString props.light ++ " }") ]
        , case props.dark of
            Just dark ->
                case props.strategy of
                    ClassStrategy darkClass ->
                        H.node "style"
                            []
                            [ H.text ("." ++ darkClass ++ " { " ++ toString dark ++ "; color-scheme: dark; }") ]

                    SystemStrategy ->
                        H.node "style"
                            []
                            [ H.text ("@media (prefers-color-scheme: dark) { body { " ++ toString dark ++ "; color-scheme: dark; } }") ]

            Nothing ->
                H.text ""
        ]


provider_ :
    { light : Theme
    , dark : Maybe Theme
    , strategy : DarkModeStrategy
    }
    ->
        { styles : H.Html msg
        , provider : List (H.Attribute msg) -> List (H.Html msg) -> H.Html msg
        }
provider_ props =
    let
        targetClass : String
        targetClass =
            props.dark
                |> Maybe.map toString
                |> Maybe.withDefault ""
                |> (++) (toString props.light)
                |> hashString
                |> String.fromInt
                |> (++) "theme-"
    in
    case props.dark of
        Just dark ->
            case props.strategy of
                ClassStrategy darkClass ->
                    { styles =
                        H.node
                            "style"
                            []
                            [ H.text
                                ("."
                                    ++ targetClass
                                    ++ " { "
                                    ++ toString props.light
                                    ++ " } ."
                                    ++ darkClass
                                    ++ " ."
                                    ++ targetClass
                                    ++ " { "
                                    ++ toString dark
                                    ++ "; color-scheme: dark; }"
                                )
                            ]
                    , provider =
                        \attrs children ->
                            H.div
                                (HA.class targetClass :: attrs)
                                children
                    }

                SystemStrategy ->
                    { styles =
                        H.node
                            "style"
                            []
                            [ H.text
                                ("."
                                    ++ targetClass
                                    ++ " { "
                                    ++ toString props.light
                                    ++ " } @media (prefers-color-scheme: dark) { ."
                                    ++ targetClass
                                    ++ " { "
                                    ++ toString dark
                                    ++ "; color-scheme: dark; } }"
                                )
                            ]
                    , provider =
                        \attrs children ->
                            H.div
                                (HA.class targetClass :: attrs)
                                children
                    }

        Nothing ->
            { styles =
                H.node "style"
                    []
                    [ H.text ("." ++ targetClass ++ " { " ++ toString props.light ++ " }") ]
            , provider =
                \attrs children ->
                    H.div (HA.class targetClass :: attrs) children
            }
