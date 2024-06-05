--mi posible solucion al caso 2
CREATE OR REPLACE PROCEDURE liquidar_pagos IS
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
END liquidar_pagos;
/
