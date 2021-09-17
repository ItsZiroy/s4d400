*&---------------------------------------------------------------------*
*& Report z05_sql2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_sql2.

data g_flights type d400_t_flights.
DATA g_airline TYPE s_carrid.
DATA g_flight_number TYPE d400_s_flight-connid.

cl_s4d_input=>get_connection(
  IMPORTING
    ev_airline   = g_airline
    ev_flight_no = g_flight_number
).

SELECT FROM sflight
    FIELDS carrid, connid, fldate, planetype, seatsmax, seatsocc
    WHERE carrid = @g_airline AND connid = @g_flight_number
    INTO CORRESPONDING FIELDS OF TABLE @g_flights.

cl_s4d_output=>display_table( it_table = g_flights ).
