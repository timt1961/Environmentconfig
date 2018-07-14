;;; planner-setup.el --- 

;; Copyright 2012 Tim Timmerman
;;
;; Author: utt@wsasd492
;; Version: $Id: planner-setup.el,v 0.0 2012/12/12 08:07:47 utt Exp $
;; Keywords: 
;; X-URL: not distributed yet

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; 

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'planner-setup)

;;; Code:
 (require 'remember-planner)
    (setq remember-handler-functions '(remember-planner-append))
    (setq remember-annotation-functions planner-annotation-functions)

;; Planner set up from emacs wiki
(setq planner-project "WikiPlanner")
     (setq muse-project-alist
	   '(("WikiPlanner"
	      ("~/Plans"   ;; Or wherever you want your planner files to be
	       :default "index"
	       :major-mode planner-mode
	       :visit-link planner-visit-link))))

(require 'planner)
;;; Planner key bindings. (This is how I like them)
(global-set-key [f1] 'plan)
(global-set-key [f2] 'planner-create-task-from-buffer)
(global-set-key [S-f2] 'planner-task-done)
(global-set-key [C-f2] 'planner-delete-task)

;; Linux only (at the moment)

(require 'remember-planner)
(global-set-key [f3] 'remember)

;;Old planner setup
;;(setq remember-handler-functions '(remember-planner-append))
(setq remember-annotation-functions planner-annotation-functions)
;; Publishing Plans
(planner-option-customized 'planner-publishing-directory "/home/utt/WWW/Plans")
;;
;; diary mode
(european-calendar)
(setq calendar-week-start-day 1)
(add-hook 'list-diary-entries-hook 'sort-diary-entries t)
(setq diary-file "~/Plans/diary")

;; Appointments
(require 'planner-appt)
(planner-appt-use-tasks-and-schedule)
(planner-appt-insinuate)
;;
;; Temporary planner-diary code (move to final location later)
(require 'planner-diary)
(add-hook 'diary-display-hook 'fancy-diary-display)
(setq planner-diary-use-diary t)
(planner-diary-insinuate)
(setq planner-day-page-template
      "* Tasks\n\n\n* Schedule\n\n\n* Timeclock\n\n\n* Diary\n\n\n* Notes")

;; global task ids
(require 'planner-id)

;; planner reports
(require 'planner-report)

;;
;; Project as keywords
(require 'muse-wiki)    ;;; Allow wiki-links
(setq muse-wiki-allow-nonexistent-wikiword t)
