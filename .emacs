;;
;; newdotemacs: replacement .emacs
;; 18-Aug-2009 Creation
;;
;; Really should put this in a local git and cleanup.. 

;; Speed up startup

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(modify-frame-parameters nil '((wait-for-wm . nil)))
;; Don't load the default library
;;
(setq inhibit-default-init t)
;;
;; Expand tabs to spaces
(setq-default indent-tabs-mode nil)
;; indent-tabs-mode is buffer local
(setq indent-tabs-mode nil)
;; Eliminate splash screen
(setq inhibit-splash-screen t)
;;
;; Allow emacs to operate on regions only
(put 'narrow-to-region 'disabled nil)
;;
;; Extend the load path with my personal libs
(add-to-list 'load-path "~/emacs/lisp")
(add-to-list 'load-path "~/emacs/tramp-2.1.17")
(add-to-list 'load-path "~/emacs/lib/emacs/site-lisp")
(add-to-list 'load-path "~/emacs/lib/emacs/site-lisp/color-theme-6.6.0")
;;
;; Load my standard keys
(load-file "~/emacs/lib/emacs/site-lisp/asml-keys.el")
;;
;; turn on time and mail flag in the modeline
(display-time)
(setq display-time-24hr-format t)

;; Found in a post by Shyamal Prasad (exushml@s10b06.exu.ericsson.se)
;; If on a parenthesis, typing %  takes you to the matching parenthesis.
;; Otherwise, it just inserts a %.
;; I ext

(global-set-key "%" 'goto-match-paren)
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis AND last command is a movement command, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (message "%s" last-command)
  (if (not (memq last-command '(
                                set-mark
                                cua-set-mark
                                goto-match-paren
                                down-list
                                up-list
                                end-of-defun
                                beginning-of-defun
                                backward-sexp
                                forward-sexp
                                backward-up-list
                                forward-paragraph
                                backward-paragraph
                                end-of-buffer
                                beginning-of-buffer
                                backward-word
                                forward-word
                                mwheel-scroll
                                backward-word
                                forward-word
                                mouse-start-secondary
                                mouse-yank-secondary
                                mouse-secondary-save-then-kill
                                move-end-of-line
                                move-beginning-of-line
                                backward-char
                                forward-char
                                scroll-up
                                scroll-down
                                scroll-left
                                scroll-right
                                mouse-set-point
                                next-buffer
                                previous-buffer
                                )
                 ))
      (self-insert-command (or arg 1))
    (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
          ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
          (t (self-insert-command (or arg 1))))))

;; Ediff configuration.
;; Needs review
(autoload 'ediff-buffers "ediff" "Visual interface to diff" t)
(autoload 'ediff  "ediff"  "Visual interface to diff" t)
(autoload 'ediff-files "ediff" "Visual interface to diff" t)
(autoload 'ediff-windows "ediff" "Visual interface to diff" t)
(autoload 'ediff-regions "ediff" "Visual interface to diff" t)
(autoload 'epatch  "ediff"  "Visual interface to patch" t)
(autoload 'ediff-patch-file "ediff" "Visual interface to patch" t)
(autoload 'ediff-patch-buffer "ediff" "Visual interface to patch" t)
(autoload 'epatch-buffer "ediff" "Visual interface to patch" t)
(autoload 'ediff-revision "ediff"
			"Interface to diff & version control" t)
;; Following customizes ediff the way I like it.
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-use-last-dir t)
(require 'vc)
(unless (fboundp 'make-temp-file)
  (defun make-temp-file (p)
    (make-temp-name (expand-file-name p temporary-file-directory))))
(defun vc-ediff (rev)
  (interactive "sVersion to diff (default is BASE): ")
  (vc-ensure-vc-buffer)
  (let* ((version (if (string-equal rev "")
		      (vc-latest-version buffer-file-name)
		    rev))
	 (filename (make-temp-file "vc-ediff")))
    (vc-backend-checkout buffer-file-name nil version filename)
    (let ((buf (find-file-noselect filename)))
      (ediff-buffers buf (current-buffer)))))

;; Make sure the buffer name is unique, and reflects the location of its
;; contents
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Turn on crypt++ mode: this also handles tar zip etc.
(require 'crypt++)

;; Time stamp functionality
(defun date ()
  "Insert a nicely formated date string."
  (interactive)
  (insert (format-time-string "%d-%b-%Y"))
)
(defun timestamp()
  "insert the current date/timestamp."
  (interactive)
  (insert (format-time-string "%d-%b-%YT%H:%M:%S"))
)

;;
;; Programming mode support
;; cwarn : highlight suspicious C/C++ constructs
(require 'cwarn)
(global-cwarn-mode 1)

;; Move between functions
(defun beginning-of-next-defun ()
  "Moves cursor to the beginning of the next defun."
  (interactive)
  (beginning-of-defun -1))

(global-set-key '[(meta up)] 'beginning-of-defun)
(global-set-key '[(meta down)] 'beginning-of-next-defun)
;;
;; Buffer cycling
(global-set-key "\M-z"  'bury-buffer)

;;
(setq hcz-set-cursor-color-color "")
(setq hcz-set-cursor-color-buffer "")
(defun hcz-set-cursor-color-according-to-mode ()
  "change cursor color according to some minor modes."
  ;; set-cursor-color is somewhat costly, so we only call it when needed:
  (let ((color
	 (if buffer-read-only "black"
	   (if overwrite-mode "red"
	     "blue"))))
    (unless (and
	     (string= color hcz-set-cursor-color-color)
	     (string= (buffer-name) hcz-set-cursor-color-buffer))
      (set-cursor-color (setq hcz-set-cursor-color-color color))
      (setq hcz-set-cursor-color-buffer (buffer-name)))))
(add-hook 'post-command-hook 'hcz-set-cursor-color-according-to-mode)
;;
;; Auto fill on in text mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; playing around with colors:
(require 'color-theme)
;; Following information received on emacs wiki
;; http://www.emacswiki.org/emacs/ColorTheme
(defun color-theme-face-attr-construct (face frame)
       (if (atom face)
	   (custom-face-attributes-get face frame)
	 (if (and (consp face) (eq (car face) 'quote))
	     (custom-face-attributes-get (cadr face) frame)
	   (custom-face-attributes-get (car face) frame))))

;;
;; After some playing around with color-theme-select:
;; (Whateveryou like is a nice theme too.. )
(setq color-theme-is-global t)
(color-theme-initialize)
;;(color-theme-high-contrast)
;;
;;
;; tramp mode
;;(setq tramp-syntax 'url)
(require 'tramp)

;;
;; Package manager support/monokai theme
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(require 'color-theme)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;;(load-theme 'monokai t)


;; 
;; Org mode customization 
;; based on http://stackoverflow.com/questions/22394394/orgmode-a-report-of-tasks-that-are-done-within-the-week
;;
;; define "R" as the prefix key for reviewing what happened in various
;; time periods


(require 'org-install)
(require 'org-agenda)
(require 'org-habit)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(add-to-list 'org-agenda-custom-commands
             '("R" . "Review" )
             )
;; Common settings for all reviews
(setq efs/org-agenda-review-settings
      '((org-agenda-show-all-dates t)
        (org-agenda-start-with-log-mode t)
        (org-agenda-start-with-clockreport-mode t)
        (org-agenda-archives-mode t)
        ;; I don't care if an entry was archived
        (org-agenda-hide-tags-regexp
         (concat org-agenda-hide-tags-regexp
                 "\\|ARCHIVE"))
      ))

; Show the agenda with the log turn on, the clock table show and
;; archived entries shown.  These commands are all the same exept for
;; the time period.
(add-to-list 'org-agenda-custom-commands
             `("Rw" "Week in review"
                agenda ""
                ;; agenda settings
                ,(append
                  efs/org-agenda-review-settings
                  '((org-agenda-span 'week)
                    (org-agenda-start-on-weekday 0)
                    (org-agenda-overriding-header "Week in Review"))
                  )
                ("~/org/review/week.html")
                ))


(add-to-list 'org-agenda-custom-commands
             `("Rd" "Day in review"
                agenda ""
                ;; agenda settings
                ,(append
                  efs/org-agenda-review-settings
                  '((org-agenda-span 'day)
                    (org-agenda-overriding-header "Week in Review"))
                  )
                ("~/org/review/day.html")
                ))

(add-to-list 'org-agenda-custom-commands
             `("Rm" "Month in review"
                agenda ""
                ;; agenda settings
                ,(append
                  efs/org-agenda-review-settings
                  '((org-agenda-span 'month)
                    (org-agenda-start-day "01")
                    (org-read-date-prefer-future nil)
                    (org-agenda-overriding-header "Month in Review"))
                  )
                ("~/org/review/month.html")
                ))

(defvar org-journal-file "~/Plans/Journal.org"  
  "Path to OrgMode journal file.") 
(defvar org-journal-date-format "%Y-%m-%d"  
  "Date format string for journal headings.")
  
(defun org-journal-entry ()  
  "Create a new diary entry for today or append to an existing one."  
  (interactive)
  (switch-to-buffer (find-file org-journal-file))
  (widen)
  (let ((isearch-forward t)
        (today (format-time-string org-journal-date-format)))
    (beginning-of-buffer)
    (unless (org-goto-local-search-headings today nil t)
      ((lambda ()
         (org-insert-heading)
         (insert today)
         (insert "\n\n  \n"))))
    (beginning-of-buffer)
    (org-show-entry)
    (org-narrow-to-subtree)
    (end-of-buffer)
    (backward-char 2)
    (unless (= (current-column) 2)
      (insert "\n\n  "))))

(global-set-key (kbd "C-c C-j") 'org-journal-entry)


;;(require 'org-publish)
(setq org-publish-project-alist
      '(

       ;; ... add all the components here (see below)...

        ("org-notes"
         :base-directory "~/Plans/"
         :base-extension "org"
         :publishing-directory "~/public_html/"
         :recursive t
         :publishing-function org-publish-org-to-html
         :headline-levels 4             ; Just the default for this project.
         :auto-preamble t
         )
        ("org-static"
         :base-directory "~/Plans/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/public_html/"
         :recursive t
         :publishing-function org-publish-attachment
         ("org" :components ("org-notes" "org-static"))
        )

      ))

;pdb setup, note the python version
(setq pdb-path '/usr/lib/python2.6/pdb.py
      gud-pdb-command-name (symbol-name pdb-path))
(defadvice pdb (before gud-query-cmdline activate)
  "Provide a better default command line when called interactively."
  (interactive
   (list (gud-query-cmdline pdb-path
	 		    (file-name-nondirectory buffer-file-name)))))
