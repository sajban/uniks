;; -*- lexical-binding: t -*-

(require 'dired)
(require 'json)

(defun loadElnFromPackage (packagePath)
  (let*
      ((nativeDir (expand-file-name
		   "share/emacs/native-lisp/" packagePath))
       (elnDir (expand-file-name
		comp-native-version-dir nativeDir))
       (elnFiles (directory-files elnDir nil "\\.eln$")))
    (defun loadElnFile  (file)
      (let
	  ((elnFile (expand-file-name file elnDir)))
	(progn
	  (native-elisp-load elnFile))))
    (mapc 'loadElnFile elnFiles)))

(let*
    ((jsonFileExists (file-exists-p "./.attrs.json"))
     (maybeJsonFromFile (when jsonFileExists
			  (json-read-file "./.attrs.json")))
     (jsonAList (or maybeJsonFromFile))
     (setupElnDependencies
      (append (cdr (assoc 'setupElnDependencies jsonAList)) nil))
     (elispMkDerivation (cdr (assoc 'elispMkDerivation jsonAList))))
  (mapc 'loadElnFromPackage setupElnDependencies)
  (load-file elispMkDerivation)
  (making (jeison-read elispDerivationAttrs jsonAList)))
