;;; publish.el --- To publish my org site -*- lexical-binding: t; -*-

;; Author: Kanishak Vaidya <kanishak@gmail>
;; Maintainer: Kanishak Vaidya <kanishak@gmail>
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;; Code:

;; (org-export-define-derived-backend 'my-custom-backend 'html
;;   :options-alist
;;   '((:keywords "keywords" nil nil split)
;;     (:filetags "filetags" nil nil split)))

;; (defun kpv/sitemap (file style project)
;;   (concat (format-time-string "%Y-%m-%d" (org-publish-find-date file project)) " - [[./" file "][" (org-publish-find-title file project) "]] " (mapconcat 'identity (org-publish-find-property file :filetags project) " : ")))

(require 'org)

(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-export-with-timestamps nil
      org-export-time-stamp-file nil)


(setq org-publish-project-alist
   '(
     ("kvos-site"
      :base-directory "~/doc/repos/arch-kvos/org-site"
      :base-extension "org"
      :publishing-directory "~/doc/repos/arch-kvos/docs"
      :html-link-home "https://kanishakvaidya.github.io/arch-kvos"
      :html-link-use-abs-url t
      :recursive t
      :with-author nil
      :with-broken-links t
      :with-creator t
      :html-validation-link nil
      :publishing-function org-html-publish-to-html)
     ("kvos-static"
      :base-directory "~/doc/repos/arch-kvos/org-site"
      :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|svg\\|ttf"
      :publishing-directory "~/doc/repos/arch-kvos/docs"
      :recursive t
      :publishing-function org-publish-attachment)
     ("kvos" :components ("kvos-site" "kvos-static"))))

(org-publish-project "kvos")

;; (provide 'publish)
;;; publish.el ends here

