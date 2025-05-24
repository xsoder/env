;;; dtmacs-theme.el --- Theme based on Tokyonight

;; Copyright (C) 2023

;; Author: Derek Taylor (DT)
;; Version: 0.1
;; Package-Requires: ((emacs "24.1"))
;; Created with ThemeCreator, https://github.com/mswift42/themecreator.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;; dtmacs-theme was created by Derek Taylor in 2023, now using Tokyonight colors

;;; Code:

(deftheme dtmacs)
(let ((class '((class color) (min-colors 89)))
      ;; Tokyonight color palette (Moon variant base)
      (fg1       "#c0caf5") ;; foreground
      (fg2       "#a9b1d6")
      (fg3       "#7aa2f7")
      (fg4       "#565f89")
      (fg6       "#3b4261")
      (bg1       "#1a1b26") ;; background dark blue/black
      (bg2       "#16161e")
      (bg3       "#292e42")
      (bg4       "#545c7e")
      (builtin   "#7aa2f7") ;; blue
      (keyword   "#bb9af7") ;; purple
      (const     "#ff9e64") ;; orange
      (comment   "#565f89") ;; muted blue-gray
      (func      "#7dcfff") ;; cyan
      (str       "#9ece6a") ;; green
      (type      "#7aa2f7") ;; blue
      (var       "#ff7eb6") ;; pink
      (bufid     "#c0caf5") ;; same as fg1
      (selection "#33467c") ;; dark blue for selection background
      (warning   "#f7768e") ;; red/pink for warnings
      (warning2  "#e0af68") ;; yellow for warnings
      (todo      "#bb9af7") ;; purple
      (done      "#9ece6a") ;; green
      (unspec   (when (>= emacs-major-version 29) 'unspecified)))
  (custom-theme-set-faces
   'dtmacs
   ;; basics
   `(default ((,class (:background ,bg1 :foreground ,fg1))))
   `(cursor ((,class (:background ,fg3))))
   `(fringe ((,class (:background ,bg1 :foreground ,fg4))))
   `(region ((,class (:background ,selection))))
   `(highlight ((,class (:background ,bg3 :foreground ,fg3))))
   `(hl-line ((,class (:background ,bg2))))
   `(vertical-border ((,class (:foreground ,bg4))))
   `(minibuffer-prompt ((,class (:foreground ,keyword :bold t))))
   `(link ((,class (:foreground ,func :underline t))))

   ;; font lock
   `(font-lock-builtin-face ((,class (:foreground ,builtin))))
   `(font-lock-comment-face ((,class (:foreground ,comment :italic t))))
   `(font-lock-constant-face ((,class (:foreground ,const))))
   `(font-lock-function-name-face ((,class (:foreground ,func))))
   `(font-lock-keyword-face ((,class (:foreground ,keyword :bold t))))
   `(font-lock-string-face ((,class (:foreground ,str))))
   `(font-lock-type-face ((,class (:foreground ,type))))
   `(font-lock-variable-name-face ((,class (:foreground ,var))))
   `(font-lock-warning-face ((,class (:foreground ,warning :background ,bg2))))

   ;; mode line
   `(mode-line ((,class (:background ,bg2 :foreground ,fg3 :box (:line-width 4 :color ,bg2) :bold t))))
   `(mode-line-inactive ((,class (:background ,bg3 :foreground ,fg4 :box (:line-width 4 :color ,bg3)))))
   `(mode-line-buffer-id ((,class (:foreground ,bufid :bold t))))
   `(mode-line-highlight ((,class (:foreground ,selection :weight bold))))

   ;; org mode
   `(org-level-1 ((,class (:foreground ,builtin :weight bold :height 1.7))))
   `(org-level-2 ((,class (:foreground ,str :weight bold :height 1.6))))
   `(org-level-3 ((,class (:foreground ,var :weight bold :height 1.5))))
   `(org-level-4 ((,class (:foreground ,func :weight bold :height 1.4))))
   `(org-todo ((,class (:foreground ,todo :weight bold :italic t))))
   `(org-done ((,class (:foreground ,done :weight bold :italic t))))
   `(org-warning ((,class (:underline t :foreground ,warning))))
   `(org-block ((,class (:background ,bg2 :foreground ,fg2))))
   `(org-quote ((,class (:inherit org-block :slant italic))))
   `(org-ellipsis ((,class (:foreground ,builtin))))

   ;; helm
   `(helm-header ((,class (:foreground ,fg2 :background ,bg1 :underline nil :box nil))))
   `(helm-selection ((,class (:background ,bg2))))
   `(helm-source-header ((,class (:foreground ,keyword :background ,bg1 :weight bold))))
   `(helm-visible-mark ((,class (:foreground ,bg1 :background ,bg3))))
   `(helm-candidate-number ((,class (:foreground ,bg1 :background ,fg1))))
   `(helm-separator ((,class (:foreground ,type :background ,bg1))))

   ;; company
   `(company-tooltip ((,class (:foreground ,fg2 :background ,bg2 :bold t))))
   `(company-tooltip-selection ((,class (:background ,bg3 :foreground ,fg3))))
   `(company-scrollbar-bg ((,class (:background ,bg3))))
   `(company-scrollbar-fg ((,class (:foreground ,keyword))))
   `(company-tooltip-common ((,class (:foreground ,fg3))))
   `(company-tooltip-common-selection ((,class (:foreground ,str))))

   ;; rainbow delimiters
   `(rainbow-delimiters-depth-1-face ((,class (:foreground ,fg1))))
   `(rainbow-delimiters-depth-2-face ((,class (:foreground ,type))))
   `(rainbow-delimiters-depth-3-face ((,class (:foreground ,var))))
   `(rainbow-delimiters-depth-4-face ((,class (:foreground ,const))))
   `(rainbow-delimiters-depth-5-face ((,class (:foreground ,keyword))))
   `(rainbow-delimiters-depth-6-face ((,class (:foreground ,fg1))))
   `(rainbow-delimiters-depth-7-face ((,class (:foreground ,type))))
   `(rainbow-delimiters-depth-8-face ((,class (:foreground ,var))))

   ;; misc
   `(trailing-whitespace ((,class (:background ,warning))))
   `(show-paren-match ((,class (:background ,str :foreground ,bg1))))
   `(show-paren-mismatch ((,class (:background ,warning :foreground ,bg1))))

   ;; line numbers (Emacs >=26)
   (when (>= emacs-major-version 26)
     (custom-theme-set-faces
      'dtmacs
      `(line-number ((t (:foreground ,fg6 :background ,bg1))))
      `(line-number-current-line ((t (:foreground ,fg3 :background ,bg1 :weight bold))))))

   ;; tabs (Emacs >=27)
   (when (>= emacs-major-version 27)
     (custom-theme-set-faces
      'dtmacs
      `(tab-line ((,class (:background ,bg2 :foreground ,fg4))))
      `(tab-line-tab ((,class (:inherit tab-line))))
      `(tab-line-tab-inactive ((,class (:background ,bg2 :foreground ,fg4))))
      `(tab-line-tab-current ((,class (:background ,bg1 :foreground ,fg1))))
      `(tab-line-highlight ((,class (:background ,bg1 :foreground ,fg2)))))))

(provide-theme 'dtmacs)
;;; dtmacs-theme.el ends here
