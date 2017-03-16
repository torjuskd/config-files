;; we can require features
(require 'cl)
(require 'package)

;; add mirrors for list-packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

;; needed to use things downloaded with the package manager
(package-initialize)


;; install some packages if missing
(let* ((packages '(ac-geiser                ; Auto-complete backend for geiser
		   auto-complete            ; auto completion
		   geiser                   ; GNU Emacs and Scheme talk to each other
		   ido-vertical-mode
		   multiple-cursors
		   paredit                  ; minor mode for editing parentheses
		   pdf-tools
		   latex-preview-pane       ; minor mode, preview your LaTeX files directly in Emacs
		   auctex                   ; extensible package for writing and formatting TeX files
		   ;ox-latex                ; the latex-exporter (from org)
		   ;ox-md                   ; Markdown exporter (from org)
		   pretty-lambdada          ; `lambda' as the Greek letter.
		   try
		   undo-tree
		   monokai-theme
		   molokai-theme
		   solarized-theme
		   zenburn-theme
		   leuven-theme
		   material-theme
		   ))
       (packages (remove-if 'package-installed-p packages)))
  (when packages
    (package-refresh-contents)
    (mapc 'package-install packages)))

;; enable system-copy
(setq x-select-enable-clipboard t)

;; no splash screen
(setq inhibit-splash-screen t)

;; La *scratch*-bufferen være tom.
(setq initial-scratch-message nil)

;; show matching parenthesis
(show-paren-mode 1)

;; show column number in mode-line
(column-number-mode 1)

;; overwrite marked text
(delete-selection-mode 1)

;; enable ido-mode, changes the way files are selected in the minibuffer
(ido-mode 1)

;; use ido everywhere
(ido-everywhere 1)

;; show vertically
(ido-vertical-mode 1)

;; use undo-tree-mode globally
(global-undo-tree-mode 1)

;; stop blinking cursor
(blink-cursor-mode 0)

;; no menubar
(menu-bar-mode 0)

;; no toolbar either
(tool-bar-mode 0)

;; scrollbar? no
(scroll-bar-mode 0)

;; global-linum-mode shows line numbers in all buffers, exchange 0
;; with 1 to enable this feature
(global-linum-mode 0)

;; answer with y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; get the default config for auto-complete (downloaded with
;; package-manager)
(require 'auto-complete-config)

;; load the default config of auto-complete
(ac-config-default)

;; kills the active buffer, not asking what buffer to kill.
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;; choose a color-theme
(load-theme 'material t)

;; function to cycle between themes
(defun cycle-themes ()
  "Returns a function that lets you cycle your themes."
  (lexical-let ((themes '#1=(leuven material . #1#)))
    (lambda ()
      (interactive)
      ;; Rotates the thme cycle and changes the current theme.
      (load-theme (car (setq themes (cdr themes))) t))))

;; Changing themes
(global-set-key (kbd "C-c C-t") (cycle-themes))

;; adds all autosave-files (i.e #test.txt#, test.txt~) in one
;; directory, avoid clutter in filesystem.
(defvar emacs-autosave-directory (concat user-emacs-directory "autosaves/"))
(setq backup-directory-alist
      `((".*" . ,emacs-autosave-directory))
      auto-save-file-name-transforms
      `((".*" ,emacs-autosave-directory t)))

;; defining a function that sets more accessible keyboard-bindings to
;; hiding/showing code-blocs
(defun hideshow-on ()
  (local-set-key (kbd "C-c <right>") 'hs-show-block)
  (local-set-key (kbd "C-c <left>")  'hs-hide-block)
  (local-set-key (kbd "C-c <up>")    'hs-hide-all)
  (local-set-key (kbd "C-c <down>")  'hs-show-all)
  (hs-minor-mode t))

;; now we have to tell emacs where to load these functions. Showing
;; and hiding codeblocks could be useful for all c-like programming
;; (java is c-like) languages, so we add it to the c-mode-common-hook.
(add-hook 'c-mode-common-hook 'hideshow-on)

;; adding shortcuts to java-mode, writing the shortcut folowed by a
;; non-word character will cause an expansion.
(defun java-shortcuts ()
  (define-abbrev-table 'java-mode-abbrev-table
    '(("psv" "public static void main(String[] args) {" nil 0)
      ("sop" "System.out.printf" nil 0)
      ("sopl" "System.out.println" nil 0)))
  (abbrev-mode t))

;; the shortcuts are only useful in java-mode so we'll load them to
;; java-mode-hook.
(add-hook 'java-mode-hook 'java-shortcuts)

;; defining a function that guesses a compile command and bindes the
;; compile-function to C-c C-c
(defun java-setup ()
  (set (make-variable-buffer-local 'compile-command)
       (concat "javac " (buffer-name)))
  (local-set-key (kbd "C-c C-c") 'compile))

;; this is a java-spesific function, so we only load it when entering
;; java-mode
(add-hook 'java-mode-hook 'java-setup)

;; defining a function that sets the right indentation to the marked
;; text, or the entire buffer if no text is selected.
(defun tidy ()
  "Ident, untabify and unwhitespacify current buffer, or region if active."
  (interactive)
  (let ((beg (if (region-active-p) (region-beginning) (point-min)))
	(end (if (region-active-p) (region-end)       (point-max))))
    (whitespace-cleanup)
    (indent-region beg end nil)
    (untabify beg end)))

(defun duplicate-thing (comment)
  "Duplicates the current line, or the region if active. If an argument is
given, the duplicated region will be commented out."
  (interactive "P")
  (save-excursion
    (let ((start (if (region-active-p) (region-beginning) (point-at-bol)))
	  (end   (if (region-active-p) (region-end) (point-at-eol))))
      (goto-char end)
      (unless (region-active-p)
	(newline))
      (insert (buffer-substring start end))
      (when comment (comment-region start end)))))

(global-set-key (kbd "C-c d") 'duplicate-thing)

;; bindes the tidy-function to C-TAB
(global-set-key (kbd "<C-tab>") 'tidy)

;;Rename the file while in buffer
(defun rename-this-buffer-and-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
	(filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
	(error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
	(cond ((get-buffer new-name)
	       (error "A buffer named '%s' already exists!" new-name))
	      (t
	       (rename-file filename new-name 1)
	       (rename-buffer new-name)
	       (set-visited-file-name new-name)
	       (set-buffer-modified-p nil)
	       (message "File '%s' successfully renamed to '%s'" name (file-name-nondirectory new-name))))))))

(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-tools-install))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#272822" "#F92672" "#A6E22E" "#E6DB74" "#66D9EF" "#FD5FF0" "#A1EFE4" "#F8F8F2"])
 '(compilation-message-face (quote default))
 '(custom-safe-themes
   (quote
    ("f81a9aabc6a70441e4a742dfd6d10b2bae1088830dc7aba9c9922f4b1bd2ba50" default)))
 '(fci-rule-color "#3C3D37")
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-tail-colors
   (quote
    (("#3C3D37" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#3C3D37" . 100))))
 '(magit-diff-use-overlays nil)
 '(package-selected-packages
   (quote
    (pdf-tools exec-path-from-shell undo-tree try pretty-lambdada paredit multiple-cursors monokai-theme ido-vertical-mode ac-geiser)))
 '(pos-tip-background-color "#A6E22E")
 '(pos-tip-foreground-color "#272822")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#F92672")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#A6E22E")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#A1EFE4")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#66D9EF"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;More specific setups are placed here near the end of the file.


;; Latex setup

(when (eq system-type 'gnu/linux) 
  (pdf-tools-install) ; pdf-tools to start automatically (nice PDF viewer)
  (setq TeX-view-program-selection '((output-pdf "pdf-tools")))
  (setq TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view"))))

; (pdf-tools-install) ; pdf-tools to start automatically
(latex-preview-pane-enable) ; Should open preview pane automatically, else use "M-x latex-preview-pane-mode".

;; .tex-files should be associated with latex-mode instead of tex-mode.
(add-to-list 'auto-mode-alist '("\\.tex\\'" . latex-mode))

;; Use biblatex for bibliography.
(setq-default bibtex-dialect 'biblatex)

;; I like using the Minted package for source blocks in LaTeX. To make org use this we add the following snippet.

(eval-after-load 'org
  '(add-to-list 'org-latex-packages-alist '("" "minted")))
(setq org-latex-listings 'minted)

;; Because Minted uses Pygments (an external process),
;; we must add the -shell-escape option to the org-latex-pdf-process commands.
;; The tex-compile-commands variable controls the default compile command for Tex- and LaTeX-mode,
;; we can add the flag with a rather dirty statement (if anyone finds a nicer way to do this, please let me know).
(eval-after-load 'tex-mode
  '(setcar (cdr (cddaar tex-compile-commands)) " -shell-escape "))

;; When exporting from Org to LaTeX, use latexmk for compilation.
(eval-after-load 'ox-latex
  '(setq org-latex-pdf-process
	 '("latexmk -pdflatex='pdflatex -shell-escape -interaction nonstopmode' -pdf -f %f")))

;; For my thesis, I need to use our university’s LaTeX class, this snippet makes that class available.
(eval-after-load "ox-latex"
  '(progn
     (add-to-list 'org-latex-classes
		  '("ifimaster"
		    "\\documentclass{ifimaster}
[DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]
\\usepackage{babel,csquotes,ifimasterforside,url,varioref}"
		   ("\\chapter{%s}" . "\\chapter*{%s}")
		   ("\\section{%s}" . "\\section*{%s}")
		   ("\\subsection{%s}" . "\\subsection*{%s}")
		   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		   ("\\paragraph{%s}" . "\\paragraph*{%s}")
		   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
    (custom-set-variables '(org-export-allow-bind-keywords t))))

;; End Latex setup

;; Markdown setup

;; This makes .md-files open in markdown-mode.
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; I sometimes use a specialized markdown format, where inline math-blocks
;; can be achieved by surrounding a LaTeX formula with $math$ and $/math$.
;; Writing these out became tedious, so I wrote a small function.
(defun insert-markdown-inline-math-block ()
  "Inserts an empty math-block if no region is active, otherwise wrap a
math-block around the region."
  (interactive)
  (let* ((beg (region-beginning))
	 (end (region-end))
	 (body (if (region-active-p) (buffer-substring beg end) "")))
    (when (region-active-p)
      (delete-region beg end))
    (insert (concat "$math$ " body " $/math$"))
    (search-backward " $/math$")))

;; Most of my writing in this markup is in Norwegian, so the dictionary is set accordingly.
;; The markup is also sensitive to line breaks, so auto-fill-mode is disabled.
;; Of course we want to bind our lovely function to a key!
(add-hook 'markdown-mode-hook
	  (lambda ()
	    (auto-fill-mode 0)
	    (visual-line-mode 1)
	    (ispell-change-dictionary "norsk")
	    (local-set-key (kbd "C-c b") 'insert-markdown-inline-math-block)) t)

;; End Markdown setup


;; START Scheme-setup

;; We use racket.
(setq geiser-active-implementations '(racket))

;; Visualize matching parentheses.
(show-paren-mode 1)

;; Make sure these features are loaded.
(require 'auto-complete-config)
(require 'ac-geiser)

;; Standard auto-complete setup.
(ac-config-default)

;; ac-geiser recommended setup.
(add-hook 'geiser-mode-hook 'ac-geiser-setup)
(add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'geiser-repl-mode))

;; pretty-lambdada setup.
(add-to-list 'pretty-lambda-auto-modes 'geiser-repl-mode)
(pretty-lambda-for-modes)

;; Loop the pretty-lambda-auto-modes list.
(dolist (mode pretty-lambda-auto-modes)
  ;; add paredit-mode to all mode-hooks
  (add-hook (intern (concat (symbol-name mode) "-hook")) 'paredit-mode))

;; END Scheme-setup
