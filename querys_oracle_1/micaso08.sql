--mi posible solucion al caso 8
CREATE OR REPLACE PACKAGE paquete_departamentos AS
    
    PROCEDURE insertar_departamento(p_deptno NUMBER, p_dnombre VARCHAR2, p_loc VARCHAR2);

    PROCEDURE actualizar_departamento(p_deptno NUMBER, p_dnombre VARCHAR2, p_loc VARCHAR2);

    PROCEDURE eliminar_departamento(p_deptno NUMBER);

    FUNCTION obtener_departamento(p_deptno NUMBER) RETURN SYS_REFCURSOR;
    
END paquete_departamentos;
/

CREATE OR REPLACE PACKAGE BODY paquete_departamentos
    AS PROCEDURE insertar_departamento(p_deptno NUMBER, p_dnombre VARCHAR2, p_loc VARCHAR2) 
    IS
    BEGIN
        INSERT INTO dept (deptno, dname, loc) VALUES (p_deptno, p_dnombre, p_loc);
    END insertar_departamento;
    
    
    PROCEDURE actualizar_departamento(p_deptno NUMBER, p_dnombre VARCHAR2, p_loc VARCHAR2) 
    IS
    BEGIN
        UPDATE dept SET dname = p_dnombre, loc = p_loc WHERE deptno = p_deptno;
    END actualizar_departamento;
    
   
    PROCEDURE eliminar_departamento(p_deptno NUMBER) 
    IS
    BEGIN
    
        DELETE FROM dept WHERE deptno = p_deptno;
    END eliminar_departamento;
    
    
    FUNCTION obtener_departamento(p_deptno NUMBER) RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM dept WHERE deptno = p_deptno;
        RETURN v_cursor;
    END obtener_departamento;
END paquete_departamentos;

/

SHOW ERRORS PACKAGE BODY dept_package;

SET SERVEROUTPUT ON; 
--select * from dept;

DECLARE
    v_deptno NUMBER := 40;
    v_dnombre VARCHAR2(100) := 'operations';
    v_loc VARCHAR2(100) := 'tulua';
    v_cursor SYS_REFCURSOR;
    v_deptno_result NUMBER;
    v_dnombre_result VARCHAR2(100);
    v_loc_result VARCHAR2(100);
BEGIN
    -- Insertar departamento
    paquete_departamentos.insertar_departamento(v_deptno, v_dnombre, v_loc);
    DBMS_OUTPUT.PUT_LINE('Nuevo departamento insertado con éxito.');
    
    -- Actualizar departamento
    --v_dnombre := 'jaimito';
    paquete_departamentos.actualizar_departamento(v_deptno, v_dnombre, v_loc);
    DBMS_OUTPUT.PUT_LINE('Información del departamento actualizada con éxito.');

    -- Eliminar departamento
    paquete_departamentos.eliminar_departamento(v_deptno);
    DBMS_OUTPUT.PUT_LINE('Departamento eliminado con éxito.');

    -- Obtener departamento
    
    v_cursor := paquete_departamentos.obtener_departamento(v_deptno);
    DBMS_OUTPUT.PUT_LINE('Información detallada del departamento:');
    LOOP
        FETCH v_cursor INTO v_deptno_result, v_dnombre_result, v_loc_result;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('DeptNo: ' || v_deptno_result || ', DNombre: ' || v_dnombre_result || ', Loc: ' || v_loc_result);
    END LOOP;
    CLOSE v_cursor;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
