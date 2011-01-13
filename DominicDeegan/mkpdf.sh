#!/bin/bash

LATEX=file.latex

cat > $LATEX <<EOF
\documentclass{minimal}
\usepackage{graphicx}
\begin{document}
EOF

ls | egrep '\.(gif|jpe?g)$' | sort | while read FILE; do

    echo $FILE >&2

    case $FILE in
	*.gif)
	    NEWFILE=tmp_${FILE%.gif}.png
	    [ -e $NEWFILE ] || convert $FILE $NEWFILE
	    FILE=$NEWFILE
	    ;;
    esac	    

    echo "\includegraphics[scale=0.8, angle=90]{$FILE}\\\\"
#    echo "\clearpage"

done >> $LATEX


cat >> $LATEX <<EOF
\end{document}
EOF

