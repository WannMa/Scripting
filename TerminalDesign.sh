#!/bin/ksh

LEFT_OUTER_CORNER_U="\u250F"      # --> ┏ 
LEFT_OUTER_CORNER_D="\u2517"
LEFT_OUTER_VERT_LINE="\u2503"     # --> ┃ 
LEFT_OUTER_MID_LINE="\u2523"      # --> ┣ 

MID_INNER_DASH="\u2501"           # --> ━
MID_INNER_ODASH="\u2919"          # --> ⤙
MID_INNER_CDASH="\u257C"          # --> ╼

RIGHT_INNER_BLOCK="\u25A7"        # --> ▨ 
RIGHT_INNER_BLOCKW="\u2B1C"       # --> ⬜
RIGHT_INNER_CIRC="\u29BF"         # --> ⦿ 
RIGHT_INNER_ARROW="\u2192"        # --> →

#   ------ Procedure's ------   #

  Design_Start(){
#
  printf "\n ${LEFT_OUTER_CORNER_U}${RIGHT_INNER_BLOCK}"  # --> ▨
  printf "\n ${LEFT_OUTER_VERT_LINE}"  # --> |
  #
  return 0
}
  Design_Command(){
#
typeset -i faktor=${1}    # faktor of mid delim dashes
typeset msg="${2}"        # message 
typeset descr="${3}"      # descr after read
typeset command="${4}"    # command 2b executed
integer x_length=0     # calcs nr of cursor moves
  x_length=${#msg}+8+$faktor
  #
  printf "\n ${LEFT_OUTER_MID_LINE}${MID_INNER_DASH}"
  xfaktorchar_ "$faktor" "${MID_INNER_DASH}"
  printf "${MID_INNER_DASH}${MID_INNER_ODASH} ${RIGHT_INNER_CIRC} $msg"
  printf "\n ${LEFT_OUTER_VERT_LINE}\t\t $descr \033[A\r\033[${x_length}C" # returns (via ansi esc-seq) to previous row
  $command;                                                                # before executes handed-command and moves cursor
  Design_Line "1"
  #
  return 0
}
  Design_Table(){
#
#***#   Display Parameters    #***#
typeset inner_column_seperator="\u002B"   #==> Standard: \u002B | Unicode for plus (+)
typeset outer_column_seperator="\u007C"   #==> Standard: \u007C | Unicode for pipe (|)
typeset column_delimeter="\u002D"         #==> Standard: \u002D | Unicode for dash (-)
typeset space_delimeter="\u0020"          #==> Standard: \u0020 | Unicode for space ( )
#
#***#   Variables     #***#
typeset mode=${1}               #] Either Column / Row or Print
typeset ftemp="${PWD}/_Variable_Design.conf"
#
integer width_resize
#
integer NROFROW
integer NROFCOL
# _ indicating procedure wide variable
typeset -A _arr_align
integer _counter=0
integer _icounter=0
integer _counter_params=${#}
# 
  case $mode in
    COLUMN|Column|column)
      #
        typeset x_head_name #] stores x head content
        #
        touch "${ftemp}"  #] create temporary file
        ((NROFCOL=_counter_params-1)) #] get number of columns
        #
        printf "#==> wma TerminalDesign := Procedure Variables\n">"${ftemp}"
        printf "\nNROFCOL=\"${NROFCOL}\"">>${ftemp} #] prints "global" number of columns to temp-file (var-formatting/usage)
        printf "\nNROFROW=\"0\"">>${ftemp}  #] prints "global" number of rows to temp-file (var-formatting/usage)
        numtochar_ "${NROFCOL}" " 0"  #] returns string of x (amount col) zeros
        printf "\nMAX_SIZE=(${x_chars} )\n">>${ftemp}  #] prints "global" array of maximal sizing (var-formatting/usage)
        #
        printf "\n#==> Column-Variables">>${ftemp}
        ((_icounter=0)) #] set array index counter
        ((_counter=1))  #] set counter
        for ((i=2;i<=_counter_params;i++))  #] for each desired column do...
        do
          eval "typeset x_in=\${${i}}"; #] sets handover value temporarily
          #pattern="!(:a@(l|r|c))"
          _arr_align[${_icounter}]="${x_in##*:}" #] sets array element (index=nrcol-1) with alignment specifications if provided 
          x_head_name=${x_in%%+(:a@(l|r|c))}  #] extracts possible specifications and returns pure column name
          #
          printf "\nHEAD_${_counter}_NAME=\"${x_head_name}\"">>${ftemp} #] writes "global" x column name to temp-file (var-formatting/usage)
          #
          ((_counter++))  #] increment counter
          ((_icounter++)) #] increment index counter
        done
        printf "\nALIGN_HEAD=( ${_arr_align[*]} )">>${ftemp} #] writes full alignment array for heading to temp-file (var-formatting/usage)
        printf "\n\n#<----------------------\n\n">>${ftemp} #] delim
      #
      ;;
    ROW|Row|row)
      #
        ### Exception Block
          if [ ! -e "${ftemp}" ]; then exception 11; fi #] raise error due missing temp-file
          #if ((_counter_params-1 = NROFCOL ));then exception 12; fi  #] raise error due overlap 
        ### <--
        readfile "${ftemp}"  #] accses to variables via associated temp-file
        #
        x_row=( typeset content ; typeset -i size) #] struct row storing content and size
        integer temp_arrvalue #] stores temporary array value
        typeset pre_pat #] calc-var which results in a pattern to store pre set array-values  
        typeset post_pat  #] calc-var which results in a pattern to store post set array-values 
        #
        ((NROFROW++)) # increment number of rows (global) counter
        printf "#==> RUN := ${NROFROW} Row-Variable">>${ftemp}
        #
        ((_counter=1))  #] set counter
        ((_icounter=0)) #] set index counter
        for ((i=2;i<=_counter_params;i++))  #] for each desired row do...
        do
          #
          eval "typeset x_in=\${${i}}"; #] sets handover value temporarily
          _arr_align[$_icounter]="${x_in##*:}" #] sets array element (index=nrcol-1) with alignment specifications if provided 
          x_row.content="${x_in%%+(:a@(l|r|c))}" #] extracts possible specifications and returns pure row content
          x_row.size=${#x_in} #] sets pure row content size
          #
          temp_arrvalue=${MAX_SIZE[$_icounter]} #] sets max (column) size
          #] SED array replace certain element workflow
          if (( x_row.size > temp_arrvalue )); then #] if current row size larger than stored one in array then...
            ((pre_pat=_counter-1))  #] get count of numbers "before desired change" [*left*new] 
            numtochar_ "$pre_pat" "[[:space:]][[:digit:]]*" #] build posix pattern to recognize numbers before desired change
            pre_pat="${x_chars}"  #] set result string of numtochar_ function to var
            ((post_pat=_counter_params-_counter-1)) #] get count of numbers "after desired change" [new*right*] 
            numtochar_ "$post_pat" "[[:space:]][[:digit:]]*"  #] build posix pattern to recognize numbers after desired change
            post_pat="${x_chars}" #] set result string of numtochar_ function to var
            sed 's/\(^MAX_SIZE=('${pre_pat}'\)[[:space:]][[:digit:]]*\('${post_pat}'[[:space:]]\))/\1 '${x_row.size}'\2)/' "${ftemp}" > "${ftemp}.temp";  #] replace array values in file
            mv "${ftemp}.temp" "${ftemp}" #] replace file created via sed with orginal
          fi
          #
          printf "\nROW${NROFROW}_COL_${_counter}_CONTENT=\"${x_row.content}\"">>${ftemp} #] writes "global" x row content (x col) to temp-file (var-formatting/usage)
          #
          ((_counter++))  #] increment counter
          ((_icounter++)) #] increment index counter
        done
        sed 's/\(^NROFROW=\"\).*/\1'${NROFROW}'\"/' "${ftemp}" > "${ftemp}.temp"; #] replace row number in file with update
        mv "${ftemp}.temp" "${ftemp}" #] replace file created via sed with orginal
        printf "\nALIGN_${NROFROW}_ROW=( ${_arr_align[*]} )">>${ftemp}  #] writes full alignment array for heading to temp-file (var-formatting/usage)
        printf "\n\n#--------->\n">>${ftemp}  #] delim
      #
      ;;
    PRINT|Print|print)
      #
        ### Exception Block
          if [ ! -e "${ftemp}" ]; then exception 21; fi #] raise error due missing temp-file
        ### <--
        readfile "${ftemp}"  #] accses to variables via associated temp-file
        #
        typeset -i width_resize=4 #] dynamic width placeholder for calculations
        typeset Layout_Line_Full=" ${LEFT_OUTER_VERT_LINE} $inner_column_seperator" #] stores full line
        typeset Layout_Line_Header=" ${LEFT_OUTER_VERT_LINE} $outer_column_seperator" #] holds header line
        typeset Layout_Line_Row=""  #] holds Row line
        #
        x_head=( typeset name ; typeset -i size) #] struct storing head row content and size
        x_row=( typeset content ; typeset -i size) #] struct row storing content and size
        typeset x_full  #] stores full size by x col
        #
        typeset alignment #] stores x col/row alignment setting
        #
        ((_icounter=0)) #] set counter
        for ((i=1;i<=NROFCOL;i++))  #] for each column do...
        do 
          eval "x_head.name=\${HEAD_${i}_NAME}";  #] sets x column(name) size value temporarily
          x_head.size=${#x_head.name} #] sets pure head size
          x_maxrow_size=${MAX_SIZE[$_icounter]} #] sets max (column) size
          alignment=${ALIGN_HEAD[$_icounter]} #] sets alignment info for this specific column
          #
          while ((x_maxrow_size<=x_head.size)); do  #] while max reuqierd row size larger than heading do...
            ((x_maxrow_size++)) #] increment maximal row size
            __GO=${__TRUE}  #] flag = GO
          done
          if [[ ${__GO} = ${__TRUE} && $alignment = ":al" || $alignment = ":ar" ]]; then  #] if maxnr gotten larger and alignment left / right do... 
            ((x_maxrow_size+=4))  #] increment maximal row size by 4
          else
            ((x_maxrow_size+=2))  #] increment maximal row size by 2
          fi  #] padding / visibility purposes
          #
          ((x_full=x_maxrow_size))  #] sets full size for delimeter row
          defallignment_ "${alignment}~COLUMN" "${x_maxrow_size}" "${x_head.name}"  #] evaluates allignment settings and builds heading row
          #
          eval "MAX_SIZE[$_icounter]=$x_maxrow_size"; #] replaces max size value with possible new one
          numtochar_ "$x_full" "$column_delimeter"  #] returns charakters 
          Layout_Line_Full+="${x_chars}${inner_column_seperator}" #] builds full string
          #
          ((_icounter++)) #] increment counter
        done
        #
        printf "\n$Layout_Line_Full"  #] prints delim row
        printf "\n$Layout_Line_Header"  #] prints header ( column ) row
        printf "\n$Layout_Line_Full"  #] prints delim row
        for ((i=1;i<=NROFROW;i++))  #] for each row do...
        do
          ((_icounter=0)) #] set counter
          Layout_Line_Row="\n ${LEFT_OUTER_VERT_LINE} $outer_column_seperator"  #] standard row line setting
          for ((j=1;j<=NROFCOL;j++))  #] for each column in row do...
          do
          eval "x_row.content=\${ROW${i}_COL_${j}_CONTENT}";  #] take x row content into var
          x_maxrow_size="${MAX_SIZE[$_icounter]}" #] get max size x into var
          x_row.size="${#x_row.content}"  #] holds row size 
          eval "alignment=\${ALIGN_${i}_ROW[$_icounter]}";  #] get alignment setting for x row
          #
          defallignment_ "${alignment}~ROW" "${x_maxrow_size}" "${x_row.content}" #] evaluates allignment settings and builds custom row
          #
          ((_icounter++)) #] increment counter
          done
          printf "$Layout_Line_Row" #] prints custom created row ( aligned )
          printf "\n$Layout_Line_Full"  #] prints delim row
          # 
        done
        #rm "${ftemp}"
      #
      ;;
    *)
      ;;
  esac
  
  return 0
}
  Design_Block(){
#
    typeset -i faktor=${1}    # faktor of mid delim dashes
    typeset descr=${2}        # description before block
    typeset msg=${3}          # message after block
    #
    printf "\n ${LEFT_OUTER_VERT_LINE}"
    xfaktorchar_ "$faktor" "$MID_INNER_DASH"
    printf "${MID_INNER_CDASH}${MID_INNER_DASH}$descr${RIGHT_INNER_BLOCKW} $msg"
                
  return 0
}
  Design_Arrow(){
#
    typeset -i faktor=${1}    # faktor of mid delim dashes
    typeset descr=${2}        # description before block
    typeset msg=${3}          # message after block
    #
    printf "\n ${LEFT_OUTER_VERT_LINE}"
    xfaktorchar_ "$faktor" "$MID_INNER_DASH"
    printf "${MID_INNER_DASH}${MID_INNER_DASH}$descr ${RIGHT_INNER_ARROW} $msg"

  return 0
}
  Design_Line(){
#
    typeset -i faktor=${1}    # faktor of mid delim dashes
    #
    xfaktorchar_ "$faktor" "\n $LEFT_OUTER_VERT_LINE"

  return 0
}
  Design_End(){
#
    printf "\n ${LEFT_OUTER_VERT_LINE}"  # --> |
    printf "\n ${LEFT_OUTER_CORNER_D}${RIGHT_INNER_BLOCK}"  # --> ▨

  return 0
}

#==> Internal Usage Only

  xfaktorchar_(){
#
    typeset faktor=${1}
    typeset char=${2}
    for ((i=0;i<faktor;i++))
    do
       printf "${char}"
    done

  return 0
}
  numtochar_(){
#
    typeset -i sum=${1}
    typeset char=${2}
    typeset x_chars=""
    #
    for ((x=1;x<=sum;x++))
    do
      x_chars+="${char}"
    done

    return 0
}
  append_(){
#
    typeset mode="${1}"
    typeset txtl="${2}"
    typeset txtr="${3}"
    typeset txtcontent="${4}"

    case $mode in
      COLUMN)
        Layout_Line_Header+="${txtl}${txtcontent}${txtr}${outer_column_seperator}"
        ;;
      ROW)
        Layout_Line_Row+="${txtl}${txtcontent}${txtr}${outer_column_seperator}"
        ;;
    esac

    return 0
  }
  defallignment_(){
#
      typeset option=${1%%~*} # deletes match - longest part at end till ~ of var
      typeset mode=${1##*~} # deletes match - longest part at beginning till ~ of var
      typeset x_maxrow_size=${2}
      typeset x_content=${3}
      typeset x_size=0
      typeset x_width_lr=0
      typeset x_row_left=0
      typeset x_row_right=0
      #
      x_size=${#x_content}
      #
      specconvert__(){
      #
              typeset left=${1}
              typeset right=${2}
              typeset delim=${3}
              typeset cont=${4}
              #
                numtochar_ "$left" "${delim}"
                x_row_left="${x_chars}" 
                numtochar_ "$right" "${delim}"
                x_row_right="${x_chars}" 
                #
                append_ "$mode" "$x_row_left" "$x_row_right" "$cont"
              #
              return 0
            }
      #
      case $option in
            al) #] = Option: Align Content Left
              ##### :al
              ((x_row_left=1))  # Adaptes left side space
              ((x_row_right=x_maxrow_size-x_size-x_row_left))
              #
              specconvert__ "${x_row_left}" "${x_row_right}" "${space_delimeter}" "${x_content}"
              ;;
            ar) #] = Option: Align Content Right
              ##### :ar
              ((x_row_right=1))
              ((x_row_left=x_maxrow_size-x_size-x_row_right))
              #
              specconvert__ "${x_row_left}" "${x_row_right}" "${space_delimeter}" "${x_content}"              
              ;;
            ac|*) #] = Option: Align Content Center
              ##### :ac
              ((x_width_lr=x_maxrow_size-x_size))
              if (( x_width_lr%2 > 0 )); then ((x_row_right+=1)); fi    # just number check and fix
              ((x_width_lr=x_width_lr/2))
              ((x_row_right+=x_width_lr))
              #
              specconvert__ "${x_width_lr}" "${x_row_right}" "${space_delimeter}" "${x_content}"
        ;;
      esac
      #
      return 0
  }
  resize_(){
#
    typeset height="${1}"
    typeset width="${2}"
    typeset sequence
    #
    eval "sequence='\033[8;$1;$2t'";
    printf "$sequence" # == > adapt screen size to max width

    return 0
}
  readfile(){
#
    typeset file="${1}"
    . ${file}
    
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
      12) #] = Row Procedure cant be executed due invalid number of handover vars
        printf "\nRow Procedure cant be executed due invalid number of handover vars"
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
Design_Line "1"
Design_Block "3" " Text " "Block"
Design_Line "2"
Design_Table "COLUMN" "ColumnHead1:al" "ColumnHead2ColumnHead2ColumnHead2:al" "ColumnHead3:al" "ColumnHead4:al"
Design_Table "ROW" "Row1ssssssCol1" "Row1Col2" "Row1sssssCol3123" "Row1Col4:ac"
Design_Table "ROW" "Row2Col1" "Row2Col2123" "Row2Col3" "Row2sssssssssssCol4123:ac"
Design_Table "PRINT"
#Design_Command "20" "Message: " "(e.g example)" "read test1"
Design_Arrow "3" " Input" "Test"
Design_End
