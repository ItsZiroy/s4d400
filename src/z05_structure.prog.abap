*&---------------------------------------------------------------------*
*& Report z05_structure
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_structure.

TYPES: BEGIN OF ty_complete,
         carrid    TYPE s_carr_id,
         connid    TYPE s_conn_id,
         cityfrom  TYPE s_from_cit,
         cityto    TYPE s_to_city,
         fldate    TYPE s_date,
         planetype TYPE s_planetye,
         seatsmax  TYPE s_seatsmax,
         seatsocc  TYPE s_seatsocc,
       END OF ty_complete.


DATA gs_conn TYPE z05_connection.
DATA gs_flight TYPE d400_s_flight.
DATA gs_complete TYPE ty_complete.

gs_conn = VALUE #( carrid = 'LH' connid = '0400' cityfrom = 'FRANKFURT' cityto = 'NEW YORK' ).

cl_s4d400_flight_model=>get_next_flight(
    EXPORTING
        iv_carrid =  gs_conn-carrid
        iv_connid = gs_conn-connid
    IMPORTING
        es_flight = gs_flight
    EXCEPTIONS
        OTHERS = 1
).
IF sy-subrc <> 0.
  MESSAGE 'No data supplied' TYPE 'E'.

  ELSE.

  gs_complete = CORRESPONDING #( BASE ( gs_conn ) gs_flight ).

  cl_s4d_output=>display_structure( gs_complete ).
ENDIF.
