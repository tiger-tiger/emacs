(mouse-avoidance-mode 'animate)
(setq-default case-fold-search t)
(setq frame-title-format "%f")
(setq inhibit-startup-message t)
(setq fill-column 100)
(setq visible-bell t)
(show-paren-mode t)
(setq show-paren-style 'parentheses)
(blink-cursor-mode -1)
(setq kill-ring-max 100) 
;;allow paste between emacs and other applications
(setq select-enable-clipboard t)
;;the following line is commented for MAC
;; (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;; (icomplete-mode 1)
(mouse-wheel-mode t)
;;don't wrap lines
(put 'scroll-left 'disabled nil)
(scroll-left 1)
(scroll-right 1)
(setq hscroll-step 3)
;;(set-window-hscroll (selected-window) 10)
(setq display-line-display-limit 100000)
(setq truncate-partial-width-windows nil)
(setq toggle-truncate-lines t)
(global-set-key (kbd "C-c w") 'toggle-truncate-lines)
;;scroll smoothly
(setq scroll-step 1
      scroll-margin 3
      scroll-conservatively 10000)

(require 'color-theme)

;;image view
(require 'thumbs)
(auto-image-file-mode t)
(desktop-save-mode 1)
(setq history-length 250)
(add-to-list 'desktop-globals-to-save 'file-name-history)
;; remove desktop after it's been read
(add-hook 'desktop-after-read-hook
          '(lambda ()
            ;; desktop-remove clears desktop-dirname
            (setq desktop-dirname-tmp desktop-dirname)
            (desktop-remove)
            (setq desktop-dirname desktop-dirname-tmp)))
(setq desktop-buffers-not-to-save
	  (concat "\\(" "^nn\\.a[0-9]+\\.log\\|(ftp)\\|.*cscope\\|^tags\\|^TAGS"
      "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
	  "\\)$"))
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'infor-lookup-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)
(add-to-list 'desktop-modes-not-to-save 'mark-ring)

;;end of desktop
;;stick to end of line as previous line
(setq track-eol t)
(setq uniquify-buffer-name-style 'forward)

;;session, record history
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
;;auto insert newline at the end of a file
(setq require-final-newline t)
;; ------------------------------------------------------------------
(defun my-insert-date ()
  (interactive)
  (insert (format-time-string "%Y/%m/%d %H:%M:%S" (current-time))))
(global-set-key (kbd "C-c m d") 'my-insert-date)
;;line number-mode and column
(setq column-number-mode t)
(require 'linum)
;; using nlinum instead
(global-linum-mode 1)
;; (add-hook 'linum-mode '(c-mode-hook c++-mode-hook common-lisp-mode-hook elisp-mode-hook))
;; (set-face-attribute 'linum nil :foreground "yellow")
;; (set-face-attribute 'linum nil :background "white")
;; (set-face-background 'linum "yellow")
;; (set-face-foreground 'linum "green")
;; global key setting
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)

;;if no region is active and you press copy or cut you'll copy current line
;;C-w comment by MAC USER, the following lines are useless for MAC
;; Smart copy, if no region active, it simply copy the current whole line
(transient-mark-mode 1)
(global-set-key "\C-w" 'clipboard-kill-region)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key "\C-y" 'clipboard-yank)

;; kill and cut here doesn't work

(defun vi-open-next-line (arg)
  "move to the next line, open new line"
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (indent-according-to-mode))
(global-set-key [(control o)] 'vi-open-next-line)

;;backward kill line
;;Meta
;;the same to \C-x del
(global-set-key [(meta backspace)] 'my-kill-backward-line)
(defun my-kill-backward-line ()
    "Kill backward to the beginnning of line"
 (interactive)
 (kill-region (point)
	      (progn
		(beginning-of-line)
		(point))))
(global-set-key [(control backspace)] 'kill-syntax-backward)
(defun kill-syntax-backward ()
  "Kill characters with syntax at point."
  (interactive)
  (kill-region (point)
	       (progn
		 (skip-syntax-backward (string (char-syntax (char-before))))
		 (point))))
(defun kill-syntax-forward ()
  "Kill characters with syntax at point."
  (interactive)
  (kill-region (point)
	       (progn
		 (skip-syntax-forward (string (char-syntax (char-after))))
		 (point))))
(global-set-key "\M-\C-r" 'isearch-backward-regexp)
(global-set-key "\M-r" 'replace-string)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-h" 'help-command)
(global-set-key "\C-xt" 'indent-relative)
;; Function keys

(global-set-key [f1] 'manual-entry)
(global-set-key [f3] 'repeat-complex-command)
(global-set-key [f4] 'advertised-undo)
(global-set-key [f5] 'other-window)
(global-set-key [f6] 'buffer-menu)
(global-set-key [f7] 'delete-other-windows)
(global-set-key [f9] 'compile)
(global-set-key [c-f9] 'recompile)
(global-set-key [f10] 'next-error)
(global-set-key [c-f10] 'previous-error)
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)
(global-set-key [up] "\C-p")
(global-set-key [down] "\C-n")

;(enable-visual-studio-bookmarks)
;; map for rectangle edit
(require 'rect-mark)
(define-key ctl-x-map "r\C-@" 'rm-set-mark)
(define-key ctl-x-map "r\C-x" 'rm-exchange-point-and-mark)
(define-key ctl-x-map "r\C-w" 'rm-kill-region)
(define-key ctl-x-map "r\M-w" 'rm-kill-ring-save)
(define-key ctl-x-map "r\C-y" 'yank-rectangle)
;; yank copy pase


;;shift+mouse to select region
(define-key global-map [S-down-mouse-1] 'rm-mouse-drag-region)
(setq mouse-drag-copy-region t)
;; Treat 'y' or <CR> as yes, 'n' as no
(fset 'yes-or-no-p 'y-or-n-p)
(define-key query-replace-map [return] 'act)
(define-key query-replace-map [?\C-m] 'act)
;; Pretty diff mode
(autoload 'ediff-buffers "ediff" "Intelligent Emacs interface to diff" t)
(autoload 'ediff-files "ediff" "Intelligent Emacs interface to diff" t)
(autoload 'ediff-files-remote "ediff" "Intelligent Emacs interface to diff" t)
(setq-default make-backup-files nil)
;;(setq backup-directory-alist (quote(("." . "~/.backup")))) 

;;time stamp
;(setq time-stamp-active t)
;(setq time-stamp-warn-inactive t)
;(setq time-stamp-format "%:d.%:m.%:y %02H:%02M:%02S")


;;ido 
;(require 'ido)
;(ido-mode t)
;(setq ido-enable-flex-matching t)
                                        ;(setq ido-everywhere t)


;(global-unset-key (kbd "C-x c"))
;;ibuffer
;; (require 'ibuf-ext)
;; (require 'ibuffer)

;; auctex
(setq Tex-parse-self t)
(setq preview-scale-function 1.5)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'TeX-mode-hook 'flyspell-mode)
(savehist-mode 1)
(setq savehist-file "~/.emacs.d/savehist")
(auto-image-file-mode 1)
(require 'hungry-delete)
(global-hungry-delete-mode)
(require 'move-dup)
(global-move-dup-mode)
(elscreen-start)
(smart-cursor-color-mode 1)
(display-time-mode 1)
(setq abbrev-file-name "~/.emacs.d/abbrev_defs")
(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)
(require 'hl-line+)
(global-hl-line-mode 1)
(set-face-background 'hl-line "DodgerBlue4")
;; (set-face-background 'hl-line "DodgerBlue3")
;; (set-face-background 'hl-line "DodgerBlue2")
;; (set-face-underline-p 'hl-line t)
;; (set-face-attribute 'hl-line nil :underline "red2" )
;; (require 'hl-spotlight)
;(require 'highline)
;; (setq highlight-tail-colors '(("DodgerBlue2" . 0)
;;                               ("DodgerBlue3" . 25)
;;                               ("DodgerBlue4" . 88)))
;; (setq highlight-tail-colors '(("DarkBlue" . 0)
;;                               ("DarkBlue" . 25)
;;                               ("DarkBlue" . 88)))
;(require 'highlight-tail)
;(highlight-tail-mode)
(set 'clean-aindent-is-simple-indent t)
(require 'comment-dwim-2)
(global-set-key (kbd "M-;") 'comment-dwim-2)
(require 'helm-config)
(helm-mode 1)
(setq helm-mini-default-sources '(helm-source-buffers-list
                                  helm-source-recentf
                                  helm-source-bookmarks
                                  helm-source-buffer-not-found))
(require 'helm-projectile)
(helm-projectile-on)

(global-set-key (kbd "C-x C-r" ) 'helm-for-files)
(define-key helm-command-map (kbd "m") 'helm-mini)
(define-key helm-command-map (kbd "a") #'helm-apropos)
(define-key helm-command-map (kbd "p") #'helm-projectile)
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "M-.")  'helm-etags-plus-select)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-unset-key (kbd "C-x c"))
(define-key helm-map (kbd "C-z") 'helm-select-action)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-map (kbd "<ret>") 'helm-execute-persistent-action)
(helm-autoresize-mode t)
(add-to-list 'helm-sources-using-default-as-input 'helm-sources-man-pages)

(require 'highlight-parentheses)  
(global-highlight-parentheses-mode t)
(autoload
    'ace-jump-mode
    "ace-jump-mode"
    "Emacs quick move minor mode"
    t)
(autoload
    'ace-jump-mode-pop-mark
    "ace-jump-mode"
    "Ace jump back:-)"
    t)
(eval-after-load "ace-jump-mode"
    (progn
        '(ace-jump-mode-enable-mark-sync)
        ))


(require 'ace-isearch)
(global-ace-isearch-mode +1)
(define-key global-map (kbd "C-x SPC") 'ace-isearch-pop-mark)
;; triger the search
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; basically C-s  or C-r, but should in 0.35 input the search word
;; or it just go char search

(global-visible-mark-mode 1)
(require 'pos-tip)
(global-set-key (kbd "C-c k") 'browse-kill-ring)

;; (require 'autofit-frame)
;; (add-hook 'after-make-frame-functions 'fit-frame)

(require 'basic-c-compile)
;; C-c C-d h make-instance to search make-instance in clhs
(load "/Users/heisenberg/quicklisp/clhs-use-local.el" t)
;; (setq common-lisp-hyperspec-root "/Users/heisenberg/quicklisp/HyperSpec/")
(setq browse-url-browser-function 'w3m-browse-url)

(require 'which-key)
(which-key-mode)
(global-font-lock-mode t)
(require 'font-lock+)
(modern-c++-font-lock-global-mode t)
(autoload 'cmake-font-lock-activate "cmake-font-lock" nil t)
