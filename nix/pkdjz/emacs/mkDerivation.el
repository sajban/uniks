;; -*- lexical-binding: t -*-

(defclass derivationAttrs ()
  ((name :type string)
   (version :type string)
   (src :type string)
   (system :type string)
   (outputs :type list)
   (builder :type string)))

(cl-deftype elispPackage () 'stringp)
(cl-deftype elispPackages () '(vector-of elispPackage))

(defclass elispDerivationAttrs (derivationAttrs)
  ((elnDependencies :type (vector-of string))
   (elispBuild :type string)
   (elispDependencies :type elispPackages)
   (elispMkDerivation :type string)
   (structuredDerivations :type vector)))

(mapc 'jeisonify '(derivationAttrs elispDerivationAttrs))

(cl-defmethod makingNativeLoadPath ((elispPackage string))
  (let* ((nativePathSuffix "/share/emacs/native-lisp"))
    (expand-file-name nativePathSuffix elispPackage)))

(cl-defmethod mkLoadPath (elispPackage)
  (let* ((elispPathSuffix "/share/emacs/site-lisp"))
    (expand-file-name elispPathSuffix elispPackage)))

(cl-defmethod addingLoadPaths ((elispDependencies vector))
  (let* ((elispLoadPaths
	  (mapcar 'mkLoadPath elispDependencies))
	 (nativeLoadPaths
	  (mapcar 'makingNativeLoadPath elispDependencies)))
    (print elispLoadPaths)
    (print nativeLoadPaths)
    (setq load-path (append elispLoadPaths load-path))
    (setq native-comp-eln-load-path
	  (append nativeLoadPaths native-comp-eln-load-path))))

(cl-defmethod making ((attrs elispDerivationAttrs))
  (let*
      ((elispDependencies (oref attrs elispDependencies)))
    (addingLoadPaths elispDependencies)
    (print elispDependencies)
    (print load-path)
    (print process-environment)))
