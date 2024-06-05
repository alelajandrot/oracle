--MI POSIBLE RESPUESTA AL CASO 5
--CREO LA TABLA DONDE QUEDRA EL REGISTRO DE LOS DATOS
CREATE TABLE cambios_salario (
  empno NUMBER,
  old_sal NUMBER,
  new_sal NUMBER,
  old_comm NUMBER,
  new_comm NUMBER,
  change_date DATE,
  changed_by VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER cambios_salario
BEFORE UPDATE OF sal, comm ON EMP
FOR EACH ROW -- SE EJECUTARA UNA VEZ POR CADA FILA AFECTADA POR LA SENTENCIA UPDATE:)
DECLARE
BEGIN
  IF :OLD.sal <> :NEW.sal OR :OLD.comm <> :NEW.comm THEN --VERIFICO SI ES DIFERENTE
    INSERT INTO cambios_salario (empno, old_sal, new_sal, old_comm, new_comm, change_date, changed_by)
    VALUES (:OLD.empno, :OLD.sal, :NEW.sal, :OLD.comm, :NEW.comm, SYSDATE, USER);
  END IF;
END;
/
--voy a comprobar si quedo funcional
SELECT * FROM EMP;
UPDATE EMP
SET sal = 900
WHERE empno = 7369;
--VEAMOS SI QUEDO EL REGISTRO
SELECT * FROM cambios_salario;

