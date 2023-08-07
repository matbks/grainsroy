CLASS zadocl_grains_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zadocl_grains_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS define REDEFINITION.


  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS semantics_navigations.
    METHODS create_semantics_navigations
      IMPORTING
        entity_type     TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        property        TYPE string
        semantic_object TYPE string.

ENDCLASS.



CLASS zadocl_grains_mpc_ext IMPLEMENTATION.


  METHOD define.

    super->define( ).

    me->semantics_navigations( ).

  ENDMETHOD.


  METHOD semantics_navigations.

    SELECT * FROM zadot_grains_004 INTO TABLE @DATA(ddls).

    IF sy-subrc = 0.

      SELECT * FROM zadot_grains_006
        FOR ALL ENTRIES IN @ddls WHERE company_code = @ddls-company_code
                                   AND app_code     = @ddls-app_code
                                   AND id           = @ddls-id INTO TABLE @DATA(semantics_objects).

    ENDIF.

    LOOP AT ddls INTO DATA(ddl).

      LOOP AT semantics_objects INTO DATA(semantic_object) WHERE company_code = ddl-company_code
                                                             AND app_code     = ddl-app_code
                                                             AND id           = ddl-id.

        me->create_semantics_navigations( entity_type     = ddl-ddl_name && 'Type'
                                          property        = CONV string( semantic_object-Property )
                                          semantic_object = CONV string( semantic_object-semantic_object ) ).

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD create_semantics_navigations.

    CONSTANTS: namespace_srv TYPE string VALUE 'ZADOP_GRAINS_SRV'.

    cl_fis_uibb_annotation=>create_semantic_object_anno( io_odata_model     = model
                                                         io_vocan_model     = vocab_anno_model
                                                         iv_entity_type     = entity_type
                                                         iv_property        = property
                                                         iv_semantic_object = semantic_object
                                                         iv_namespace       = namespace_srv ).

  ENDMETHOD.

ENDCLASS.
