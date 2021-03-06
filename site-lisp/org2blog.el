;;; org2blog.el --- blog from Org mode to wordpress
;; Copyright (C) 2010 Puneeth Chaganti

;; Author: Puneeth Chaganti <punchagan+org2blog at gmail dot com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; A portion of the code in this file is based on blog.el posted to 
;; http://www.mail-archive.com/gnu-emacs-sources@gnu.org/msg01576.html
;; copyrighted by Ashish Shukla. The Copyright notice from that file is
;; given below.

;; blog.el -- a wordpress posting client
;; Copyright (C) 2008 Ashish Shukla

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


(require 'org)
(require 'xml-rpc)
(require 'metaweblog)

(defgroup org2blog nil 
  "Post to weblogs from Emacs" 
  :group 'org2blog)

(defcustom org2blog-blog-alist nil
  "Association list to set information for each blog.
Each element of the alist is a blog name.  The CAR of each
element is a string, uniquely identifying the project.  The CDR
of each element is a well-formed property list with an even
number of elements, alternating keys and values, specifying
parameters for the blog.

     (:property value :property value ... )

When a property is given a value in org2blog-blog-alist, its
setting overrides the value of the corresponding user
variable (if any) during publishing.

Most properties are optional, but some should always be set:

  :url                     xmlrpc url of the blog.
  :username                username to be used.

All the other properties are optional. They over-ride the global variables.
  
  :default-title           `org2blog-default-title'
  :default-categories      `org2blog-default-categories'
                           Use a list of categories.
                           (\"category1\" \"category2\" ...)
  :tags-as-categories      `org2blog-use-tags-as-categories'
  :confirm                 `org2blog-confirm-post'
  :keep-new-lines          `org2blog-keep-new-lines'
  :wp-latex                `org2blog-use-wp-latex'
  :wp-code                 `org2blog-use-sourcecode-shortcode'
  :track-posts             `org2blog-track-posts'
"
  :group 'org2blog
  :type 'alist)

(defcustom org2blog-default-categories '("Uncategorized" "Hello") 
  "Default list of categories" 
  :group 'org2blog 
  :type '(repeat string))

(defcustom org2blog-buffer-template
  "#+DATE: %s
#+OPTIONS: toc:nil num:nil todo:nil pri:nil tags:nil ^:nil TeX:nil 
#+CATEGORY: %s
#+TAGS: 
#+DESCRIPTION: 
#+TITLE: %s
\n"
  "The default template to be inserted in a new post buffer."
  :group 'org2blog
  :type 'string)

(defcustom org2blog-default-title "Hello, World" 
  "Title of the new post" 
  :group 'org2blog 
  :type 'string)

(defcustom org2blog-use-tags-as-categories nil
  "Non-nil means assign :tags: to Wordpress categories instead."
  :group 'org2blog
  :type 'boolean)

(defcustom org2blog-confirm-post nil
  "Non-nil means confirm before Publishing a post."
  :group 'org2blog
  :type 'boolean)

(defcustom org2blog-keep-new-lines nil
  "Non-nil means do not strip newlines."
  :group 'org2blog
  :type 'boolean)

(defcustom org2blog-use-sourcecode-shortcode nil
  "Non-nil means convert <pre> tags to WP sourcecode blocks."
  :group 'org2blog
  :type 'boolean)

(defcustom org2blog-use-wp-latex t
  "Non-nil means convert LaTeX to WP latex blocks."
  :group 'org2blog
  :type 'boolean)

(defcustom org2blog-sourcecode-default-params "light=\"true\""
  "Default arguments to pass to WP syntaxhighlighter."
  :group 'org2blog
  :type 'string)

(defcustom org2blog-sourcecode-langs 
  (list "actionscript3" "bash" "coldfusion" "cpp" "csharp" "css" "delphi" 
        "erlang" "fsharp" "diff" "groovy" "javascript" "java" "javafx" "matlab"
        "objc" "perl" "php" "text" "powershell" "python" "ruby" "scala" "sql" 
        "vb" "xml")
  "List of languages supported by sourcecode shortcode of WP."
  :group 'org2blog
  :type 'list)

(defcustom org2blog-track-posts 
  (list ".org2blog.org" "Posts")
  "File where to save logs about posts. 
Set to nil if you don't wish to track posts."
  :group 'org2blog
  :type 'list)

(defvar org2blog-blog nil
  "Parameters of the currently selected blog.")

(defvar org2blog-blog-name nil
  "Name of the blog, to pick from `org2blog-blog-alist'")

(defvar org2blog-categories-list nil 
  "List of weblog categories")

(defvar org2blog-tags-list nil 
  "List of weblog tags")

(defvar org2blog-pages-list nil 
  "List of WP pages.")

(defvar org2blog-server-xmlrpc-url nil 
  "Weblog server XML-RPC URL")

(defvar org2blog-server-userid nil 
  "Weblog server user id")

(defvar org2blog-server-blogid nil 
  "Weblog ID")

(defvar org2blog-entry-mode-map nil 
  "Keymap for blog entry buffer")

(defvar org2blog-logged-in nil 
  "Flag whether user is logged-in or not")

(defvar org2blog-buffer-name "*org2blog-%s*"
  "Name of the blog buffer")

(defvar org2blog-buffer-kill-prompt t
  "Ask before killing buffer")
(make-variable-buffer-local 'org2blog-buffer-kill-prompt)

(defconst org2blog-version "0.3" 
  "Current version of blog.el")

(defvar org2blog-mode-hook nil
  "Hook to run upon entry into mode.")

(defun org2blog-kill-buffer-hook ()
  "Prompt before killing buffer."
  (if (and org2blog-buffer-kill-prompt
	   (not (buffer-file-name)))
    (if (y-or-n-p "Save entry?")
        (progn
          (save-buffer)
          (org2blog-save-details (org2blog-parse-entry) nil 
                                 (y-or-n-p "Published?"))))))

(unless org2blog-entry-mode-map
  (setq org2blog-entry-mode-map
	(let ((org2blog-map (make-sparse-keymap)))
	  (set-keymap-parent org2blog-map org-mode-map)
	  (define-key org2blog-map (kbd "C-c p") 'org2blog-post-buffer-and-publish)
	  (define-key org2blog-map (kbd "C-c P") 'org2blog-post-buffer-as-page-and-publish)
	  (define-key org2blog-map (kbd "C-c d") 'org2blog-post-buffer)
	  (define-key org2blog-map (kbd "C-c D") 'org2blog-post-buffer-as-page)
	  (define-key org2blog-map (kbd "C-c t") 'org2blog-complete-category)
	  org2blog-map)))

(define-minor-mode org2blog-mode
  "Toggle org2blog mode.
With no argument, the mode is toggled on/off.  
Non-nil argument turns mode on. 
Nil argument turns mode off.

Commands:
\\{org2blog-entry-mode-map}

Entry to this mode calls the value of `org2blog-mode-hook'."

  :init-value nil
  :lighter " o2b"
  :group 'org2blog
  :keymap org2blog-entry-mode-map

  (if org2blog-mode
      (run-mode-hooks 'org2blog-mode-hook)))

(defun org2blog-create-categories (categories)
  "Create unknown categories."
  (mapcar
   (lambda (cat)
     (if (and (not (member cat org2blog-categories-list))
              (y-or-n-p (format "Create %s category? " cat)))
         (wp-new-category org2blog-server-xmlrpc-url
                          org2blog-server-userid
                          org2blog-server-pass
                          org2blog-server-blogid
                          cat))
     (add-to-list 'org2blog-categories-list cat))
   categories))

(defun org2blog-password ()
  "Set password."
  (interactive)
  (setq org2blog-server-pass (read-passwd "Weblog password? ")))

(defun org2blog-login()
  "Logs into the blog. Initializes the internal data structures."
  (interactive)
  (let ()
    (setq org2blog-blog-name (completing-read "Blog ? " 
                                              (mapcar 'car 
                                                      org2blog-blog-alist))
          org2blog-blog (assoc org2blog-blog-name org2blog-blog-alist)
          org2blog-server-xmlrpc-url (plist-get (cdr org2blog-blog) :url)
          org2blog-server-userid (plist-get (cdr org2blog-blog) :username)
          org2blog-server-blogid (or (plist-get (cdr org2blog-blog) :id) "1")
          org2blog-server-pass (or 
                                (plist-get (cdr org2blog-blog) :password)
                                (read-passwd "Weblog password? "))
          org2blog-categories-list
	  (mapcar (lambda (category) (cdr (assoc "categoryName" category)))
		  (metaweblog-get-categories org2blog-server-xmlrpc-url
					     org2blog-server-userid
                                             org2blog-server-pass
					     org2blog-server-blogid))
          org2blog-tags-list
	  (mapcar (lambda (tag) (cdr (assoc "slug" tag)))
		  (wp-get-tags org2blog-server-xmlrpc-url
			       org2blog-server-userid
                               org2blog-server-pass
			       org2blog-server-blogid))
          org2blog-pages-list
	  (mapcar (lambda (pg) 
                    (cons (cdr (assoc "page_title" pg)) 
                          (cdr (assoc "page_id" pg))))
		  (wp-get-pagelist org2blog-server-xmlrpc-url
				   org2blog-server-userid
				   org2blog-server-pass
				   org2blog-server-blogid)))
    (setq org2blog-logged-in t)
    (message "Logged in")))

(defun org2blog-logout()
  "Logs out from the blog and clears. Clears the internal data structures."
  (interactive)
  (setq org2blog-server-xmlrpc-url nil
	org2blog-server-userid nil
	org2blog-server-blogid nil
	org2blog-server-pass nil
	org2blog-categories-list nil
	org2blog-tags-list nil
	org2blog-pages-list nil
	org2blog-logged-in nil)
  (message "Logged out"))

(defun org2blog-new-entry()
  "Creates a new blog entry."
  (interactive)
  (if (and (not org2blog-logged-in)
           (y-or-n-p "You are not logged in. Login?"))
      (org2blog-login))
  (let ((org2blog-buffer (generate-new-buffer 
                          (format org2blog-buffer-name org2blog-blog-name))))
    (switch-to-buffer org2blog-buffer)
    (add-hook 'kill-buffer-hook 'org2blog-kill-buffer-hook nil 'local)
    (org-mode)
    (insert 
     (format org2blog-buffer-template
             (format-time-string "[%Y-%m-%d %a %H:%M]" (current-time))
             (mapconcat
              (lambda (cat) cat)
              (or (plist-get (cdr org2blog-blog) :default-categories)
                  org2blog-default-categories)
              ", ")
             (or (plist-get (cdr org2blog-blog) :default-title)
                 org2blog-default-title)))
    (org2blog-mode)))

(defun org2blog-upload-images-replace-urls (text)
  "Uploads images if any in the html, and changes their links"
  (let ((file-all-urls nil)
        file-name file-web-url beg
        (image-regexp "<img src=\"\\(.*?\\)\""))
    (save-excursion
      (while (string-match image-regexp text beg)
        (setq file-name (substring text (match-beginning 1) (match-end 1)))
        (setq file-name (save-match-data (if (string-match "^file:" file-name)
                                             (substring file-name 7)
                                           file-name)))
        (setq beg (match-end 0))
        (if (save-match-data (not (string-match org-plain-link-re file-name)))
            (progn
              (goto-char (point-min))
              (if (re-search-forward (concat "^#\\+" 
                                             (regexp-quote file-name)
                                             " ") nil t 1)
                  (setq file-web-url (buffer-substring-no-properties 
                                      (point) 
                                      (or (end-of-line) (point))))
                (setq file-web-url
                      (cdr (assoc "url" 
                                  (metaweblog-upload-image org2blog-server-xmlrpc-url
                                                           org2blog-server-userid
                                                           org2blog-server-pass
                                                           org2blog-server-blogid
                                                           (get-image-properties file-name)))))
                (goto-char (point-max))
                (newline)
                (insert (concat "#+" file-name " " file-web-url)))
              (setq file-all-urls (append file-all-urls (list (cons 
                                                               file-name file-web-url)))))))
      (dolist (image file-all-urls)
        (setq text (replace-regexp-in-string 
                         (regexp-quote (car image)) (cdr image) text))))
    text))

(defun org2blog-get-post-id ()
  "Gets the post-id from a buffer."
  (let (post-id)
    (save-excursion 
      (goto-char (point-min))
      (if (re-search-forward "^#\\+POSTID: \\(.*\\)" nil t 1)
          (setq post-id (match-string-no-properties 1))))
    post-id))

(defun org2blog-get-post-parent ()
  "Gets the post's parent from a buffer."
  (let (post-par)
    (save-excursion 
      (goto-char (point-min))
      (if (re-search-forward "^#\\+PARENT: \\(.*\\)" nil t 1)
          (progn
            (setq post-par (match-string-no-properties 1))
            (if (and post-par
                     (> (length post-par) 1))
                (setq post-par (substring post-par 0 -2)))
            (setq post-par (cdr (assoc post-par org2blog-pages-list)))
            (if (not post-par)
                (setq post-par "0")))
        (setq post-par "0")))
    post-par))

(defun org2blog-strip-new-lines (html)
  "Strip the new lines from the html, except in pre and blockquote tags."
  (save-excursion
    (with-temp-buffer
      (let* (start-pos end-pos)
        (insert html)
        (setq start-pos (point-min))
        (goto-char start-pos)
        (while (re-search-forward 
                (concat 
                 "\\(<\\(pre\\|blockquote\\).*?>\\(.\\|[[:space:]]\\)*?</\\2.*?>\\|"
                 "\\[\\([[:word:]]+\\).*?\\]\\(.\\|[[:space:]]\\)*?\\[/\\4.*?\\]\\)")
                nil t 1)
          (setq end-pos (match-beginning 0))
          (replace-regexp "\\\n" " " nil start-pos end-pos)
          (setq start-pos (match-end 0))
          (goto-char start-pos))
        (setq end-pos (point-max))
        (replace-regexp "\\\n" " " nil start-pos end-pos)
        (buffer-substring-no-properties (point-min) (point-max))))))

(defun org2blog-point-in-wp-sc ()
  "Return True when point in sourcecode block."
  (save-excursion
    (let* ((pos (point))
           (s-count 0)
           (e-count 0))
      (while (re-search-backward "\\[sourcecode.*\\]" nil t)
        (setq s-count (1+ s-count)))
      (goto-char pos)
      (while (re-search-backward "\\[/sourcecode\\]" nil t)
        (setq e-count (1+ e-count)))
      (> (- s-count e-count) 0))))

(defun org2blog-latex-to-wp (html)
  "Change inline LaTeX to wp latex blocks."
  (save-excursion
    (with-temp-buffer
      (insert html)
      (let* ((matchers (plist-get org-format-latex-options :matchers))
             (re-list org-latex-regexps)
             beg end re e m n block off)
        (while (setq e (pop re-list))
          (setq m (car e) re (nth 1 e) n (nth 2 e)
                block (if (nth 3 e) "\n\n" ""))
          (when (member m matchers)
            (goto-char (point-min))
            (save-match-data
              (while (and
                      (re-search-forward re nil t)
                      (not (org2blog-point-in-wp-sc)))
                (cond
                 ((equal m "$")
                  (unless (string-match "^latex" (match-string 4))
                    (replace-match (concat (match-string 1) "$latex "
                                           (match-string 4) "$" 
                                           (match-string 6))
                                   nil t)))
                 ((equal m "$1")
                  (replace-match (concat (match-string 1) "$latex " 
                                         (substring (match-string 2) 1 -1)
                                         "$" (match-string 3))
                                   nil t))
                 ((equal m "\\(")
                  (replace-match (concat "$latex " 
                                         (substring (match-string 0) 2 -2)
                                         "$") nil t))
                 ((equal m "\\[")
                  (replace-match (concat "$latex \\displaystyle " 
                                         (substring (match-string 0) 2 -2)
                                         "$") nil t))
                 ((equal m "$$")
                  (replace-match (concat "$latex \\displaystyle " 
                                         (substring (match-string 0) 2 -2)
                                         "$") nil t))
                 ((equal m "begin")
                  (if (equal (match-string 2) "equation")
                      (replace-match (concat "$latex \\displaystyle " 
                                             (substring (match-string 1) 16 -14)
                                             "$") nil t)))))))))
      (buffer-substring-no-properties (point-min) (point-max)))))

(defun org2blog-replace-pre (html)
  "Replace pre blocks with sourcecode shortcode blocks."
  (save-excursion
    (let (pos code lang info params src-re code-re)
      (with-temp-buffer
        (insert html)
        (goto-char (point-min))
        (save-match-data
          (while (re-search-forward 
                  "<pre\\(.*?\\)>\\(\\(.\\|[[:space:]]\\|\\\n\\)*?\\)</pre.*?>"
                  nil t 1)
            (setq code (match-string-no-properties 2))
            (if (save-match-data 
                  (string-match "example" (match-string-no-properties 1)))
                (setq lang "text")
              (setq lang (substring 
                          (match-string-no-properties 1) 16 -1))
              (unless (member lang org2blog-sourcecode-langs)
                (setq lang "text"))
              (save-match-data
                (setq code (replace-regexp-in-string "<.*?>" "" code))))
            (replace-match 
             (concat "\n[sourcecode language=\"" lang  "\"" 
                     org2blog-sourcecode-default-params "]\n" code 
                     "\n[/sourcecode]\n") 
             nil t)))
        (setq html (buffer-substring-no-properties (point-min) (point-max))))
      (goto-char (point-min))
      (setq pos 1)
      (while (re-search-forward org-babel-src-block-regexp nil t 1)
        (backward-word)
        (setq info (org-babel-get-src-block-info))
        (setq params (nth 2 info))
        (setq code (org-html-protect (nth 1 info)))
        (setq code-re (regexp-quote code))
        (setq src-re (concat "\\[sourcecode language=\"\\(.*?\\)\".*?\\]\n"
                             code-re "\\(\n\\)*\\[/sourcecode\\]"))
        (save-excursion
          (with-temp-buffer
            (insert html)
            (goto-char pos)
            (save-match-data
              (re-search-forward src-re nil t 1)
              (setq pos (point))
              (setq lang (match-string-no-properties 1))
              (when (assoc :syntaxhl params)
                (replace-match 
                 (concat "\n[sourcecode language=\"" lang  "\" " 
                         (cdr (assoc :syntaxhl params))
                         "]\n" code "[/sourcecode]\n")
                 nil t)))
            (setq html (buffer-substring-no-properties (point-min) (point-max))))))))
  html)

(defun org2blog-parse-entry (&optional publish)
  "Parse an org2blog buffer."
  (interactive "P")
  (let* ((keep-new-lines (if (plist-member (cdr org2blog-blog) :keep-new-lines)
                             (plist-get (cdr org2blog-blog) :keep-new-lines)
                           org2blog-keep-new-lines))
         (wp-latex (if (plist-member (cdr org2blog-blog) :wp-latex)
                       (plist-get (cdr org2blog-blog) :wp-latex)
                     org2blog-use-wp-latex))
         (sourcecode-shortcode (if (plist-member (cdr org2blog-blog) :wp-code)
                             (plist-get (cdr org2blog-blog) :wp-code)
                           org2blog-use-sourcecode-shortcode))
         html-text post-title post-id post-date tags categories narrow-p 
         cur-time post-par)
    (save-restriction
      (save-excursion
        (if (not org2blog-mode)
            (org-save-outline-visibility 'use-markers (org-mode-restart))
          (org-save-outline-visibility 'use-markers (org-mode-restart))
          (org2blog-mode))
        (setq narrow-p (not (equal (- (point-max) (point-min)) (buffer-size))))
        (if narrow-p
            (progn
              (setq post-title (or (org-entry-get (point) "Title")
                                   (nth 4 (org-heading-components))))
              (setq excerpt (org-entry-get (point) "DESCRIPTION"))
              (setq post-id (org-entry-get (point) "POST_ID"))
              ;; Set post-date to the Post Date property or look for timestamp
              (setq post-date (or (org-entry-get (point) "POST_DATE")
                                  (org-entry-get (point) "SCHEDULED")
                                  (org-entry-get (point) "DEADLINE")
                                  (org-entry-get (point) "TIMESTAMP_IA")
                                  (org-entry-get (point) "TIMESTAMP")))
              (setq tags (mapcar 'org-no-properties (org-get-tags-at (point) nil)))
              (setq categories (org-split-string 
                                (or (org-entry-get (point) "CATEGORY") "") ":")))
          (setq post-title (or (plist-get (org-infile-export-plist) :title) 
                               "No Title"))
          (setq excerpt (plist-get (org-infile-export-plist) :description))
          (setq post-id (org2blog-get-post-id))
          (setq post-par (org2blog-get-post-parent))
          (setq post-date (plist-get (org-infile-export-plist) :date))
          (setq tags (or 
                      (mapcar (lambda (f) (car (split-string (car f) ",")))
                              org-tag-alist)
                      ""))
          (setq categories 
                (if org-category
                    (symbol-name org-category)
                  ""))
          (setq categories
                (or (split-string categories "[ ,]+" t) "")))

        ;; Convert post date to ISO timestamp
        ;;add the date of posting to the post. otherwise edits will change it
        (setq cur-time (format-time-string (org-time-stamp-format t t) (org-current-time)))
        (setq post-date
              (format-time-string "%Y%m%dT%T%z" 
                                  (if post-date
                                      (apply 'encode-time (org-parse-time-string post-date))
                                    (current-time)
                                    (if narrow-p
                                        (org-entry-put (point) "POST_DATE" cur-time)
                                      (save-excursion
                                        (goto-char (point-min))
                                        (insert (concat "#+DATE: " cur-time "\n"))))) 
                                  t))
        
        (if 
            (if (plist-member (cdr org2blog-blog) :tags-as-categories)
                (plist-get (cdr org2blog-blog) :tags-as-categories)
              org2blog-use-tags-as-categories)
            (setq categories tags
                  tags nil))
        (save-excursion
          (if (not narrow-p)
              (setq html-text (org-export-as-html nil nil nil 'string t nil))
            (setq html-text
                  (org-export-region-as-html
                   (1+ (and (org-back-to-heading) (line-end-position)))
                   (org-end-of-subtree)
                   t 'string)))
          (setq html-text (org-no-properties html-text)))
        (setq html-text (org2blog-upload-images-replace-urls html-text))
        (unless keep-new-lines
          (setq html-text (org2blog-strip-new-lines html-text)))
        (when sourcecode-shortcode
          (setq html-text (org2blog-replace-pre html-text)))
        (when wp-latex
          (setq html-text (org2blog-latex-to-wp html-text)))))

    (list
     (cons "point" (point))
     (cons "subtree" narrow-p)
     (cons "date" post-date)
     (cons "title" post-title)
     (cons "tags" tags)
     (cons "categories" categories)
     (cons "post-id" post-id)
     (cons "parent" post-par)
     (cons "excerpt" excerpt)
     (cons "description" html-text))))


(defun org2blog-post-buffer-and-publish ()
  "Post buffer and mark it as published"
  (interactive)
  (org2blog-post-buffer t))

(defun org2blog-post-buffer (&optional publish)
  "Posts new blog entry to the blog or edits an existing entry."
  (interactive "P")
  (unless org2blog-logged-in 
    (org2blog-login))
  (save-excursion
    (save-restriction
      (let ((post (org2blog-parse-entry))
            (confirm (and 
                     (if (plist-member (cdr org2blog-blog) :confirm)
                        (plist-member (cdr org2blog-blog) :confirm)
                      org2blog-confirm-post) 
                     publish))
            post-id)
        (org2blog-create-categories (cdr (assoc "categories" post)))
        (setq post-id (cdr (assoc "post-id" post)))
        (unless (not confirm)
          (if (not (y-or-n-p (format "Publish %s ?" 
                                     (cdr (assoc "title" post)))))
              (error "Post cancelled.")))
        (if post-id
            (metaweblog-edit-post org2blog-server-xmlrpc-url
                                  org2blog-server-userid
                                  org2blog-server-pass
                                  post-id
                                  post
                                  publish)
          (setq post-id (metaweblog-new-post org2blog-server-xmlrpc-url
                                             org2blog-server-userid
                                             org2blog-server-pass
                                             org2blog-server-blogid
                                             post
                                             publish))
          (if (cdr (assoc "subtree" post))
              (org-entry-put (point) "POST_ID" post-id)
            (goto-char (point-min))
            (insert (concat "#+POSTID: " post-id "\n"))))
        (org2blog-save-details post post-id publish)
        (message (if publish
                     "Published (%s): %s"
                   "Draft (%s): %s")
                 post-id
                 (cdr (assoc "title" post)))
        (when (y-or-n-p "[For drafts, ensure you login] View in browser? y/n")
          (if (cdr (assoc "subtree" post))
              (org2blog-preview-subtree-post)
            (org2blog-preview-buffer-post)))))))

(defun org2blog-post-buffer-as-page-and-publish ()
  "Alias to post buffer and mark it as published"
  (interactive)
  (org2blog-post-buffer-as-page t))

(defun org2blog-post-buffer-as-page (&optional publish)
  "Posts new page to the blog or edits an existing page."
  (interactive "P")
  (unless org2blog-logged-in 
    (org2blog-login))
  (save-excursion
    (save-restriction
      (widen)
      (let ((post (org2blog-parse-entry))
            post-id)
        (org2blog-create-categories (cdr (assoc "categories" post)))
        (setq post-id (cdr (assoc "post-id" post)))
        (unless (not (and org2blog-confirm-post publish))
          (if (not (y-or-n-p (format "Publish %s ?" 
                                     (cdr (assoc "title" post)))))
              (error "Post cancelled.")))
        (if post-id
            (wp-edit-page org2blog-server-xmlrpc-url
                          org2blog-server-userid
                          org2blog-server-pass
                          org2blog-server-blogid
                          post-id
                          post
                          publish)
          (setq post-id (wp-new-page org2blog-server-xmlrpc-url
                                     org2blog-server-userid
                                     org2blog-server-pass
                                     org2blog-server-blogid
                                     post
                                     publish))
          (setq org2blog-pages-list
                (mapcar (lambda (pg) 
                          (cons (cdr (assoc "title" pg)) 
                                (cdr (assoc "page_id" pg))))
                        (wp-get-pagelist org2blog-server-xmlrpc-url
					 org2blog-server-userid
					 org2blog-server-pass
					 org2blog-server-blogid)))
          (if (cdr (assoc "subtree" post))
              (org-entry-put (point) "POST_ID" post-id)
            (goto-char (point-min))
            (insert (concat "#+POSTID: " post-id "\n"))))
        (org2blog-save-details post post-id publish)
        (message (if publish
                     "Published (%s): %s"
                   "Draft (%s): %s")
                 post-id
                 (cdr (assoc "title" post)))))))

(defun org2blog-delete-entry (&optional post-id)
  (interactive "P")
  (if (null post-id)
      (setq post-id (org2blog-get-post-id)))
  (metaweblog-delete-post org2blog-server-xmlrpc-url
                                org2blog-server-userid
                                org2blog-server-pass
                                post-id)
  (message "Post Deleted"))

(defun org2blog-delete-page (&optional page-id)
  (interactive "P")
  (if (null page-id)
      (setq page-id (org2blog-get-post-id)))
  (wp-delete-page org2blog-server-xmlrpc-url
                  org2blog-server-blogid
                  org2blog-server-userid
                  org2blog-server-pass
                  page-id)
   (message "Page Deleted"))

(defun org2blog-save-details (post pid pub)
  "Save the details of posting, to a file."
  (save-excursion
    (when (if (plist-member (cdr org2blog-blog) :track-posts)
              (car (plist-get (cdr org2blog-blog) :track-posts))
            (car org2blog-track-posts))
      (let* ((o2b-id (if (cdr (assoc "subtree" post))
                         (concat "id:" (org-id-get nil))
                       (buffer-file-name)))
             (log-file (if (plist-member (cdr org2blog-blog) :track-posts)
                           (car (plist-get (cdr org2blog-blog) :track-posts))
                         (car org2blog-track-posts)))
             (log-file (if (file-name-absolute-p log-file)
                           log-file
                         (if org-directory
                             (expand-file-name log-file org-directory)
                           (message "org-track-posts: filename is ambiguous 
use absolute path or set org-directory")
                           log-file)))
             (headline (if (plist-member (cdr org2blog-blog) :track-posts)
                           (cadr (plist-get (cdr org2blog-blog) :track-posts))
                         (cadr org2blog-track-posts)))
             p)
        (when o2b-id
          (with-current-buffer (or (find-buffer-visiting log-file)
                                   (find-file-noselect log-file))
            (save-excursion
              (save-restriction
                (widen)
                (setq p (org-find-exact-headline-in-buffer headline))
                (if p
                    (progn (goto-char p) (org-narrow-to-subtree) (end-of-line))
                  (goto-char (point-max))
                  (if (y-or-n-p (format "No heading - %s. Create?" headline))
                      (progn (org-insert-heading t) (insert headline)
                             (org-narrow-to-subtree))))
                (if (search-forward o2b-id nil t 1)
                    (progn
                      (org-back-to-heading)
                      (forward-thing 'whitespace)
                      (kill-line))
                  (org-insert-subheading t)))
              (org2blog-update-details post o2b-id pid pub))
            (save-buffer)))))))

(defun org2blog-update-details (post o2b-id pid pub)
  "Inserts details of a new post or updates details."
  (insert (format "[[%s][%s]]" 
                  (if (cdr (assoc "subtree" post))
                      o2b-id
                    (concat "file:" o2b-id))
                  (cdr (assoc "title" post))))
  (org-entry-put (point) "POST_ID" (or pid ""))
  (org-entry-put (point) "POST_DATE" (cdr (assoc "date" post)))
  (org-entry-put (point) "Published" (if pub "Yes" "No")))

(defun org2blog-complete-category()
  "Provides completion for categories and tags."
  (interactive)
  (let* (current-pos tag-or-category-list)
    (setq current-pos (point))
    (forward-line 0)
    (forward-char 2)
    (if (or (looking-at "CATEGORY: ") (looking-at "TAGS: ")
            (looking-at "PARENT: "))
        (progn
          (cond
           ((looking-at "TAGS: ")
            (setq tag-or-cat-list org2blog-tags-list)
	    (setq tag-or-cat-prompt "Tag ?"))
           ((looking-at "CATEGORY: ")
            (setq tag-or-cat-list org2blog-categories-list)
	    (setq tag-or-cat-prompt "Category ?"))
           ((looking-at "PARENT: ")
            (setq tag-or-cat-list org2blog-pages-list)
	    (setq tag-or-cat-prompt "Parent ?")))
          (goto-char current-pos)
      	  (let ((word-match (or (current-word t) ""))
      		(completion-match nil))
      	    (when word-match
      	      (setq completion-match (completing-read tag-or-cat-prompt tag-or-cat-list nil nil word-match))
      	      (when (stringp completion-match)
      		(search-backward word-match nil t)
                (replace-match (concat completion-match ", ") nil t)))))
      (progn
      	(goto-char current-pos)
      	(command-execute (lookup-key org-mode-map (kbd "C-c t")))))))

(defun org2blog-post-subtree (&optional publish)
  "Post the current entry as a draft. Publish if PUBLISH is non-nil."
  (interactive "P")
  (save-restriction
    (save-excursion
      (org-narrow-to-subtree)
      (org-id-get nil t "o2b")
      (org-insert-heading-after-current)
      (org-backward-same-level 1)
      (let ((level (1- (org-reduced-level (org-outline-level))))
            (contents (buffer-substring (point-min) (point-max))))
        (save-excursion
          (with-temp-buffer
            (insert contents)
            (org-mode)
            (goto-char (point-min))
            (org-narrow-to-subtree)
            (dotimes (n level nil) (org-promote-subtree))
            (org2blog-post-buffer publish)
            (dotimes (n level nil) (org-demote-subtree))
            (setq contents (buffer-string))))
        (delete-region (point-min) (point-max))
        (insert contents))
      (widen))))

(defun org2blog-mark-subtree-as-draft ()
  "Post the current subtree as a draft. Saves details in tracking file."
  (interactive)
  (save-restriction
    (save-excursion
      (org-narrow-to-subtree)
      (org2blog-save-details (org2blog-parse-entry) "" nil)
      (widen))))

(defun org2blog-preview-buffer-post ()
  (interactive)
  "Preview the present buffer in browser, if posted."
  (let* ((postid (org2blog-get-post-id))
         (url org2blog-server-xmlrpc-url))
    (if (not postid)
        (message "This buffer hasn't been posted, yet.")
      (setq url (substring url 0 -10))
      (setq url (concat url "?p=" postid "&preview=true"))
      (browse-url url))))

(defun org2blog-preview-subtree-post ()
  (interactive)
  "Preview the present subtree in browser, if posted."
  (let* ((postid (org-entry-get (point) "POST_ID"))
         (url org2blog-server-xmlrpc-url))
    (if (not postid)
        (message "This subtree hasn't been posted, yet.")
      (setq url (substring url 0 -10))
      (setq url (concat url "?p=" postid "&preview=true"))
      (browse-url url))))

(provide 'org2blog)