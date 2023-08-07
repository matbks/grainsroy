CLASS zadocl_grains_utilities DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_msg
      IMPORTING
                type          TYPE bapi_mtype
                id            TYPE syst_msgid
                number        TYPE syst_msgno
                var1          TYPE syst_msgv OPTIONAL
                var2          TYPE syst_msgv OPTIONAL
                var3          TYPE syst_msgv OPTIONAL
                var4          TYPE syst_msgv OPTIONAL
      RETURNING VALUE(return) TYPE bapiret2.


    CLASS-METHODS get_timestamp
      RETURNING VALUE(return) TYPE tzntstmps.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zadocl_grains_utilities IMPLEMENTATION.

  METHOD get_msg.

    CALL FUNCTION 'BALW_BAPIRETURN_GET2'
      EXPORTING
        type   = type
        cl     = id
        number = number
        par1   = var1
        par2   = var2
        par3   = var3
        par4   = var4
      IMPORTING
        return = return.

  ENDMETHOD.


  METHOD get_timestamp.

    GET TIME STAMP FIELD return.

  ENDMETHOD.

ENDCLASS.
