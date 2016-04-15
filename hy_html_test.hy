(require hy_html)
(import (hy_html [prettify]))


(defclass Circle ()
  (defn --init-- (self &optional [x 50] [y 50] [r 40] [stroke "green"] [stroke-width 4] [fill "yellow"])
    (setv self.cx x
          self.cy y
          self.r r
          self.stroke stroke
          self.stroke-width stroke-width
          self.fill fill))

  (defn draw (self)
    (hy-html
     (circle {cx self.cx cy self.cy r self.r
              stroke self.stroke stroke-width self.stroke-width fill self.fill}))))


;; BeautifulSoup changes <circle ../> to <circle ...> </circle>
(defn ncircles (n)
  (prettify
   (+ "<!DOCTYPE html>"
      (hy-html
       (html
        (body
         (h1 "Five circles")
         (svg {width 300 height 100}
              (hy
               (setv result [])
               (for (i (range n))
                 (.append result (.draw (Circle :x (* i 50)))))
               (.join "" result)))))))))


(with (f (open "circles.html" "w"))
  (.write f (ncircles 5)))


