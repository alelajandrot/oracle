--mi posible solucion al caso 4
CREATE OR REPLACE PROCEDURE liquidar_pagos1 IS
  rango NUMBER;
BEGIN 

      INSERT INTO payment (empno, paydate, sal, comm)
  SELECT empno,SYSDATE, sal ,comm
  FROM emp;

  COMMIT;
  

  FOR emp_rec IN (SELECT empno, ename, sal , comm FROM emp) LOOP
    SELECT grade INTO rango
    FROM salgrade sg
     WHERE  emp_rec.sal >= sg.losal AND emp_rec.sal <= sg.hisal;
     
    IF rango >= 4 THEN
      INSERT INTO logemp 
      VALUES (SYSDATE, 'Empleado ' || emp_rec.ename || ' con salario en rango ' || rango || ' liquidado por ' || USER);
    END IF;
  END LOOP;
  
  
  DBMS_OUTPUT.PUT_LINE('Proceso de liquidación de pagos completado');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error en el proceso de liquidación de pagos: ' || SQLERRM);
END liquidar_pagos1;
/

EXEC liquidar_pagos;

--PARA COMPROBAR SI SE CREO BIEN EL METODO Y ESTA EN LA BASE DE DATOS
SELECT *
FROM user_procedures
WHERE object_name = 'LIQUIDAR_PAGOS';

