--Caso 01

-- Alternativa 1


INSERT INTO payment
SELECT empno, sysdate, sal, comm
FROM emp;


--Alternativa que propongo utilizando pl
create or replace procedure insertar_dato 
is
begin 
INSERT INTO payment
SELECT empno, sysdate, sal, comm
FROM emp;

COMMIT;

END insertar_dato;
/
BEGIN
  insertar_dato;
END;

SELECT * FROM payment;


-- Alternativa 2 de solucion 
/*
DECLARE
  CURSOR cu_emp
  IS
    SELECT *
    FROM   emp;

BEGIN
  FOR recu_emp IN cu_emp LOOP
    INSERT INTO payment
    VALUES (recu_emp.empno, recu_emp.sysdate, recu_emp.sal, recu_emp.comm);
  END LOOP;

EXCEPTION
  WHEN Others THEN
    Dbms_Output.put_line(SQLCODE || ' - ' || SQLERRM);
END;
*/