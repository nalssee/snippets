(import bs4)

(defmacro hy-html (expr)
  (defn tag (&rest args)
    ;; Hy expression insertion
    (setv INSERT "hy")
    (cond [(= (len args) 1)
           (setv val (get args 0))
           (cond [(symbol? val)
                  ;; like <br />
                  (+ "<" (str val) " />")]
                 ;; TODO: Keyword seems to be wierd a bit
                 [(string? val) val]
                 [(= (str (first val)) INSERT)
                  `(str (do ~@(cut val 1)))]
                 [True
                  (apply tag val)])]
          
          [(= (len args) 2)
           (setv tagname (get args 0))
           (setv attr-or-val (get args 1))
           (if (instance? (type '{}) attr-or-val)
             ;; attributes and no value
             `(+ "<" (str '~tagname) " " ~(build-attr attr-or-val) " />")
             ;; no attr, just a single value
             `(+ "<" (str '~tagname) ">"
                 ~(tag attr-or-val)
                 "</" (str '~tagname) ">"))]
          ;; more than 2
          [True
           (setv tagname (get args 0))
           (if (instance? (type '{}) (get args 1))
             ;; has attributes
             `(+ "<" (str '~tagname) " " ~(build-attr (get args 1)) ">"
                 ~(build-values (cut args 2))
                 "</" (str '~tagname) ">")
             `(+ "<" (str '~tagname) ">"
                 ~(build-values (cut args 1))
                 "</" (str '~tagname) ">"))]))

  ;; attr is not a Dict, it's a HyDict
  (defn build-attr (attrs)
    (setv result [])
    (for (i (range 0 (len attrs) 2))
      (.append result `(+ ~(name (get attrs i)) "=" "\"" (str ~(get attrs (+ i 1))) "\"")))
    `(.join " " ~result))

  (defn build-values (vals)
    (setv result [])
    (for (val vals)
      (.append result (tag val)))
    `(.join "" ~result))

  (tag expr))


(defn prettify (html)
  (.prettify (.BeautifulSoup bs4 html "html.parser")))

