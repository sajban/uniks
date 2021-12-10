(use-package imaksMin)

(use-package adaptive-wrap
  :hook ((emacs-lisp-mode shen-mode lisp-mode nix-mode)
	 . adaptive-wrap-prefix-mode))

(use-package company
  :hook ((lisp-mode nix-mode shen-mode)
	 . company-mode))

(use-package consult-flycheck)

(use-package consult-ghq
  :after (consult)
  :custom
  (consult-ghq-find-function #'consult-find)
  (consult-ghq-grep-function #'consult-grep))

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode))

(use-package doom-modeline
  :config
  (doom-modeline-mode 1))

(use-package embark)

(use-package ement)

(use-package eshell-prompt-extras
  :config
  (with-eval-after-load "esh-opt"
    (autoload 'epe-theme-lambda "eshell-prompt-extras"))
  :custom
  (eshell-highlight-prompt nil)
  (eshell-prompt-function 'epe-theme-lambda))

(use-package fish-completion
  :config
  (global-fish-completion-mode))

(use-package flycheck
  :custom
  (flycheck-idle-change-delay 7)
  (flycheck-idle-buffer-switch-delay 49)
  (flycheck-check-syntax-automatically
   '(save idle-change mode-enabled)))

(use-package flycheck-guile)

(use-package forge
  :after (magit))

(use-package ghq :commands ghq)

(use-package git-link
  :custom (git-link-use-commit t))

(use-package marginalia
  :config (marginalia-mode))

(use-package nixpkgs-fmt
  :hook (nix-mode . nixpkgs-fmt-on-save-mode))

(use-package projectile
  :config
  (projectile-mode +1)
  :custom
  (projectile-project-search-path '("~/git/" "/git/")))

(use-package shen-elisp)

(use-package sly)
(use-package sly-macrostep)
(use-package sly-asdf)
(use-package sly-quicklisp)

(use-package zoxide
  :hook
  ((find-file projectile-after-switch-project)
   . zoxide-add))
