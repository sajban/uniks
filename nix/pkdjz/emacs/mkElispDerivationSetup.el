;; -*- lexical-binding: t -*-
(require 'json)
(require 'eieio)

(defun loadElnFromPackage (packagePath)
  (let*
      ((elnPathSuffix (concat "/share/emacs/native-lisp/"
			      comp-native-version-dir))
       (elnDir (expand-file-name elnPathSuffix packagePath))
       (elnFiles (list-directory elnDir))
       (loadElnFile (lambda (file)
		      (load-file (expand-file-name file elnDir)))))
    (mapc 'loadElnFile elnFiles)))


(defclass derivationAttrs ()
  (system :type string)
  (name :type string)
  (version :type string)
  (src :type string)
  (out :type string)
  (builder :type string)
  (ElispBuild :type string)
  (ElispDependencies :type (list-of string)))


(let*
    ((jsonAList (json-read-file "./.attrs.json"))
     (PATH (assoc "PATH" jsonAList))
     (pathEnvSet (setenv "PATH" PATH))
     (elnDependencies (assoc "elnDependencies" jsonAList)))
  (mapc 'loadElnFromPackage elnDependencies))
  

(let* ((jsonAList (json-read-file "./.attrs.json"))
       (jeisonLoaded (require 'jeison))
       (derivationAttrsJeisonified (jeisonify derivationAttrs))
       (derivationAttrs (jeison-read jsonAList)))
  (print derivationAttrs))
