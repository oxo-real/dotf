(setq package-eable-at-startup nil
      package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(use-package doom-themes
  :config (load-theme 'doom-dracula t)
  )

(custom-set-variables
  '(inhibit-startup-screen t)
  '(initial-scratch-message nil)
  )

(custom-set-variables
   '(column-number-mode t)
   '(tooltip-mode nil)
   ;;'(display-line-numbers t)
   '(global-hl-line-mode t)
   '(show-paren-mode t)
   '(windmove-default-keybindings nil)
   ;;'(ivy-mode t)
   ;;'(winner-mode t)
   )

(setq vc-follow-symlinks t)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq backup-directory-alist '(("." . "~/.saves"))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 10
      kept-old-versions 10
      version-control t)

(use-package which-key
  :config (which-key-mode))

(use-package evil
  :config
  (evil-mode 1))

(use-package evil-magit)

(use-package helm
  :init
  (setq helm-follow-mode-persistent t
	helm-auto-resize-max 40
	helm-display-header-line nil
	;;helm-display-line-numbers nil
	)
  :config
  (require 'helm-config)
  (helm-autoresize-mode t)
  (add-hook
   'helm-minibuffer-set-up-hook
   'helm-hide-minibuffer-maybe
   )
  (helm-mode t)
  )

(use-package general
  :config
  (general-define-key
   "M-x" 'helm-M-x
   "C-x g" 'magit-status
   "C-x C-f" 'helm-find-files
   )
 )
