CLASS zadocl_grains_convert_json DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS convert
      IMPORTING
                json           TYPE string
                structure_name TYPE tabname
                table          TYPE abap_bool OPTIONAL
      RETURNING VALUE(return)  TYPE REF TO data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zadocl_grains_convert_json IMPLEMENTATION.

  METHOD convert.
    DATA: function_name  TYPE funcname,
          tablestructure TYPE REF TO cl_abap_structdescr,
          tabletype      TYPE REF TO cl_abap_tabledescr.

    FIELD-SYMBOLS <output_data> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <output_line> TYPE any.

    CHECK json IS NOT INITIAL.

    tablestructure ?= cl_abap_typedescr=>describe_by_name( structure_name  ).
    tabletype = cl_abap_tabledescr=>create( p_line_type = tablestructure ).

    IF table = abap_true.

      CREATE DATA return TYPE HANDLE tabletype.

      ASSIGN return->* TO <output_data>.

      CLEAR <output_data>.

      cl_fdt_json=>json_to_data(
        EXPORTING
          iv_json = json
        CHANGING
          ca_data = <output_data> ).

    ELSE.

      CREATE DATA return TYPE HANDLE tablestructure.

      ASSIGN return->* TO <output_line>.
      CLEAR <output_line>.

      cl_fdt_json=>json_to_data(
        EXPORTING
          iv_json = json
        CHANGING
          ca_data = <output_line> ).

    ENDIF.


    DATA(components) = tablestructure->get_ddic_field_list( ).


    IF <output_data> IS ASSIGNED AND <output_data> IS NOT INITIAL.

      LOOP AT <output_data> ASSIGNING FIELD-SYMBOL(<line>).

        LOOP AT components INTO DATA(component).

          IF component-datatype = 'TTYP'.
            DATA: new_function_name  TYPE funcname,
                  new_tablestructure TYPE REF TO cl_abap_structdescr,
                  new_tabletype      TYPE REF TO cl_abap_tabledescr,
                  new_data           TYPE REF TO data,
                  new_structure_name TYPE tabname.

            FIELD-SYMBOLS <new_output_data> TYPE STANDARD TABLE.

            SELECT SINGLE * FROM dd40l INTO @DATA(new_structure) WHERE typename = @component-rollname.

            new_structure_name = new_structure-rowtype.

            new_tablestructure ?= cl_abap_typedescr=>describe_by_name( new_structure_name ).
            new_tabletype = cl_abap_tabledescr=>create( p_line_type = new_tablestructure ).

            CREATE DATA new_data TYPE HANDLE new_tabletype.

            ASSIGN new_data->* TO <new_output_data>.

            ASSIGN COMPONENT component-fieldname OF STRUCTURE <line> TO <new_output_data>.

            DATA(new_components) = new_tablestructure->get_ddic_field_list( ).

            IF <new_output_data> IS ASSIGNED AND <new_output_data> IS NOT INITIAL.

              LOOP AT <new_output_data> ASSIGNING FIELD-SYMBOL(<new_line>).

                LOOP AT new_components INTO DATA(new_component).
                  IF new_component-convexit IS INITIAL.
                    CONTINUE.
                  ENDIF.

                  new_function_name = |CONVERSION_EXIT_{ new_component-convexit }_INPUT|.

                  ASSIGN COMPONENT new_component-fieldname OF STRUCTURE <new_line> TO FIELD-SYMBOL(<new_field_value>).

                  IF <new_field_value> IS ASSIGNED.

                    CALL FUNCTION new_function_name
                      EXPORTING
                        input  = <new_field_value>
                      IMPORTING
                        output = <new_field_value>.

                  ENDIF.

                ENDLOOP.

              ENDLOOP.

            ENDIF.

          ENDIF.

          IF component-convexit IS INITIAL.
            CONTINUE.
          ENDIF.

          function_name = |CONVERSION_EXIT_{ component-convexit }_INPUT|.

          ASSIGN COMPONENT component-fieldname OF STRUCTURE <line> TO FIELD-SYMBOL(<field_value>).

          IF <field_value> IS ASSIGNED.

            CALL FUNCTION function_name
              EXPORTING
                input  = <field_value>
              IMPORTING
                output = <field_value>.

          ENDIF.

        ENDLOOP.

      ENDLOOP.

    ENDIF.

    IF <output_line> IS ASSIGNED AND <output_line> IS NOT INITIAL.

      LOOP AT components INTO component WHERE convexit IS NOT INITIAL.

        function_name = |CONVERSION_EXIT_{ component-convexit }_INPUT|.

        ASSIGN COMPONENT component-fieldname OF STRUCTURE <output_line> TO <field_value>.

        IF <field_value> IS ASSIGNED.

          CALL FUNCTION function_name
            EXPORTING
              input  = <field_value>
            IMPORTING
              output = <field_value>.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
