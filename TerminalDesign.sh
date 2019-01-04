#!/bin/ksh

LEFT_OUTER_CORNER_U="\u250F"      # --> ┏
LEFT_OUTER_CORNER_D="\u2517"
LEFT_OUTER_VERT_LINE="\u2503"     # --> ┃
LEFT_OUTER_MID_LINE="\u2523"      # --> ┣

MID_INNER_DASH="\u2501"           # --> ━
MID_INNER_ODASH="\u2919"          # --> ⤙

RIGHT_INNER_BLOCK="\u25A7"        # --> ▨
RIGHT_INNER_CIRC="\u29BF"         # --> ⦿


#   ------ Procedure's ------   #

  Design_Start(){
#
  printf "\n ${LEFT_OUTER_CORNER_U}${RIGHT_INNER_BLOCK}"  # --> ▨
  printf "\n ${LEFT_OUTER_VERT_LINE}"  # --> |

  return 0
}

  Design_Command(){
#
typeset -i faktor=${1}    # faktor of mid delim dashes
typeset msg="${2}"        # message
typeset descr="${3}"      # descr after read
typeset command="${4}"    # command 2b executed
typeset -i x_length=0     # calcs nr of cursor moves
  x_length=${#msg}+8+$faktor

  printf "\n ${LEFT_OUTER_MID_LINE}${MID_INNER_DASH}"
  xfaktordash_ "$faktor"
  printf "${MID_INNER_DASH}${MID_INNER_ODASH} ${RIGHT_INNER_CIRC} $msg"
  printf "\n ${LEFT_OUTER_VERT_LINE}\t\t $descr \033[A\r\033[${x_length}C" # returns (via ansi esc-seq) to previous row and move cursor
  $command;

  return 0
}

  Design_Table(){
#
#***#   Display Parameters    #***#
typeset inner_column_seperator="\u002B"   #==> Standard: \u002B | Unicode for plus (+)
typeset outer_column_seperator="\u007C"   #==> Standard: \u007C | Unicode for pipe (|)
typeset column_delimeter="\u002D"         #==> Standard: \u002D | Unicode for dash (-)
#
#***#   Internal Varibles     #***#
typeset mode=${1}               #] Either Column / Row or Print
typeset temp_file_vars_name="$PWD/_Variable_Design.conf"
#
typeset _savepath="$PWD"
typeset -i width_resize
#
typeset -i NROFROW
typeset -i NROFCOL
typeset -i MAXOFROW
typeset -i MAXOFCOL
#
typeset -i _counter=0
typeset -i _counter_params=$#
#
  case $mode in
    COLUMN|Column|column)
      #
        typeset -i x_width=0 #
        NROFROW=0
        ((NROFCOL=_counter_params-1))
        #
        touch "$temp_file_vars_name"  #] Create Temp-File
        #
        printf "#==> wma TerminalDesign := Procedure Variables\n">"$temp_file_vars_name"
        #
        printf "\n#==> Column-Variables">>$temp_file_vars_name
        printf "\nNROFCOL=\"$NROFCOL\"\n">>$temp_file_vars_name
        ((_counter=1))
        for ((i=2;i<=_counter_params;i++))
        do
          eval "typeset x_in=\${$i}"; # returns input param to var
          #
          typeset x_head_content=${x_in}
          typeset x_head_size=${#x_in}
          ((x_width=x_head_size))
          #
          printf "\nHEAD_${_counter}_CONTENT=\"$x_head_content\"">>$temp_file_vars_name
          printf "\nHEAD_${_counter}_SIZE=\"$x_width\"">>$temp_file_vars_name
          #
          ((_counter++))
        done
        printf "\n\n#-------------------->\n">>$temp_file_vars_name
        #
      #
      ;;
    ROW|Row|row)
      #
        ### Exception Block
          if [ ! -e "$temp_file_vars_name" ]; then exception 11; fi # raise error 11
        ### <--
        . "$temp_file_vars_name"  #accses to associated variable file
        #
        typeset -i x_width=0 #

        ((NROFROW++)) # increment number of rows (global) counter
        printf "#==> RUN := $NROFROW Row-Variable">>$temp_file_vars_name
        printf "\nNROFROW=\"$NROFROW\"\n">>"$temp_file_vars_name"
        ((_counter=1))
        for ((i=2;i<=_counter_params;i++))
        do
          eval "typeset x_in=\${$i}"; # returns input param to var
          #
          typeset x_row_content=${x_in}
          typeset x_row_size=${#x_in}
          ((x_width=x_row_size))
          printf "\nCOL${_counter}_ROW_${NROFROW}_NAME=\"$x_row_content\"">>$temp_file_vars_name
          printf "\nCOL${_counter}_ROW_${NROFROW}_SIZE=\"$x_width\"">>$temp_file_vars_name
          #
          ((_counter++))
        done
        printf "\n\n#--------->\n">>$temp_file_vars_name
      #
      ;;
    PRINT|Print|print)
      #
        ### Exception Block
          if [ ! -e "$temp_file_vars_name" ]; then exception 21; fi # check if variable file exists
        ### <--
        . "$temp_file_vars_name"  #accses to associated variable file
        #
        typeset -i width_resize=4
        typeset terminalfull
        typeset Layout_Line_Full="\n ${LEFT_OUTER_VERT_LINE} $inner_column_seperator" #result full line
        typeset Layout_Line_Header=" ${LEFT_OUTER_VERT_LINE} $outer_column_seperator" # result header line
        typeset Layout_Line_Row=""  # result Row line
        #
        typeset x_head_content
        typeset x_head_size
        typeset temp_max_size
        #
        typeset x_row_size
        typeset x_width_lr=""
        typeset x_full=""
        #
        for ((i=1;i<=NROFCOL;i++))
        do
          eval "x_head_size=\${HEAD_${i}_SIZE}";
          eval "x_head_content=\${HEAD_${i}_CONTENT}";
          #
          ### Get Max Values of Row
          ((temp_max_size=0))
          #
          for ((j=1;j<=NROFROW;j++))
          do
            eval "x_row_size=\${COL${i}_ROW_${j}_SIZE}";  # get xrow size for xcolumn
            if ((x_row_size > temp_max_size)); then
              ((temp_max_size=x_row_size))  # get max size from all rows
            fi
          done
          #
          if (( temp_max_size%2 > 0 )); then ((temp_max_size+=1)) ; fi    # just number check and fix
          #
          ((x_width_lr=temp_max_size/2)) # get left/right size for center view (xcol)
          ((x_full=temp_max_size+x_head_size)) # add col name = full col size
          #
          eval "COL${i}_NR_FULL=\${x_full}" # store max of xcol
          ###==> Symbols
          #COL
          numtochar_ "$x_width_lr" " "
          Layout_Line_Header+="${x_chars}${x_head_content}${x_chars}${outer_column_seperator}"
          numtochar_ "$x_full" "$column_delimeter"
          Layout_Line_Full+="${x_chars}${inner_column_seperator}"
          #
          ((width_resize=width_resize+x_full+1))
        #
        done

        typeset x_row_left=2
        typeset x_row_right
        #ROW's
        for ((i=1;i<=NROFROW;i++))
        do
        #
        Layout_Line_Row="\n ${LEFT_OUTER_VERT_LINE} $outer_column_seperator"
          for ((j=1;j<=NROFCOL;j++))
          do
            ((x_row_left=2))
            eval "x_row_name=\${COL${j}_ROW_${i}_NAME}";  # get xrow content for xcolumn
            eval "x_row_size=\${COL${j}_ROW_${i}_SIZE}";  # get xrow size for xcolumn
            eval "x_col_max=\${COL${j}_NR_FULL}";
            ((x_row_right=x_col_max-x_row_size-x_row_left)) # get right side content space
            numtochar_ "$x_row_left" " "
            x_row_left=$x_chars
            numtochar_ "$x_row_right" " "
            Layout_Line_Row+="${x_row_left}${x_row_name}${x_chars}${outer_column_seperator}"
          done
        eval "ROW_${i}_STYLE=\"$Layout_Line_Row\"";
        #
        done
        #
        if ((width_resize<150 )); then ((width_resize=150)); fi # sets min resize-size
        resize_ "50" "$width_resize"
        ###==> FINAL Printing Part
        printf "$Layout_Line_Full"
        printf "\n$Layout_Line_Header"
        printf "$Layout_Line_Full"
        for ((i=1;i<=NROFROW;i++))
        do
          eval "Layout_Line_Row=\${ROW_${i}_STYLE}";
          printf "$Layout_Line_Row"
          printf "$Layout_Line_Full"
        done
        printf "\n"
        #
        rm "$temp_file_vars_name"
      #
      ;;
    *)
      ;;
  esac
}
  Design_End(){
#
  printf " ${LEFT_OUTER_VERT_LINE}"  # --> |
  printf "\n ${LEFT_OUTER_CORNER_D}${RIGHT_INNER_BLOCK}\n"  # --> ▨

  return 0
}

#### Internal

  xfaktordash_(){
    typeset faktor=${1}
    for ((i=0;i<faktor;i++))
    do
       printf "${MID_INNER_DASH}"
    done

  return 0
}
  numtochar_(){
    typeset -i sum=${1}
    typeset char=$2
    typeset x_chars=""
    #
    for ((x=1;x<=sum;x++))
    do
      x_chars+="$char"
    done

    return 0
}
  resize_(){
    typeset height="$1"
    typeset width="$2"
    typeset sequence
    #
    eval "sequence='\033[8;$1;$2t'";
    printf "$sequence" # == > adapt screen size

    return 0
}
#
#   ------ Exception Handeling ------   #
  exception(){
    _errorlvl=${1}
    clear
    case $_errorlvl in
      11) #] = Row Procedure cant be executed due missing/invalid variable file
        printf "\nRow Procedure cant be executed due missing/invalid variable-file"
        exception 999
        ;;
      21) #] = Print Procedure cant be executed due missing/invalid file
        printf "\nPrint Procedure cant be executed due missing/invalid variable-file"
        exception 999
        ;;
      999) #] = Norm. Exit
        sleep 3
        exit;
        ;;
      *)
        printf "\nPlease make sure that the executed / calling Script has w&r permissions!"
        exit;
        ;;
    esac
}
#
### ==> MAIN

Design_Start
Design_Command "20" "Message: " "(e.g example)" "read test1"
Design_Table "COLUMN" "ColumnHead1" "ColumnHead2" "ColumnHead3" "ColumnHead4"
Design_Table "ROW" "Row1Col1" "Row1Col2" "Row1Col3" "Row1Col4"
Design_Table "ROW" "Row2Col1" "Row2Col2" "Row2Col3" "Row2Col4"
Design_Table "PRINT"
Design_End
