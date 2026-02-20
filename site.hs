{-# LANGUAGE OverloadedStrings #-}

import Hakyll
import Text.Pandoc.Options

main :: IO ()
main = hakyll $ do
    -- Static files
    match "css/*" $ do
        route idRoute
        compile compressCssCompiler

    match "images/*" $ do
        route idRoute
        compile copyFileCompiler

    match "pdf/*" $ do
        route idRoute
        compile copyFileCompiler

    -- Archive: serve old site as-is
    match "_archive/**" $ do
        route idRoute
        compile copyFileCompiler

    -- Templates
    match "templates/*" $ compile templateBodyCompiler

    -- Blog posts
    match "posts/*" $ do
        route $ setExtension "html"
        compile $ mathPandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    -- Index page
    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) <>
                    constField "title" "Home" <>
                    defaultContext
            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    -- Old page
    match "old.html" $ do
        route idRoute
        compile $ getResourceBody
            >>= loadAndApplyTemplate "templates/post.html" oldCtx
            >>= loadAndApplyTemplate "templates/default.html" oldCtx
            >>= relativizeUrls

postCtx :: Context String
postCtx =
    dateField "date" "%Y-%m-%d" <>
    defaultContext

oldCtx :: Context String
oldCtx =
    constField "title" "Old" <>
    constField "date" "[0000-00-00]" <>
    defaultContext

mathPandocCompiler :: Compiler (Item String)
mathPandocCompiler =
    pandocCompilerWith readerOpts writerOpts
  where
    readerOpts = defaultHakyllReaderOptions
        { readerExtensions = readerExtensions defaultHakyllReaderOptions
            <> extensionsFromList
                [ Ext_tex_math_dollars
                , Ext_tex_math_double_backslash
                , Ext_latex_macros
                , Ext_raw_html
                ]
        }
    writerOpts = defaultHakyllWriterOptions
        { writerHTMLMathMethod = MathJax ""
        }
