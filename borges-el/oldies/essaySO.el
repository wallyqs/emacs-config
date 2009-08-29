(require 'url)

(defun my-switch-to-url-buffer (status)
  (switch-to-buffer (current-buffer)))
;; &#26085;&#26412;&#35486; 日本語
;; &#241 ñ

(defun create-post()
  (interactive)
  (let ((url-request-method "POST")
        (url-request-extra-headers '(("Content-Type" . "application/xml; charset=utf-8")))
        (url-request-data
         (encode-coding-string (concat "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                       ;; <?xml version="1.0" encoding="UTF-8"?>
                                       "<essay>"
                                       "<title>"
                                       "Not working with spanish nor japanese"
                                       "</title>"
                                       "<content>"
                                       "日本語"   ;;  working !!!
                                       "ñ"        ;;  working !!!
                                       "h1. Textile title\n\n"
                                       "*Textile bold*"
                                       "</content>"
                                       "</essay>") 'utf-8)
         )
        )                               ; end of let varlist
    (url-retrieve "http://127.0.0.1:3000/essays.xml"
                  ;; CALLBACK
                  (lambda (status)
                    (switch-to-buffer (current-buffer))
                    )))                 ;let
  )

;; elisp del que puedo aprender como a usar bien url.el
;; http://meta.wikimedia.org/wiki/Mediawiki.el

