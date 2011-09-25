;; hacker-news.el by invertedplate
;; December 12th 2009
;; "Feed to read hacker-news on emacs with very lame programming skills"
;; Links are opened by Firefox
;; TODO: (really?)
;; Ponerle bold a los titulos
;; Si esta creado borra el buffer de nuevo
;; poner el nombre del autor, puntos y comentarios
;; TODO:
;; Ponele el titulo de bold.
;; Poner la cantidad de comentarios de cada uno de los posts
;; quiero hacer el refactor de esto tal vez
;; Arreglar los item?XXXXXX
;; how many points???

(defun hacker-news()
  (interactive)
  (let ((url-request-method "GET"))
    (url-retrieve
     ;; "http://127.0.0.1/classic"
     "http://news.ycombinator.com/classic"
     '(lambda (status)
        (with-current-buffer (current-buffer)
          ;; PRINCIPIO DE LOS TITLE, deberia de ser el primer td con class title
          (re-search-forward "\<td class=\"title\"" nil t)
          (setq inicio (match-beginning 0))
          ;; PRINCIPIO DEL ULTIMO TITLE, avanzo 29 veces
          (re-search-forward "\<td class=\"title\"" nil t 29)
          ;; FIN DEL ULTIMO TITLE COMMENT
          (re-search-forward "\<tr" nil t)
          (re-search-forward "tr\>" nil t)
          (setq final (match-end 0))
	  
	  ;; AHORA DEBO DE METER TODO EN CONTENT => bloque de html que quiero
          (setq content
                (buffer-substring-no-properties inicio final))
	  
          ;; SACAR EL CONTENIDO QUE QUIERO
          ;; titulo, url, puntos, posted_by, time, discuss
          ;; AHORA METERLO TODO EN UN HASH
          (setq hashy (make-hash-table :test 'equal))
          (with-temp-buffer
            (insert "\n" content)
            (goto-char (point-min))
            ;; mientras exista un td con clase title...
            (while (re-search-forward "\<td class=\"title\"" nil t)
              ;; BUSCAR LOS TITLES
              ;; <td class="title">
              ;;   <a|| href="http://blog.davidwurtz.com/smart-people-should-do-stupid-stuff">
              ;;     Smart People should do Stupid Stuff</a>
              (re-search-forward "\<a" nil t)
              (setq anchor-start (match-beginning 0))

              ;; MIENTRAS ESTAS AHI, VE POR LOS LINKS => title-link
              ;; (recuerda que estabas buscando los titles)
              ;; <a href="http://blog.davidwurtz.com/smart-||">
              (re-search-forward "href=\"" nil t)
              (setq link-start (match-end 0))
              (re-search-forward "\"")
              (setq link-end (match-beginning 0))
              (setq title-link
                    (buffer-substring-no-properties link-start link-end))

              ;; ok, sigue con lo de los titulos
              (re-search-forward "\>" nil t)
              (setq iinicio (match-end 0))
              (re-search-forward "\<\/a\>" nil t)
              (setq ffinal (match-beginning 0))
              (setq titulo
                    (buffer-substring-no-properties iinicio ffinal))

              ;; ahora trae cuantos puntos tiene y de paso cual es su id
              (re-search-forward "\<td class=\"subtext\"" nil t)
              (re-search-forward "\<span id=score." nil t)

              ;; este match es el id del title
              (re-search-forward "[0-9]*" nil t)
              (setq title-id (match-string-no-properties 0))

              ;; continua con lo de cuantos puntos tiene
              ;; <span id=score_992023>
              ;; 85 points</span||>
              (re-search-forward "\>" nil t)
              (setq title-points-start (match-end 0))
              (re-search-forward "\<\/span" nil t)
              (setq title-points-end (match-beginning 0))
              (setq title-points (buffer-substring-no-properties
                                  title-points-start
                                  title-points-end))

              ;; CUAL USER?
              ;; by <a href="user?id=||davidwurtz">
              ;; davidwurtz</a>
              (re-search-forward "id=" nil t)
              (setq title-user-start (match-end 0))
              (re-search-forward "\"" nil t)
              (setq title-user-end (match-beginning 0))
              (setq title-user (buffer-substring-no-properties
                                title-user-start
                                title-user-end))

              ;; HOW MANY COMMENTS?
              ;; 9 hours ago  | <a href="item?id=992023">
              ;; ||21 comments</a>
              ;; (re-search-forward "href=\"item\?id=[0-9]*" nil t)
              ;; (re-search-forward "href=\".*?\"?" nil t)
              ;; (re-search-forward "href=\".*\"." nil t)
	      (re-search-forward "href=\".*\?\"." nil t)
              (setq title-comments-count-start (match-end 0))
              (re-search-forward "\<\/a" nil t)
              (setq title-comments-count-end (match-beginning 0))
              (setq title-comments-count (buffer-substring-no-properties
                                          title-comments-count-start
                                          title-comments-count-end))

              ;; (message "%s %s \n %s %s %s \n Comentarios:%s"
              ;;          titulo
              ;;          title-link
              ;;          title-points
              ;;          title-id
              ;;          title-user
              ;;          title-comments-count
              ;;          )

              ;; QUIERO METER ESA INFORMACION EN UN HASH
              ;; hacer un hash del titulo para que no haya INFORMACION
              ;; repetida
              ;; meterlo en el hash
              (puthash titulo
                       (vector titulo title-link title-points title-id title-user title-comments-count)
                       ;; title-link
                       ;; (titulo  title-link title-points)
                       ;; "uno dos tres cuatro"
                       hashy)

              ) ; while
            )
          )
        (kill-buffer (current-buffer))
        ;; (pp hashy)

        (get-buffer-create "*Hacker News*")
        (set-buffer "*Hacker News*")
        (kill-buffer "*Hacker News*")
        (get-buffer-create "*Hacker News*")
        (set-buffer "*Hacker News*")
        ;; t: titulo, l: link
        ;; FOREACH PARA CADA UNO DE LOS LINKS QUE ENCONTRO: The View
        (setq articles-counter 0)
	(insert "* Hacker News" "\n")

        (maphash (lambda(ti li)
                   (setq articles-counter
                         (1+ articles-counter))
                   (setq articles-counter-s (number-to-string articles-counter))
		   ;; "Smart People should do Stupid Stuff" 
		   ;; "http://blog.davidwurtz.com/smart-people-should-do-stupid-stuff" 
		   ;; "85 points" 
		   ;; "992023" 
		   ;; "davidwurtz" 
		   ;; "6 comments"
                   (insert "** " articles-counter-s ". " (elt li 0)) ; TITULO
                   (insert "\n")		   
                   (insert "   :PROPERTIES:\n" "   :url: " (elt li 1)  "\n"  "   :END:" "\n") ; LINK
                   ;; esto esta super chafilla deberia de pasarle un argumento
                   ;; al boton pero no supe como
                   ;; el boton tiene una posicion que se llama (overlay-start buton)
                   (insert-button "Go"
                                  'action '(lambda (button)
                                             ;; boton al que te lleva el browser
                                             ;; casi casi lo que hago es prev-line
                                             (re-search-backward "http")
                                             (setq address-start (match-beginning 0))
                                             (goto-char address-start)
                                             (re-search-forward "^http.*?$" nil t)
                                             (setq address-end (match-end 0))
                                             (setq address (buffer-substring-no-properties
                                                            address-start
                                                            address-end))
                                             (browse-url-firefox address)
                                             ;; (pp address)
                                             )) ; BOTON 
		   (insert  "  " (elt li 2))	; POINTS
		   (insert  " by " (elt li 4))	; POSTED_BY
		   (insert  " | " (elt li 5))
                   (insert "\n\n")
                   ) hashy)
        (set-window-buffer (next-window) "*Hacker News*")
        (goto-char (point-min))
	(org-mode)
        ) ;; lambda end
     )
    ) ;; let end ----------------------------
  )

(provide 'hacker-news)