module Main exposing (main)

import ElmBook exposing (Book, book, withChapterGroups)
import ElmBook.Chapter exposing (chapter, render, renderComponent)
import ElmBook.ComponentOptions
import Html exposing (..)
import Html.Attributes exposing (..)
import Theme


viewSideBySide : Html msg -> Html msg -> Html msg
viewSideBySide left right =
    div [ style "display" "flex" ]
        [ div [ style "flex-grow" "1" ] [ left ]
        , div [ style "flex-grow" "1" ] [ right ]
        ]


main : Book ()
main =
    book "Theme"
        |> withChapterGroups
            [ ( "Theme Spec"
              , [ chapter "About Theme Spec"
                    |> render """
A common theme specification.

> **Base**
- `bg` e.g. the main background color
- `fg` e.g. the main foreground color
- `aux` e.g. accessible foreground variant (usually used for lighter text)

> **Primary, Secondary, Etc.**
- `bg` e.g. color used for button background
- `fg` e.g. the color used for primary texts on a base background
- `aux` e.g. color used for text on top of a primary background
"""
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
