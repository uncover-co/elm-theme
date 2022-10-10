# ThemeSpec

A reusable theme specification for web applications.

ThemeSpec is a theme specification that can be used across a variety of projects to quickly theme them based on CSS varabless. Themes are scoped and multiple can be used in the same page of an application. ThemeSpec is fully compatible with dark mode and any theme can have dark variants toggled through system preferences or CSS classes.

## Setup

After defining one or more themes you can "provide" them through your application using this project's sibling package [elm-theme-provider](https://package.elm-lang.org/packages/uncover-co/elm-theme-provider/latest/).

```elm
import ThemeSpec
import ThemeProvider
import Html exposing (..)
import Html.Attributes exposing (..)


main : Html msg
main =
    div []
        [ ThemeProvider.globalProvider ThemeSpec.lightTheme
        , ...
        , p
            [ style "color" ThemeSpec.color ]
            [ text "My color won't change if the user goes to dark mode." ]
        , ...
        , ThemeProvider.providerWithDarkMode
            { light = ThemeSpec.lightTheme
            , dark = ThemeSpec.darkTheme
            , strategy = ThemeProvider.ClassStrategy "is-dark"
            }
            []
            [ p
                [ style "background" ThemeSpec.background ]
                [ text "My color will change based on the user's dark mode!" ]
            ]
        ]
```
