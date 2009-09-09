;; elisp file for espresso-mode and html mumamo mode

(defconst mumamo-javascript-tag-start-regex  (rx "<script type=\"text/javascript\">"))
 
(defun mumamo-search-bw-exc-start-inlined-javascript (pos min)
  "Helper for `mumamo-chunk-inlined-javascript'.
POS is where to start search and MIN is where to stop."
  (goto-char (+ pos 30))
  (let ((marker-start (search-backward "<script type=\"text/javascript\"" min t))
        exc-mode
        exc-start)
    (when marker-start
      (when (looking-at mumamo-javascript-tag-start-regex)
        (setq exc-start (match-end 0))
        (goto-char exc-start)
        (when (<= exc-start pos)
          ;; (cons (point) 'js2-mode)
          (list (point) 'actionscript-mode '(sgml-mode))
          )
        ))))
 
(defun mumamo-search-bw-exc-end-inlined-javascript (pos min)
  "Helper for `mumamo-chunk-inlined-actionscript'.
POS is where to start search and MIN is where to stop."
  (mumamo-chunk-end-bw-str pos min "</script>"))
 
(defun mumamo-search-fw-exc-start-inlined-javascript (pos max)
  "Helper for `mumamo-chunk-inlined-actionscript'.
POS is where to start search and MAX is where to stop."
  (goto-char (1+ pos))
  (skip-chars-backward "^<")
  ;; Handle <![CDATA[
  (when (and
         (eq ?< (char-before))
         (eq ?! (char-after))
         (not (bobp)))
    (backward-char)
    (skip-chars-backward "^<"))
  (unless (bobp)
    (backward-char 1))
  (let ((exc-start (search-forward "<script type=\"text/javascript\"" max t))
        exc-mode)
    (when exc-start
      (goto-char (- exc-start 30))
      (when (looking-at mumamo-javascript-tag-start-regex)
        (goto-char (match-end 0))
        (point)
        ))))
 
(defun mumamo-search-fw-exc-end-inlined-javascript (pos max)
  "Helper for `mumamo-chunk-inlined-actionscript'.
POS is where to start search and MAX is where to stop."
  (save-match-data
    (mumamo-chunk-end-fw-str pos max "</script>")))
 
(defun mumamo-chunk-inlined-javascript (pos min max)
  "Find <script>...</script>.  Return range and 'javascript-mode.
See `mumamo-find-possible-chunk' for POS, MIN and MAX."
  (mumamo-find-possible-chunk pos min max
                              'mumamo-search-bw-exc-start-inlined-javascript
                              'mumamo-search-bw-exc-end-inlined-javascript
                              'mumamo-search-fw-exc-start-inlined-javascript
                              'mumamo-search-fw-exc-end-inlined-javascript))
 
 
(define-mumamo-multi-major-mode html-ecmascript-mumamo-mode
    "Turn on multiple major modes for MXML with main mode `nxml-mode'.
This covers inlined style and script for mxml."
  ("NXML Family" sgml-mode
                 (
                  mumamo-chunk-inlined-javascript
                  )))
 
(add-to-list 'auto-mode-alist '("\\.html\\'" . html-ecmascript-mumamo-mode))
;; (add-to-list 'auto-mode-alist '("\\.as\\'" . actionscript-mode))
