module Main exposing (main)

import ElmBook exposing (Book, book, withChapterGroups, withStatefulOptions)
import ElmBook.Actions
import ElmBook.Chapter exposing (chapter, render, renderComponent, renderStatefulComponent)
import ElmBook.ComponentOptions
import ElmBook.StatefulOptions
import Html as H exposing (..)
import Html.Attributes exposing (..)
import Theme
import ThemeGenerator


viewSideBySide : Html msg -> Html msg -> Html msg
viewSideBySide left right =
    div [ style "display" "flex" ]
        [ div [ style "flex-grow" "1" ] [ left ]
        , div [ style "flex-grow" "1" ] [ right ]
        ]


main : Book ThemeGenerator.Model
main =
    book "elm-theme"
        |> withStatefulOptions
            [ ElmBook.StatefulOptions.initialState ThemeGenerator.init
            ]
        |> withChapterGroups
            [ ( "Theme"
              , [ chapter "Design Tokens"
                    |> render """
Design tokens are all about constraints.

The majority of time spent developing `elm-theme` was focused on trying out the minimum amount of colors and fonts the would allow us to create most if not all of your UI use cases with room for flexibility. If the set of fonts and colors we arrived seems obvious, that it is by design! 😁

**Fonts**
- `heading` used for all types of headings
- `text` used for the majority of text elements
- `code` used for inline and blocks of code

**Base**
- `background` the main background color
- `foreground` the main foreground color
- `aux` accessible foreground variant (usually used for lighter text)

**Primary, Secondary, Neutral, Success, Warning and Danger**
- `background` color used for button background
- `foreground` the color used for primary texts on a base background
- `aux` color used for text on top of a primary background
"""
                , chapter "Theme Generator"
                    |> renderStatefulComponent
                        (\state ->
                            ThemeGenerator.view state
                                |> H.map
                                    (ElmBook.Actions.mapUpdate
                                        { toState = \_ -> identity
                                        , fromState = identity
                                        , update = ThemeGenerator.update
                                        }
                                    )
                        )
                ]
              )
            , ( "Theme Provider"
              , [ chapter "Global"
                    |> renderComponent
                        (div []
                            [ Theme.globalProvider Theme.lightTheme
                            , Theme.sample
                            ]
                        )
                , chapter "Global Dark Mode"
                    |> renderComponent
                        (div []
                            [ Theme.globalProviderWithDarkMode
                                { light = Theme.lightTheme
                                , dark = Theme.darkTheme
                                , strategy = Theme.classStrategy "elm-book-dark-mode"
                                }
                            , Theme.sample
                            ]
                        )
                , chapter "Global Dark Mode (System)"
                    |> renderComponent
                        (div []
                            [ Theme.globalProviderWithDarkMode
                                { light = Theme.lightTheme
                                , dark = Theme.darkTheme
                                , strategy = Theme.systemStrategy
                                }
                            , Theme.sample
                            ]
                        )
                , chapter "Provider"
                    |> ElmBook.Chapter.withComponentOptions [ ElmBook.ComponentOptions.fullWidth True ]
                    |> renderComponent
                        (Theme.provider Theme.lightTheme
                            []
                            [ viewSideBySide
                                Theme.sample
                                (Theme.provider Theme.darkTheme
                                    []
                                    [ Theme.sample ]
                                )
                            ]
                        )
                , chapter "Provider Dark Mode"
                    |> ElmBook.Chapter.withComponentOptions [ ElmBook.ComponentOptions.fullWidth True ]
                    |> renderComponent
                        (Theme.providerWithDarkMode
                            { light = Theme.lightTheme
                            , dark = Theme.darkTheme
                            , strategy = Theme.classStrategy "elm-book-dark-mode"
                            }
                            []
                            [ viewSideBySide
                                Theme.sample
                                (Theme.providerWithDarkMode
                                    { light = Theme.darkTheme
                                    , dark = Theme.lightTheme
                                    , strategy = Theme.classStrategy "elm-book-dark-mode"
                                    }
                                    []
                                    [ Theme.sample ]
                                )
                            ]
                        )
                , chapter "Provider Dark Mode (System)"
                    |> ElmBook.Chapter.withComponentOptions [ ElmBook.ComponentOptions.fullWidth True ]
                    |> renderComponent
                        (div []
                            [ Theme.providerWithDarkMode
                                { light = Theme.lightTheme
                                , dark = Theme.darkTheme
                                , strategy = Theme.systemStrategy
                                }
                                []
                                [ viewSideBySide
                                    Theme.sample
                                    (Theme.providerWithDarkMode
                                        { light = Theme.darkTheme
                                        , dark = Theme.lightTheme
                                        , strategy = Theme.systemStrategy
                                        }
                                        []
                                        [ Theme.sample ]
                                    )
                                ]
                            ]
                        )
                ]
              )
            ]
