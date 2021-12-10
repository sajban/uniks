(require 'json)

(defun mkModule (attrs)
  (print attrs))

(let* ((JsonAttrsFile (concat pwd "./.attrs.json"))
       (attrs (json-read-file JsonAttrsFile)))
  (mkModule attrs))