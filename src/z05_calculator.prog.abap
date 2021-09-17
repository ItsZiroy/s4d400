*&---------------------------------------------------------------------*
*& Report z05_calculator
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_calculator.

PARAMETERS: p_int_1 TYPE i, p_op TYPE z05_operator,  p_int_2 TYPE i.

DATA g_result TYPE z00_packed.

DATA g_error_message TYPE string.

CASE p_op.

  WHEN '+'.
    g_result = p_int_1 + p_int_2.

  WHEN '-'.
    g_result = p_int_1 - p_int_2.

  WHEN '*'.
    g_result = p_int_1 * p_int_2.

  WHEN '/'.
    CALL FUNCTION 'Z_05_DIVIDE'
      EXPORTING
        i_val1           = conv z00_packed( p_int_1 )
        i_val2           = conv z00_packed( p_int_2 )
      IMPORTING
        e_result         = g_result
      EXCEPTIONS
        division_by_zero = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      g_error_message = 'Division durch 0 nicht erlaubt.'.
    ENDIF.

  WHEN '^'.
    g_result = ipow( base = p_int_1 exp = p_int_2 ).

    DATA g_percentage_result TYPE s4d400_percentage.

  WHEN '%'.
    CALL FUNCTION 'S4D400_CALCULATE_PERCENTAGE'
      EXPORTING
        iv_int1          = p_int_1
        iv_int2          = p_int_2
      IMPORTING
        ev_result        = g_percentage_result
      EXCEPTIONS
        division_by_zero = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      MESSAGE 'Division by Zeor' TYPE 'E' DISPLAY LIKE 'E'.
    ELSE.
      g_result = g_percentage_result.
    ENDIF.

  WHEN OTHERS.
    g_error_message = 'Fehlerhafter Operator'.

ENDCASE.

IF g_error_message IS INITIAL.

  WRITE |Das Ergebnis ist { g_result }|.
ELSE.

  WRITE g_error_message.
ENDIF.
