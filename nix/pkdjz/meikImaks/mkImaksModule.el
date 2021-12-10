(use-package json)

(defun mkModule (attrs)
  (print attrs))

(let (attrs (json-read-file "./attrs.json"))
  (mkModule attrs))
