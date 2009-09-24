
(require 'auto-complete)

(ac-define-dictionary-source
 ac-source-sql
 '("use" 
   "development" 
   "test" 
   "production" 
   "select" 
   "from" 
   "show" 
   "databases" 
   "where"))

(provide 'auto-complete-sql)
