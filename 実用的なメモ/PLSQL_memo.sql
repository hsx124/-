set SERVEROUTPUT ON //スクリーン表示をオンに
DECLARE
  v_name VARCHAR2(20) :='testuser';
  v_salary NUMBER(10,2);
  v_address VARCHAR2(200);
  v_empno EMP.EMPNO %type :=20;//あるテーブルのカラムの長さや型
BEGIN
  v_salary:=1000.00;
  select 'Tokyo' into v_address from dual;
  SYS.DBMS_OUTPUT.PUT_LINE('name=' || v_name || ','||'salary=' || v_salary || ','||'address=' || v_address || ',');  
  DBMS_OUTPUT.PUT_LINE(v_empno);
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

set SERVEROUTPUT ON
DECLARE
  v_name VARCHAR2(20);
  v_sal NUMBER;
BEGIN
  select ename,sal into v_name,v_sal from emp where empno='7369';
  DBMS_OUTPUT.put_line(v_name || '----' || v_sal);
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

set SERVEROUTPUT ON
DECLARE
  v_row_data emp%rowtype;//一行のデータを保持
BEGIN
  select * into v_row_data from emp where empno='7369';
  DBMS_OUTPUT.put_line(v_row_data.empno);//変数.カラム名で値を取得
  DBMS_OUTPUT.put_line(v_row_data.ename);
  DBMS_OUTPUT.put_line(v_row_data.job);
  DBMS_OUTPUT.put_line(v_row_data.mgr);
  DBMS_OUTPUT.put_line(v_row_data.sal);
  DBMS_OUTPUT.put_line(v_row_data.comm);
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SET SERVEROUTPUT ON
DECLARE
  v_cnt number;
BEGIN
  SELECT count(1) INTO v_cnt FROM emp;
  if v_cnt > 0 then
    DBMS_OUTPUT.PUT_LINE(v_cnt);
  ELSIF v_cnt > 10 then
    DBMS_OUTPUT.PUT_LINE(v_cnt);
  ELSE
    DBMS_OUTPUT.PUT_LINE(v_cnt);
  end if;
END;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SET SERVEROUTPUT ON
DECLARE
  v_cnt NUMBER:=1;
BEGIN
  LOOP
    EXIT　WHEN v_cnt > 10;//ループ抜ける条件
    DBMS_OUTPUT.PUT_LINE(v_cnt);
    v_cnt:=v_cnt + 1;
  END LOOP;
END;

DECLARE
  v_count NUMBER(5):=0;
BEGIN
  WHILE v_count < 10
  LOOP
    DBMS_OUTPUT.PUT_LINE(v_count);
    v_count:=v_count+1;
  END LOOP;
END;

BEGIN
  FOR i IN 1..100
  LOOP
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;

BEGIN
  FOR i IN REVERSE 1..100 //反転
  LOOP
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;

BEGIN
  FOR i IN 1..100
  LOOP
    IF i = 80 THEN
      GOTO end_loop;
    END IF;
  END LOOP;
  <<end_loop>>
  DBMS_OUTPUT.PUT_LINE('hello world');
END;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

DECLARE
type dept_record
IS
  RECORD
  (
    v_deptno DEPT.DEPTNO%type,
    v_dname DEPT.DNAME%type,
    v_loc DEPT.LOC%type );
  v_dept_record dept_record;
BEGIN
  SELECT * INTO v_dept_record FROM dept WHERE deptno=10;
  DBMS_OUTPUT.put_line('dept='||v_dept_record.v_deptno || ',dname='||v_dept_record.v_dname||',loc='||v_dept_record.v_loc);
END;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
*游标属性
%ROWCOUNT Integer 获得FETCH语句返回的数据行数
%FOUND    Boolean 最近的FETCH返回一和数据为真，否则为假
%NOTFOUND Boolean 与%FOUND相反
%ISOPEN   Boolean 游标已经打开时值为真，否则为假
*/
SET SERVEROUTPUT ON
DECLARE
  CURSOR c_dept
  IS
    SELECT * FROM dept;
  v_row_dept dept%rowtype;
BEGIN
  OPEN c_dept;
  LOOP
    FETCH c_dept INTO v_row_dept;
    EXIT
  WHEN c_dept%notfound;
    DBMS_OUTPUT.PUT_LINE('deptno='|| v_row_dept.deptno || ',dename='|| v_row_dept.dname ||',loc=' || v_row_dept.loc);
  END LOOP;
  CLOSE c_dept;
END;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//游标带参数

SET SERVEROUTPUT ON
DECLARE
  CURSOR c_dept(v_deptno DEPT.DEPTNO%type)
  IS
    SELECT * FROM dept WHERE deptno=v_deptno;
  v_row_dept dept%rowtype;
BEGIN
  OPEN c_dept(10);
  LOOP
    FETCH c_dept INTO v_row_dept;
    EXIT
  WHEN c_dept%notfound;
    DBMS_OUTPUT.PUT_LINE('deptno='|| v_row_dept.deptno || ',dename='|| v_row_dept.dname ||',loc=' || v_row_dept.loc);
  END LOOP;
END;

SET SERVEROUTPUT ON
DECLARE
  CURSOR c_dept(v_deptno DEPT.DEPTNO%type)
  IS
    SELECT * FROM dept WHERE deptno=v_deptno;
BEGIN
  FOR c IN c_dept(10)
  LOOP
    DBMS_OUTPUT.PUT_LINE('deptno='|| c.deptno || ',dename='|| c.dname ||',loc=' || c.loc);
  END LOOP;
END;

SET SERVEROUTPUT ON
DECLARE
  CURSOR c_dept(v_deptno DEPT.DEPTNO%type)
  IS
    SELECT * FROM dept WHERE deptno=v_deptno;
BEGIN
  for c in c_dept(v_deptno=>10) loop
    DBMS_OUTPUT.PUT_LINE('deptno='|| c.deptno || ',dename='|| c.dname ||',loc=' || c.loc);
  END LOOP;
END;

//隐式游标%notfound,%found
SET SERVEROUTPUT ON
DECLARE
  v_dname dept.dname%type:=100;
BEGIN
  UPDATE dept SET dname='sample' WHERE deptno=v_dname;
  IF sql%notfound THEN
    DBMS_OUTPUT.PUT_LINE('data is not found!!');
  END IF;
END;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//存储过程

/*sqlplus运行存储过程
  SQL>exec 存储过程名
*/

CREATE OR REPLACE PROCEDURE P_HELLO AS 
BEGIN
  DBMS_OUTPUT.PUT_LINE('hello world...');
END P_HELLO;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//存储过程带参数(输入参数)

CREATE OR REPLACE PROCEDURE P_DEPT(
    i_deptno IN DEPT.DEPTNO%type)
AS
  v_row_dept dept%rowtype;
BEGIN
  SELECT * INTO v_row_dept FROM dept WHERE DEPTNO=i_deptno;
  DBMS_OUTPUT.PUT_LINE('deptno='|| v_row_dept.deptno || ',dename='|| v_row_dept.dname ||',loc=' || v_row_dept.loc);
END P_DEPT;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//存储过程带参数(输出参数)
CREATE OR REPLACE PROCEDURE P_EMP(
    I_EMPNO IN EMP.EMPNO%TYPE ,
    o_row_data OUT emp%rowtype )
AS
BEGIN
  SELECT * INTO o_row_data FROM emp WHERE empno=I_EMPNO;
END P_EMP;

//调用
DECLARE
  v_empno EMP.EMPNO%type:=7369;
  v_row_data emp%rowtype;
BEGIN
  p_emp(v_empno,v_row_data);
  DBMS_OUTPUT.PUT_LINE('empno='|| v_row_data.empno || ',mgr='|| v_row_data.mgr ||',sal=' || v_row_data.sal);
END;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//EXCEPTION

SET SERVEROUTPUT ON
DECLARE
  v_dname dept.dname%type:=100;
BEGIN
  SELECT dname INTO v_dname FROM dept WHERE deptno = v_dname;
EXCEPTION
WHEN NO_data_found THEN
  DBMS_OUTPUT.PUT_LINE('data not found...');
END;

DECLARE
  v_dname dept.dname%type:=sysdate;
BEGIN
  SELECT dname INTO v_dname FROM dept WHERE deptno = v_dname;
EXCEPTION
WHEN NO_data_found THEN
  DBMS_OUTPUT.PUT_LINE('data not found...');
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('other error...');
END;

DECLARE
  e_sal_high EXCEPTION;
  v_sal emp.sal%type;
BEGIN
  SELECT sal INTO v_sal FROM emp WHERE empno=7369;
  IF v_sal > 100 THEN
    raise e_sal_high;
  END IF;
EXCEPTION
WHEN e_sal_high THEN
  DBMS_OUTPUT.PUT_LINE('too high..');
END;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//存储函数
CREATE OR REPLACE FUNCTION SUMSALARY(
    v_deptno IN EMPLOYEES.DEPARTMENT_ID%TYPE ,
    v_count OUT NUMBER )
  RETURN EMPLOYEES.SALARY%type
AS
  v_sum_sal EMPLOYEES.SALARY%type;
BEGIN
  SELECT SUM(SALARY),
    COUNT(1)
  INTO v_sum_sal,
    v_count
  FROM EMPLOYEES
  GROUP BY DEPARTMENT_ID
  HAVING DEPARTMENT_ID=v_deptno;
  RETURN v_sum_sal;
END SUMSALARY;

//调用
SET SERVEROUTPUT ON
DECLARE
  v_count NUMBER:=0;
  v_sal   NUMBER;
BEGIN
  v_sal:=SUMSALARY(80,v_count);
  DBMS_OUTPUT.PUT_LINE(v_count);
END;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//触发器
CREATE OR REPLACE TRIGGER DEMO001 
	BEFORE
  DELETE ON customer 
BEGIN 
  SYS.DBMS_OUTPUT.PUT_LINE('delete ....');
END;

CREATE OR REPLACE TRIGGER DEMO001 
BEFORE
  DELETE ON customer 
  FOR EACH row 
BEGIN 
  SYS.DBMS_OUTPUT.PUT_LINE('delete ....');
END;

create or replace TRIGGER TRIGGER1 
AFTER
  UPDATE ON customer 
  FOR EACH ROW 
BEGIN 
SYS.DBMS_OUTPUT.PUT_LINE('old'
    || :old.id
    || ','
    || :new.id);
END;









