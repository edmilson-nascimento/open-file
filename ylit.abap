report ylit .

data:
* file     type pffile value '/usr/sap/trans/cofiles/K909627.D03',
  file     type pffile value '/usr/sap/trans/data/R909727.D03',
  filename type STRING value 'C:\Users\cnsexternosap04\Desktop\K909627.D03'.

*data(tab) =
*  zlit_reci_cl_mail=>get_data( file ) .

*report bcs_example_7.
**********************************************************************
**********************************************************************
**********************************************************************
**********************************************************************

* This report provides an example for sending an Excel
* attachment in Unicode Systems

constants:
  gc_tab  type c value cl_bcs_convert=>gc_tab,
  gc_crlf type c value cl_bcs_convert=>gc_crlf,
  mailto  type ad_smtpadr value 'edmilson.nascimento@litsolutions.com.br'.

*parameters:
*  mailto type ad_smtpadr
*   default 'edmilson.nascimento@litsolutions.com.br'.       "#EC *

data send_request   type ref to cl_bcs.
data document       type ref to cl_document_bcs.
data recipient      type ref to if_recipient_bcs.
data bcs_exception  type ref to cx_bcs.

data main_text      type bcsy_text.
data binary_content type solix_tab.
data size           type so_obj_len.
data sent_to_all    type os_boolean.

start-of-selection.
*  perform create_content.
  perform send.

*&---------------------------------------------------------------------*
*&      Form  send
*&---------------------------------------------------------------------*
form send.

  try.

*     -------- create persistent send request ------------------------
      send_request = cl_bcs=>create_persistent( ).

*     -------- create and set document with attachment ---------------
*     create document object from internal table with text
      append 'Hello world!' to main_text.                   "#EC NOTEXT
      document = cl_document_bcs=>create_document(
        i_type    = 'RAW'
        i_text    = main_text
        i_subject = 'Test Created By BCS_EXAMPLE' ).      "#EC NOTEXT

*     add the spread sheet as attachment to document object
*      document->add_attachment(
*        i_attachment_type    = 'xls'                        "#EC NOTEXT
*        i_attachment_subject = 'ExampleSpreadSheet'         "#EC NOTEXT
*        i_attachment_size    = size
*        i_att_content_hex    = binary_content ).

      perform attachment .

*     add document object to send request
      send_request->set_document( document ).

*     --------- add recipient (e-mail address) -----------------------
*     create recipient object
      recipient = cl_cam_address_bcs=>create_internet_address( mailto ).

*     add recipient object to send request
      send_request->add_recipient( recipient ).

*     ---------- send document ---------------------------------------
      sent_to_all = send_request->send( i_with_error_screen = 'X' ).

      commit work.

      if sent_to_all is initial.
        message i500(sbcoms) with mailto.
      else.
        message s022(so).
      endif.

*   ------------ exception handling ----------------------------------
*   replace this rudimentary exception handling with your own one !!!
    catch cx_bcs into bcs_exception.
      message i865(so) with bcs_exception->error_type.
  endtry.

endform.                    "send


form attachment .

  data:
    path     type char100,
    l_size   type i,
    l_data   type standard table of tbl1024,
    frontend type c,
    subject  type sood-objdes .


  path = file .

  refresh binary_content .

*  call function 'SCMS_UPLOAD'
*    exporting
*      filename = path
*      binary   = 'X'
*      frontend = frontend
*    importing
*      filesize = l_size
*    tables
*      data     = l_data
*    exceptions
*      error    = 1
*      others   = 2.
*  if sy-subrc <> 0.
*    message id sy-msgid type sy-msgty number sy-msgno
*            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
*            raising error_file.
*  else .
*    size = l_size .
*    binary_content = cl_rmps_general_functions=>convert_1024_to_255( l_data ) .
*  endif.

  CALL FUNCTION 'SCMS_CLIENT_TO_R3'
    EXPORTING
      FNAME                         = file
      RFC_DESTINATION               = 'SAPFTPA'
*     VSCAN_PROFILE                 = '/SCMS/KPRO_CREATE'
   IMPORTING
     BLOB_LENGTH                   = l_size
    TABLES
      BLOB                          = binary_content
*   EXCEPTIONS
*     COMMAND_ERROR                 = 1
*     DATA_ERROR                    = 2
*     FILE_OPEN_ERROR               = 3
*     FILE_READ_ERROR               = 4
*     NO_BATCH                      = 5
*     GUI_REFUSE_FILETRANSFER       = 6
*     INVALID_TYPE                  = 7
*     NO_AUTHORITY                  = 8
*     UNKNOWN_ERROR                 = 9
*     OTHERS                        = 10
            .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
else .
  size = l_size .
  ENDIF.

subject = 'ylit_K909727.D03' .


  try .
      document->add_attachment(
*       i_attachment_type    = 'xls'                    "#EC NOTEXT
        i_attachment_type    = 'D03'                        "#EC NOTEXT
        i_attachment_subject = subject
        i_attachment_size    = size
        i_att_content_hex    = binary_content
      ) .

    catch cx_document_bcs .
  endtry .


endform.
