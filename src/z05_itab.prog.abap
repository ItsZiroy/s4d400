*&---------------------------------------------------------------------*
*& Report z05_itab
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_itab.

DATA g_connections TYPE z05_connections.
DATA g_flights TYPE d400_t_flights.
DATA g_percentages TYPE d400_t_percentage.

g_connections = VALUE #( ( carrid = 'LH' connid = '400' ) ( carrid = 'LH' connid = '402' ) ).

CALL FUNCTION 'Z_05_GET_FLIGHTS_FOR_CONN'
  EXPORTING
    it_connections = g_connections
  IMPORTING
    et_flights     = g_flights
  EXCEPTIONS
    CX_S4D400_NO_DATA  = 1
    OTHERS         = 2.


IF sy-subrc = 0.
  g_percentages = CORRESPONDING #( g_flights ).

  LOOP AT g_percentages REFERENCE INTO DATA(l_percentage).
    l_percentage->percentage = l_percentage->seatsocc / l_percentage->seatsmax * 100.
  endloop.


  cl_s4d_output=>display_table( g_percentages ).
ENDIF.
