-- 강다영 SQL Test

-- 1. Student 테이블을 참조해서 아래 화면과 같이 
-- 1 전공이(deptno1 컬럼) 201번인 학생의 이름과 전화번호와 지역번호를 출력하세요. 
-- (단 지역번호는 숫자만 나와야 합니다. )
SELECT NAME, tel , SUBSTR(tel, 1, INSTR(tel, ')') -1) AS "AREA CODE" 
FROM student WHERE deptno1 = 201;

-- 2.	Student 테이블에서 아래 그림과 같이 1 전공이 102 번인 학생들의 이름과 전화번호, 전화번호에서 
-- 국번 부분만 ‘*’ 처리하여 출력하세요. (단 모든 국번은 3자리로 간주합니다.)
SELECT NAME, tel, INSERT(tel, INSTR(tel, ')')+1, (INSTR(tel,'-')-1) - (INSTR(tel, ')')), '***') AS 'REPLACE'
FROM student 
WHERE deptno1 = 102;

#SELECT SUBSTR(tel, INSTR(tel, ')')+1, (INSTR(tel,'-')-1) - (INSTR(tel, ')'))) AS tel2 FROM student;


-- 3. Student 테이블의 birthday 컬럼을 사용하여 
-- 생일이 1월인 학생의 학번,이름, birthday 를 아래 화면과 같이 출력하세요.
SELECT studno, NAME, date_format(birthday, '%y/%m/%d') AS birthday 
FROM student WHERE MONTH(birthday) = 01;

-- 4. emp 테이블을 조회하여 comm 값을 가지고 있는 사람들의 
-- empno , ename , hiredate , 총연봉, 15% 인상 후 연봉을 아래 화면처럼 출력하세요. 
-- 단 총연봉은 (sal*12)+comm 으로 계산하고 아래 화면에서는 SAL 로 출력되었으며 
-- 15% 인상한 값은 총연봉의 15% 인상 값입니다. 
-- (HIREDATE 컬럼의 날짜 형식과 SAL 컬럼 , 15% UP 컬럼의 $ 표시와 , 기호 나오게 하세요)  
SELECT empno, ename, date_format(hiredate, '%y/%m/%d') AS "hiredate",
(sal*12)+IFNULL(comm,0) AS "sal",
LPAD(FORMAT((((sal*12)+IFNULL(comm,0)) * 1.15),0), 7, "$") AS "15% UP"
FROM emp;

#SELECT FORMAT((((sal*12)+IFNULL(comm,0)) * 1.15),0) AS "15% UP" FROM emp;


-- 5. Professor 테이블에서 201번 학과 교수들의 
-- 이름과 급여, bonus , 총 연봉을 아래와 같이 출력하세요. 
-- 단 총 연봉은 (pay*12+bonus) 로 계산하고 bonus 가 없는 교수는 0으로 계산하세요.
SELECT profno, NAME, pay, ifnull(bonus,0) AS "bonus", (pay*12+ifnull(bonus,0)) as total 
FROM professor WHERE deptno=201;


-- 6. Student 테이블을 사용하여 제 1 전공 (deptno1) 이 101 번인 학과 학생들의 
-- 이름과 주민번호, 성별을 출력하되 성별은 주민번호(jumin) 컬럼을 이용하여 7번째 숫자가 1일 경우 
-- “MAN” , 2일 경우 “WOMAN” 로 출력하세요.
SELECT NAME, jumin, if(SUBSTR(jumin,7,1) = 1 , 'Man', 'Woman') AS Gender
FROM student WHERE deptno1 = 101;

#SELECT SUBSTR(jumin,7,1) FROM student WHERE deptno1 = 101;

-- 7. emp 테이블을 사용하여 사원 중에서 급여(sal)와 보너스(comm)를 합친 금액이 가장 많은 경우와 가장 적은 경우, 평균 금액을 구하세요. 
-- 단 보너스가 없을 경우는 보너스를 0 으로 계산하고 출력 금액은 모두 소수점 첫째 자리까지만 나오게 하세요.
SELECT max(sal + ifnull(comm,0)) AS "MAX", 
		 min(sal + ifnull(comm,0)) AS "MIN", 
		 FORMAT(avg(sal + ifnull(comm,0)),1) AS "AVG"
FROM emp;


-- 8. emp 테이블을 조회하여 사번, 이름, 급여, 부서번호, 부서별 급여순위를 출력하세요. (부서별 급여순위 부분을 잘 보세요)
SELECT empno, ename, sal, deptno, RANK() OVER (Partition by deptno ORDER BY sal DESC) AS 'RANK'
FROM emp ORDER BY deptno, sal desc;

-- 9. panmae 테이블을 사용하여 1000 번 대리점의 판매 내역을 출력하되 판매일자, 제품코드, 판매량, 누적 판매금액을 아래와 같이 출력하세요.
SELECT p_date, p_code, p_qty, p_total, p_store,
		 SUM(p_total) OVER(ORDER BY p_total) "TOTAL"
FROM panmae 
WHERE p_store = 1000 
ORDER BY p_total;

-- 10. emp 테이블을 사용하여 아래와 같이 부서별로 급여 누적 합계가 나오도록 출력하세요. ( 단 부서번호로 오름차순 출력하세요. )
SELECT deptno, ename, sal, SUM(sal) OVER(partition by deptno ORDER BY sal, empno) AS "TOTAL" FROM emp ORDER BY "TOTAL";
		-- sal 이 동일하면 유일한 값인 empno로 순서를 구분해야 한다. 
		
-- 11. 학생 테이블 (student) 과 교수 테이블 (professor) 을 join 하여 학생의 이름과 지도교수 이름을 출력하세요. 
-- (student : name, profno,  professor : name, profno) 
SELECT s.name, p.NAME
FROM student s JOIN professor p
ON s.profno = p.profno;

-- 12. 학생 테이블(student)과 학과 테이블(department) , 교수 테이블(professor)을 Join하여 
-- 학생이름, 학생의 학과 이름, 학생의 지도교수 이름을 출력하세요. (출력 순서 다를 수 있음)
SELECT s.name, d.dname, p.NAME
FROM student s JOIN department d
ON s.deptno1 = d.deptno
JOIN professor p
ON s.profno = p.profno;

-- 13. Student 테이블과 score 테이블 , hakjum 테이블을 조회하여 학생들의 이름과 점수와 학점을 출력하세요
-- (student : studno,name, score : studno,total, hakjum : min_point,max_point)
SELECT s.name, c.total, h.grade
FROM student s JOIN score c
ON s.studno = c.studno
JOIN hakjum h
ON c.total >= h.min_point AND c.total <= h.max_point
ORDER BY c.total desc;


-- 14. Student 테이블과 Professor 테이블을 Join하여 학생 이름과 지도교수 이름을 출력하세요. 
-- (단 지도학생이 결정되지 않은 교수의 명단도 함께 출력하세요.)
SELECT s.name, p.NAME
FROM student s right JOIN professor p
ON s.profno = p.profno;

-- 15. EMP 테이블을 이용하여 사번, 이름, 관리자명을 출력하세요. (emp : empno,ename,mgr)
SELECT e1.empno, e1.ename, e2.ENAME 
FROM emp e1 JOIN emp e2
ON e1.MGR = e2.EMPNO
ORDER BY empno DESC;

-- 16. Student 테이블과 department 테이블을 사용하여 ‘Anthony Hopkins’ 학생과 1전공(deptno1)이 동일한 학생들의 이름과 1전공 이름을 출력하세요.
-- (student : name, deptno1, department : dname, deptno)

#서브쿼리
SELECT deptno1 FROM student WHERE NAME = "Anthony Hopkins";

#
SELECT s.name, d.dname
FROM student s JOIN department d
ON s.deptno1 = d.deptno
WHERE d.deptno = (SELECT deptno1 FROM student WHERE NAME = "Anthony Hopkins");


-- 17. Professor 테이블과 department 테이블을 조회하여 ‘Meg Ryan’ 교수보다 나중에 입사한 사람의 이름과 입사일, 학과명을 출력하세요.
SELECT hiredate FROM professor WHERE NAME = "Meg Ryan";

SELECT p.NAME, date_format(p.hiredate, '%y/%m/%d') AS "hiredate" , d.dname
FROM professor p JOIN department d
ON p.deptno = d.deptno
WHERE p.hiredate > (SELECT hiredate FROM professor WHERE NAME = "Meg Ryan");

-- 18. Student 테이블에서 1전공(deptno1)이 201번인 학과의 평균 몸무게가 많은 학생들의 이름과 몸무게를 출력하세요. (student : name, deptno1, weight)
SELECT AVG(weight) FROM student WHERE deptno1 = 201;

SELECT NAME, weight
FROM student
WHERE weight > (SELECT AVG(weight) FROM student WHERE deptno1 = 201);


-- 19. Student 테이블을 조회하여 전체 학생 중에서 체중이 2학년 학생들의 체중에서 가장 적게 나가는 학생보다 
-- 몸무게가 적은 학생의 이름과 학년과 몸무게를 출력하세요. (student : name, grade, weight)
SELECT MIN(weight) FROM student WHERE grade = 2;

SELECT NAME, grade, weight
FROM student 
WHERE weight < (SELECT MIN(weight) FROM student WHERE grade = 2);

-- 20. Emp2 테이블을 조회하여 직급별로 해당 직급에서 최대 연봉을 받는 직원의 직급, 연봉을을 출력하세요. 연봉 순으로 오름차순 정렬하세요.
-- (emp2 : name,position,pay)
SELECT MAX(pay) , position
FROM emp2 
WHERE POSITION != ''
GROUP BY POSITION;

SELECT NAME, POSITION, CONCAT('$',format(pay,0)) AS "salary"
FROM emp2
WHERE POSITION != '' and pay IN (SELECT MAX(pay) FROM emp2 GROUP BY POSITION)
ORDER BY pay;



