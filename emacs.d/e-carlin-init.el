(provide 'e-carlin-init)

(setq package-user-dir "~/src/e-carlin/home-env/emacs.d/melpa") ; sets melpa install dir
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             t)
(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/packages/")
             t)
(add-to-list 'package-archives
             '("MELPA Stable" . "https://stable.melpa.org/packages/")
             t)
(package-initialize)

(require 'e-radiasoft)
(require 'srefactor)
(require 'srefactor-lisp)

(require 'evil)
(customize-set-variable 'evil-want-minibuffer t)
(evil-mode 1)
(advice-add 'evil-make-overriding-map :override #'ignore)
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map "jj"
                  'evil-normal-state) ; normal mode with jj
;; window motions
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
;; Make evil-mode up/down operate in screen lines instead of logical lines
(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)
;; Also in visual mode
(define-key evil-visual-state-map "j" 'evil-next-visual-line)
(define-key evil-visual-state-map "k" 'evil-previous-visual-line)

;; evil-commentary for commenting out code
(require 'evil-commentary)
(evil-commentary-mode)

;; helm for completions
(add-to-list 'load-path "~/src/e-carlin/home-env/emacs.d/helm")
(require 'helm-config)
(require 'helm-dabbrev) ; dynamic abbreviations
(helm-mode 1)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z") 'helm-select-action) ; list actions using C-z
(global-set-key (kbd "M-x")
                'helm-M-x) ; helm for M-x
(setq helm-mode-fuzzy-match t) ; fuzzy matching for all of helm
(setq helm-dabbrev-related-buffer-fn nil) ; search in all buffers for dabbrev matches
(global-set-key (kbd "M-'")
                'helm-dabbrev)
(set-face-attribute 'helm-selection nil :background "purple"
                    :foreground "black")
                                        ; get this to work
;; (setq helm-ff-skip-boring-files t)
;; (add-to-list 'helm-boring-file-regexp-list ".*\.pyc$")

;; follow version controlled symlinks
(setq vc-follow-symlinks t)

;; Prefer split windows side by side
                                        ;(setq split-width-threshold 0)
(setq split-width-threshold nil)
(setq split-height-threshold 0)

;; Always switch to new buffer when opening
(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2")
                'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3")
                'split-and-follow-vertically)

;; Open shell in current buffer
(add-to-list 'display-buffer-alist
             '("^\\*shell\\*$" . (display-buffer-same-window)))
;; Start shell in normal-mode
(evil-set-initial-state 'shell-mode 'normal)

;; Don't prompt to kill buffers with running processes
(setq kill-buffer-query-functions nil)

;; Allow the evil escape characters to do their thing
(setq comint-output-filter-functions (remove 'ansi-color-process-output comint-output-filter-functions))
(add-hook 'shell-mode-hook
          (lambda ()
            ;; Disable font-locking in this buffer to improve performance
            (font-lock-mode -1)
            ;; Prevent font-locking from being re-enabled in this buffer
            (make-local-variable 'font-lock-function)
            (setq font-lock-function (lambda (_)
                                       nil))
            (add-hook 'comint-preoutput-filter-functions
                      'xterm-color-filter nil t)))


;; C-f1 shows currently editing filename
(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))
(global-set-key (kbd "<f25>")
                'show-file-name) ; C-f1 seems to be f25?

;; Prefer side by side splits
(setq helm-split-window-in-side-p t)
(setq helm-split-window-default-side 'right)

(defun my-sensible-window-split (&optional window)
  (cond
   ((and (> (window-width window) (window-height window))
         (window-splittable-p window 'horizontal))
    (with-selected-window window
      (split-window-right)))
   ((window-splittable-p window)
    (with-selected-window window
      (split-window-right)))))
(setq split-window-preferred-function #'my-sensible-window-split)

;; efficient fuzzy file searching in version controlled repos
(require 'find-file-in-repository)
(global-set-key (kbd "C-x C-f")
                'find-file-in-repository)

;; Need a way to search other files when in a repo
(global-set-key (kbd "C-x f")
                'helm-find-files)


(add-to-list 'load-path "~/src/e-carlin/home-env/emacs.d/flycheck")
(require 'dash) ; flycheck dependency
(require 'pkg-info) ; flycheck dependency
(require 'epl) ; pkg-info dependency
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; emacs-pager https://github.com/mbriggs/emacs-pager
(require 'server)
(unless (server-running-p)
  (server-start))
(add-to-list 'load-path "~/src/e-carlin/home-env/emacs.d/emacs-pager.el")
(require 'emacs-pager)
(add-to-list 'auto-mode-alist
             '("\\.emacs-pager$" . emacs-pager-mode))
;; color 750 lines (default is 500)
(setq emacs-pager-max-line-coloring 750)

;; pyenv mode
(require 'pyenv-mode)
(pyenv-mode)

;; show line numbers
;; TODO(e-carlin): come on this is gross
(global-linum-mode t)
(add-hook 'shell-mode-hook
          (lambda ()
            (linum-mode -1)))
(add-hook 'dired-mode-hook
          (lambda ()
            (linum-mode -1)))
(add-hook 'markdown-mode-hook
          (lambda ()
            (linum-mode -1)))

;; Keep underscores within a word boundary
(add-hook 'python-mode-hook
          (lambda ()
            (modify-syntax-entry ?_ "w" python-mode-syntax-table)))
;; TODO(e-carlin): Simplify, superword-mode and the code above do the same thing
(add-hook 'c++-mode-hook
          (lambda ()
            (modify-syntax-entry ?_ "w" c++-mode-syntax-table)))
;; (add-hook 'c++-mode-hook #'superword-mode)
(add-hook 'sh-mode-hook
          (lambda ()
            (modify-syntax-entry ?_ "w" sh-mode-syntax-table)))

;; prettier code formatting for js
(require 'prettier-js)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode) ;; TODO: web mode involves more thna js/x https://github.com/prettier/prettier-emacs#usage-with-web-mode

;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist
             '("\\.jsx$" . web-mode))
;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers (append flycheck-disabled-checkers
                                                 '(javascript-jshint)))
;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file (or (buffer-file-name)
                                           default-directory)
                                       "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint
               (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable
                  eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
;; for better jsx syntax-highlighting in web-mode
;; - courtesy of Patrick @halbtuerke
(defadvice web-mode-highlight-part
    (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        ad-do-it)
    ad-do-it))

;; set purple text highlight background
(set-face-attribute 'region nil :background "purple"
                    :foreground "black")
(set-face-attribute 'minibuffer-prompt nil
                    :foreground "black")

;; yasnippet for completions
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(setq yas-snippet-dirs '("~/src/e-carlin/home-env/emacs.d/e-carlin-yasnippets")) ; must be above yas-global-mode
(yas-global-mode 1)

;; lsp (language server protocol)
(require 'lsp-mode)
(require 'lsp-python-ms)
(require 'lsp-ui)
(setq lsp-signature-auto-activate nil) ;; disalbe bottom documentation popup
(setq company-dabbrev-downcase 1)
(setq company-idle-delay 0.01)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'web-mode-hook 'flycheck-mode)
(add-hook 'js-mode-hook 'flycheck-mode)
(add-hook 'js-mode-hook #'lsp)
(add-hook 'python-mode-hook #'lsp)
(add-hook 'web-mode-hook #'lsp)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-completion-provider :capf)

;; show column-number so I know when I'm at 80 cols
(column-number-mode 1)

;; close some characters on opening
(electric-pair-mode 1)

;;disable company in shell
(add-hook 'shell-mode-hook
          (lambda ()
            (company-mode -1))
          'append)

;; remove flickering when searching
(setq-default isearch-allow-scroll t ; TODO(e-carlin): what does this do?
              lazy-highlight-cleanup nil ; TODO(e-carlin): what does this do?
              lazy-highlight-initial-delay 0) ; this removes the flicker

;; slime mode for lisp
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contribs '(slime-fancy))

;;possibly enable evil mode for some modes (I really only need vc-history). Oddly it seems like it is working w/o it
;; This doesn't work... :(
;; (cl-loop for buffer-name in '("\\*sly-macroexpansion\\*" "\\*sly-description\\*"
;;                               "\\*VC-history\\*" "COMMIT_EDITMSG" "CAPTURE-.*\\.org"
;;                               "\\*Warnings\\*" "\\*cider-inspect\\*")
;;          do (add-to-list 'evil-buffer-regexps
;;                          (cons buffer-name 'emacs)))
;; (add-to-list 'evil-buffer-regexps
;;              '("\\*VC-history\\*" . emacs))

;; revert all buffers when disk contents changes. Useful for updateing buffers
;; when git branch changes or watching files being written to like `tail -f`
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Reverting.html
(global-auto-revert-mode t)

;; Use "linux" c-style
;; https://www.emacswiki.org/emacs/IndentingC
(setq c-default-style "linux" c-basic-offset
      4)

(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            (setq dired-omit-files (concat dired-omit-files "|\\.pyc$"))))
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode)))

;; cleanup whitespace (ex trailing spaces)
;; (add-hook 'before-save-hook 'whitespace-cleanup) ; this seemed to be doing too much (especially in js files))
(add-hook 'before-save-hook 'delete-trailing-whitespace)
