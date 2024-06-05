CREATE OR REPLACE PACKAGE paquete_departamentos AS
    -- Declaración de variable de estado
      estado VARCHAR2(20) := 'No';

    -- Declaración de procedimientos y funciones
    PROCEDURE insertar_departamento(p_deptno NUMBER, p_dnombre VARCHAR2, p_loc VARCHAR2);
    PROCEDURE actualizar_departamento(p_deptno NUMBER, p_dnombre VARCHAR2, p_loc VARCHAR2);
    PROCEDURE eliminar_departamento(p_deptno NUMBER);
    FUNCTION obtener_departamento(p_deptno NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION cambiar_estado(estado_in VARCHAR2) RETURN VARCHAR2;
END paquete_departamentos;
/

CREATE OR REPLACE PACKAGE BODY paquete_departamentos AS
    -- Implementación de la variable de estado


    -- Procedimiento para insertar un departamento
    PROCEDURE insertar_departamento(p_deptno NUMBER, p_dnombre VARCHAR2, p_loc VARCHAR2) IS
    BEGIN
        INSERT INTO dept (deptno, dname, loc) VALUES (p_deptno, p_dnombre, p_loc);
        estado := 'si';
    END insertar_departamento;

    -- Procedimiento para actualizar un departamento
    PROCEDURE actualizar_departamento(p_deptno NUMBER, p_dnombre VARCHAR2, p_loc VARCHAR2) IS
    BEGIN
        UPDATE dept SET dname = p_dnombre, loc = p_loc WHERE deptno = p_deptno;
        estado := 'si';
    END actualizar_departamento;

    -- Procedimiento para eliminar un departamento
    PROCEDURE eliminar_departamento(p_deptno NUMBER) IS
    BEGIN
        DELETE FROM dept WHERE deptno = p_deptno;
        estado := 'si';
    END eliminar_departamento;

    -- Función para obtener un departamento
    FUNCTION obtener_departamento(p_deptno NUMBER) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM dept WHERE deptno = p_deptno;
        RETURN v_cursor;
    END obtener_departamento;

    -- Función para cambiar el estado
    FUNCTION cambiar_estado(estado_in VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        estado := estado_in;
        RETURN 'Estado cambiado a: ' || estado;
    END cambiar_estado;
END paquete_departamentos;
/



CREATE OR REPLACE PACKAGE BODY paquete_departamentos AS

     estado VARCHAR2(20) := 'No';

     FUNCTION cambiar_estado(estado VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        paquete_departamentos.estado := estado;
        RETURN 'Estado cambiado a: ' || estado;
    END cambiar_estado;

    PROCEDURE insertar_departamento(p_deptno NUMBER, p_dnombre VARCHAR2, p_loc VARCHAR2)
    IS
    BEGIN
        INSERT INTO dept (deptno, dname, loc) VALUES (p_deptno, p_dnombre, p_loc);
        cambiar_estado('Si'); -- Cambiar el estado a "Insertado"
    END insertar_departamento;

    PROCEDURE actualizar_departamento(p_deptno NUMBER, p_dnombre VARCHAR2, p_loc VARCHAR2)
    IS
    BEGIN
        UPDATE dept SET dname = p_dnombre, loc = p_loc WHERE deptno = p_deptno;
        cambiar_estado('Si'); -- Cambiar el estado a "Actualizado"
    END actualizar_departamento;

    PROCEDURE eliminar_departamento(p_deptno NUMBER)
    IS
    BEGIN
        DELETE FROM dept WHERE deptno = p_deptno;
        cambiar_estado('Si'); -- Cambiar el estado a "Eliminado"
    END eliminar_departamento;

    FUNCTION obtener_departamento(p_deptno NUMBER) RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM dept WHERE deptno = p_deptno;
        RETURN v_cursor;
    END obtener_departamento;

    -- Implementación de la función cambiar_estado

END paquete_departamentos;
/


CREATE OR REPLACE TRIGGER trg_validar_estado
BEFORE INSERT OR UPDATE OR DELETE ON dept
FOR EACH ROW
BEGIN
    -- Verificar si el estado no es "Ninguna"
    IF paquete_departamentos.estado ='No'  THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede realizar la operación porque el estado es: ' || paquete_departamentos.estado);
    END IF;
END trg_validar_estado;
/


SELECT * FROM dept;

INSERT INTO dept (deptno, dname, loc) VALUES (50, daliang, tulua);

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
