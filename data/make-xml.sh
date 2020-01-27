#!/bin/bash

data=$WNHOME31
frames=verb.Framestext
templates=sents.vrb
templatesmap=sentidx.vrb
tagcounts=cntlist.rev

#echo $data
#echo ${data}/${frames}
#echo ${data}/${templates}
#echo ${data}/${templatesmap}
#echo ${data}/${tagcounts}

# frame list
sort -n ${data}/${frames} | \
sed 's/^\([0-9]*\) /<frame id="\1">/' - | \
sed 's/ *$/<\/frame>/' - > verbframes.xml

# template list
sort -n ${data}/${templates} | \
sed 's/^\([0-9]*\) /<sent id="\1">/' - | \
sed 's/ *$/<\/sent>/' - > verbtemplates.xml

# template map
sort -n ${data}/${templatesmap} | \
awk -F ' |,' 'BEGIN{print "<maps>"} {printf "<map><sensekey>%s</sensekey>",$1; for(i=2;i<=NF;i++) if($i) printf "<sentid>%s</sentid>",$i; print "</map>"} END{print "</maps>"} ' - > data-verbtemplates.xml

# template map
sort -n ${data}/${templatesmap} | \
awk -F ' |,' 'BEGIN{print "<maps>"} {printf "<map><sensekey>%s</sensekey>",$1; for(i=2;i<=NF;i++) if($i) printf "<sentid>%s</sentid>",$i; print "</map>"} END{print "</maps>"} ' - > data-verbtemplates.xml

# tagcounts
sort -n ${data}/${tagcounts} | \
awk 'BEGIN{print "<maps>"} {printf "<map><sensekey>%s</sensekey>",$1; printf "<sensenum>%d</sensenum>",$2; printf "<tagcnt>%d</tagcnt>",$3; print "</map>"} END{print "</maps>"} ' - > data-tagcount.xml
