;; (setq ac-omni-completion-sources 
;;       '(("\\window.\\=" ac-source-js-window))
;;       )

;; (setq ac-omni-completion-sources 
;;       '(("\\NodeList.\\=" ac-source-js-nodelist))
;;       )

;; (setq ac-omni-completion-sources 
;;       '(("\\Node.\\=" ac-source-js-node))
;;       )

;; (setq ac-omni-completion-sources 
;;       '(("\\document.\\=" ac-source-js-document))
;;       )


(setq ac-omni-completion-sources 
      '(
	("\\window.\\=" ac-source-js-window)
	("\\NodeList.\\=" ac-source-js-nodelist)
	("\\Node.\\=" ac-source-js-node)
	("\\document.\\=" ac-source-js-document)
	("\\jquery.\\=" ac-source-js-jquery)
	("\\arguments.\\=" ac-source-js-arguments)
	("\\Array.prototype.\\=" ac-source-js-array)
	("\\Boolean.prototype.\\=" ac-source-js-boolean)
	("\\Date\\=" ac-source-js-date)
	("\\Date.\\=" ac-source-js-date1)
	)
      )

(provide 'auto-complete-js-hooks)
