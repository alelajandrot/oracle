--MI CASO DE ESTUDIO NUNMERO 6
CREATE OR REPLACE PROCEDURE actualizar_salarios(
    p_departamento_id NUMBER,
    p_porcentaje_incremento NUMBER
)
IS
    rango salgrade.grade%TYPE; -- DeclarO la variable rango del mismo tipo que la columna grade en la tabla salgrade
BEGIN
    SELECT grade INTO rango
    FROM salgrade
    WHERE rownum = 1;

    UPDATE EMP
    SET SAL = 
        CASE 
            WHEN rango != 2 THEN SAL * (1 + (p_porcentaje_incremento / 100))
            ELSE SAL
        END
    WHERE DEPTNO = p_departamento_id;
END actualizar_salarios;
/
BEGIN
    actualizar_salarios(10, 5); 
END;
