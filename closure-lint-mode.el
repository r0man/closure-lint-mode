;;; closure-lint-mode.el -- Minor mode for the Closure Linter

;; Copyright (C) 2010 Roman Scherer

;; Author:  Roman Scherer
;; Created: 18 Nov 2010
;; Keywords: tools closure javascript lint flymake

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

(require 'flymake)

(defgroup closure-lint-mode nil
  "A minor mode for the Closure Linter"
  :prefix "closure-lint-mode-"
  :group 'applications)

(defcustom closure-lint-mode-gjs-lint "gjslint"
  "The name of the Closure Linter program."
  :type 'string
  :group 'closure-lint-mode)

(defcustom closure-lint-mode-fix-js-style "fixjsstyle"
  "The name of the Closure Fix JS Style program."
  :type 'string
  :group 'closure-lint-mode)

(defun closure-lint-mode-fix-buffer (filename)
  (let* ((command (concat closure-lint-mode-fix-js-style " " filename))
         (output (shell-command-to-string command)))
    output))

(defun closure-lint-mode-flymake-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name temp-file
                                         (file-name-directory buffer-file-name))))
    (list closure-lint-mode-gjs-lint (list (expand-file-name local-file)))))

(setq flymake-allowed-file-name-masks
      (cons '(".+\\.js$"
              closure-lint-mode-flymake-init
              flymake-simple-cleanup
              flymake-get-real-file-name)
            flymake-allowed-file-name-masks))

(setq flymake-err-line-patterns
      (cons '("^Line \\([[:digit:]]+\\), E:\\([[:digit:]]+\\):
\\(.+\\)$" nil 1 nil 3)
            flymake-err-line-patterns))

(provide 'closure-lint-mode)
