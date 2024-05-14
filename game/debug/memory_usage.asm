@_total_memory_usage: DEFL 0
@_total_memory_available: DEFL 0
@_previous_memory_end: DEFL 0

    MACRO MEMORY_USAGE name, label 
        IF @_previous_memory_end != label && @_previous_memory_end != 0
            DISPLAY "MEM_USAGE: ~~~~~~~~~~~~~~  available: ", label-@_previous_memory_end+1," (",/D,label-@_previous_memory_end+1," bytes)"
@_total_memory_available = @_total_memory_available + label-@_previous_memory_end+1
        ENDIF
		DISPLAY "MEM_USAGE: ",name,"start: ",label, ", end: ", $-1, ", size: ",/H,$-label,/D," (",$-label," bytes)"   
@_previous_memory_end = $
@_total_memory_usage=@_total_memory_usage+($-label)
	ENDM

    MACRO TOTAL_MEMORY_USAGE
        DISPLAY "MEM_USAGE: ~~~~~~~~~~~~~~  available: ", 0xFFFF-@_previous_memory_end+1," (",/D,0xFFFF-@_previous_memory_end+1," bytes)"
@_total_memory_available = @_total_memory_available + 0xFFFF-@_previous_memory_end+1
        DISPLAY "TOTAL_MEM_USAGE: ",@_total_memory_usage," (",/D,@_total_memory_usage," bytes)"
        DISPLAY "TOTAL_MEM_AVAILABLE: ",@_total_memory_available," (",/D,@_total_memory_available," bytes)"
    ENDM