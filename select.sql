-- -------------------------------
-- ** select from : 데이터 조회 
-- -------------------------------
#주석 
-- 주석
#select 컬럼명1, 컬럼명2, ... from 테이블 이름 : 테이블에 있는 데이터 조회할 때 사용
SELECT * FROM emp;  -- 전체 조회 

#emp 테이블에서 ename, job, hiredate 컬럼 조회 
SELECT ename, job, hiredate FROM emp; -- 대소문자 구분 안함

#student 테이블에서 학번, 이름, 학년, 주전공학과번호 조회
SELECT studno, NAME, grade, deptno1 FROM student;
SELECT (studno), (NAME), (grade), (deptno1) FROM student;
-- SELECT (studno, NAME, grade, deptno1) FROM student;  -- /*Operand should contain 1 column(s)*/

#dept테이블의 전체 컬럼 조회
SELECT * FROM dept;
-- select (*) from dept; error -- in your SQL syntax;

#select from where : 행에 대한 조건절 
SELECT * FROM emp WHERE deptno = 10; -- = 은 같다라는 뜻 (변수가 아님)

#사번이 7782인 직원의 사번, 이름, job을 조회 
SELECT empno, ename, job FROM emp WHERE empno = 7782;

#job이 clerk인 직원의 모든 정보 조회
SELECT * FROM emp WHERE job = 'clerk';

#emp 테이블에서 급여가 1000이상인 직원의사번, 이름, 급여 조회 
SELECT empno, ename, sal FROM emp WHERE sal >= 1000;

#student 테이블에서 4학년 학생들의 학번, 이름, 생일, 전화번호, 학년 조회 
SELECT studno, NAME, birthday, tel, grade FROM student WHERE grade = 4;

#student 테이블에서 1,2,4학년 학생들의 모든 컬럼 조회 
SELECT * FROM student WHERE grade = 1 OR grade = 2 OR grade = 4;
SELECT * FROM student WHERE grade != 3;
SELECT * FROM student WHERE not grade = 3;
SELECT * FROM student WHERE grade IN (1,2,4);

#student 테이블에서 2,3학년 학생들의 모든 컬럼 조회 
SELECT * FROM student WHERE grade IN (2,3);
SELECT * FROM student WHERE NOT grade IN (1,4);
SELECT * FROM student WHERE grade = 2 OR grade = 3;
SELECT * FROM student WHERE grade >=2 AND grade <= 3;

#emp 테이블에서 업무(job)가 clerk이거나 salesman인 직원의 사번, 이름, 업무 조회
SELECT empno, ename, job FROM emp WHERE job IN ('clerk','salesman');
SELECT empno, ename, job FROM emp WHERE job = 'clerk' or job = 'salesman';

#student테이블에서 4학년이면서 학과번호가 101인 학생의 학번, 이름, 학년, 학과번호 조회
SELECT studno, NAME, grade, deptno1 FROM student WHERE grade = 4 AND deptno1 = 101;
SELECT studno, NAME, grade, deptno1 FROM student WHERE grade IN (4) AND deptno1 IN (101);
SELECT studno, NAME, grade, deptno1 FROM student WHERE grade LIKE (4) AND deptno1 IN (101);

#student 테이블에서 주전공이나 부전공이 101인 학생의 모든 항목 조회
SELECT * FROM student WHERE deptno1 = 101 OR deptno2 = 101;
SELECT * FROM student WHERE deptno1 like (101) or deptno2 IN (101);

#날짜 형식도 비교 연산자 사용이 가능 
SELECT * FROM emp WHERE hiredate >= '1985-01-01'; -- 최근 날짜가 큰 값

#student 테이블에서 1976년생 학생 조회 
SELECT * FROM student WHERE birthday >= '1976-01-01' AND birthday <= '1976-12-31'; -- 성능은 이 쿼리가 좋다
SELECT * FROM student WHERE birthday BETWEEN '1976-01-01' AND '1976-12-31';

#professor 테이블에서 급여가 500대인 교수의 정보 조회
SELECT * FROM professor WHERE pay >= 500 AND pay <600;
SELECT * FROM professor WHERE pay BETWEEN 500 AND 599;
SELECT * FROM professor WHERE pay LIKE '5%'; 
-- LIKE는 문자열 비교에 사용되므로 INT형 컬럼에서는 성능이 좋지 않거나 사용할 수 없음 
-- 내부적으로 숫자 타입을 문자열로 변환하여 비교를 수행하기 때문 
-- MariaDB의 유연한 타입 변환 기능 때문인데, 성능 면에서는 비효율적일 수 있다. 


#order by : 정렬
SELECT * FROM emp ORDER BY ename; -- 기본 : 오름차순
SELECT * FROM emp ORDER BY hiredate; -- 오름차순
SELECT * FROM emp ORDER BY sal DESC; -- 내림차순

#emp 테이블에서 부서번호가 10인 직원들의 정보를 급여가 높은 순으로 조회 
SELECT * FROM emp WHERE deptno = 10 ORDER BY sal DESC;
SELECT * FROM emp WHERE deptno IN (10) ORDER BY sal DESC;

#professor테이블에서 급여가 500대인 교수의 정보를 급여순으로 조회
SELECT * FROM professor WHERE pay >= 500 AND pay < 600 ORDER BY pay;
SELECT * FROM professor WHERE pay BETWEEN 500 AND 599 ORDER BY pay;

SELECT * FROM emp ORDER BY deptno, ename; -- 앞에 것의로 먼저 정렬, 앞의 것이 같을 때 뒤의같으로 정렬한다
SELECT * FROM emp ORDER BY deptno desc, ename DESC;  -- desc는 각각 적용할 수 있다. 

#student 테이블에서 학년 순으로 정렬, 학년이 같은 경우 키가 큰 순으로 정렬
SELECT * FROM student ORDER BY grade, height desc;

#DISTINCT : 중복 행 제거 
SELECT distinct deptno FROM emp;
SELECT DISTINCT (deptno) FROM emp;
-- SELECT deptno DISTINCT FROM emp;  DISTINCT는 컬럼 뒤에 명시 

#like 연산자 
SELECT * FROM student WHERE NAME LIKE ('김%');
SELECT * FROM student WHERE NAME LIKE '김%'; -- 1글자 이상 가능
SELECT * FROM student WHERE NAME LIKE '허_'; -- _의 갯수만큼의 글자만 가능 

SELECT studno, NAME, jumin, birthday FROM student WHERE jumin LIKE ('%08%');
SELECT studno, NAME, jumin, birthday FROM student WHERE jumin LIKE '__08%';

#professor 테이블에서 email이 naver인 교수조회 
SELECT * FROM professor WHERE email LIKE ('%naver%');
SELECT * FROM professor WHERE email LIKE '%naver%';
SELECT * FROM professor WHERE email LIKE '%naver.com%';

#emp에서 comm이 null인 사람만 조회
-- SELECT * FROM emp WHERE comm = NULL; -- null 은 이퀄이 아니라 is Null로 비교 
SELECT * FROM emp WHERE comm IS NULL;  -- null인 것 비교 : is null
SELECT * FROM emp WHERE comm IS NOT NULL;  -- null이 아닌 것 비교 : is not null

#professor 테이블에서 hpage가 있는 교수 조회 
SELECT * FROM professor WHERE hpage IS NOT NULL;

#emp테이블에서 sal이 1000보다 크고 comm이 1000보다 작거나 없는 직원의 사번, 이름, 급여, 커미션 조회
SELECT empno, ename, sal, comm from emp WHERE sal > 1000 AND (comm <= 1000 or comm IS NULL);
-- SELECT empno, ename, sal, comm from emp WHERE sal > 1000 AND comm <= 1000 or comm IS NULL; AND조건이 더 크기 때문에 괄호!

#emp 테이블에서 모든 직원의 총급여 (12*sal + comm) 을 조회 
SELECT empno, ename, job, sal, comm, (sal + comm) AS '총급여' FROM emp; -- null과 연산을 하면 연산을 해도 null이 된다.
SELECT empno, ename, job, sal, comm, sal + ifnull(comm,0) AS '총급여' FROM emp;  -- ifnull : null이면 0으로 연산해라

#professor 테이블에서 각 교수의 사번, 이름, 급여, 보너스, 총급여 (pay+bounus)조회
SELECT profno, pay, bonus, pay + IFNULL(bonus, 0) AS '총급여' from professor;


