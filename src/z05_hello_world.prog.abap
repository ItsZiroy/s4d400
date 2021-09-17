*&---------------------------------------------------------------------*
*& Report z05_hello_world
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_hello_world.


**********************************************************************
* Variable definition
**********************************************************************

DATA g_not_very_inline TYPE i VALUE 25.
DATA g_arithmetic TYPE i.

DATA(g_int_inline) = 25.
DATA(g_int_converted) = CONV int8( 25 ).

DATA bool TYPE abap_bool.

TYPES type.

DATA type TYPE type. " XDDDDDDD

" '' --> Character mit bestimmter Länge
" `` --> String


**********************************************************************
* Parameter definition
**********************************************************************
PARAMETERS: g_text TYPE string LOWER CASE, g_carr TYPE s_carr_id.

CLEAR g_int_inline. " Setzt Variable auf Standart Wert zurück (0)


**********************************************************************
* arithmetic expressions
**********************************************************************
g_arithmetic = 50.

g_arithmetic = g_arithmetic DIV 2.
g_arithmetic = g_arithmetic MOD 2.



**********************************************************************
* expressions
**********************************************************************

IF g_arithmetic = 0. ENDIF." gleich (==)
IF g_arithmetic <> 0. ENDIF." ungleich (!=)

g_arithmetic = 5.

CASE g_arithmetic.

  WHEN 3.

    WRITE 3.

  WHEN 4.

    WRITE 4.

  WHEN OTHERS.

    WRITE 'Other'.

ENDCASE.


**********************************************************************
* loops
**********************************************************************

DO.
  g_arithmetic = 10.
  IF g_arithmetic = 10.
    EXIT.
  ENDIF.
ENDDO.

DO 5 TIMES.
  WRITE sy-index.
ENDDO.

**********************************************************************
* Structures
**********************************************************************
TYPES: BEGIN OF ty_person_chain,
         first_name TYPE string,
         last_name  TYPE string,
         birthdate  TYPE d.
TYPES END OF ty_person_chain.


TYPES ty_persons TYPE STANDARD TABLE OF ty_person_chain
    WITH NON-UNIQUE KEY first_name last_name. " Standard Table cannot be unique

TYPES ty_persons_sorted TYPE SORTED TABLE OF ty_person_chain
    WITH UNIQUE KEY first_name last_name.




DATA(g_yannik) = VALUE ty_person_chain( first_name = 'Yannik' ).
g_yannik = VALUE #( last_name = 'Hahn' birthdate = '20030810' ).
g_yannik = VALUE #( BASE g_yannik first_name = 'Yannik' ).


DATA g_persons TYPE ty_persons.

g_persons = VALUE #( ( g_yannik ) ( g_yannik ) ( g_yannik ) ).


LOOP AT g_persons REFERENCE INTO DATA(g_person_ref).

  g_person_ref->first_name = 'Tessa'.

ENDLOOP.

TRY.
    cl_s4d_output=>display_structure( g_persons ).
  CATCH cx_s4d_no_structure INTO DATA(g_test).
    WRITE / |No structure error: { g_test->get_text(  ) }|.
ENDTRY.

cl_s4d_output=>display_table( g_persons ).

WRITE g_text.
