-- SUB Query

-- ELECT column1, column2, ...
-- FROM TABLE
-- WHERE 조건 연산자 (SELECT column1, column2,... FROM TABLE WHERE 조건) -- 서브쿼리는 괄호안에 넣어준다

-- = , <> (!=), > , >= , < , <= : 단일행 연산자
#############단일행 서브쿼리 #####################
# emp 테이블에서 CLARK 보다 급여를 많이 받는 사원의 사번, 이름, 급여 조회 
SELECT sal FROM emp WHERE ename = 'CLARK'; -- 서브쿼리를 먼저 만드는 것이 편함 

#14+14
SELECT empno, ename, sal   -- 서브쿼리가 효율성 성능이 더 좋은 편이다. 
FROM emp
WHERE sal > (SELECT sal FROM emp WHERE ename = 'CLARK')
ORDER BY 3;

# join으로 위의 문제 풀기 
# 14*14
SELECT e1.empno, e1.ename, e1.sal 
FROM emp e1 JOIN emp e2
ON e1.SAL > e2.SAL
WHERE e2.ename = 'CLARK'
ORDER BY 3;

# emp 테이블에서 WARD보다 커미션이 적은 사원의 이름과 커미션 조회
SELECT * FROM emp;
SELECT comm FROM emp WHERE ename = 'WARD';

SELECT ename, comm
FROM emp
WHERE ifnull(comm,0) < IFNULL((SELECT comm FROM emp WHERE ename = 'WARD'),0);   -- null인 사람도 조회

# Student , department 테이블을 이용하여 서진수 학생과 주전공이 동일한 학생들의 이름과 전공명 조회 
SELECT * FROM student;
SELECT * FROM department;

--  서브쿼리
SELECT d.dname
FROM student s JOIN department d
ON s.deptno1 = d.deptno
WHERE s.name = '서진수';

-- 풀쿼리 
SELECT s.name, d.dname
FROM student s JOIN department d
ON s.deptno1 = d.deptno
WHERE s.deptno1 = (
	SELECT d.deptno
	FROM student s JOIN department d
	ON s.deptno1 = d.deptno
	WHERE s.name = '서진수');
	

-- 선생님 답 
SELECT s.name, s.deptno1, d.dname
FROM student s LEFT JOIN department d
ON s.deptno1 = d.deptno
WHERE s.deptno1 = (SELECT deptno1 FROM student WHERE NAME ='서진수');

	
# professor, department 테이블을 이용하여 박원범 교수보다 나중에 입사한 교수의 이름과 입사일, 학과명 조회
SELECT * FROM professor;
SELECT * FROM department;

-- 서브쿼리 
SELECT hiredate 
FROM professor	
WHERE NAME = '박원범';

-- 풀쿼리
SELECT p.NAME, p.hiredate, d.dname
FROM professor p JOIN department d
ON p.deptno = d.deptno
WHERE p.hiredate > (
	SELECT hiredate 
	FROM professor	
	WHERE NAME = '박원범');	 
	

-- 선생님 답
SELECT p.name, p.hiredate, d.dname
FROM professor p LEFT JOIN department d
ON p.deptno = d.deptno
WHERE p.hiredate > (SELECT hiredate FROM professor WHERE NAME = '박원범')
ORDER BY 2; 


# 컴퓨터공학과 학생들의 평균 몸무게 보다 많이 나가는 학생들의 학번, 이름, 학과, 몸무게 조회 
SELECT * FROM student;
SELECT * FROM department;

-- 서브쿼리 
SELECT avg(s.weight)
FROM student s LEFT JOIN department d
ON s.deptno1 = d.deptno
WHERE d.deptno = '101';

-- 풀쿼리 
SELECT ms.studno, ms.name, md.dname, ms.weight
FROM student ms JOIN department md
ON ms.deptno1 = md.deptno
WHERE ms.weight > (
	SELECT avg(s.weight)
	FROM student s JOIN department d
	ON s.deptno1 = d.deptno
	WHERE d.deptno = '101');


-- 선생님 답안
SELECT ms.studno, ms.NAME, md.dname, ms.weight
FROM student ms JOIN department md
ON ms.deptno1 = md.deptno
WHERE weight > (SELECT AVG(s.weight)
					FROM student s JOIN department d
					ON s.deptno1 = d.deptno
					WHERE d.dname = '컴퓨터공학과');
	

# gogak, gift 테이블을 이용하여 노트북 상품을 탈 수 있는 고객의 고객번호, 이름, 포인트 조회 
SELECT * FROM gogak;	
SELECT * FROM gift;	

-- 서브쿼리
SELECT g_start FROM gift WHERE gname = '노트북';

-- 풀쿼리
SELECT g.gno, g.gname, g.`point` 
FROM gogak g
WHERE g.`point` > (SELECT g_start FROM gift WHERE gname = '노트북');  -- 해당 포인트 이상이면 노트북을 살 수 있으니까 
					
					
-- 선생님 답
SELECT g_start FROM gift WHERE gname = '노트북';

SELECT gno, gname, point
FROM gogak 
WHERE POINT > (SELECT g_start FROM gift WHERE gname = '노트북');


# (emp, dept) : NEW YORK 에 근무하는 직원의 목록 
-- 서브쿼리
SELECT deptno
FROM dept
WHERE LOC = 'NEW YORK';

-- 풀쿼리
SELECT *
FROM emp
WHERE deptno = (
		SELECT deptno
		FROM dept
		WHERE LOC = 'NEW YORK'
		);

# (student, professor) : 박원범 교수가 담당하는 학생목록 조회 
-- 서브쿼리
SELECT profno FROM professor WHERE NAME = '박원범';

-- 풀쿼리 
SELECT * 
FROM student
WHERE profno = (
	SELECT profno FROM professor WHERE NAME = '박원범'
	);

# (gogak, gift) : 안광훈 고객이 포인터로 받을 수 있는 상품 목록 조회 
-- 서브쿼리
SELECT point FROM gogak WHERE gname = '안광훈';

-- 풀쿼리
SELECT *
FROM gift
WHERE g_start < (SELECT point FROM gogak WHERE gname = '안광훈');  


# (emp, dept) : sales 부서를 제외한 나머지 부서에 속한 직원의 사번, 이름, 부서명 조회 
-- 서브쿼리
SELECT deptno FROM dept WHERE dname = 'sales';

-- 풀쿼리  
SELECT e.EMPNO, e.ENAME, d.dname
FROM emp e  JOIN dept d
ON e.DEPTNO = d.DEPTNO
WHERE e.DEPTNO != (SELECT deptno FROM dept WHERE dname = 'sales');

-- 선생님 답
SELECT e.EMPNO, e.ENAME, d.dname
FROM emp e  JOIN dept d
ON e.DEPTNO = d.DEPTNO
WHERE e.DEPTNO in (SELECT deptno FROM dept WHERE dname <> 'sales') 
-- WHERE e.DEPTNO <> (SELECT deptno FROM dept WHERE dname = 'sales') 이렇게 써도 된다. 
ORDER BY 2;


# (Student, exam_01, hakjum) : 학점이 B0 미만인 학생의 학번, 이름, 점수 조회 

SELECT * FROM hakjum WHERE min_point < 80;

SELECT e.* 
FROM exam_01 e JOIN (SELECT * FROM hakjum WHERE min_point < 80) h
ON e.total = h.

-- 선생님 답 
SELECT s.studno, s.name, e.total
FROM student s JOIN exam_01 e
ON s.studno = e.studno
WHERE e.total < (SELECT min_point FROM hakjum WHERE grade = 'B0');


# (student, exam_01, hakjum) : 학점이 A0인 학생의 학번, 이름, 점수 조회
SELECT min_point FROM hakjum WHERE grade = 'A0';

SELECT s.studno, s.name, e.total
FROM student s JOIN exam_01 e
ON s.studno = e.studno
WHERE e.total BETWEEN (SELECT min_point FROM hakjum WHERE grade = 'A0') AND (SELECT max_point FROM hakjum WHERE grade = 'A0');

--선생님 답
SELECT s.studno, s.name, e.total
FROM student s JOIN exam_01 e
-- ON s.studno = e.studno
USING (studno)  -- 이렇게 써도 된다. 
WHERE e.total BETWEEN (SELECT min_point FROM hakjum WHERE grade = 'A0') 
					AND (SELECT max_point FROM hakjum WHERE grade = 'A0');
					
-- in, exists, not exists, <any , >any , <all , >all : 다중행 연산자 	
#############다중행 서브쿼리 #####################				
# (emp2, dept2) : 포항 본사에서 근무하는 직원들의 사번, 이름, 직급, 부서명 조회 
SELECT * FROM emp2;
SELECT * FROM dept2;

SELECT dcode FROM dept2 WHERE AREA = '포항본사';

SELECT e.EMPNO, e.NAME, ifnull(e.`POSITION`,0), d.DNAME
FROM emp2 e JOIN dept2 d
ON e.DEPTNO = d.DCODE
WHERE e.DEPTNO IN (SELECT dcode FROM dept2 WHERE AREA = '포항본사');

-- 선생님 답
SELECT e.EMPNO, e.NAME, e.`POSITION`, d.DNAME
FROM emp2 e JOIN dept2 d
ON e.DEPTNO = d.DCODE
WHERE e.DEPTNO IN (SELECT dcode FROM dept2 WHERE AREA = '포항본사');


# (Student , department) : 공과대학 학생들의 학번, 이름, 학년, 주전공 조회 
SELECT deptno FROM department WHERE dname LIKE '%공학%';

SELECT s.studno, s.name, s.grade, d.dname
FROM student s JOIN department d
ON s.deptno1 = d.deptno
WHERE deptno IN (SELECT deptno FROM department WHERE dname LIKE '%공학%')
ORDER BY d.dname, grade DESC;

-- 선생님 답 
-- deptno 의 part로 가지고 있는 것을 조회한다. 공과대학 전체는 10,  ~~공학과는 1010 이런식임
-- 1. 공과대학에 해당하는 학부 조회 
SELECT deptno 
FROM department
WHERE part IN (SELECT deptno FROM department WHERE dname = '공과대학');

-- 2. 공과대학 학부에 해당하는 학과 조회 
SELECT deptno
FROM department
WHERE part IN (SELECT deptno 
					FROM department
					WHERE part IN (SELECT deptno FROM department WHERE dname = '공과대학'));
					
-- 3. 공과대학 학과에 해당하는 학생 조회
SELECT studno, NAME, grade, deptno1
FROM student 
WHERE deptno1 IN (SELECT deptno
						FROM department
						WHERE part IN (SELECT deptno 
											FROM department
											WHERE part IN (SELECT deptno FROM department WHERE dname = '공과대학')));
											

# (emp2) : 과장 직급의 최소연봉자보다 연봉이 높은 직원의 사번, 이름, 연봉, 직급 조회 
SELECT * FROM emp2;

-- 1. 과장 직급의 최소연봉자 구하기 
SELECT min(pay) FROM emp2 WHERE POSITION = '과장';

-- 2. 과장 직급의 최소연봉자보다 연봉이 높은 직원 조회 
SELECT empno, NAME, pay, position
FROM emp2
WHERE pay > (SELECT min(pay) FROM emp2 WHERE POSITION = '과장') 
ORDER BY 3 DESC;


-- 선생님 답 
SELECT empno, NAME, pay, POSITION 
FROM emp2
WHERE pay > (SELECT min(pay) FROM emp2 WHERE POSITION = '과장') 
-- >ANY (...EMPNO)  -- 서브쿼리의 결과값이 여러개가 왔을 때 비교 

SELECT empno, NAME, pay, POSITION 
FROM emp2
WHERE pay > ANY (SELECT pay FROM emp2 WHERE POSITION = '과장'); -- pay의 여러 행 중에 어떤것보다도 크면 된다. (ANY)

# (student) : 각 학년별 가장 큰 학생의 이름과 학년, 키 조회
# (a, b) IN ((1,2) , (3,4))
SELECT grade, max(height) FROM student GROUP BY grade;

SELECT NAME, grade, height
FROM student 
WHERE (grade, height) IN (SELECT grade, max(height) FROM student GROUP BY grade); -- 서브쿼리의 결과가 다중행, 다중열인 경우의 비교 

-- 선생님 답
SELECT * 
FROM student 
WHERE (grade, height) IN (SELECT grade, MAX(height)
									FROM student
									GROUP BY grade);
									
# (student) : 2학년 학생들 중 몸무게가 가장 적게 나가는 학생보다 적은 학생의 이름, 학년, 몸무게 조회 
SELECT weight FROM student WHERE grade = 2;

-- min 말고 다중행 쿼리 이용해보기 any
SELECT NAME, grade, weight
FROM student 
WHERE weight < all (SELECT weight FROM student WHERE grade = 2);

# (emp2, dept2) : 본인이 속한 부서의 평균 연봉보다 적게 받는 직원의 이름, 연봉, 부서명 조회 
-- 본인이 속한 부서 : 한명 한명의 부서를 봐야함 (서브쿼리를 매번 다시 구해야 하니까 비효율) : 서브쿼리를 한번 돌려서 메인쿼리를 만드는게 제일 효율적
-- 선생님 답
SELECT me.name, me.PAY, me.DEPTNO, d.DNAME
FROM emp2 me JOIN dept2 d
ON me.DEPTNO = d.DCODE
WHERE me.pay < (SELECT AVG(pay) FROM emp2 WHERE deptno = me.deptno);

SELECT deptno, AVG(pay) FROM emp2 GROUP BY deptno;

# (professor, department) : 각 학과별 입사일이 가장 오래된 교수의 교수번호, 이름, 입사일, 학과명 조회 

-- 선생님 답
SELECT p.profno, p.name, p.hiredate, d.dname
FROM professor p JOIN department d
ON p.deptno = d.deptno
WHERE (p.deptno, p.hiredate) IN (SELECT deptno, MIN(hiredate) FROM professor GROUP BY deptno);


# (student) : 학년별 나이가 가장 많은 학생의 학번, 이름, 학년, 나이 조회
SELECT min(birthday) FROM student GROUP BY grade;

SELECT studno 학번, NAME 이름, grade 학년, YEAR(CURDATE()) - YEAR(birthday) AS 나이
FROM student 
WHERE (grade, birthday) IN (SELECT grade, min(birthday) FROM student GROUP BY grade)
ORDER BY 학년;


# (emp2) : 직급별 최대 연봉을 받는 직원의 이름과 직급, 연봉 조회
SELECT POSITION, max(pay) FROM emp2 GROUP BY POSITION;

SELECT NAME, POSITION, pay
FROM emp2
WHERE (POSITION, pay) IN (SELECT POSITION, max(pay) FROM emp2 GROUP BY POSITION);

-- 선생님 답1
SELECT NAME, POSITION, pay
FROM emp2 
WHERE (POSITION, pay) IN (SELECT POSITION, MAX(pay) FROM emp2 GROUP BY POSITION)
ORDER BY 1;

-- SELECT NAME, POSITION, MAX(pay) FROM emp2 GROUP BY POSITION ORDER BY 1;  -- group by [name추가] 했는데 결과가 다르게 나오는 상황이 발생함...

-- 선생님 답2
SELECT NAME 이름, if(POSITION != '', POSITION, '사원') 직급, pay 급여
FROM emp2 
WHERE (POSITION, pay) IN (SELECT POSITION, MAX(pay) FROM emp2 GROUP BY POSITION)
ORDER BY 3 desc;


# (student, exam_01, department) : 같은학과 같은학년 학생의 평균 점수보다 높은 학생의 학번, 이름, 학과, 학년, 점수 조회
-- 1. 같은 학과 같은 학년별 평균 구하기 
SELECT s.deptno1, s.grade, AVG(e.total) 
FROM student s JOIN exam_01 e
USING(studno)
GROUP BY s.deptno1, s.grade;


-- 생선님 답 
SELECT s.studno, s.name, s.grade, e.total
	FROM student s 
	JOIN exam_01 e USING(studno)
JOIN department d
ON s.deptno1 = d.deptno
WHERE e.total > (SELECT AVG(total) 
						FROM student s2 JOIN exam_01 e2 USING (studno) 
						WHERE s2.grade = s.grade AND s2.deptno1 = s.deptno1);


