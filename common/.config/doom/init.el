;;; init.el -*- lexical-binding: t; -*-

;; This config keeps the Neovim workflow shape, but lets Doom own the
;; implementation: Evil, Vertico/Consult, Corfu, Eglot, Magit, vterm, tree-sitter
;; and language modules do the heavy lifting.

(doom! :completion
       (corfu +orderless)
       vertico

       :ui
       doom
       doom-dashboard
       hl-todo
       ligatures
       modeline
       ophints
       (popup +defaults)
       treemacs
       (vc-gutter +pretty)
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       snippets
       (whitespace +guess +trim)
       word-wrap

       :emacs
       dired
       electric
       ibuffer
       tramp
       undo
       vc

       :term
       eshell
       shell
       term
       vterm

       :checkers
       syntax

       :tools
       direnv
       docker
       editorconfig
       (eval +overlay)
       lookup
       (lsp +eglot)
       llm
       (magit +forge)
       make
       pdf
       (terraform +lsp)
       tree-sitter

       :os
       (:if (featurep :system 'macos) macos)
       tty

       :lang
       data
       emacs-lisp
       (go +lsp +tree-sitter)
       (graphql +lsp +tree-sitter)
       (java +lsp +tree-sitter)
       (javascript +lsp +tree-sitter)
       (json +lsp +tree-sitter)
       (lua +lsp +tree-sitter)
       (markdown +tree-sitter)
       org
       (python +lsp +tree-sitter)
       (sh +lsp)
       (web +lsp +tree-sitter)
       (yaml +lsp +tree-sitter)

       :config
       (default +bindings +smartparens))
