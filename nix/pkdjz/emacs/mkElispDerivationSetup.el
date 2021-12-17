;; -*- lexical-binding: t -*-

(require 'dired)
(require 'json)
(require 'eieio)

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

(defclass derivationAttrs nil
  ((name :type string)
   (version :type string)
   (src :type string)
   (system :type string)
   (outputs :type list)
   (coreutilsPath :type string)
   (builder :type string)
   (elnDependencies :type vector)
   (elispBuild :type string)
   (elispDependencies :type vector)))

(let*
    ((jsonFile "./.attrs.json")
     (jsonAList (json-read-file jsonFile))
     (coreutilsPath (cdr (assoc 'coreutilsPath jsonAList)))
     (pathEnvSet (set-variable 'exec-path (append (list coreutilsPath) exec-path)))
     (elnDependencies (append
		       (cdr (assoc 'elnDependencies jsonAList)) nil))
     (elnDepsLoaded (mapc 'loadElnFromPackage elnDependencies))
     (classJeisonified (jeisonify derivationAttrs))
     (jeisonObject (jeison-read derivationAttrs jsonAList)))
  (print (oref jeisonObject outputs))
  (print jeisonObject))
