*&---------------------------------------------------------------------*
*& Report z05_sql1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_sql1.

DATA g_flight TYPE d400_s_flight.
DATA g_airline TYPE s_carrid.
DATA g_flight_number TYPE d400_s_flight-connid.
DATA g_flight_date TYPE d400_s_flight-fldate.


cl_s4d_input=>get_flight(
  IMPORTING
    ev_airline   = g_airline
    ev_flight_no = g_flight_number
    ev_date      = g_flight_date
).

SELECT SINGLE carrid, connid, fldate, planetype, seatsmax, seatsocc
 FROM sflight
    WHERE carrid = @g_airline AND connid = @g_flight_number AND fldate = @g_flight_date
    INTO @g_flight.

IF sy-subrc = 0.
  cl_s4d_output=>display_structure( iv_structure = g_flight ).
ELSE.
  MESSAGE 'No Flights found for this date.' TYPE 'I'.
ENDIF.
