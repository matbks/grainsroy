CLASS zadocl_grains_royalties_monsan DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor.

    METHODS read_credit
      IMPORTING request       TYPE zados_royalties_request
      RETURNING VALUE(return) TYPE xstring.

    METHODS update_credit.


  PRIVATE SECTION.

    METHODS: convert_req_type.

    METHODS: log_data.

    METHODS: start_comm.

    METHODS: end_comm.

    DATA: read_credit_destination  TYPE c,
          update_credit_destnation TYPE c,
          client                   TYPE REF TO if_http_client,
          error                    TYPE string,
          request_structure        TYPE zados_royalties_request,
          request_data             TYPE string.


ENDCLASS.



CLASS ZADOCL_GRAINS_ROYALTIES_MONSAN IMPLEMENTATION.


  METHOD constructor.

    me->start_comm( ).
    CHECK me->client IS NOT INITIAL.

  ENDMETHOD.


  METHOD convert_req_type.

    me->request_data = /ui2/cl_json=>serialize(  data             = me->request_structure
                                                 compress         = abap_true
                                                 assoc_arrays     = abap_true
                                                 assoc_arrays_opt = abap_true
                                                 pretty_name      = /ui2/cl_json=>pretty_mode-camel_case ).

    TRANSLATE  request_data TO UPPER CASE.

    cl_bcs_convert=>string_to_xstring(
      EXPORTING
        iv_string     = me->request_data
      RECEIVING
        ev_xstring    = me->request_data ).


  ENDMETHOD.


  METHOD log_data.

  ENDMETHOD.


  METHOD read_credit.

    me->client->send( ).
    me->client->receive( ).
    return = me->client->response->get_data( ).


  ENDMETHOD.


  METHOD start_comm.

    CHECK me->read_credit_destination IS NOT INITIAL.

    cl_http_client=>create_by_destination(
              EXPORTING
                destination              = me->read_credit_destination
              IMPORTING
                client                   = me->client
              EXCEPTIONS
                argument_not_found       = 1
                destination_not_found    = 2
                destination_no_authority = 3
                plugin_not_active        = 4
                internal_error           = 5
                OTHERS                   = 6 ).

    IF sy-subrc <> 0.

      me->error = 'Falha na comunicação com o serviço de desstino'.

    ELSE.

      me->client->request->set_method( if_http_request=>co_request_method_post ).

    ENDIF.

  ENDMETHOD.


  METHOD update_credit.



  ENDMETHOD.


  METHOD end_comm.

    me->client->close( ).

  ENDMETHOD.
ENDCLASS.
