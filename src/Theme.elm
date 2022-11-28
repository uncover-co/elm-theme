module Theme exposing
    ( new, ThemeData, ThemeFonts, ThemeColorSet, Theme
    , lightTheme, darkTheme
    , fromTheme, toTheme, toThemeData
    , withFonts, withFontHeading, withFontText, withFontCode
    , withBase, withBaseForeground, withBaseBackground, withBaseAux
    , withNeutral, withNeutralForeground, withNeutralBackground, withNeutralAux
    , withPrimary, withPrimaryForeground, withPrimaryBackground, withPrimaryAux
    , withSecondary, withSecondaryForeground, withSecondaryBackground, withSecondaryAux
    , withSuccess, withSuccessForeground, withSuccessBackground, withSuccessAux
    , withWarning, withWarningForeground, withWarningBackground, withWarningAux
    , withDanger, withDangerForeground, withDangerBackground, withDangerAux
    , withThemeData, withExtraValues
    , globalProvider, provider
    , globalProviderWithDarkMode, providerWithDarkMode, classStrategy, systemStrategy, DarkModeStrategy
    , optimizedProvider, optimizedProviderWithDarkMode, ThemeProvider
    , sample
    , styles, stylesIf
    , fontHeading, fontText, fontCode
    , baseForeground, baseBackground, baseAux, baseForegroundWithAlpha, baseBackgroundWithAlpha, baseAuxWithAlpha
    , neutralForeground, neutralBackground, neutralAux, neutralForegroundWithAlpha, neutralBackgroundWithAlpha, neutralAuxWithAlpha
    , primaryForeground, primaryBackground, primaryAux, primaryForegroundWithAlpha, primaryBackgroundWithAlpha, primaryAuxWithAlpha
    , secondaryForeground, secondaryBackground, secondaryAux, secondaryForegroundWithAlpha, secondaryBackgroundWithAlpha, secondaryAuxWithAlpha
    , successForeground, successBackground, successAux, successForegroundWithAlpha, successBackgroundWithAlpha, successAuxWithAlpha
    , warningForeground, warningBackground, warningAux, warningForegroundWithAlpha, warningBackgroundWithAlpha, warningAuxWithAlpha
    , dangerForeground, dangerBackground, dangerAux, dangerForegroundWithAlpha, dangerBackgroundWithAlpha, dangerAuxWithAlpha
    , ThemeColorSetValues, base, neutral, primary, secondary, success, warning, danger
    )

{-|


# Creating Themes

@docs new, ThemeData, ThemeFonts, ThemeColorSet, Theme


# Built-in Themes

@docs lightTheme, darkTheme


# Extending Themes

@docs fromTheme, toTheme, toThemeData
@docs withFonts, withFontHeading, withFontText, withFontCode
@docs withBase, withBaseForeground, withBaseBackground, withBaseAux
@docs withNeutral, withNeutralForeground, withNeutralBackground, withNeutralAux
@docs withPrimary, withPrimaryForeground, withPrimaryBackground, withPrimaryAux
@docs withSecondary, withSecondaryForeground, withSecondaryBackground, withSecondaryAux
@docs withSuccess, withSuccessForeground, withSuccessBackground, withSuccessAux
@docs withWarning, withWarningForeground, withWarningBackground, withWarningAux
@docs withDanger, withDangerForeground, withDangerBackground, withDangerAux
@docs withThemeData, withExtraValues


# Theme Providers

@docs globalProvider, provider


## Dark Mode

@docs globalProviderWithDarkMode, providerWithDarkMode, classStrategy, systemStrategy, DarkModeStrategy


## Optimized Providers

@docs optimizedProvider, optimizedProviderWithDarkMode, ThemeProvider


# Theme Sampler

@docs sample


# Theme Html Helpers

Elm doesn't always play nice with CSS variables. These functions are a workaround for that issue. **Please note that you can only use one of these functions per element (or Html.Attributes.style).**

@docs styles, stylesIf


# Theme Values

@docs fontHeading, fontText, fontCode
@docs baseForeground, baseBackground, baseAux, baseForegroundWithAlpha, baseBackgroundWithAlpha, baseAuxWithAlpha
@docs neutralForeground, neutralBackground, neutralAux, neutralForegroundWithAlpha, neutralBackgroundWithAlpha, neutralAuxWithAlpha
@docs primaryForeground, primaryBackground, primaryAux, primaryForegroundWithAlpha, primaryBackgroundWithAlpha, primaryAuxWithAlpha
@docs secondaryForeground, secondaryBackground, secondaryAux, secondaryForegroundWithAlpha, secondaryBackgroundWithAlpha, secondaryAuxWithAlpha
@docs successForeground, successBackground, successAux, successForegroundWithAlpha, successBackgroundWithAlpha, successAuxWithAlpha
@docs warningForeground, warningBackground, warningAux, warningForegroundWithAlpha, warningBackgroundWithAlpha, warningAuxWithAlpha
@docs dangerForeground, dangerBackground, dangerAux, dangerForegroundWithAlpha, dangerBackgroundWithAlpha, dangerAuxWithAlpha


# Theme Value Sets

@docs ThemeColorSetValues, base, neutral, primary, secondary, success, warning, danger

-}

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
    , neutral : ThemeColorSet
    , primary : ThemeColorSet
    , secondary : ThemeColorSet
    , success : ThemeColorSet
    , warning : ThemeColorSet
    , danger : ThemeColorSet
    }


{-| -}
type alias ThemeFonts =
    { heading : String
    , text : String
    , code : String
    }


{-| -}
type alias ThemeColorSet =
    { background : Color
    , foreground : Color
    , aux : Color
    }



-- Builder


{-| -}
new : ThemeData -> Theme
new data =
    ThemeBuilder
        { data = data
        , extra = []
        }
        |> toTheme



-- Extending Themes


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


{-| -}
toThemeData : Theme -> ThemeData
toThemeData (Theme theme) =
    case theme.builder of
        ThemeBuilder builder ->
            builder.data


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
withFontHeading : String -> ThemeBuilder -> ThemeBuilder
withFontHeading v (ThemeBuilder ({ data } as theme)) =
    let
        fonts : ThemeFonts
        fonts =
            data.fonts
    in
    ThemeBuilder { theme | data = { data | fonts = { fonts | heading = v } } }


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
    ThemeBuilder { theme | data = { data | base = { colorSet | foreground = v } } }


{-| -}
withBaseBackground : Color -> ThemeBuilder -> ThemeBuilder
withBaseBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.base
    in
    ThemeBuilder { theme | data = { data | base = { colorSet | background = v } } }


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
withNeutral : ThemeColorSet -> ThemeBuilder -> ThemeBuilder
withNeutral v (ThemeBuilder ({ data } as theme)) =
    ThemeBuilder { theme | data = { data | neutral = v } }


{-| -}
withNeutralForeground : Color -> ThemeBuilder -> ThemeBuilder
withNeutralForeground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.neutral
    in
    ThemeBuilder { theme | data = { data | neutral = { colorSet | foreground = v } } }


{-| -}
withNeutralBackground : Color -> ThemeBuilder -> ThemeBuilder
withNeutralBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.neutral
    in
    ThemeBuilder { theme | data = { data | neutral = { colorSet | background = v } } }


{-| -}
withNeutralAux : Color -> ThemeBuilder -> ThemeBuilder
withNeutralAux v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.neutral
    in
    ThemeBuilder { theme | data = { data | neutral = { colorSet | aux = v } } }


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
    ThemeBuilder { theme | data = { data | primary = { colorSet | foreground = v } } }


{-| -}
withPrimaryBackground : Color -> ThemeBuilder -> ThemeBuilder
withPrimaryBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.primary
    in
    ThemeBuilder { theme | data = { data | primary = { colorSet | background = v } } }


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
    ThemeBuilder { theme | data = { data | secondary = { colorSet | foreground = v } } }


{-| -}
withSecondaryBackground : Color -> ThemeBuilder -> ThemeBuilder
withSecondaryBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.secondary
    in
    ThemeBuilder { theme | data = { data | secondary = { colorSet | background = v } } }


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
    ThemeBuilder { theme | data = { data | success = { colorSet | foreground = v } } }


{-| -}
withSuccessBackground : Color -> ThemeBuilder -> ThemeBuilder
withSuccessBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.success
    in
    ThemeBuilder { theme | data = { data | success = { colorSet | background = v } } }


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
    ThemeBuilder { theme | data = { data | danger = { colorSet | foreground = v } } }


{-| -}
withDangerBackground : Color -> ThemeBuilder -> ThemeBuilder
withDangerBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.danger
    in
    ThemeBuilder { theme | data = { data | danger = { colorSet | background = v } } }


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
    ThemeBuilder { theme | data = { data | warning = { colorSet | foreground = v } } }


{-| -}
withWarningBackground : Color -> ThemeBuilder -> ThemeBuilder
withWarningBackground v (ThemeBuilder ({ data } as theme)) =
    let
        colorSet : ThemeColorSet
        colorSet =
            data.warning
    in
    ThemeBuilder { theme | data = { data | warning = { colorSet | background = v } } }


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
    "theme"


{-| -}
cssVar : String -> String
cssVar v =
    "var(--" ++ namespace ++ "-" ++ v ++ ")"


{-| -}
cssVarWithAlpha : String -> Float -> String
cssVarWithAlpha v alpha =
    "rgb(var(--" ++ namespace ++ "-" ++ v ++ "-ch) / " ++ String.fromFloat alpha ++ ")"


{-| -}
fontHeading : String
fontHeading =
    cssVar "font-heading"


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
neutralForeground : String
neutralForeground =
    cssVar "neutral-fg"


{-| -}
neutralForegroundWithAlpha : Float -> String
neutralForegroundWithAlpha =
    cssVarWithAlpha "neutral-fg"


{-| -}
neutralBackground : String
neutralBackground =
    cssVar "neutral-bg"


{-| -}
neutralBackgroundWithAlpha : Float -> String
neutralBackgroundWithAlpha =
    cssVarWithAlpha "neutral-bg"


{-| -}
neutralAux : String
neutralAux =
    cssVar "neutral-aux"


{-| -}
neutralAuxWithAlpha : Float -> String
neutralAuxWithAlpha =
    cssVarWithAlpha "neutral-aux"


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
neutral : ThemeColorSetValues
neutral =
    { foreground = neutralForeground
    , foregroundWithAlpha = neutralForegroundWithAlpha
    , background = neutralBackground
    , backgroundWithAlpha = neutralBackgroundWithAlpha
    , aux = neutralAux
    , auxWithAlpha = neutralAuxWithAlpha
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
    new
        { fonts =
            { heading = "system-ui, sans-serif"
            , text = "system-ui, sans-serif"
            , code = "monospace"
            }
        , base =
            { background = Color.rgb255 253 253 253
            , foreground = Color.rgb255 43 52 59
            , aux = Color.rgb255 99 119 136
            }
        , neutral =
            { background = Color.rgb255 91 111 125
            , foreground = Color.rgb255 99 119 136
            , aux = Color.rgb255 255 255 255
            }
        , primary =
            { background = Color.rgb255 0 122 204
            , foreground = Color.rgb255 0 119 199
            , aux = Color.rgb255 255 255 255
            }
        , secondary =
            { background = Color.rgb255 192 57 181
            , foreground = Color.rgb255 209 0 192
            , aux = Color.rgb255 255 255 255
            }
        , success =
            { background = Color.rgb255 150 230 71
            , foreground = Color.rgb255 34 128 0
            , aux = Color.rgb255 0 66 38
            }
        , warning =
            { background = Color.rgb255 250 192 56
            , foreground = Color.rgb255 182 91 7
            , aux = Color.rgb255 87 46 0
            }
        , danger =
            { background = Color.rgb255 220 50 84
            , foreground = Color.rgb255 230 25 66
            , aux = Color.rgb255 255 255 255
            }
        }


{-| -}
darkTheme : Theme
darkTheme =
    new
        { fonts =
            { heading = "system-ui, sans-serif"
            , text = "system-ui, sans-serif"
            , code = "monospace"
            }
        , base =
            { background = Color.rgb255 37 40 48
            , foreground = Color.rgb255 240 240 240
            , aux = Color.rgb255 150 154 162
            }
        , neutral =
            { background = Color.rgb255 96 110 123
            , foreground = Color.rgb255 199 206 214
            , aux = Color.rgb255 255 255 255
            }
        , primary =
            { background = Color.rgb255 0 122 204
            , foreground = Color.rgb255 105 171 247
            , aux = Color.rgb255 255 255 255
            }
        , secondary =
            { background = Color.rgb255 199 51 186
            , foreground = Color.rgb255 248 142 239
            , aux = Color.rgb255 255 255 255
            }
        , success =
            { background = Color.rgb255 74 200 0
            , foreground = Color.rgb255 119 223 59
            , aux = Color.rgb255 119 223 59
            }
        , warning =
            { background = Color.rgb255 251 179 0
            , foreground = Color.rgb255 255 215 114
            , aux = Color.rgb255 91 65 0
            }
        , danger =
            { background = Color.rgb255 255 92 95
            , foreground = Color.rgb255 251 116 116
            , aux = Color.rgb255 56 27 0
            }
        }



-- Sample


{-| -}
sample : H.Html msg
sample =
    let
        colorVars : List ThemeColorSetValues
        colorVars =
            [ neutral
            , primary
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
                    [ HA.style "grid-column" "span 2 / span 2"
                    , HA.style "display" "flex"
                    , HA.style "flex-direction" "column"
                    , HA.style "gap" "8px"
                    , HA.style "padding-bottom" "12px"
                    ]
                    [ H.h1
                        [ HA.style "font-family" fontHeading
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
            [ colorVars (name ++ "-bg") color.background
            , colorVars (name ++ "-fg") color.foreground
            , colorVars (name ++ "-aux") color.aux
            ]
                |> List.concat
    in
    [ [ ( "font-heading", data.fonts.heading )
      , ( "font-text", data.fonts.text )
      , ( "font-code", data.fonts.code )
      ]
    , colorSpec "base" data.base
    , colorSpec "neutral" data.neutral
    , colorSpec "primary" data.primary
    , colorSpec "secondary" data.secondary
    , colorSpec "success" data.success
    , colorSpec "warning" data.warning
    , colorSpec "danger" data.danger
    , extra
    ]
        |> List.concat
        |> List.map (Tuple.mapFirst (\v -> namespace ++ "-" ++ v))
        |> List.map (\( k, v ) -> "--" ++ k ++ ":" ++ v)
        |> String.join ";"



-- Theme Providers


{-| Used to propagate themes to an specific scope.

    main : Html msg
    main =
        div []
            [ Theme.globalProvider defaultTheme

            -- section using the default theme
            , section [] [ .. ]

            -- section using the orange theme
            , Theme.provider orangeTheme [] [ .. ]
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


{-| Used to provide a Theme globally. It will be applied to your `body` element and it will be available for use anywhere in your application.

    main : Html msg
    main =
        div []
            [ Theme.globalProvider lightTheme
            , p [ style "color" Theme.baseForeground ]
                [ text "I'm colored using the `base foreground` value!" ]
            ]

**Note**: You are still able to overwrite this Theme locally.

-}
globalProvider : Theme -> H.Html msg
globalProvider theme =
    globalProvider_
        { light = theme
        , dark = Nothing
        , strategy = SystemStrategy
        }


{-| -}
type DarkModeStrategy
    = SystemStrategy
    | ClassStrategy String


{-| Uses the user system settings to decide between light and dark mode.
-}
systemStrategy : DarkModeStrategy
systemStrategy =
    SystemStrategy


{-| Uses the presence of a given CSS class in the element scope to decide between light and dark mode.
-}
classStrategy : String -> DarkModeStrategy
classStrategy =
    ClassStrategy


{-| Used to provide a Theme globally with a dark mode alternative. Themes will automatically switch based on the strategy condition.

    main : Html msg
    main =
        div []
            [ Theme.globalProviderWithDarkMode
                { light = lightTheme
                , dark = darkTheme
                , strategy = Theme.systemStrategy
                }
            , p [ style "color" Theme.baseForeground ]
                [ text "I'm colored using the `base foreground` value!" ]
            ]

**Note**: You are still able to overwrite this Theme locally.

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
            [ Theme.globalProviderWithDarkMode
                { light = lightTheme
                , dark = darkTheme
                , strategy = Theme.systemStrategy
                }

            -- section using the default light or dark theme
            , section [] [ .. ]

            -- section using the orange light and dark themes
            , Theme.providerWithDarkMode
                { light = lightOrange
                , dark = darkOrange
                , strategy = Theme.systemStrategy
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
type alias ThemeProvider msg =
    { styles : H.Html msg
    , provider : List (H.Attribute msg) -> List (H.Html msg) -> H.Html msg
    }


{-|

    myTheme =
        optimizedProvider theme

    body []
        [ myTheme.styles
        , myTheme.provider []
            [ ... ]
        ]

-}
optimizedProvider : Theme -> ThemeProvider msg
optimizedProvider theme =
    provider_
        { light = theme
        , dark = Nothing
        , strategy = SystemStrategy
        }


{-| -}
optimizedProviderWithDarkMode :
    { light : Theme, dark : Theme, strategy : DarkModeStrategy }
    -> ThemeProvider msg
optimizedProviderWithDarkMode props =
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



-- Theme Html Helpers


{-|

    div
        [ styles
            [ ( "color", Theme.baseForeground )
            , ( "background", Theme.baseBackground )
            ]
        ]
        []

-}
styles : List ( String, String ) -> H.Attribute msg
styles xs =
    xs
        |> List.map (\( k, v ) -> k ++ ":" ++ v)
        |> String.join ";"
        |> HA.attribute "style"


{-|

    div
        [ stylesIf
            [ ( "background", Theme.baseBackground, True )
            , ( "color", Theme.primaryForeground, isPrimary )
            , ( "color", Theme.baseForeground, not isPrimary )
            ]
        ]
        []

-}
stylesIf : List ( String, String, Bool ) -> H.Attribute msg
stylesIf xs =
    xs
        |> List.filterMap
            (\( k, v, f ) ->
                if f then
                    Just (k ++ ":" ++ v)

                else
                    Nothing
            )
        |> String.join ";"
        |> HA.attribute "style"
