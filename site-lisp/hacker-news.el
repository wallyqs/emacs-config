;; hacker-news.el by invertedplate
;; December 12th 2009
;; "Feed to read hacker-news on emacs with very lame programming skills"
;; Links are opened by Firefox
;; TODO: (really?)
;; Ponerle bold a los titulos
;; Si esta creado borra el buffer de nuevo
;; poner el nombre del autor, puntos y comentarios

(defun donde-esta-hacker-news()
  (interactive)
  (let ((url-request-method "GET"))
    (url-retrieve
     ;; "http://127.0.0.1/classic"
     "http://news.ycombinator.com/classic"
     '(lambda (status)
        (with-current-buffer (current-buffer)
          ;; PRINCIPIO DE LOS TITLE
          (re-search-forward "\<td class=\"title\"" nil t)
          (setq inicio (match-beginning 0))

          ;; PRINCIPIO DEL ULTIMO TITLE
          (re-search-forward "\<td class=\"title\"" nil t 29)

          ;; FIN DEL ULTIMO TITLE COMMENT
          (re-search-forward "\<tr" nil t)
          (re-search-forward "tr\>" nil t)

          (setq final (match-end 0))
          ;; AHORA DEBO DE METER TODO EN CONTENT
          (setq content
                (buffer-substring-no-properties inicio final))

          ;; TENGO EL CONTENT!!! AHORA SACAR LOS TITLES. X
          ;; AHORA METERLO TODO EN UN HASH
          (setq hashy (make-hash-table :test 'equal))
          (with-temp-buffer
            (insert "\n" content)
            (goto-char (point-min))
            ;; QUIERO HACER UN HASH DE ESTO
            (while (re-search-forward "\<td class=\"title\"" nil t)
              ;; buscar los titles
              (re-search-forward "\<a" nil t)
              (setq anchor-start (match-beginning 0))

              ;; parentesis, ve por los links
              (re-search-forward "href=\"" nil t)
              (setq link-start (match-end 0))
              (re-search-forward "\"")
              (setq link-end (match-beginning 0))

              (setq title-link
                    (buffer-substring-no-properties link-start link-end))

              ;; ok regresa por los titulos
              (re-search-forward "\>" nil t)
              (setq iinicio (match-end 0))

              (re-search-forward "\<\/a\>" nil t)
              (setq ffinal (match-beginning 0))

              (setq titulo
                    (buffer-substring-no-properties iinicio ffinal))
	      
              ;; meterlo en el hash
              (puthash titulo title-link hashy)

              )	; while
            )          
          )
        (kill-buffer (current-buffer))
	;; (pp hashy)
	
	(get-buffer-create "Hacker News")
	(set-buffer "Hacker News")
	(kill-buffer "Hacker News")
	(get-buffer-create "Hacker News")
	(set-buffer "Hacker News")
	;; t: titulo, l: link
	;; FOREACH PARA CADA UNO DE LOS LINKS QUE ENCONTRO: The View
	(setq articles-counter 0)
	(maphash (lambda(ti li) 
		   (setq articles-counter 
			 (1+ articles-counter))
		   (setq articles-counter-s (number-to-string articles-counter))
		   (insert articles-counter-s ".- " ti )
		   (insert "\n")
		   (insert li "\n")
		   ;; esto esta super chafilla deberia de pasarle un argumento 
		   ;; al boton pero no supe como
		   ;; el boton tiene una posicion que se llama (overlay-start buton)
		   (insert-button "Go"
				  'action '(lambda (button)
					     (re-search-backward "http")
					     (setq address-start (match-beginning 0))
					     (goto-char address-start)
					     (re-search-forward "^http.*?$" nil t)
					     (setq address-end (match-end 0))
					     (setq address (buffer-substring-no-properties address-start address-end))
					     (browse-url-firefox address)
					     (pp address)
					    ))
		   (insert "\n\n")
		   ) hashy)
	(set-window-buffer (next-window) "Hacker News")
	(goto-char (point-min))
        ) ;; lambda end
     )
    ) ;; let end ----------------------------
  )

(provide 'hacker-news)