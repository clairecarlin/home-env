(provide 'e-carlin-init)

;; (setq package-user-dir "~/src/e-carlin/home-env/emacs.d/melpa") ; sets melpa install dir
;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("gnu" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("MELPA Stable" . "https://stable.melpa.org/packages/") t)
;; (package-initialize)

;; evil mode for vi keybindings
(require 'undo-tree) ; evil needs undo-tree
(add-to-list 'load-path "~/src/e-carlin/home-env/emacs.d/evil")
(require 'evil)
(evil-mode 1)
(advice-add 'evil-make-overriding-map :override #'ignore)
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map  "jj" 'evil-normal-state) ; normal mode with jj
;; window motions
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

;; evil-commentary for commenting out code
(add-to-list 'load-path "~/src/e-carlin/home-env/emacs.d/evil-commentary")
(require 'evil-commentary)
(evil-commentary-mode)

;; helm for completions
(add-to-list 'load-path "~/src/e-carlin/home-env/emacs.d/helm")
(require 'helm-config)
(require 'helm-dabbrev) ; dynamic abbreviations
(helm-mode 1)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(global-set-key (kbd "M-x") 'helm-M-x) ; helm for M-x
(setq helm-mode-fuzzy-match t) ; fuzzy matching for all of helm
(setq helm-dabbrev-related-buffer-fn nil) ; search in all buffers for dabbrev matches
(global-set-key (kbd "M-'") 'helm-dabbrev)
(set-face-attribute 'helm-selection nil
    :background "purple"
    :foreground "black")

;; follow version controlled symlinks
(setq vc-follow-symlinks t)

;; Prefer split windows side by side
;(setq split-width-threshold 0)
(setq split-width-threshold nil)
(setq split-height-threshold 0)

;; Don't prompt to kill buffers with running processes
(setq kill-buffer-query-functions nil)

;; Allow the evil escape characters to do their thing
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)


;; C-f1 shows currently editing filename
(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))
(global-set-key (kbd "<f25>") 'show-file-name) ; C-f1 seems to be f25?

;; Prefer side by side splits
(setq helm-split-window-in-side-p t)
(setq helm-split-window-default-side 'right)

(defun my-sensible-window-split (&optional window)
  (cond
    ((and (> (window-width window)
             (window-height window))
          (window-splittable-p window 'horizontal))
      (with-selected-window window
        (split-window-right)))
    ((window-splittable-p window)
      (with-selected-window window
        (split-window-right)))))
(setq split-window-preferred-function #'my-sensible-window-split)

;; efficient fuzzy file searching in version controlled repos
(require 'find-file-in-repository)
(global-set-key (kbd "C-x C-f") 'find-file-in-repository)

;; Need a way to search other files when in a repo
(global-set-key (kbd "C-x f") 'helm-find-files)


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
(add-to-list 'auto-mode-alist '("\\.emacs-pager$" . emacs-pager-mode))

;; xclip to share clipboard between emacs and system
(require 'xclip)
(xclip-mode 1)

;; pyenv mode
(require 'pyenv-mode)
(pyenv-mode)

;; elpy for python development
(add-to-list 'load-path "~/src/e-carlin/home-env/emacs.d/elpy")
(add-to-list 'load-path "~/src/e-carlin/home-env/emacs.d/company-mode") ;; dependency of elpy
(require 'company)
(require 'elpy)
(elpy-enable)
(setq elpy-rpc-python-command "~/.pyenv/shims/python")
(setq elpy-rpc-virtualenv-path "~/.pyenv/shims/python")
;; (setq elpy-rpc-virtualenv-path "~/.pyenv/versions/py3")
(setq elpy-rpc-backend "jedi")
(global-set-key (kbd "<f12>") 'elpy-goto-definition)

;; show line numbers
(global-linum-mode t)
(add-hook 'shell-mode-hook (lambda () (linum-mode -1)))
(add-hook 'dired-mode-hook (lambda () (linum-mode -1)))

;; Keep underscores within a word boundary
(add-hook 'python-mode-hook
          (lambda () (modify-syntax-entry ?_ "w" python-mode-syntax-table)))

;; prettier code formatting for js
(require 'prettier-js)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode) ;; TODO: web mode involves more thna js/x https://github.com/prettier/prettier-emacs#usage-with-web-mode

;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
          '(javascript-jshint)))
;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
;; for better jsx syntax-highlighting in web-mode
;; - courtesy of Patrick @halbtuerke
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))


;; set purple text highlight background
(set-face-attribute 'region nil
        :background "purple"
        :foreground "black")
(set-face-attribute 'minibuffer-prompt nil
                    :foreground "green" :background "black")
