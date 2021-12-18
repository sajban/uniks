;; -*- lexical-binding: t -*-

(defclass derivationAttrs ()
  ((name :type string)
   (version :type string)
   (src :type string)
   (system :type string)
   (outputs :type list)
   (builder :type string)))

(defclass elispDerivationAttrs (derivationAttrs)
  ((elnDependencies :type vector)
   (elispBuild :type string)
   (elispDependencies :type vector)
   (elispMkDerivation :type string)
   (structuredDerivations :type vector)))

(cl-defmethod make ((attrs elispDerivationAttrs))
  (print (oref attrs structuredDerivations)))

;; jeison-defclass doesnt lint properly
(mapc 'jeisonify
      '(derivationAttrs elispDerivationAttrs))
