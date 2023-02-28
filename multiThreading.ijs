NB.* multiThreading.ijs: test new multi-threading primitives.

NB.* fnc: a CPU-bound function that will take arbitrarily long to
NB. run depending on its argument.
fnc=: 3 : '+/+/%.1e9-~(y,y)?@$2e9 [ randomizeSeed '''''"0
NB.* randomizeSeed: randomize the random number seed so multiple
NB. simultaneous instances of a function yield different random numbers.
NB.* randomizeSeed: randomize random seed - not thread-aware
randomizeSeed=: 3 : '9!:1](|-/7!:1'''')+<.13#.|.(6!:1''''),(6!:4''''),6!:0'''']y'
NB.* randomizeSeed: randomize random seed - thread-aware
randomizeSeed=: 3 : '9!:1](|-/7!:1'''')+(3 T. '''')+<.13#.|.(6!:1''''),(6!:4''''),6!:0'''']y'

NB.* createThreads: create y threads
createThreads=: 3 : '{{0 T. ''''}}^:y]'''''

NB.* numThreads: return number of threads allocated.
numThreads=: {{1 T. y}}

NB.* wincpucores: returns number of cores on current Windows box.
wincpucores=: {{
  assert. 0={.;'kernel32 GetNativeSystemInfo n i' 15!:0 ,<mem=: mema 44
  (memf mem)]_2 ic _4{.memr mem,32 4
}}
NB.EG wincpucores ''

NB.* threadLook: return number of current thread.
threadLook=: 3 : '3 T. '''''

NB.* runScript: apply u to y on a thread.
runScript=: 1 : 'u t. '''' y'"1
NB.EG rr=. (shell runScript)&.>scripts

NB. * rattle: rattle pyx
rattle=: (4 T. '']])

egTests1=. 0 : 0
   1!:44 dd=. 'C:\amisc\pix\Photos\2022Q2\Unflipped20220415-19\' rplc '\/'
   load 'D:/amisc/J/NYCJUG/202205/multiThreading.ijs'
   createThreads 12
   scripts=. 0{"1 dir '*.ijs'
   str0=. 'IPD=: <''C:/amisc/pix/Photos/2022Q2/20220415-19/'''
   str1=. 'IPD=: <''C:/amisc/pix/Photos/2022Q2/Unflipped20220415-19/'''
   6!:2 '((fread &.>scripts) rplc &.> <str0;str1;CR;'''') fwrite &.> scripts'
0.0055567

   rr=. (shell runScript)&.>scripts [ tm=. 6!:1'' [ smoutput qts ''
2022 4 20 21 46 58.973
   2 T. ''                          NB. Idle threads
2 1
   rattle&>rr
12 11 10 9 8 7 6 5 4 3
)

egUseFnc=. 0 : 0
   6!:2 'fnc 1000'
0.1153
   6!:2 'fnc 2000'
0.759236
   6!:2 'fnc 4000'
5.45686
)   

egTest=. 0 : 0
   tm=. tm,6!:1'' [ 4 T. pyx0 [ tm=. tm,6!:1'' [ pyx0=. fnc t. ''"0]10$4000 [ tm=. 6!:1''
   6!:2 'pyx0=. fnc t. ''''"0]10$4000'
)

egTests=. 0 : 0
   1!:44 'd:/amisc/J/NYCJUG/202204/'
   load 'multiThreading.ijs'
   {{0 T. ''}}^:12]''
   6!:2 'pyx0=. fnc t. ''''"0]10$4000' [ smoutput qts''
2022 4 12 18 8 52.366
0.0001025
   pyx0
qts''
+------------+------------+------------+------------+------------+------...
|_9.15016e_10|_9.15016e_10|_9.15016e_10|_9.15016e_10|_9.15016e_10|_9.150...
+------------+------------+------------+------------+------------+------...
   2022 4 12 18 2 41.861
   load 'dt'
   2022 4 12 18 9 2.986 TSDiff 2022 4 12 18 8 52.366
+-----+---------------+
|10.62|0 0 0 0 0 10.62|
+-----+---------------+
   NB. So this took a total of 10.6 seconds.

   6!:2 'pyx0=. fnc t. ''''"0]10$4000' [ tm=. 6!:1 '' [ smoutput qts''
tm=. tm,~6!:1 '' [ smoutput 4 T. pyx0
tm=. tm,~6!:1 '' [ smoutput pyx0 [ smoutput qts''
tm=. tm,~6!:1 ''   NB. This froze J.

NB. But something like the following has run w/o problem several times:
6!:2 'pyx0=. fnc t. ''''"0]2$4000' [ tm=. 6!:1 '' [ smoutput qts''
tm=. tm,~6!:1 '' [ smoutput 4 T. pyx0
({.-{:) tm=. tm,~6!:1 '' [ smoutput pyx0 [ smoutput qts''

6!:2 'pyx0=. fnc t. ''''"0]12$4000' [ tm=. 6!:1 '' [ smoutput qts''
tm=. tm,~6!:1 '' [ smoutput 4 T. pyx0
({.-{:) tm=. tm,~6!:1 '' [ smoutput pyx0 [ smoutput qts''

6!:2 'pyx0=. fnc t. ''''"0]10$4000' [ tm=. 6!:1 '' [ smoutput qts''
4 T. " ] pyx0
({.-{:) tm=. tm,~6!:1 '' [ smoutput pyx0 [ smoutput qts''
)

egRunScripts=. 0 : 0
   1!:44 'd:/amisc/J/NYCJUG/202205/'
   load 'multiThreading.ijs'
   {{0 T. ''}}^:12]''
   1!:44 'D:/amisc/pix/Photos/2022Q2/20220409-10/'
   scripts=. 0{"1 dir '*.ijs'
   runScript=: 1 : 'u &.> y'
   rr=. shell&runScript t. '' scripts [ tm=. 6!:1''

   runScript=: 3 : 'shell &.> y'
   rr=. runScript t. '' scripts [ tm=. 6!:1''

   rr=. shell t. '' ] 'FlipScript0.ijs'  [ tm=. 6!:1''
   rr=. rr,shell t. '' ] 'FlipScript1.ijs'
   rr=. rr,shell t. '' ] 'FlipScript2.ijs'
   rr=. rr,shell t. '' ] 'FlipScript3.ijs'
   rr=. rr,shell t. '' ] 'FlipScript4.ijs'
   rr=. rr,shell t. '' ] 'FlipScript5.ijs'
   rr=. rr,shell t. '' ] 'FlipScript6.ijs'
   rr=. rr,shell t. '' ] 'FlipScript7.ijs'
   4 T. rr [ tm=. tm,~6!:1 ''
)
