--mi caso 3
-- Crear la función para actualizar el nombre
CREATE OR REPLACE FUNCTION actualizar_nombre_emp(p_empno IN NUMBER, p_nuevo_nombre IN VARCHAR2) RETURN VARCHAR2 IS
  v_query VARCHAR2(200);
BEGIN
  v_query := 'UPDATE emp SET ename = :1 WHERE empno = :2';
  EXECUTE IMMEDIATE v_query USING p_nuevo_nombre, p_empno;
  RETURN 'Nombre actualizado correctamente';
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'Error al actualizar el nombre: ' || SQLERRM;
END;
/

-- Llamar a la función desde un bloque anónimo PL/SQL
DECLARE
  v_resultado VARCHAR2(200);
BEGIN
  v_resultado := actualizar_nombre_emp(7369, 'jaimito');
  DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/
SELECT * FROM EMP;