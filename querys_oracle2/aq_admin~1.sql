------------------------
--
-- Connect as "aq_admin"
--
------------------------

CREATE TYPE orders_message_type AS OBJECT (
order_id NUMBER(15),
Product_code VARCHAR2(10),
Customer_id VARCHAR2(10),
order_details VARCHAR2(4000),
price NUMBER(4,2),
region_code VARCHAR2(100));
/

BEGIN
 DBMS_AQADM.CREATE_QUEUE_TABLE (queue_table =>        'orders_msg_qt',
                                queue_payload_type => 'orders_message_type',
                                multiple_consumers => TRUE);
END;
/

BEGIN
 DBMS_AQADM.CREATE_QUEUE (queue_name =>     'orders_msg_queue',
                          queue_table =>    'orders_msg_qt',
                          queue_type =>     DBMS_AQADM.NORMAL_QUEUE,
                          max_retries =>    0,
                          retry_delay =>    0,
                          retention_time => 1209600,
                          dependency_tracking => FALSE,
                          comment =>        'Test Object Type Queue',
                          auto_commit =>    FALSE);
END;
/

BEGIN
 DBMS_AQADM.START_QUEUE('orders_msg_queue');
END;
/

-- need administrator privileges to add
-- subscriber
BEGIN
  DBMS_AQADM.ADD_SUBSCRIBER(
    Queue_name => 'orders_msg_queue',
    Subscriber => sys.aq$_agent('US_ORDERS', null, null),
    Rule       => 'tab.user_data.region_code = ''EUROPE''');
END;
/

CREATE OR REPLACE FUNCTION fn_Euro_to_Dollars(src IN orders_message_type)
RETURN orders_message_type
AS
  Target orders_message_type;
BEGIN
  Target :=
    aq_admin.orders_message_type(
      src.order_id,
      src.product_code, src.customer_id,
      src.order_details, src.price*.5,
      src.region_code);
  RETURN Target;
END fn_Euro_to_Dollars;
/

BEGIN
  DBMS_TRANSFORM.CREATE_TRANSFORMATION(
    schema =>      'AQ_ADMIN',
    name =>        'EURO_TO_DOLLAR',
    from_schema => 'AQ_ADMIN',
    from_type =>   'ORDERS_MESSAGE_TYPE',
    to_schema =>   'AQ_ADMIN',
    to_type =>     'ORDERS_MESSAGE_TYPE',
    transformation => 'AQ_ADMIN.fn_Euro_to_Dollars(SOURCE.USER_DATA)');
END;
/

BEGIN
  DBMS_AQADM.ADD_SUBSCRIBER(
    Queue_name => 'orders_msg_queue',
    Subscriber => sys.aq$_agent('USA_ORDERS', null, null),
    Rule       => 'tab.user_data.region_code = ''USA''',
    Transformation =>  'EURO_TO_DOLLAR');
END;
/

------------------------
--
-- Connect as "aq_admin"
--
------------------------

--grant EXECUTE on message_type to aq_user
GRANT EXECUTE ON aq_admin.orders_message_type TO aq_user;

BEGIN
 DBMS_AQADM.GRANT_QUEUE_PRIVILEGE(
   privilege => 'ALL',
   queue_name => 'aq_admin.orders_msg_queue',
   grantee => 'aq_user',
   grant_option => FALSE);
END;
/

GRANT EXECUTE ON orders_message_type TO aq_user;
GRANT EXECUTE ON fn_Euro_to_Dollars TO aq_user;

--grant EXECUTE on message_type to aq_user
GRANT EXECUTE ON aq_admin.orders_message_type TO aq_user;

BEGIN
 DBMS_AQADM.GRANT_QUEUE_PRIVILEGE(
   privilege => 'ALL',
   queue_name => 'aq_admin.orders_msg_queue',
   grantee => 'aq_user',
   grant_option => FALSE);
END;
/

GRANT EXECUTE ON orders_message_type TO aq_user;
GRANT EXECUTE ON fn_Euro_to_Dollars TO aq_user;