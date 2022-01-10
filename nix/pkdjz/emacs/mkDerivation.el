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

(cl-deftype elisp () 'stringp)

(defclass elispDerivation (derivationAttrs)
  ((elnDependencies :type elispPackages)
   (elispBuild :type elisp)
   (elispDependencies :type elispPackages)
   (elispMkDerivation :type string)
   (structuredDerivations :type vector)))

(mapc 'jeisonify '(derivationAttrs elispDerivation))

(cl-defmethod makingNativeLoadPath ((elispPackage string))
  (let* ((nativePathSuffix "/share/emacs/native-lisp"))
    (expand-file-name nativePathSuffix elispPackage)))

(cl-defmethod ->loadPath ((elPkg elispPackage))
  (let* ((elispPathSuffix "/share/emacs/site-lisp"))
    (expand-file-name elispPathSuffix elPkg)))

(cl-defmethod addingLoadPaths ((elispDependencies vector))
  (let* ((elispLoadPaths
	  (mapcar '->LoadPath elispDependencies))
	 (nativeLoadPaths
	  (mapcar 'makingNativeLoadPath elispDependencies)))
    (print elispLoadPaths)
    (print nativeLoadPaths)
    (setq load-path (append elispLoadPaths load-path))
    (setq native-comp-eln-load-path
	  (append nativeLoadPaths native-comp-eln-load-path))))

(cl-defmethod making ((elDrv elispDerivation))
  (let*
      ((elispDependencies (oref elDrv elispDependencies)))
    (addingLoadPaths elispDependencies)
    (print elDrv)))
