*&---------------------------------------------------------------------*
*& Report z05_first
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_first.

DATA gv_text TYPE string.

cl_s4d_input=>get_text( IMPORTING ev_text = gv_text ).

cl_s4d_output=>display_string( gv_text ).
