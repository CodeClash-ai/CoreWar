;redcode
;name B-scanners live in vain
;author Matt Hastings
;strategy same as original, this is a SPL/JMP
;strategy bombing B-scanner.  Just noticed
;strategy that it was dropping out of loop early

      add #1226,3
start jmz -1,@2
      mov grave,@1
      mov prog,<-2+1226
      jmn -4,-4
prog  spl 0,0
      mov @10,<-1
grave jmp -1,0

      end start
