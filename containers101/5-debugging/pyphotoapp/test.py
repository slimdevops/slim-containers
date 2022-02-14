# test.py
import pkg_resources
import os

required = {'flask'}
installed = installed = {pkg.key for pkg in pkg_resources.working_set}
missing = required - installed 

CURSED = """
         .e$$$$e.
       e$$$$$$$$$$e
      $$$$$$$$$$$$$$
     d$$$$$$$$$$$$$$b
     $$$$$$$$$$$$$$$$
    4$$$$$$$$$$$$$$$$F
    4$$$$$$$$$$$$$$$$F
     $$$" "$$$$" "$$$
     $$F   4$$F   4$$
     '$F   4$$F   4$"
      $$   $$$$   $P
      4$$$$$"^$$$$$%
       $$$$F  4$$$$
        "$$$ee$$$"
        . *$$$$F4
         $     .$
         "$$$$$$"
          ^$$$$
 4$$c       ""       .$$r
 ^$$$b              e$$$"
 d$$$$$e          z$$$$$b
4$$$*$$$$$c    .$$$$$*$$$r
 ""    ^*$$$be$$$*"    ^"
          "$$$$"
        .d$$P$$$b
       d$$P   ^$$$b
   .ed$$$"      "$$$be.
 $$$$$$P          *$$$$$$
4$$$$$P            $$$$$$"
 "*$$$"            ^$$P
    ""              ^" 
        Magic FLASK not found! 
    TESTS FAILED: CONTAINER IS CURSED! 
    """

# os.environ["USER_ID"] = "freddy_kruger"
# os.environ["GROUP_ID"] = "monster"
    
with open('/app/result.txt','w') as f:
  if missing:     
      f.write(CURSED)
  else: 
      f.write("Flask of Magic found. Test Passed. You have made it to Level 2.")
