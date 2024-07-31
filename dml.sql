-- SQL
-- DML(Data Manipulation Language) : 데이터 조작어 (select, insert, delete, update) :  C(create: insert) U(update) R(read: select) D(Delete)
-- DDL(Data Definition Language) : 데이터 정의어 (create, alter, drop, truncate : 초기화, rename)
-- DCL(Data control Language) : 데이터 제어어 (grant, revoke)
-- TCL(Transaction control Language) : 트랜젝션 제어어 (commit, rollback)

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- DML
-- ----------------------------------------------------------------------------------------------------------------------------------------
create TABLE USER (
	id VARCHAR(10),
	NAME VARCHAR(20)
);

INSERT INTO user (id, NAME) VALUES('hong', '홍길동');
INSERT INTO user VALUES('song', '송길동'); -- 모든 컬럼을 삽입할 경우 컬럼목록 생략 가능. 단, 컬럼순서대로 입력
INSERT INTO user (NAME, id) VALUES ('박길동', 'park');
INSERT INTO user (id) VALUES ('gong');  -- 일부 컬럼만 삽입시 컬럼목록 생략 불가능.

CREATE TABLE article (
	num INTEGER AUTO_INCREMENT PRIMARY KEY, -- auto_increment 는 자동으로 1씩 증가하면서 입력된다. 중간에 삭제되더라도 
	title VARCHAR(50),
	content VARCHAR(200),
	writer VARCHAR(30)
);

-- article data insert
-- 1. 'title1' 'content1'
INSERT INTO article (title, content) VALUES('title1', 'content1'); 
-- 2. 'title2'
INSERT INTO article(title) VALUES('title2');
-- 3. 'content3'
INSERT INTO article(content) values('content3');
-- 4. 'title4' , 'content4', 'hong'
INSERT INTO article(title, content, writer) VALUES ('title4', 'content4', 'hong');
INSERT INTO article VALUES(NULL, 'title4', 'content4', 'hong');
-- 5. 'title5', 'song'
INSERT INTO article (title, writer) VALUES('title5', 'song');

-- emp
-- 사번 : 9999, 이름: hong , 담당업무 : SALESMAN, 담당매니저 : 7369 , 입사일 : 오늘, 급여 : 1800, 부서번호 :40
SELECT * FROM emp;
INSERT INTO emp VALUES(9999, 'HONG', 'SALESMAN', 7369, CURDATE(), 1800, NULL, 40);

-- insert into select : select의 결과값을 테이블에 삽입
DROP TABLE emp_sub;
CREATE TABLE emp_sub (
	id INT,
	NAME VARCHAR(30)
);

INSERT INTO emp_sub (id, NAME) 
	SELECT empno, eNAME FROM emp WHERE deptno=10;  -- select의 결과값 (여러개일수도) 을 insert
	
-- -------------------------------------------------------------------------------------------------------------
SELECT @@Autocommit;
SET autocommit = 1;  -- 오토커밋을 0으로 해놓으면 내가 커밋해야 실행된다. 

-- -------------------------------------------------------------------------------------------------------------
-- update table_name set column_name1 = value2, cloumn_name2 = value2,... where 조건;
-- -------------------------------------------------------------------------------------------------------------
UPDATE emp SET job='SALESMAN' , mgr=7369 WHERE ename = 'hong';  -- hong의 job과 mgr을 바꾸는 작업
ROLLBACK; -- 오토커밋이 1이면 원상복귀 안됨

-- deptno이 10인 부서만 comm을 급여의 10% 더 준다. 
UPDATE emp SET comm = ifnull(comm,0)+ sal*0.1 WHERE deptno = 10;
ROLLBACK; 

-- SMITH 와 같은 업무를 담당하는 사람들의 급여를 30% 인상
#SELECT job FROM emp WHERE ename = 'smith';
UPDATE emp SET sal = sal * 1.3 WHERE job IN (SELECT job FROM emp WHERE ename = 'smith');
ROLLBACK; 

-- ------------------------------------------------------------------------------------------
-- delete from table_name where 조건;
-- ------------------------------------------------------------------------------------------
-- emp에서 이름이 hong인 데이터 삭제 
DELETE FROM emp WHERE ename = 'hong'; 
-- dept에서 부서번호가 40인 데이터 삭제 

START TRANSACTION;
DELETE FROM emp_sub;
COMMIT;					-- start transaction 이전으로 복구 
ROLLBACK;				-- start transaction 이후 변경 반영

SELECT * FROM emp_sub;