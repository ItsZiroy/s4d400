*&---------------------------------------------------------------------*
*& Report z05_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_class.

CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.

    DATA: name      TYPE string,
          planetype TYPE saplane-planetype.

    TYPES: BEGIN OF ty_attribute,
             attribute TYPE string,
             value     TYPE string,

           END OF ty_attribute.


    TYPES ty_attributes
        TYPE STANDARD TABLE OF ty_attribute
        WITH NON-UNIQUE KEY attribute.

    METHODS:
      constructor
        IMPORTING i_name      TYPE string
                  i_planetype TYPE saplane-planetype
        RAISING
                  cx_s4d400_wrong_plane,

      set_attributes
        IMPORTING i_name      TYPE string
                  i_planetype TYPE saplane-planetype,

      get_attributes
        EXPORTING e_attributes TYPE ty_attributes,

      get_attributes_return
        RETURNING VALUE(e_attributes) TYPE ty_attributes.
    CLASS-METHODS:
      class_constructor,
      get_n_o_airplanes
        EXPORTING e_number TYPE i.

  PRIVATE SECTION.


    CLASS-DATA: g_n_o_airplane TYPE i VALUE 0,
                g_planetypes   TYPE TABLE OF saplane WITH NON-UNIQUE KEY planetype.


ENDCLASS.



CLASS lcl_airplane IMPLEMENTATION.

  METHOD class_constructor.
    SELECT FROM saplane FIELDS * INTO CORRESPONDING FIELDS OF TABLE @g_planetypes.
  ENDMETHOD.

  METHOD constructor.
    IF NOT line_exists( g_planetypes[ planetype = i_planetype ] ).
      RAISE EXCEPTION TYPE cx_s4d400_wrong_plane.
    ENDIF.
    name = i_name.
    planetype = i_planetype.
    g_n_o_airplane = g_n_o_airplane + 1.
  ENDMETHOD.

  METHOD get_attributes.
    e_attributes = VALUE #( ( attribute = 'NAME' value = name )
                             ( attribute = 'PLANETYPE' value = planetype ) ).
  ENDMETHOD.

  METHOD get_attributes_return.
    e_attributes = VALUE #( ( attribute = 'NAME' value = name )
                             ( attribute = 'PLANETYPE' value = planetype ) ).
  ENDMETHOD.

  METHOD get_n_o_airplanes.
    e_number = g_n_o_airplane.
  ENDMETHOD.

  METHOD set_attributes.
    name = i_name.
    planetype = i_planetype.
  ENDMETHOD.

ENDCLASS.
CLASS lcl_cargo_plane DEFINITION INHERITING FROM lcl_airplane.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING i_name      TYPE string
                i_planetype TYPE saplane-planetype
                i_weight    TYPE i
      RAISING   cx_s4d400_wrong_plane.

    METHODS get_attributes REDEFINITION.
    METHODS get_weight RETURNING VALUE(rv_weight) TYPE i.
  PRIVATE SECTION.
    DATA weight TYPE i.
ENDCLASS.

CLASS lcl_cargo_plane IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      EXPORTING
        i_name               = i_name
        i_planetype          = i_planetype
    ).
    weight = i_weight.
  ENDMETHOD.

  METHOD get_attributes.
    e_attributes = VALUE #(
    ( attribute = 'NAME' value = name )
    ( attribute = 'PLANETYPE' value = planetype )
    ( attribute = 'WEIGHT' value = weight  )
    ).
  ENDMETHOD.

  METHOD get_weight.
    rv_weight = weight.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_passenger_plane DEFINITION
INHERITING FROM lcl_airplane.

  PUBLIC SECTION.

    DATA: seats TYPE i.

    METHODS:
      constructor
        IMPORTING i_name      TYPE string
                  i_planetype TYPE saplane-planetype
                  i_seats     TYPE i
        RAISING   cx_s4d400_wrong_plane,
      get_attributes REDEFINITION.

ENDCLASS.

CLASS lcl_passenger_plane IMPLEMENTATION.

  METHOD constructor.

    super->constructor( i_name = i_name i_planetype = i_planetype ).
    seats = i_seats.
  ENDMETHOD.

  METHOD get_attributes.
    super->get_attributes( IMPORTING e_attributes = DATA(l_attributes) ).
    l_attributes = VALUE #( BASE l_attributes ( attribute = 'SEATS' value = seats ) ).
    e_attributes = l_attributes.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_carrier DEFINITION.
  PUBLIC SECTION.

    TYPES: t_planetab TYPE STANDARD TABLE OF REF TO lcl_airplane WITH EMPTY KEY.

    METHODS:
      add_plane
        IMPORTING
          i_airplane TYPE REF TO lcl_airplane,
      get_planes
        RETURNING VALUE(r_planes) TYPE t_planetab,
      get_heighest_cargo_weight
        RETURNING VALUE(r_weight) TYPE i.
    .


  PRIVATE SECTION.
    DATA:
            planes TYPE t_planetab.
ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.

  METHOD add_plane.
    planes = VALUE #( BASE planes ( i_airplane ) ).
  ENDMETHOD.

  METHOD get_planes.
    r_planes = planes.
  ENDMETHOD.

  METHOD get_heighest_cargo_weight.
    DATA l_airplane TYPE REF TO lcl_airplane.
    DATA l_heighest_weight TYPE i.

    LOOP AT planes INTO l_airplane.
      IF l_airplane IS INSTANCE OF lcl_cargo_plane.
        DATA(l_cargo_plane) = CAST lcl_cargo_plane( l_airplane ).
        IF l_heighest_weight < l_cargo_plane->get_weight(  ).
          l_heighest_weight = l_cargo_plane->get_weight(  ).
        ENDIF.
      ENDIF.
    ENDLOOP.

    r_weight = l_heighest_weight.
  ENDMETHOD.

ENDCLASS.


DATA: g_airplane        TYPE REF TO lcl_airplane,
      g_airplanes       TYPE TABLE OF REF TO lcl_airplane,
      g_attributes      TYPE lcl_airplane=>ty_attributes,
      gt_output         TYPE lcl_airplane=>ty_attributes,
      g_carrier         TYPE REF TO lcl_carrier,
      g_cargo_plane     TYPE REF TO lcl_cargo_plane,
      g_passenger_plane TYPE REF TO lcl_passenger_plane.

START-OF-SELECTION.

*  DO 3 TIMES.
*    g_airplane = NEW #( i_name = |TEST-{ sy-index }| i_planetype = '777-30' ).
*
*    g_airplanes = VALUE #( BASE g_airplanes ( g_airplane ) ).
*  ENDDO.
*
*  LOOP AT g_airplanes INTO g_airplane. " Damit refernziert wird
*    g_airplane->get_attributes( IMPORTING e_attributes = g_attributes ).
*    gt_output = CORRESPONDING #( BASE ( gt_output ) g_attributes ).
*  ENDLOOP.
*
*  " ODER
*  CLEAR g_attributes.
*



  g_carrier = NEW #(  ).

  TRY.
      g_airplane = NEW #( i_name = 'Test' i_planetype = '777-300' ).
      g_carrier->add_plane( g_airplane ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

  TRY.
      g_passenger_plane = NEW #( i_name = 'Pessenger Plane' i_planetype = '747-400' i_seats = 300 ).
      g_carrier->add_plane( g_passenger_plane ).
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

  DO  5 TIMES.
    TRY.
        g_cargo_plane = NEW #( i_name = |Cargo Plane { sy-index }| i_planetype = '747-400' i_weight = 100 * sy-index ).
        g_carrier->add_plane( g_cargo_plane ).
      CATCH cx_s4d400_wrong_plane.
    ENDTRY.
  ENDDO.

  g_airplanes = CORRESPONDING #( g_carrier->get_planes(  ) ).

  LOOP AT g_airplanes INTO g_airplane.
    g_attributes = CORRESPONDING #( BASE ( g_attributes ) g_airplane->get_attributes_return(  ) ).
  ENDLOOP.

  cl_s4d_output=>display_line( |{ g_carrier->get_heighest_cargo_weight(  )  }| ).

  cl_s4d_output=>display_table( g_attributes ).
