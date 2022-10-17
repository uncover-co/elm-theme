# elm-theme

elm-theme is an opinionated, constraint-based, theme library for Elm applications.

## Getting Started


```elm
import Theme
import Html exposing (..)
import Html.Attributes exposing (..)


main : Html msg
main =
    div []
        [ Theme.globalProvider Theme.lightTheme
        , p
            [ style "color" Theme.baseForeground ]
            [ text "My color won't change if the user goes to dark mode." ]
        , Theme.providerWithDarkMode
            { light = Theme.lightTheme
            , dark = Theme.darkTheme
            , strategy = Theme.classStrategy "is-dark"
            }
            []
            [ p
                [ style "color" Theme.baseForeground ]
                [ text "My color will change based on the user's dark mode!" ]
            ]
        ]
```
