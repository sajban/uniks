(use-package imaksCore)

(use-package clojure-mode)

(use-package consult
  :custom
  (consult-preview-key (kbd "M-.")))

(use-package deadgrep)

(use-package dockerfile-mode :mode "Dockerfile")

(use-package doom-modeline
  :config
  (doom-modeline-mode 1))

(use-package find-file-in-project
  :custom (ffip-use-rust-fd t))

(use-package lispy
  :hook ((emacs-lisp-mode lisp-mode)
	 . lispy-mode))

(use-package magit
  :config
  (put 'magit-clean 'disabled nil))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package notmuch :commands notmuch)
(use-package notmuch-maildir)

(use-package orderless
  :config
  (defun flex-if-twiddle (pattern _index _total)
    (when (string-suffix-p "~" pattern)
      `(orderless-flex . ,(substring pattern 0 -1))))
  (defun without-if-bang (pattern _index _total)
    (cond
     ((equal "!" pattern)
      '(orderless-literal . ""))
     ((string-prefix-p "!" pattern)
      `(orderless-without-literal . ,(substring pattern 1)))))
  :custom
  (completion-styles '(orderless))
  (orderless-style-dispatchers
   '(flex-if-twiddle without-if-bang))
  (orderless-matching-styles '(orderless-regexp)))

(use-package unicode-fonts
  :config (unicode-fonts-setup))
 
(use-package which-key
  :config
  (which-key-mode))
