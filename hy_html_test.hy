(require hy_html)
(import (hy_html [prettify]))

(print (= (hy-html "abc") "abc"))
(print (= (hy-html abc) "<abc />"))
(print (= (hy-html (hy (+ 3 4))) "7"))
(print (= (hy-html (img {src "#"})) "<img src=\"#\" />"))
(let [x "/sample.jpg"]
  (print (= (hy-html (img {src x}))
            "<img src=\"/sample.jpg\" />")))


;; BeautifulSoup changes <circle ../> to <circle ...> </circle>


;; TODO: need some super classes and mixins
(defclass Won ()
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
              stroke self.stroke stroke-width self.stroke-width fill self.fill
              }))))

(setv won1 (Won :x 30))
(print (= (.draw won1)
          "<circle cx=\"30\" cy=\"50\" r=\"40\" stroke=\"green\" stroke-width=\"4\" fill=\"yellow\" />"))

(defn ncircles (n)
  (prettify
   (+ "<!DOCTYPE html>"
      (hy-html
       (html
        (body
         (h1 "Five circles")
         (svg {width 300 height 100}
              (hy
               (do
                (setv result [])
                (for (i (range n))
                  (.append result (.draw (Won :x (* i 50)))))
                (.join "" result))))))))))

(with (f (open "circles.html" "w"))
      (.write f (ncircles 5)))


