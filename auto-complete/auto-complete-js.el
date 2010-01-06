(require 'auto-complete)

;; SOLO VOY A PONER TODOS LOS METODOS POSIBLES DE LO QUE SEA
(ac-define-dictionary-source
 ac-source-js
 '(
   "use" 
   "development" 
   "test" 
   "production" 
   "select" 
   "from" 
   "show" 
   "databases" 
   "where"
   ))

(provide 'auto-complete-js)

