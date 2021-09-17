FUNCTION Z_05_GET_FLIGHTS_FOR_CONN.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_CONNECTIONS) TYPE  D400_ITAB_S1
*"  EXPORTING
*"     REFERENCE(ET_FLIGHTS) TYPE  D400_T_FLIGHTS
*"  RAISING
*"      CX_S4D400_NO_DATA
*"----------------------------------------------------------------------
  .

  DATA lt_where TYPE TABLE OF string.
  IF it_connections IS INITIAL.
    SELECT FROM sflight
    FIELDS carrid, connid, fldate, planetype, seatsmax, seatsocc
    INTO TABLE @et_flights.
  ELSE.
    LOOP AT it_connections ASSIGNING FIELD-SYMBOL(<line>).
      IF lines(  lt_where ) > 0.
        APPEND | or | TO lt_where.
      ENDIF.
      APPEND |carrid = '{ <line>-carrid }' and connid = '{ <line>-connid }'| TO lt_where.
    ENDLOOP.
    SELECT FROM sflight
    FIELDS carrid, connid, fldate, planetype, seatsmax, seatsocc
     WHERE (lt_where)
     INTO TABLE @et_flights.
  ENDIF.



ENDFUNCTION.
