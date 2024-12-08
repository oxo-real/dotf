(add-to-list 'default-frame-alist
             '(background-color . "#000000"))

(setq-default inhibit-redisplay t
              inhibit-message t)
(add-hook 'window-setup-hook
          (lambda ()
            (setq-default inhibit-redisplay nil
                          inhibit-message nil)
            (redisplay)))

;; Prevent lightning when emacs starts
(add-to-list 'default-frame-alist
             '(background-color . "#000000"))

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Startup %s. %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;;no splash screen and startup message in echo area
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message (lambda ()
                                          (user-login-name)))

;;(setq server-client-instructions nil)
(setq ring-bell-function 'ignore)

;; clear default screen clutter
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 0)

;; UTF-8 as default
(set-default-coding-systems 'utf-8)
