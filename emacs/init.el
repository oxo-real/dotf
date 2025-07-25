;;(server-mode)

(require 'server)
(unless (server-running-p)
  (server-start))

(require 'package)

(setq package-archives '(
           ("elpa" . "https://elpa.gnu.org/packages/")
           ("melpa" . "https://melpa.org/packages/")
           ;;("melpa_stable" . "https://stable.melpa.org/packages/")
           ("org" . "http://orgmode.org/elpa/")
           ;;("gnu" . "http://elpa.gnu.org/packages/")
           ;;("nongnu" . "http://elpa.nongnu.org/nongnu/")
           ;;("marmalade" . "https://marmalade-repo.org/packages/")
           ))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package vertico
  :ensure t

  :custom
  (vertico-cycle t)

  :init
  (vertico-mode))

(use-package orderless
  :ensure t

  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package which-key
  :ensure t

  :init (which-key-mode)

  :diminish which-key-mode

  :config
  (setq which-key-idle-delay 0.5))

(use-package doom-modeline
  :ensure t

  :init
  (doom-modeline-mode 1)

  :custom
  (doom-modeline-height 12)
  (doom-modeline-bar-width 3)
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-mu4e nil)
  (doom-modeline-irc nil)
  (doom-modeline-minor-modes t)
  (doom-modeline-persp-name nil)
  (doom-modeline-buffer-file-name-style 'truncate-except-project)
  (doom-modeline-icon nil)
  (doom-modeline-major-mode-icon nil))

(setq ediff-keep-variants nil)
(setq ediff-make-buffers-readonly-at-startup nil)
(setq ediff-merge-revisions-with-anchestor t)
(setq ediff-show-clashes-only t)
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(use-package evil
  :ensure t

  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-insert-state-message nil)
  (setq evil-visual-state-message nil)
  ;;(setq evil-search-module 'evil-search)

  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;;(define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  ;;(evil-global-set-key 'motion "j" 'evil-next-visual-line)
  ;;(evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :ensure t

  :after evil

  :config
  (evil-collection-init))

  ;;:bind
  ;; override evil-normal-state-map C-. (for embark)
  ;;(("C-." . embark-act)))

(use-package evil-surround
  :ensure t

  :config
  (global-evil-surround-mode 1))

(use-package general
  :ensure t

  :config
  (general-evil-setup t)

  (general-create-definer oxo/leader-key
                          :states '(normal insert visual emacs)
                          :keymaps 'override
                          :prefix "SPC"  ;; set leader
                          :global-prefix "C-SPC")  ;; access leader in insert mode

  (general-create-definer oxo/ctrl-c-key
                          :prefix "C-c"))

(use-package helpful
  :ensure t

  :config
  ;; Note that the built-in `describe-function' includes both functions
  ;; and macros. `helpful-function' is functions only, so we provide
  ;; `helpful-callable' as a drop-in replacement.
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)

  ;; Lookup the current symbol at point. C-c C-d is a common keybinding
  ;; for this in lisp modes.
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)

  ;; Look up *F*unctions (excludes macros).
  ;;
  ;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
  ;; already links to the manual, if a function is referenced there.
  (global-set-key (kbd "C-h F") #'helpful-function)

  ;; Look up *C*ommands.
  ;;
  ;; By default, C-h C is bound to describe `describe-coding-system'. I
  ;; don't find this very useful, but it's frequently useful to only
  ;; look at interactive functions.
  (global-set-key (kbd "C-h C") #'helpful-command))

(use-package consult
  :ensure t

  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("M-o" . consult-buffer)                  ;; orig. switch-to-buffer oxo like sway
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)

         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch

         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme

   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-recent-file
   consult--source-project-recent-file

   :preview-key "M-.")
   ;; [consult-buffer error · Issue #772 · minad/consult GitHub]
   ;; (https://github.com/minad/consult/issues/772)

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
)

  (define-key evil-normal-state-map (kbd "/") 'consult-line)
  (define-key evil-normal-state-map (kbd "*") 'evil-search-word-forward)
  (define-key evil-normal-state-map (kbd "#") 'evil-search-word-backward)

(use-package magit
  :ensure t

  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started

(use-package marginalia
  :ensure t

  :after vertigo

  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))

  :init
  (marginalia-mode))

(marginalia-mode t)

(use-package embark
  :ensure t

  :after (evil evil-collection)

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

  ;; override evil-normal-state-map C-.
  (define-key evil-normal-state-map (kbd "C-.") 'embark-act)

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t

  :after (embark consult)

  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer

  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(defun oxo/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :ensure t

  :commands (lsp lsp-deferred)

  :hook (lsp-mode . oxo/lsp-mode-setup)

  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'

  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :ensure t

  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-ivy
  :ensure t)


(use-package company
  :ensure t

  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package zig-mode
  :ensure t)

(require 'ansi-color)
(defun oxo/colorize-compilation ()
  "Colorize from `compilation-filter-start' to `point'."
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region
     compilation-filter-start (point))))

(add-hook 'compilation-filter-hook
          #'oxo/colorize-compilation)

(defun oxo/regexp-alternatives (regexps)
  "Return the alternation of a list of regexps."
  (mapconcat (lambda (regexp)
               (concat "\\(?:" regexp "\\)"))
             regexps "\\|"))

(defvar non-sgr-control-sequence-regexp nil
  "Regexp that matches non-SGR control sequences.")

(setq non-sgr-control-sequence-regexp
      (oxo/regexp-alternatives
       '(;; icon name escape sequences
         "\033\\][0-2];.*?\007"
         ;; non-SGR CSI escape sequences
         "\033\\[\\??[0-9;]*[^0-9;m]"
         ;; noop
         "\012\033\\[2K\033\\[1F"
         )))

(defun oxo/filter-non-sgr-control-sequences-in-region (begin end)
  (save-excursion
    (goto-char begin)
    (while (re-search-forward
            non-sgr-control-sequence-regexp end t)
      (replace-match ""))))

(defun oxo/filter-non-sgr-control-sequences-in-output (ignored)
  (let ((start-marker
         (or comint-last-output-start
             (point-min-marker)))
        (end-marker
         (process-mark
          (get-buffer-process (current-buffer)))))
    (oxo/filter-non-sgr-control-sequences-in-region
     start-marker
     end-marker)))

(add-hook 'comint-output-filter-functions
          'oxo/filter-non-sgr-control-sequences-in-output)

(use-package denote
  :ensure t)

;; [Denote (denote.el) | 17. Sample configuration](https://protesilaos.com/emacs/denote#h:5d16932d-4f7b-493d-8e6a-e5c396b15fd6)
(require 'denote)

;; Remember to check the doc strings of those variables.
(setq denote-directory (expand-file-name "~/Documents/notes/"))
(setq denote-save-buffers nil)
(setq denote-known-keywords '("emacs" "philosophy" "politics" "economics"))
(setq denote-infer-keywords t)
(setq denote-sort-keywords t)
(setq denote-file-type nil) ; Org is the default, set others here
(setq denote-prompts '(title keywords))
(setq denote-excluded-directories-regexp nil)
(setq denote-excluded-keywords-regexp nil)
(setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))

;; Pick dates, where relevant, with Org's advanced interface:
(setq denote-date-prompt-use-org-read-date t)


;; Read this manual for how to specify `denote-templates'.  We do not
;; include an example here to avoid potential confusion.


(setq denote-date-format nil) ; read doc string

;; By default, we do not show the context of links.  We just display
;; file names.  This provides a more informative view.
(setq denote-backlinks-show-context t)

;; Also see `denote-backlinks-display-buffer-action' which is a bit
;; advanced.

;; If you use Markdown or plain text files (Org renders links as buttons
;; right away)
(add-hook 'text-mode-hook #'denote-fontify-links-mode-maybe)

;; We use different ways to specify a path for demo purposes.
(setq denote-dired-directories
      (list denote-directory
            (thread-last denote-directory (expand-file-name "attachments"))
            (expand-file-name "~/Documents/books")))

;; Generic (great if you rename files Denote-style in lots of places):
;; (add-hook 'dired-mode-hook #'denote-dired-mode)
;;
;; OR if only want it in `denote-dired-directories':
(add-hook 'dired-mode-hook #'denote-dired-mode-in-directories)


;; Automatically rename Denote buffers using the `denote-rename-buffer-format'.
(denote-rename-buffer-mode 1)

;; Denote DOES NOT define any key bindings.  This is for the user to
;; decide.  For example:
(let ((map global-map))
  (define-key map (kbd "C-c n n") #'denote)
  (define-key map (kbd "C-c n c") #'denote-region) ; "contents" mnemonic
  (define-key map (kbd "C-c n N") #'denote-type)
  (define-key map (kbd "C-c n d") #'denote-date)
  (define-key map (kbd "C-c n z") #'denote-signature) ; "zettelkasten" mnemonic
  (define-key map (kbd "C-c n s") #'denote-subdirectory)
  (define-key map (kbd "C-c n t") #'denote-template)
  ;; If you intend to use Denote with a variety of file types, it is
  ;; easier to bind the link-related commands to the `global-map', as
  ;; shown here.  Otherwise follow the same pattern for `org-mode-map',
  ;; `markdown-mode-map', and/or `text-mode-map'.
  (define-key map (kbd "C-c n i") #'denote-link) ; "insert" mnemonic
  (define-key map (kbd "C-c n I") #'denote-add-links)
  (define-key map (kbd "C-c n b") #'denote-backlinks)
  (define-key map (kbd "C-c n f f") #'denote-find-link)
  (define-key map (kbd "C-c n f b") #'denote-find-backlink)
  ;; Note that `denote-rename-file' can work from any context, not just
  ;; Dired bufffers.  That is why we bind it here to the `global-map'.
  (define-key map (kbd "C-c n r") #'denote-rename-file)
  (define-key map (kbd "C-c n R") #'denote-rename-file-using-front-matter))

;; Key bindings specifically for Dired.
(let ((map dired-mode-map))
  (define-key map (kbd "C-c C-d C-i") #'denote-link-dired-marked-notes)
  (define-key map (kbd "C-c C-d C-r") #'denote-dired-rename-files)
  (define-key map (kbd "C-c C-d C-k") #'denote-dired-rename-marked-files-with-keywords)
  (define-key map (kbd "C-c C-d C-R") #'denote-dired-rename-marked-files-using-front-matter))

(with-eval-after-load 'org-capture
  (setq denote-org-capture-specifiers "%l\n%i\n%?")
  (add-to-list 'org-capture-templates
               '("n" "New note (with denote.el)" plain
                 (file denote-last-path)
                 #'denote-org-capture
                 :no-save t
                 :immediate-finish nil
                 :kill-buffer t
                 :jump-to-captured t)))

;; Also check the commands `denote-link-after-creating',
;; `denote-link-or-create'.  You may want to bind them to keys as well.


;; If you want to have Denote commands available via a right click
;; context menu, use the following and then enable
;; `context-menu-mode'.
(add-hook 'context-menu-functions #'denote-context-menu)

;; [Activation (The Org Manual)]
;; (https://www.gnu.org/software/emacs/manual/html_node/org/Activation.html)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; aesthetics
(defun oxo/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 0)
  (visual-line-mode 1))

(use-package org
  :ensure t

  :hook (org-mode . oxo/org-mode-setup)

  :config
  ;; replace standard three dots
  (setq org-ellipsis " +"))

;; replace indentation stars
(use-package org-bullets
  :ensure t

  :after org

  :hook (org-mode . org-bullets-mode)

  :custom (org-bullets-bullet-list '("●")))

(defun oxo/org-mode-visual-fill ()
  (setq visual-fill-column-width 100)
        ;;visual-fill-column-center-text t)
  (visual-fill-column-mode 0))

(use-package visual-fill-column
  :ensure t

  :hook (org-mode . oxo/org-mode-visual-fill))

;; read from entire directory
(custom-set-variables '(org-directory "~/.local/share/c/org/"))

(require 'org)

(require 'org-agenda)

  (custom-set-variables
   '(org-agenda-window-setup 'current-window)
   '(org-agenda-span 'week)
   '(org-agenda-start-with-log-mode t)
   '(org-agenda-include-diary t)
   '(org-deadline-warning-days 0))

  (setq org-agenda-time-grid (quote ((daily today require-timed)
                                     (0000 0600 1200 1800)
                                     " ....." "-----")))

  ;; recursively add .org files from agenda directory
  (add-hook 'org-agenda-mode-hook (lambda ()
                                    (setq org-agenda-files
                                          (directory-files-recursively "~/.local/share/c/org/agenda/" "\\`[^.].*\\.org\\'"))))
(setq org-tag-alist
      '(;; locations
        (@home . ?h)
        (@work . ?w)
        ))
  ;;;; recurrint
  ;;(defun oxo/recurrint (recurrences interval m d y)
  ;;"For use in emacs diary. Cyclic item with limited number of recurrences.
  ;;Occurs every INTERVAL days, starting on YYYY-MM-DD, for a total of
  ;;RECURRENCES occasions."
    ;;(let ((startdate (calendar-absolute-from-gregorian (list m d y)))
          ;;(today (calendar-absolute-from-gregorian date)))
      ;;(and (not (minusp (- today startdate)))
           ;;(zerop (% (- today startdate) interval))
           ;;(< (floor (- today startdate) interval) recurrences))))

(require 'org-attach)

(use-package org-journal
  :ensure t)

(custom-set-variables
 '(org-journal-dir "~/.local/share/c/org/journal/")
 '(org-journal-date-format "%Y%m%d W%V %B %d %A")
 '(org-journal-file-type 'yearly))

(define-key global-map (kbd "C-c C-j") 'org-journal-new-entry)

(require 'org-journal)

;; action sequence
(setq org-todo-keywords
        (quote ((sequence "NEXT(1/!)" "TODO(2/!)" "WAIT(4@/!)" "SDMB(5/!)" "|" "CLDR(3/!)" "CNLX(c@/!)" "DONE(d@/!)" ))))
        ;;(quote ((sequence "NEXT(1/!)" "TODO(2/!)" "CLDR(3/!)" "WAIT(4@/!)" "SDMB(5/!)" "|" "CNLX(c@/!)" "DONE(d@/!)" ))))
;; (sequence "QUOTE" "ORDER" "INVOICE" "PAID" "SHIPPED" "DELIVERED"))))

;; action colors
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "cyan" :weight regular
               :box '(:line-width -1 :color "cyan" :style nil))
              ("NEXT" :foreground "cyan" :weight regular
               :box '(:line-width -1 :color "cyan" :style nil))
              ("CLDR" :foreground "yellow" :weight bold)
              ("WAIT" :foreground "magenta" :weight bold)
              ("SDMB" :foreground "cyan" :weight bold)
              ("DONE" :foreground "green" :weight bold)
              ("CNLX" :foreground "dark grey" :weight bold))))

;; log created
(defun oxo/log-todo-creation-date (&rest ignore)
  "Log TODO creation time in the property drawer under the key 'CREATED'."
  (when (and (org-get-todo-state)
             (not (org-entry-get nil "CREATED")))
    (org-entry-put nil "CREATED" (format-time-string (cdr org-time-stamp-formats)))))

(advice-add 'org-insert-todo-heading
            :after #'oxo/log-todo-creation-date)
(advice-add 'org-insert-todo-heading-respect-content
            :after #'oxo/log-todo-creation-date)
(advice-add 'org-insert-todo-subheading
            :after #'oxo/log-todo-creation-date)

(add-hook 'org-after-todo-state-change-hook #'oxo/log-todo-creation-date)

(unless (package-installed-p 'org-present)
  (package-install 'org-present))

(unless (package-installed-p 'visual-fill-column)
  (package-install 'visual-fill-column))

;; fill width
(setq visual-fill-column-width 110
      visual-fill-column-center-text t)

;; collapsed headers
;; info: function has parameters buffer-name and heading
(defun oxo/org-present-prepare-slide (buffer-name heading)
  ;; Show only top-level headlines
  (org-overview)

  ;; Unfold the current entry
  (org-show-entry)

  ;; Show only direct subheadings of the slide but don't expand them
  (org-show-children))

;; info: hook variable ...-hook can not pass parameters to the function it calls
;; info: hook variable ...-functions can pass parameters
(add-hook 'org-present-after-navigate-functions 'oxo/org-present-prepare-slide)

(defun oxo/org-present-start ()
  ;; set font configuration
  (setq-local face-remapping-alist '((default (:height 105.5) fixed-pitch)
              (header-line (:height 105.0) fixed-pitch)
              (org-document-title (:height 105.75) org-document-title)
              (org-code (:height 105.55) org-code)
              (org-verbatim (:height 105.55) org-verbatim)
              (org-block (:height 105.25) org-block)
              (org-block-begin-line (:height 105.7) org-block)))
  ;; start centering text
  (visual-fill-column-mode 1)
  ;; start wrap lines
  ;;(visual-line-mode 1)
  ;; no line numbers
  (global-display-line-numbers-mode 0)
  ;; configure cursor type
  (setq cursor-type 'hbar)
  (blink-cursor-mode 0)
  ;; blank header line to create space at the top of the screen
  (setq header-line-format " "))

(defun oxo/org-present-stop ()
  ;; reset font configuration
  (setq-local face-remapping-alist '((default fixed-pitch default)))
  ;; stop centering text
  (visual-fill-column-mode 0)
  ;; stop wrap lines
  ;;(visual-line-mode 0)
  ;; line numbers on again
  (global-display-line-numbers-mode 1)
  ;; reset cursor type
  (setq cursor-type 't)
  ;; reset blank header line
  (setq header-line-format nil))

;; register hooks with org-present
(add-hook 'org-present-mode-hook 'oxo/org-present-start)
(add-hook 'org-present-mode-quit-hook 'oxo/org-present-stop)

(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)

(setq calendar-week-start-day 1)

(setq calendar-intermonth-text
  '(propertize
    (format "%2d"
            (car
             (calendar-iso-from-absolute
              (calendar-absolute-from-gregorian (list month day year)))))
    'font-lock-face
    'font-lock-warning-face))

(use-package org-capture
  :ensure nil

  :after org

  :custom (org-contacts-files '("~/.local/share/c/org/contacts/contacts.org")))

(use-package ledger-mode
  :ensure t)

(org-babel-do-load-languages 'org-babel-load-languages
			       '((emacs-lisp . t)
				 (python . t)
				 (perl . t)))

(require 'org-tempo)

;;(add-to-list 'org-structure-template-alist '("arduino" . "src arduino"))
;;(add-to-list 'org-structure-template-alist '("c" . "src c"))
;;(add-to-list 'org-structure-template-alist '("cpp" . "src cpp"))
;;(add-to-list 'org-structure-template-alist '("css" . "src css"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
;;(add-to-list 'org-structure-template-alist '("java" . "src java"))
;;(add-to-list 'org-structure-template-alist '("js" . "src js"))
;;(add-to-list 'org-structure-template-alist '("lua" . "src lua"))
;;(add-to-list 'org-structure-template-alist '("make" . "src make"))
;;(add-to-list 'org-structure-template-alist '("perl" . "src perl"))
;;(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
;;(add-to-list 'org-structure-template-alist '("sql" . "src sql"))

(defun oxo/org-babel-tangle-auto-rewrite ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.config/emacs/config.org"))
    ;;                  (expand-file-name (or "~/.config/emacs/config.org" "~/.config/emacs/early-init.org")))
    ;; tangle without confirmation
    ;; let: dynamic scoping for security
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda ()
                           (add-hook 'after-save-hook #'oxo/org-babel-tangle-auto-rewrite)))

(setq custom-file (locate-user-emacs-file "~/.config/emacs/custom.el"))
(load custom-file 'noerror 'nomessage)

;; ;;no splash screen and startup message in echo area
;; (setq inhibit-startup-message t)
;; (setq inhibit-startup-echo-area-message (lambda ()
;;                                           (user-login-name)))
;; ;;(setq server-client-instructions nil)

;; ;; clear default screen clutter
;; (menu-bar-mode -1)
;; (scroll-bar-mode -1)
;; (tool-bar-mode -1)
;; (tooltip-mode -1)
;; (set-fringe-mode 0)

;; ;; UTF-8 as default
;; (set-default-coding-systems 'utf-8)

;; (setq visible-bell nil)

;; (setq ring-bell-function
;;       (lambda ()
;;         (let ((orig-fg (face-foreground 'mode-line)))
;;           (set-face-foreground 'mode-line "red")
;;           (run-with-idle-timer 0.3 nil
;;                                (lambda (fg) (set-face-foreground 'mode-line fg))
;;                                orig-fg))))

(defun oxo/custom-mode-line ()
   ;; column number in modeline
   (column-number-mode)

       ;; background
       ;;(custom-theme-set-faces 'modus-vivendi
       ;;                        :box nil)
       ;;(set-face-attribute 'mode-line nil
       ;;                    :background "black"
       ;;                    :box nil)
       ;; ------

   (setq mode-line-format nil)
   ;; default mode line
   (setq mode-line-format
      '("%e"
        mode-line-front-space
        mode-line-mule-info
        mode-line-client
        mode-line-modified
        mode-line-remote
        mode-line-frame-identification
        mode-line-buffer-identification
        "   "
        mode-line-position
        (vc-mode vc-mode)
        "  "
        mode-line-modes
        mode-line-misc-info
        mode-line-end-spaces))

   (setq mode-line-format
         (list
          "%b"
          )))

(oxo/custom-mode-line)

(use-package diminish
  :ensure t)

;; relative line numbers
  (setq display-line-numbers-type 'relative)
  (setq display-line-numbers-minor-tick '5)
  (setq display-line-numbers-major-tick '10)
;;  (setq line-number-major-tick)
  (global-display-line-numbers-mode)

  ;; disable line numbers for some modes
  (dolist (mode '(term-mode-hook
                  shell-mode-hook
                  eshell-mode-hook))
    (add-hook mode (lambda ()
                     (display-line-numbers-mode 0))))

  ;; TODO absolute line numbers for evil-insert-state
  ;;(add-hook 'evil-insert-state-entry-hook 'menu-bar--display-line-numbers-mode 'absolute)
  ;;(add-hook 'evil-insert-state-exit-hook 'menu-bar--display-line-numbers-mode 'relative)
  ;;(menu-bar--display-line-numbers-mode 'relative)

;;  (add-hook 'window-setup-hook #'(lambda ()
;;                                   (set-cursor-color "#ffffb6")))
;;  (add-hook 'after-make-frame-functions #'(lambda (f)
;;                                            (with-selected-frame f (set-cursor-color "#ffffb6"))))
(setq evil-normal-state-cursor '(box "#ffffb6")
      evil-insert-state-cursor '(bar "#ffffb6")
      evil-visual-state-cursor '(hollow "#ffffb6"))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq use-dialog-box nil) ;; Disable dialog boxes since they weren't working in Mac OSX

(set-frame-parameter nil 'alpha-background 70)
(add-to-list 'default-frame-alist '(alpha-background . 70))

(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(85 . 50) '(100 . 100)))))

(setq hl-line-mode t)

(add-hook 'prog-mode-hook (lambda ()
  (display-fill-column-indicator-mode)))

(defun oxo/set-font-faces ()
  ;; default
  (set-face-attribute 'default nil
                      :font "SauceCodePro Nerd Font"
                      :height 105)
  ;; fixed pitch
  (set-face-attribute 'fixed-pitch nil
                      :font "SauceCodePro Nerd Font"
                      :height 105)
  ;; variable pitch
  (set-face-attribute 'variable-pitch nil
                      :font "SauceCodePro Nerd Font"
                      :height 105
                      :weight 'regular))

(if (daemonp)
    ;;alternative: 'server-after-make-frame-hook
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (setq doom-modeline-icon nil)
                (with-selected-frame frame
                  (oxo/set-font-faces))))
  (oxo/set-font-faces))

;;(setq tab-bar-close-button-show nil
;;tab-bar-open-button-show nil)
;;(setq tab-bar-format '(tab-bar-format-global)
;;  tab-bar-mode t))

;; (use-package base16-theme
;;   :ensure t
;;   :config
;;   (load-theme 'base16-default-dark t))

;; first set the custom variables
(setq modus-themes-mode-line '(borderless))
(setq modus-themes-hl-line '(nil))
(setq modus-themes-region '(bg-only))
(setq modus-themes-completions
      '((matches . (extrabold background))
        (selection . (semibold accented))
        (popup . (accented))))
(setq modus-themes-paren-match '(bold))
(setq modus-themes-bold-constructs t)
(setq modus-themes-italic-constructs t)
;;(setq modus-themes-syntax '(faint))
(setq modus-themes-syntax '(yellow-comments))
(setq modus-themes-headings
 '((1 . (rainbow background 1.1))
   (2 . (rainbow background 1.1))
   (3 . (rainbow background 1.0))
   (4 . (rainbow background 1.0))))
(setq modus-themes-org-blocks 'gray-background)
(setq modus-themes-org-agenda
      '((header-block . (variable-pitch 1.5))
        (header-date . (grayscale workaholic bold-today 1.2))
        (event . (accented italic varied))
        (scheduled . uniform)
        (habit . traffic-light)))

;; load theme after setting the custom variables
(load-theme 'modus-vivendi t)

(setq use-short-answers t)

(setq use-dialog-box nil)

(recentf-mode 1)

(save-place-mode 1)

(setq history-lenght 25)
(savehist-mode 1)

(defun oxo/increment-number-at-point (&optional increment)
  "Increment the number at point by INCREMENT."
  (interactive "*p")
  (let ((pos (point)))
    (save-match-data
      (skip-chars-backward "0-9")
      (if (looking-at "[0-9]+")
          (let ((field-width (- (match-end 0) (match-beginning 0)))
                (newval (+ (string-to-number (match-string 0) 10) increment)))
            (when (< newval 0)
              (setq newval (+ (expt 10 field-width) newval)))
            (replace-match (format (concat "%0" (int-to-string field-width) "d")
                                   newval)))
        (user-error "No number at point")))
    (goto-char pos)))

(defun oxo/decrement-number-at-point (&optional decrement)
  "Decrement the number at point by DECREMENT."
  (interactive "*p")
  (oxo/increment-number-at-point (- decrement)))

;; SPC n a increment
;; SPC n x decrement
(oxo/leader-key
  "n" '(:ignore t :wk "number")
  "n a" '(oxo/increment-number-at-point :wk "increment")
  "n x" '(oxo/decrement-number-at-point :wk "decrement"))

(use-package smartparens
  :ensure t
  :hook (prog-mode text-mode markdown-mode lsp-mode) ;; add `smartparens-mode` to these hooks
  :config
  ;; load default config
  (require 'smartparens-config))

(use-package indent-bars
  :ensure t
  :hook ((lsp-mode) . indent-bars-mode)) ; or whichever modes you prefer

;; 4 'alt /'
(use-package evil-nerd-commenter
  :ensure t
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; 1 'g c (evil normal mode)'
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "g c") 'evilnc-comment-or-uncomment-lines))

;; 2 'SPC g c  go comment toggle'
;; 3 'SPC t c  toggle comment'
(oxo/leader-key
  "g" '(:ignore t :wk "go")
  "t c" '(evilnc-comment-or-uncomment-lines :wk "comment")
  "g c" '(evilnc-comment-or-uncomment-lines :wk "comment toggle"))

(oxo/leader-key
  "w" '(:ignore t :wk "window")
  "w d" '(delete-window :wk "remove focused")
  "w w" '(:ignore t :wk "create new")
  "w w l" '(split-window-right :wk "right")
  "w w j" '(split-window-below :wk "below"))
  ;;(global-set-key (kbd "SPC-w-c-l") 'split-window-right)
  ;;(global-set-key (kbd "SPC-w-c-j") 'split-window-below)

;; ;; prevent interference with org mode map
;; ;; when org-mode loads alter bindings
;; ;;  (defun oxo/org-mode-map-alt-focus ()
;; (define-key outline-mode-map (kbd "<normal-state> M-h") nil)
;; (define-key org-mode-map (kbd "M-h") nil)
;; (define-key outline-mode-map (kbd "<normal-state> M-j") nil)
;; (define-key outline-mode-map (kbd "<normal-state> M-k") nil)
;; (define-key outline-mode-map (kbd "<normal-state> M-l") nil)
;; (global-set-key (kbd "M-h") 'windmove-left)
;; (global-set-key (kbd "M-j") 'windmove-down)
;; (global-set-key (kbd "M-k") 'windmove-up)
;; (global-set-key (kbd "M-l") 'windmove-right)

;; (use-package buffer-move
;;   :ensure t

;;   :config
;;   (global-set-key (kbd "M-H") 'buf-move-left)
;;   (global-set-key (kbd "M-J") 'buf-move-down)
;;   (global-set-key (kbd "M-K") 'buf-move-up)
;;   (global-set-key (kbd "M-L") 'buf-move-right))

;; (global-set-key (kbd "M-C-h") 'shrink-window-horizontally)
;; (global-set-key (kbd "M-C-j") 'enlarge-window)
;; (global-set-key (kbd "M-C-k") 'shrink-window)
;; (global-set-key (kbd "M-C-l") 'enlarge-window-horizontally)

(oxo/leader-key
  "s" '(:ignore t :wk "search")
  "s ." '(isearch-forward-thing-at-point :wk "thing at point")
  "s j" '(isearch-forward :wk "next")
  "s k" '(isearch-backward :wk "prev"))

(delete-selection-mode 1)  ;; overwrite selection from insert mode

(use-package super-save
  :ensure t

  :defer 1

  :diminish super-save-mode

  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

(let ((backup-dir "~/c/emacs/backup")
      (autosave-dir "~/c/emacs/autosave"))
  (dolist (dir (list backup-dir autosave-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,autosave-dir t))
        auto-save-list-file-prefix (concat autosave-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory autosave-dir))

(setq backup-by-copying t    ;; don't delink hardlinks
      delete-old-versions t  ;; automatically delete excess backups
      version-control t      ;; use version numbers on backups
      kept-new-versions 20   ;; how many of the newest versions to keep
      kept-old-versions 5)   ;; and how many of the old

(use-package dired
  :ensure nil

  :commands (dired dired-jump)

  :bind (("C-x C-j" . dired-jump))

  :custom
  ((dired-listing-switches "-ilaA --group-directories-first --color=auto"
                           global-auto-revert-non-file-buffers t
                           dired-kill-when-opening-new-dired-buffer t
                           delete-by-moving-to-trash t))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file))

(setq dired-auto-revert-buffer t)

(setq dired-dwim-target t)

(global-auto-revert-mode 1)

(add-hook 'write-file-hooks 'delete-trailing-whitespace)

(oxo/leader-key
  "t"  '(:ignore t :which-key "toggles")
  "tw" 'whitespace-mode
  "tt" '(counsel-load-theme :which-key "choose theme"))

(use-package pinentry
  :ensure t)
(setq epa-pinentry-mode 'loopback)
(pinentry-start)

;; make escape quit commands
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; zooming text
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") 'text-scale-adjust)

;; consult history
(global-set-key (kbd "M-<up>") 'consult-history)
