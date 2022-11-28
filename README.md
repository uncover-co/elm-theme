# elm-theme

**An opinionated, constraint-based, theme library for Elm applications.**

- Themes are easy to create and extend.
- Test the accessibility of your theme through the theme sampler.
- Mix and match different themes in a single application through providers.
- Dark mode ready with class and system detection strategies.

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
            , strategy = Theme.systemStrategy
            }
            []
            [ p
                [ style "color" Theme.baseForeground ]
                [ text "My color will change based on the user's dark mode!" ]
            ]
        ]
```


# Tailwind Integration

If you're using [Tailwind](https://tailwindcss.com/) you're gonna love elm-theme! We maintain a plugin so your theme is deeply integrated into your tailwind config.

Your theme's font families are included like `font-heading`, `font-text` and `font-code`. And your theme's colors are included like `{color}-bg`, `{color}-fg` and `{color}-aux`.  So you can use them like the example below.

```elm
section
  [ class "bg-base-bg"
  , class "font-heading text-primary-fg"
  , class "border-b border-primary-fg/20"
  ]
  []
```

Check out the [elm-theme-tailwindcss](https://www.npmjs.com/package/elm-theme-tailwindcss) tailwind plugin for extra information.

# Elm & CSS Variables

This package is based on [CSS variables](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties) and Elm doesn't always play nice with them. For example, the `background` property does not appear to respect values passed through CSS variables.

For that reason, we've included two helper functions as a workaround to this problem. See [Theme.styles](https://package.elm-lang.org/packages/uncover-co/elm-theme/latest/Theme#styles) and [Theme.stylesIf](https://package.elm-lang.org/packages/uncover-co/elm-theme/latest/Theme#stylesIf).
