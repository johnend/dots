;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Identity is used by GPG, snippets, file templates and Magit/Forge.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;;; Look and feel
(setq doom-font (font-spec :family "Monaspace Neon Frozen" :size 14 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "UbuntuSans Nerd Font" :size 14)
      doom-big-font (font-spec :family "Monaspace Neon Frozen" :size 24)
      doom-theme 'doom-rose-pine
      display-line-numbers-type 'relative
      display-fill-column-indicator-column 120)

(custom-set-faces!
  '(italic :family "Monaspace Radon Frozen" :slant italic)
  '(font-lock-comment-face :family "Monaspace Radon Frozen" :slant italic)
  '(font-lock-keyword-face :family "Monaspace Radon Frozen" :slant italic)
  '(org-italic :family "Monaspace Radon Frozen" :slant italic))

(add-hook! prog-mode #'display-fill-column-indicator-mode)

;;; Editing defaults
(setq-default tab-width 2
              evil-shift-width 2
              fill-column 120
              word-wrap t)

(setq confirm-kill-emacs nil
      scroll-margin 8
      truncate-lines nil
      evil-want-fine-undo t
      evil-vsplit-window-right t
      evil-split-window-below t
      projectile-project-search-path '("~/Developer"))

;;; Org
(setq org-directory "~/org/")

;;; Local documentation
(defun johne/open-doom-workflows ()
  "Open the local Doom workflow guide."
  (interactive)
  (find-file (expand-file-name "workflows.org" doom-user-dir)))

;;; Search
(after! consult
  (setq consult-ripgrep-args
        (concat consult-ripgrep-args
                " --hidden --glob !.git/ --glob !node_modules/ --glob !dist*/ --glob !.next/ --glob !coverage/")))

;;; Formatting
(after! apheleia
  (setf (alist-get 'prettier apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath)
        (alist-get 'prettierd apheleia-formatters)
        '("prettierd" filepath))
  (dolist (mode '(js-mode js-ts-mode
                  jsx-ts-mode
                  typescript-mode typescript-ts-mode
                  tsx-ts-mode
                  web-mode
                  css-mode css-ts-mode
                  scss-mode
                  json-mode json-ts-mode
                  graphql-mode graphql-ts-mode
                  markdown-mode markdown-ts-mode
                  yaml-mode yaml-ts-mode))
    (setf (alist-get mode apheleia-mode-alist) '(prettierd prettier))))

;;; Leader aliases for the Neovim muscle memory that Doom does not already use.
(map! :leader
      :desc "Format buffer" "F" #'+format/buffer
      :desc "Write buffer" "w" #'save-buffer
      :desc "Quit window" "q" #'evil-quit

      (:prefix ("h d" . "docs")
       :desc "Workflow guide" "w" #'johne/open-doom-workflows)

      (:prefix-map ("s" . "search")
       :desc "Buffers" "b" #'consult-buffer
       :desc "Diagnostics" "d" #'+default/diagnostics
       :desc "Files" "f" #'projectile-find-file
       :desc "Grep" "g" #'+default/search-project
       :desc "Help" "h" #'helpful-symbol
       :desc "Keymaps" "k" #'describe-keymap
       :desc "Doom config files" "n" #'doom/find-file-in-private-config
       :desc "Commands" "x" #'execute-extended-command
       :desc "Recent files" "r" #'consult-recent-file
       :desc "Current word" "w" #'+default/search-project-for-symbol-at-point)

      (:prefix-map ("n" . "navigation")
       :desc "Project sidebar" "e" #'+treemacs/toggle
       :desc "Find in sidebar" "f" #'treemacs-find-file
       :desc "TODOs" "t" #'hl-todo-occur)

      (:prefix-map ("x" . "split")
       :desc "Close split" "d" #'evil-window-delete
       :desc "Equalize splits" "e" #'balance-windows
       :desc "Horizontal split" "h" #'evil-window-split
       :desc "Vertical split" "s" #'evil-window-vsplit)

      (:prefix-map ("z" . "shell")
       :desc "Toggle vterm" "z" #'+vterm/toggle))
