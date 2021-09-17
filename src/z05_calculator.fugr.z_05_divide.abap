FUNCTION Z_05_DIVIDE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_VAL1) TYPE  Z00_PACKED
*"     VALUE(I_VAL2) TYPE  Z00_PACKED
*"  EXPORTING
*"     REFERENCE(E_RESULT) TYPE  Z00_PACKED
*"  EXCEPTIONS
*"      DIVISION_BY_ZERO
*"----------------------------------------------------------------------
  IF i_val2 = 0.
    RAISE division_by_zero.
  ENDIF.

  e_result = i_val1 / i_val2.
.

ENDFUNCTION.
