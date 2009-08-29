(let* ((xml "<post time=\"20050716234509\" id=\"010101\">
              <login>Test</login>
               <msg>Here is the message</msg>
               <info>My UA</info>
             </post>")
       (root (with-temp-buffer
               (insert xml)
               (xml-parse-region (point-min) (point-max))))
       (post (car root))
       (attrs (xml-node-attributes post))
       (time (cdr (assq 'time attrs)))
       (msg (car (xml-get-children post 'msg)))
       (text (car (xml-node-children msg))))
  (message "time: %s, message '%s'" time text))

;; hace print de todo el xml
(let* ((xml "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
             <essay>
             <content>&#26085;&#26412;&#35486;&#241;h1. Textile title
               *Textile bold*</content>
               <created-at type=\"datetime\">2009-08-26T19:15:05Z</created-at>
               <id type=\"integer\">24</id>
               <title>Not working with spanish nor japanese</title>
               <updated-at type=\"datetime\">2009-08-26T19:15:05Z</updated-at>
             </essay>")
       (root (with-temp-buffer
               (insert xml)
               (xml-parse-region (point-min) (point-max))))
;;;        (post (car root))
;;;        (attrs (xml-node-attributes post))
;;;        (time (cdr (assq 'time attrs)))
;;;        (msg (car (xml-get-children post 'msg)))
;;;        (text (car (xml-node-children msg)))
       )				; end of let varlist
  (message "%s" root))

;; debe decirme lo que hay dentro de content
(let* ((xml "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
             <essay>
             <content>&#26085;&#26412;&#35486;&#241;h1. Textile title
               *Textile bold*</content>
               <created-at type=\"datetime\">2009-08-26T19:15:05Z</created-at>
               <id type=\"integer\">24</id>
               <title>Not working with spanish nor japanese</title>
               <updated-at type=\"datetime\">2009-08-26T19:15:05Z</updated-at>
             </essay>")
       (root (with-temp-buffer
               (insert xml)
               (xml-parse-region (point-min) (point-max))))
       (essay (car root))
       (content (car (xml-get-children essay 'content)))
       (inner-content (car (xml-node-children content)))
       )				; end of let varlist
  (message "%s" inner-content))

;; ejemplo del xml parseado 
'((essay nil 
              (content nil 日本語ñh1. Textile title
               *Textile bold*) 
                (created-at ((type . datetime)) 2009-08-26T19:15:05Z) 
                (id ((type . integer)) 24) 
                (title nil Not working with spanish nor japanese) 
                (updated-at ((type . datetime)) 2009-08-26T19:15:05Z) 
             ))

(setq lista '((essay nil 
              (content nil 日本語ñh1. Textile title
               *Textile bold*) 
                (created-at ((type . datetime)) 2009-08-26T19:15:05Z) 
                (id ((type . integer)) 24) 
                (title nil Not working with spanish nor japanese) 
                (updated-at ((type . datetime)) 2009-08-26T19:15:05Z) 
             )))





;; ejemplo del xml
;; <?xml version="1.0" encoding="UTF-8"?>
;; <essay>
;; <content>&#26085;&#26412;&#35486;&#241;h1. Textile title
;; *Textile bold*</content>
;; <created-at type="datetime">2009-08-26T19:15:05Z</created-at>
;; <id type="integer">24</id>
;; <title>Not working with spanish nor japanese</title>
;; <updated-at type="datetime">2009-08-26T19:15:05Z</updated-at>
;; </essay>
