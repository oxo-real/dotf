;; prevent lightning at startup
(add-to-list 'default-frame-alist
             '(background-color . "#000000"))
(menu-bar-mode -1)
;; premature redisplays can substantially affect startup time
;; and produce ugly flashes of unstyled Emacs
(setq-default inhibit-redisplay t
              inhibit-message t)
(add-hook 'window-setup-hook
          (lambda ()
            (setq-default inhibit-redisplay nil
                          inhibit-message nil)
            (redisplay)))
