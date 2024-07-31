-- ----------------------------------------------------------------------------------------------------------------------------------------
-- DDL(Data Definition Language) : 데이터 정의어 (create, alter, drop, truncate : 초기화, rename)
-- ----------------------------------------------------------------------------------------------------------------------------------------

-- database 생성 
CREATE DATABASE kostatest;

-- database 삭제 
DROP DATABASE kostatest;

-- table 생성
CREATE TABLE person(
	id INT,
	last_name VARCHAR(255),
	first_name VARCHAR(255),
	address VARCHAR(255),
	city VARCHAR(255)
);

-- table 삭제 
DROP TABLE person;

-- table 복제 : create table as
CREATE TABLE emp_sub2 AS 
SELECT empno, ename, job, hiredate, sal FROM emp where deptno = 10;

SELECT * FROM emp_sub2;

-- emp, dept 테이블을 이용하여 emp_dept 테이블 생성
-- 컬럼 : emp의 모든 컬럼, 부서명
CREATE table emp_dept AS
SELECT e.*, d.DNAME FROM emp e JOIN dept d 
ON e.DEPTNO = d.DEPTNO;    -- = using(deptno)

SELECT * FROM emp_dept;

-- 데이터를 제외하고 테이블의 틀만 복사해서 새로운 테이블 생성
CREATE TABLE emp_cpy AS 
SELECT * FROM emp WHERE 1=2; -- 거짓조건으로 만들어 준다. 

SELECT * FROM emp_cpy;

-- truncate : 테이블 비우기 
TRUNCATE TABLE emp_sub2;

DROP TABLE USEr;
CREATE TABLE user (
	id INT AUTO_INCREMENT PRIMARY KEY,
	NAME VARCHAR(20));
	
INSERT INTO user(NAME) VALUES('홍길동');
INSERT INTO user(NAME) VALUES('김길동');
INSERT INTO user(NAME) VALUES('송길동');
INSERT INTO user(NAME) VALUES('허길동');

DELETE FROM user;

TRUNCATE TABLE user;   -- 테이블을 다시 만드는 개념. AUTO_increment key까지 다 날라감.

SELECT * FROM user;

-- -----------------------------------------------------------------------------------
-- alter table : 테이블의 구조 변경
-- -----------------------------------------------------------------------------------
-- add column : 테이블 컬럼 추가  (이미 데이터가 들어있는 테이블은 컬럼을 추가 할 수 있다)
ALTER TABLE person 
ADD COLUMN email VARCHAR(255);

-- drop column : 테이블의 컬럼 삭제 
ALTER TABLE person DROP COLUMN email;

-- modify colum : 컬럼 변경
ALTER TABLE person MODIFY COLUMN address VARCHAR(300);

-- rename column : 컬럼 이름 변경 
ALTER TABLE person 
RENAME column city TO AREA;

CREATE TABLE dept_t AS SELECT * FROM dept;

-- 컬럼 추가 & 기본값 설정 
ALTER TABLE dept_t ADD COLUMN LOC2 VARCHAR(255) DEFAULT 'seoul';

-- LOC2 를 area로 변경 
ALTER TABLE dept_t RENAME COLUMN LOC2 TO AREA;

-- table rename
RENAME TABLE dept_t TO dept_temp;

