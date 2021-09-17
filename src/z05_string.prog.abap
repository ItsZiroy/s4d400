*&---------------------------------------------------------------------*
*& Report z05_string
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_string.

PARAMETERS p_text TYPE string LOWER CASE.

CASE substring( val = p_text len = 1 ). " Alte Schreibweise: p_text+0(1)

  WHEN 'A'.
    WRITE to_upper( p_text ).

  WHEN 'Z'.
    WRITE reverse( p_text ).

  WHEN OTHERS.
    DO strlen( p_text ) TIMES.

      WRITE: / |{ sy-index }: { substring( val = p_text off = sy-index - 1 len = 1 ) }|.
    ENDDO.
ENDCASE.
