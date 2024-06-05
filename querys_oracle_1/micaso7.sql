--mi respuesta al caso 07


CREATE OR REPLACE PACKAGE servicio_salario AS
    PROCEDURE obtener_salario_actual(
        codigo_empleado NUMBER,
        nombre_empleado VARCHAR2,
        salario OUT NUMBER
    );
END servicio_salario;
/

CREATE OR REPLACE PACKAGE BODY servicio_salario AS
    PROCEDURE obtener_salario_actual(
        codigo_empleado NUMBER,
        nombre_empleado VARCHAR2,
        salario OUT NUMBER
    )
    IS
    BEGIN
        IF codigo_empleado IS NOT NULL THEN
            SELECT SAL INTO salario
            FROM EMP
            WHERE EMPNO = codigo_empleado;
        ELSIF nombre_empleado IS NOT NULL THEN
            SELECT SAL INTO salario
            FROM EMP
            WHERE ENAME = nombre_empleado;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            salario := NULL; 
    END obtener_salario_actual;
END servicio_salario;
/

DECLARE
    codigo_empleado1 NUMBER := 7369;
    nombre_empleado1 VARCHAR2(100) := 'jaimito';
    salario1 NUMBER;
BEGIN
    servicio_salario.obtener_salario_actual(codigo_empleado1, nombre_empleado1, salario1); 
    IF salario1 IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('El salario actual es: ' || salario1); 
    ELSE
        DBMS_OUTPUT.PUT_LINE('Empleado no encontrado');
    END IF;
END;
/
