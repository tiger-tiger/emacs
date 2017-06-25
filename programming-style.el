(set-default 'indent-tabs-mode nil)
;;auto-indent
(require 'auto-indent-mode)
;(auto-indent-global-mode)
(which-func-mode 1)
(add-hook 'emacs-lisp-mode-hook 'auto-indent-mode)
(add-hook 'lisp-mode-hook 'auto-indent-mode)
(add-hook 'c++-mode-hook 'auto-indent-mode)
(setq auto-indent-assign-indent-level 4)
(require 'company)                      ;
(add-hook 'after-init-hook 'global-company-mode)
;; (add-to-list 'company-backends 'company-c-headers)
(company-quickhelp-mode 1)
(add-to-list 'company-backends 'company-jedi)
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'eldoc-mode)
(setq company-number-mode t)

;;--for auto-complete
;;; for auto-complete
(require 'auto-complete)

(ac-config-default)
(global-auto-complete-mode t)

;;(require 'anything)
;;(require 'anything-config)
;; (setq auto-indent-newline-function 'newline-and-indent)
;;auto-insert
(setq auto-insert t)
;(setq auto-insert-query t)
(add-hook 'find-file-hooks 'auto-insert)
(setq auto-insert-directory "~/.emacs.d/insert/")
;;auto +x for script file
(setq my-shebang-patterns
      (list "^#!/usr/.*/perl|\\(\\(\\)\\|\\(.+\\)\\)-w *.*"
            "^#!.*/usr/.*/sh"
            "^#!.*/usr/.*/bash"
            "^#!.*/bin/sh"
            "^#!.*/.*/perl"
            "^#!.*/.*/awk"
            "^#!.*/.*/sed"
            "^#!.*/bin/bash"))
(add-hook
  'after-save-hook
  (lambda()
    (if (not (= (shell-command (concat "test -x " (buffer-file-name))) 0))
      (progn
        ;;This puts message in *Message* twice, but minibuffer
        ;;output looks better
        (message (concat "Not executable " (buffer-file-name)))
        (save-excursion
          (goto-char (point-min))
          ;;Always checks every pattern even after match
          ;;inefficient not easy
          (dolist (my-shebang-pat my-shebang-patterns)
            (if (looking-at my-shebang-pat)
              (if (= (shell-command
                       (concat "chmod u+x " (buffer-file-name)))
                     0)
                (message (concat
                           "Write and made executable "
                           (buffer-file-name))))))))
      ;; This puts message in *Message* twice
      (message (concat "Write " (buffer-file-name))))))
;; go to the matching brace
(global-set-key (kbd "C-%") 'match-paren)
(defun match-paren (arg)
  ;;Go to the matching paren if on a paren; otherwise insert %"
  (interactive "p")
  (cond ((looking-at "\\s\(")(forward-list 1)(backward-char 1))
        ((looking-at "\\s\)")(forward-char 1)(backward-list 1))
        (t (self-insert-command (or arg 1))))
  )
;;header file message
;;M-x make-header
;(require 'header2)

(setq user-mail-address "zhangqjun@gmail.com")
;; (add-hook 'write-file-hooks 'update-file-header)
;; (add-hook 'emacs-lisp-mode-hook 'auto-make-header)
;; (add-hook 'c-mode-common-hook 'auto-make-header)

;;delete between matched brace
(defun kill-match-paren (arg)
  (interactive "p")
  (cond ((looking-at "[([{]")(kill-sexp 1)(backward-char))
        (looking-at "[])}]")(forward-char)(backward-kill-sexp 1))
  (t (self-insert-command (or arg 1))))
(global-set-key (kbd "C-x %") 'kill-match-paren)


;;font lock for customized types
(require 'ctypes)
(ctypes-auto-parse-mode 1)

(setq auto-mode-alist
      (append '(("\\.cpp$" . c++-mode)
                ("\\.hpp$" . c++-mode)
                ("\\.CPP$" . c++-mode)
                ("\\.hxx"  . c++-mode)
                ("\\.lsp$"  . lisp-mode)
                ("\\.el$" . lisp-mode)
                ("\\.cl$" . lisp-mode)
                ("\\.lisp$" . lisp-mode)
                ("\\.scm$" . scheme-mode)
                ("\\.pl$" . cperl-mode)
                ("\\.plx$" . cperl-mode)
                ("\\.py$" . python-mode)
                ("\\.pdb$" . text-mode)
                ) auto-mode-alist))

;;set tab to indent
;;(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-stop-list ())
(loop for x downfrom 40 to 1 do
      (setq tab-stop-list (cons (* x 4) tab-stop-list)))

(setq c-basic-offset 4)
(defun qt-lineup-topmost-intro-cont (langelem)
  (let ((previous-point (point))(previous-line-end-position (line-end-position)))
      (save-excursion
      ;; Go back to the previous non-blank line, if any.
      (while
        (progn
          (forward-line -1)
          (back-to-indentation)
          (and (> (point) (c-langelem-pos langelem))
               (looking-at "[ \t]*$"))))
      (if (search-forward "Q_OBJECT" (line-end-position) t)
        (if (or (re-search-forward "private[ \t]*:" previous-line-end-position t)
                (re-search-forward "protected[ \t]*:" previous-line-end-position t)
                (re-search-forward "public[ \t]*:" previous-line-end-position t)
                (re-search-forward "signals[ \t]*:" previous-line-end-position t)
                (re-search-forward "public[ \t]+slots[ \t]*:" previous-line-end-position t)
                )
          '-
          '0
          )
        (progn
          (goto-char previous-point)
          (c-lineup-topmost-intro-cont langelem)
          )
        )
      )
    )
  )
;  (setq c++-mode-hook 
;	 (lambda ()
;	   (c-set-offset 'topmost-intro-cont 'qt-lineup-topmost-intro-cont)))
(defconst my-c-style
          '(
            (c-tab-always-indent        . t)
            (c-comment-only-line-offset . 0)
            (c-hanging-colons-alist     . ((member-init-intro before)
                                           (inher-intro)
                                           (case-label after)
                                           (label after)
                                           (access-label after)))
            (c-hanging-semi&comma-criteria . (c-semi&comma-no-newlines-before-nonblanks
                                               c-semi&comma-inside-parenlist
                                               c-semi&comma-no-newlines-for-oneline-inliners))
            (c-cleanup-list . (brace-else-brace
                                brace-elseif-brace
                                brace-catch-brace
                                empty-defun-braces
                                defun-close-semi
                                list-close-comma
                                scope-operator))
            (c-hanging-braces-alist . (
                                       (defun-open) (defun-close before) 
                                       (class-open before after) (class-close)
                                       (inline-open) (inline-close) 
                                       (block-open after) (block-close before)
                                       (statement-cont before) 
                                       (substatement-open before) 
                                       (statement-case-open after)
                                       (brace-list-open) (brace-list-close)
                                       (brace-list-intro) (brace-entry-open)
                                       (extern-lang-open) (extern-lang-close) 
                                       (namespace-open before) (namespace-close before)
                                       (module-open) (module-close) 
                                       (composition-open) (composition-close) 
                                       (inexpr-class-open before)
                                       (inexpr-class-close)
                                       (arglist-cont-nonempty before)))
            
            (c-offsets-alist   
              (arglist-close . c-lineup-arglist)
              (string . c-lineup-dont-change) 
              (c . c-lineup-C-comments) 
              (defun-open . 0) (defun-close . 0) 
              (defun-block-intro . +) (class-open . 0) 
              (class-close . 0) 
              (inline-open . +) (inline-close . 0) (func-decl-cont . +) 
             (knr-argdecl-intro . +) (knr-argdecl . 0) (topmost-intro . 0)
              (topmost-intro-cont . qt-lineup-topmost-intro-cont)
              (member-init-intro . +) (member-init-cont . c-lineup-multi-inher) 
              (inher-intro . +) 
              (inher-cont . c-lineup-multi-inher) 
              ;(inher-cont . qt-lineup-inher-cont)
              (block-open . 0)
              (block-close . 0) (brace-list-open . 0) (brace-list-close . 0) 
              (brace-list-intro . +) (brace-list-entry . 0) (brace-entry-open . 0)
              (statement . 0) (statement-cont . +) (statement-block-intro . +) 
              (statement-case-intro . +) (statement-case-open . 0) (substatement . +)
              (substatement-open . 0) (substatement-label . 2) (case-label . 0) 
              (access-label . -) (label . 2) (do-while-closure . 0) (else-clause . 0)
              (catch-clause . 0) (comment-intro c-lineup-knr-region-comment c-lineup-comment) 
              (arglist-intro . +) (arglist-cont c-lineup-gcc-asm-reg 0) 
              (arglist-cont-nonempty c-lineup-gcc-asm-reg c-lineup-arglist) ;(arglist-close . +)
              (arglist-close . c-lineup-close-paren)
              (stream-op . c-lineup-streamop) (inclass . +) (cpp-macro . [0]) 
              (cpp-macro-cont . +) (cpp-define-intro c-lineup-cpp-define +) 
              (friend . 0) (objc-method-intro . [0]) (objc-method-args-cont . c-lineup-ObjC-method-args)
              (objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
              (extern-lang-open . 0) (namespace-open . 0) (module-open . 0) 
              (composition-open . 0) (extern-lang-close . 0) (namespace-close . 0) 
              (module-close . 0) (composition-close . 0) (inextern-lang . +) (innamespace . +)
              (inmodule . +) (incomposition . +) (template-args-cont c-lineup-template-args +)
              (inlambda . c-lineup-inexpr-block) (lambda-intro-cont . +) (inexpr-statement . +) 
              (inexpr-class . +)
              )
            ))
(c-add-style "PERSONAL" my-c-style)
(defun my-c-mode-common-hook ()
  ;; this will make sure spaces are used instead of tabs
  (setq tab-width 4 indent-tabs-mode nil)
  (setq c-auto-newline t)
  (c-toggle-auto-hungry-state 1)
  (c-set-style "PERSONAL")
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; c/c++ mode
(require 'autopair)
(autopair-global-mode)
;; lisp paredit instead

(add-hook 'c-mode-hook
          '(lambda()
             (setq c-basic-offset 4)
             (setq c-comment-only-line-offset 0)
             (setq c-tab-always-indent t)
             (setq c-auto-hungry-initial-state 'none)
             ;(define-key c-mode-map "\C-m" 'reindent-then-newline-and-indent)
             ;;(c-toggle-auto-state) auto enter to the next line
             ;;show in which function
             (setq which-func-mode 1)
             ))
(add-hook 'c++-mode-hook
          '(lambda()
             (setq c-basic-offset  4)
             (setq c-comment-only-line-offset  0)
             (setq c++-tab-always-indent t)
             (setq c++-empty-arglist-indent 2)
             (setq which-func-mode 1)
             ))
(add-hook 'c++-mode-hook 'hs-minor-mode)

;; java mode
;; perl mode
(defalias 'perl-mode 'cperl-mode)
(add-hook 'cperl-mode-hook
          '(lambda()
             ;;(setq c-basic-offset 4)
             ;;important for autoindent
             (define-key cperl-mode-map "\C-m" 'reindent-then-newline-and-indent)
             ;;(setq tab-width 4)
             (setq cperl-auto-newline  t)
             (setq indent-tabs-mode  nil)
             (setq cperl-indent-level  4)
             (setq cperl-brace-offset  0)
             (setq cperl-continued-brace-offset  0)
             (setq cperl-continued-statement-offset  4)
             ;;(setq cperl-brace-imaginary-offset 0)
             (setq cperl-close-paren-offset  -4)
            (setq indent-parens-as-block  t)
             ;;(setq cperl-indentation-style "K&R")
             ))
;;cperl-mode	
(add-to-list 'auto-mode-alist '("\\\\.[Pp][LlMm][Cc]?$" . perl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . perl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . perl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . perl-mode))
(while (let ((orig (rassoc 'perl-mode auto-mode-alist)))
         (if orig (setcdr orig 'cperl-mode))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;python mode
(setq python-indent-guess-indent-offset nil)
(require 'python-mode)
(defun my-python-mode-hook ()
 (custom-set-variables
  '(indent-tabs-mode nil)
  '(tab-width 4)
  '(tab-stop-list nil))
 )

(add-hook 'python-mode-hook 'jedi:setup)
(when (require 'elpy nil t) (elpy-enable))

;; (add-hook 'python-mode-hook 'my-python-mode-hook)
;; end of pyton mode 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Scheme mode
(add-hook 'scheme-mode-hook
          '(lambda()
            (define-key scheme-mode-map "\C-m" 'reindent-then-newline-and-indent)))
;; lisp mode
(autoload 'paredit-mode "paredit"
    "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'lisp-mode-hook
          #'(lambda ()
                (setq autopair-dont-activate t)
                (autopair-mode -1)))
(add-hook 'lisp-mode-hook 'company-mode)
(setq slime-lisp-implementations '((sbcl ("/opt/local/bin/sbcl"))
                                   (clisp ("/opt/local/bin/clisp"))
))
(setq inferior-lisp-program "/opt/local/bin/sbcl")
;; lisp-indent-function 'common-lisp-indent-function
;; slime-startup-animation nil)

(require 'slime)
(require 'slime-autoloads)
(slime-setup '(slime-fancy))
(define-key slime-mode-map (kbd "C-c C-c") 'slime-compile-defun)
(define-key slime-mode-map (kbd "M-.") nil)

;; (define-key slime-mode-map  (kbd "M-.") 'slime-edit-definition-with-etags)
(eval-after-load "slime"
    '(progn
      (define-key slime-mode-map  (kbd "C-c ;") 'slime-insert-balanced-comments)
      (define-key slime-mode-map  (kbd "C-c C-c") 'slime-compile-defun)
      (linum-mode -1)
      ;; (nlinum-mode -1)
      ))
;; (add-hook 'slime-mode-hook '(lambda () (nlinum-mode 0)))

(add-hook 'emacs-lisp-mode-hook   'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'slime-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook  'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)

(eval-after-load "paredit"
    '(progn
      (define-key paredit-mode-map (kbd "M-;") 'comment-dwim-2)
      ))


;; end of lisp mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (slime-define-key [(meta ?\.)] 'slime-edit-definition-with-etags))))
;; Fortran mode
(add-hook 'fortran-mode-hook
          '(lambda()
             (auto-fill-mode 1)
             (setq fortran-if-indent 3)
             (setq fortran-do-indent 3)
             (setq fortran-structure-indent 3)
             (setq fortran-comment-line-extra-indent -3)
             (setq fortran-continuation-indent 5)
             (setq fortran-minimum-statement-indent-tab 6)
             ))
(add-hook 'f90-mode-hook
          (lambda () (local-set-key (kdb "RET") 'reindent-then-newline-and-indent)))

;; (ido-mode 1)

;; end of auto-complete

;git
(require 'magit)
;; tex-mik 
(require 'tex-mik)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
;; (latex-preview-pane-enable)
;; (require 'company-auctex)
;; (company-auctex-init)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-highlighting-mode 'lines)

;; close auto-complete
;; (setq ac-auto-start nil)
;; smartly add space around operator
(electric-spacing-mode 1)
;; icicle is similar to helm for buffer switch
;; (icy-mode 0)
;; all disable items should be listed in the end this file
;; can't disable auto-complete for python, don't know why
;; (add-hook 'python-mode-hook #'(lambda () (auto-complete-mode -1)))
;; to enable auto-complete check line #17 

;; projectile
(projectile-global-mode)
(setq projectile-require-project-root nil)

