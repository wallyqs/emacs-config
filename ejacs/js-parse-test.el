;;; js-parse-test.el -- miscellaneous test utilities

;; Author:  Steve Yegge (steve.yegge@gmail.com)
;; Version: 2008.10.30
;; Keywords:  javascript languages

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

;;; Profiling results:
;;
;;  - change the parser to use buffers rather than strings, and buffer
;;    positions rather than input substrings.
;;
;;  Tests running tokenizer on jsparse.js:
;;    version with substrings:  1.5 min+
;;    buffer w/ macro:  34 sec
;;    buffer w/ "faster" macro:  33 sec
;;    buffer w/o macro:  19 sec
;;    buffer w/ pre-expanded macros:  6 sec  (also expanded setfs, etc.)
;;    buffer w/ macro, compiled alias-slots + js-lexer-get:  4.5 sec
;;    buffer w/ macro, compiled whole file:  0.38 sec avg (elp)
;;    buffer w/o macro, compiled whole file:  0.38 sec avg (elp)
;;
;; Conclusions:
;;   - the buffer version is 3x-4x faster than the substring version
;;     - also yielded ~10% more compact code overall
;;   - byte-compilation is required no matter what  (40x-100x improvement)
;;   - using the $alias macro has no real effect on byte-compiled performance

(require 'js)

(defmacro js-time (form)
  "Evaluate FORM, discard result, and return elapsed time in sec"
  (let ((beg (gensym))
        (delta (gensym)))
    `(let ((,beg (current-time))
           ,delta)
       ,form
       (setq ,delta (time-subtract (current-time) ,beg))
       (+ (cadr ,delta) (/ (caddr ,delta) 1000000.0)))))

(defun js-token-print (token &optional text-only)
  "Return a debugging representation of the token."
  (if text-only
      (js-token-value token)
    (format "[token \"%s\" %s start=%s end=%s assign-op=%s]"
            (js-token-value token)
            (js-token-type token)
            (js-token-start token)
            (js-token-end token)
            (js-token-assign-op token))))

(defun js-token-copy (tk)
  (list (cons 'type (js-token-type tk))
        (cons 'start (js-token-start tk))
        (cons 'end (js-token-end tk))
        (cons 'line (js-token-line tk))
        (cons 'assign-op (js-token-assign-op tk))))

(defvar js-lexer-input-tests
  nil
  "Miscellaneous small tests of the JavaScript tokenizer.")

(setq js-lexer-input-tests
  '(("" . ())
    ("void(0)" . (void LEFT_PAREN NUMBER RIGHT_PAREN))
    ("()" . (LEFT_PAREN RIGHT_PAREN))
    ("// hi there" . ())
    ("/* I'm a test */" . ())
    ("'howdy pardner'" . (STRING))
    ("var x = 6;" . (var IDENTIFIER ASSIGN NUMBER SEMICOLON))
  ))

(defun js-lexer-test-tokenizing (input output)
  "Tests the tokenizer.
INPUT is a string of JavaScript to tokenize.
OUTPUT is the expected tokens."
  (let ((z (make-js-lexer :buffer input :filename "test")))
    (while output
      (assert (eq (pop output) (js-lexer-get z))
              t))))

(defun js-simple-lexer-tests ()
  "Go through `js-lexer-input-tests' and run each one."
  (dolist (test js-lexer-input-tests)
    (js-lexer-test-tokenizing (car test) (cdr test))))

(defun js-test-get-token (lx)
  "Fetches a copy of the current token from the tokenizer.
Copying is necessary because the Narcissus parser reuses tokens."
  (progn (js-lexer-get lx)  ; returns type
         (js-token-copy (js-lexer-token lx))))

;; not a unit test - a utility function
(defun js-test-collect-tokens (input)
  "Run the tokenizer on INPUT until end-of-input and return the tokens.
INPUT is a string, and it returns the token structs (not the types)."
  (let ((lx (make-js-lexer :buffer input))
        (tokens '()))
    (while (not (js-lexer-done lx))
      (push (js-test-get-token lx) tokens))
     (nreverse tokens)))

(defun js-test-tokenize (input &optional filename)
  "Just tokenize the input by repeatedly calling `js-lexer-get'.
Shouldn't throw any errors on well-formed input."
  (let ((z (make-js-lexer :buffer input)))
    (while (neq 'END (js-lexer-get z)))))

;; unit test
(defun js-test-lexer-ops ()
  "Test that the lexer properly recognizes all its operators."
  (let* ((input
          ;; space-separated string of all operators and punctuators
          (mapconcat #'identity
                     (mapcar #'car
                             (remove (cons "\n" 'NEWLINE)
                                     js-op-names))
                     " "))
         (lx (make-js-lexer :buffer input
                              :scan-operand nil))  ; get PLUS/UNARY_PLUS right
         token)
    (while (not (js-lexer-done lx))
      (setq token (js-test-get-token lx))
      (assert (eq (cdr (assoc (js-token-value token) js-op-names))
                  (js-token-type token))
              t))))
          

(defun js-test-lex-big-file (filename &optional print)
  "Run the tokenizer on a big javascript file.
If PRINT is non-nil, prints the tokens as it scans them."
  (let* ((buf (find-file-noselect filename))
         (lx (make-js-lexer :buffer buf))
         (end 1)
         value token)
    (while (not (js-lexer-done lx))
      (setq token (js-test-get-token lx))
      (when print
        ;; print the buffer contents skipped between tokens
        (insert (save-excursion
                  (set-buffer buf)
                  (buffer-substring end (js-token-start token))))
        (setq end (js-token-end token))
        (setq value (js-token-value token))
        ;; print the token value, depending on the token type
        (insert
         (format
          "%s"
          (cond
           ((eq 'REGEXP (js-token-type token))
            (concat "/" (car value) "/" (cdr value)))
           ((and (eq 'ASSIGN (js-token-type token))
                 (js-token-assign-op token))
            (concat (car (js-token-assign-op token)) "="))
           (t
            value))))))))
        
(defun js-test-lex-big-string (filename &optional print)
  "Run the tokenizer on a big javascript file.
If PRINT is non-nil, prints the tokens as it scans them."
  (let* ((input (save-excursion
                  (with-temp-buffer
                    (insert-file-contents filename)
                    (buffer-string))))
         (lx (make-js-lexer :source input))
         (end 1)
         value token)
    (save-excursion
      (while (not (js-lexer-done lx))
        (setq token (js-test-get-token lx))
        (when print
          ;; print the file contents skipped between tokens
          (insert (substring input end (js-token-start token)))
          (setq end (js-token-end token))
          (setq value (js-token-value token))
          ;; print the token value, depending on the token type
          (insert
           (format
            "%s"
            (cond
             ((eq 'REGEXP (js-token-type token))
              (concat "/" (car value) "/" (cdr value)))
             ((and (eq 'ASSIGN (js-token-type token))
                   (js-token-assign-op token))
              (concat (car (js-token-assign-op token)) "="))
             (t
              value)))))))))

;; development utility
(defun js-unload ()
  "Unbinds all js-* symbols."
  (interactive)
  (dolist (sym (apropos-internal "^js-"))
    (if (fboundp sym) (fmakunbound sym))
    (if (boundp sym) (makunbound sym))))

;; test suite
(defun js-lexer-run-tests ()
  "Run test suites for the interpreter."
  (js-simple-lexer-tests))

(defun js-ast-depth (tree)
  "Computes the max depth of ast TREE.
Destroys the tree while checking (puts 'seen props on each node)."
  (cond
   ((js-node-p tree)
    (if (js-node-get tree 'seen)
        0
      (progn
        (js-node-put tree 'seen t)
        (1+
         (let ((kids (js-node-child-nodes tree)))
           (cond
            ((null kids) 0)
            ((null (cdr kids))
             (js-ast-depth (car kids)))
            (t
             (apply #'max
                    (mapcar (lambda (n)
                              (js-ast-depth n))
                            kids)))))))))
   (t 0)))

                    
