------------------------
--
-- Connect as "aq_user" but in a new different session
--
------------------------

-----------------------------------
SET SERVEROUTPUT ON
-----------------------------------

DECLARE
  dequeue_options    dbms_aq.dequeue_options_t;
  message_properties dbms_aq.message_properties_t;
  message_handle     RAW(16);
  message            aq_admin.orders_message_type;
BEGIN
  -- defaults for dequeue_options
  -- Dequeue for the Europe_Orders subscriber
  -- Transformation Dollar_to_Euro is
  -- automatically applied
  dequeue_options.consumer_name :='US_ORDERS';
  -- set immediate visibility
  dequeue_options.VISIBILITY    :=  DBMS_AQ.IMMEDIATE;
  dequeue_options.WAIT          :=  15;
  
  DBMS_AQ.DEQUEUE (
    queue_name =>         'aq_admin.orders_msg_queue',
    dequeue_options =>    dequeue_options,
    message_properties => message_properties,
    payload =>            message,
    msgid =>              message_handle);
    
  dbms_output.put_line('+---------------+');
  dbms_output.put_line('| MESSAGE PAYLOAD |');
  dbms_output.put_line('+---------------+');
  dbms_output.put_line('- Order ID := ' ||  message.order_id);
  dbms_output.put_line('- Customer ID:= ' ||  message.customer_id);
  dbms_output.put_line('- Product Code:= ' || message.product_code);
  dbms_output.put_line('- Order Details := ' || message.order_details);
  dbms_output.put_line('- Price in Euros := ' || message.price); 
  dbms_output.put_line('- Region := ' || message.region_code);
  COMMIT;
END;
/