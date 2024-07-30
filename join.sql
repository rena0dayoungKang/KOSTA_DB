-- JOIN
CREATE TABLE test1 (
	A VARCHAR(10)
);

CREATE TABLE test2 (
	B VARCHAR(10)
);

INSERT INTO test1 VALUES ('a1');
INSERT INTO test1 VALUES ('a2');

INSERT INTO test2 VALUES ('b1');
INSERT INTO test2 VALUES ('b2');
INSERT INTO test2 VALUES ('b3');

SELECT * FROM test1 JOIN test2 ORDER BY 1,2;  -- 2개행 * 3개행 = 6개행, 모든 행에 대한 카티션곱 
SELECT * FROM test1 JOIN test2 where test1.A='a1' and test2.B='b1'; -- A가 'a1'인것과 B가 'b1'인것만 카티션곱
-- 데이터가 많을 수록 속도가 느려질 수 있다. 
-- join 테이블을 여러 개 할 때, 테이블 의 행의 수가 적은 것들을 먼저 join하는게 유리하다 


-- ANSI join (표준 JOIN) 보통 표준조인을 많이 쓴다 
SELECT e.EMPNO, e.ENAME, d.DNAME
FROM emp AS e JOIN dept AS d
ON e.deptno = d.deptno; 

-- 일반 join
SELECT e.empno, e.ename, d.dname
FROM emp AS e, dept AS d
WHERE e.deptno = d.deptno;

#student, department 테이블을 이용하여 학번, 이름, 학과명 조회
SELECT s.studno, s.name,  d.dname
FROM student AS s JOIN department AS d
ON s.deptno1 = d.deptno;

#student, department 테이블을 이용하여 학번, 이름, 부전공 학과 조회
-- SELECT s.studno, s.name,  d.dname
-- FROM student AS s JOIN department AS d
-- ON ifnull(s.deptno2,0) = ifnull(d.deptno,0);

SELECT s.studno, s.name,  d.dname
FROM student AS s left JOIN department AS d
ON s.deptno2 = d.deptno; 
	-- deptno2가 null 인 사람과 deptno가 맞는 경우는 없음 
	-- left join을 쓰면 s에 있는 값은 null 이라도 다 나오게 하는 것. 

##student, department 테이블을 이용하여 학번, 이름, 학과명, 부전공 학과 조회
SELECT s.studno, s.name, d1.dname, d2.dname
FROM student AS s LEFT JOIN department AS d1	
ON s.deptno1 = d1.deptno
left JOIN department d2 
ON s.deptno2 = d2.deptno;


SELECT s.studno, s.name, d1.dname, d2.dname
FROM student s, department d1, department d2
WHERE s.deptno1 = d1.deptno AND s.deptno2 = d2.deptno;  --부전공이 null인 사람들은 조회가 안된다. 

#student, professor 테이블을 이용하여 학번, 이름, 담당교수명을 조회
SELECT s.studno, s.name, p.name
FROM student AS s LEFT JOIN professor AS p
ON s.profno = p.profno;

SELECT s.studno, s.name, p.name
FROM student AS s JOIN professor AS p  --일반 join하면 담당교수가 없는 학생은 제외된다.
ON s.profno = p.profno;  

#professor, department 테이블을 이용하여 교수번호, 교수명, 소속학과명 조회
SELECT p.profno, p.name, d.dname
FROM professor AS p LEFT JOIN department AS d
ON p.deptno = d.deptno;

# 
SELECT s.studno, s.name, s.deptno2, d.dname
FROM student s RIGHT JOIN department AS d	 -- Right join하면 학과명이 전부 다 나온다. 
ON s.deptno2 = d.deptno;

# UNION
SELECT s.studno, s.name,  s.deptno2, d.dname
FROM student s LEFT OUTER JOIN department d
ON s.deptno2 = d.deptno
UNION
SELECT s.studno, s.name, s.deptno2, d.dname
FROM student s RIGHT OUTER JOIN department d	 
ON s.deptno2 = d.deptno;

#
SELECT s.studno, s.name, d.dname
FROM department d JOIN student s
ON d.deptno = s.deptno2;

#exam_01, student 테이블을 이용하여 학번, 이름, 학년,  점수 조회
SELECT e.studno, s.name, s.grade, e.total
FROM exam_01 e LEFT JOIN student s
ON e.studno = s.studno
ORDER BY 3,4 desc;

#emp 테이블에서 사번, 사원명, 관리자번호, 관리자명 조회 
SELECT e1.empno, e1.ENAME, e1.MGR, e2.ENAME
FROM emp e1 LEFT JOIN emp e2  -- King도 나와야 하기 때문에 left join을 해주어야 한다.
ON e1.MGR = e2.EMPNO;

#student, exam_01, hakjum 테이블을 이용하여, 학번, 이름, 학년, 점수, 학점 조회
SELECT s.studno, s.name, s.grade, e.total, h.grade
FROM exam_01 e LEFT JOIN student s 
ON s.studno = e.studno
LEFT JOIN hakjum h 
ON e.total >= h.min_point AND e.total <= h.max_point   
ORDER BY 3, 4 desc;
	-- e.total BETWEEN h.min_point AND h.max_point 로 바꿔  쓸 수 있다. 
	-- BETWEEN A AND B 구조에서는 항상 작은 것이 A에 와야 한다. 
	
#gogak, gift 테이블을 이용하여 고객이름, 보유 포인트, 포인트로 받을 수 있는 가장 좋은 상품이름 조회
SELECT g.gname, g.`point`, t.gname
FROM gogak g LEFT JOIN gift t
ON g.`point` BETWEEN t.g_start AND t.g_end
ORDER BY 2 DESC;

#emp2, p_grade 테이블을 이용하여 이름, 직위, 급여, 같은 직급의 최소, 최대 급여 조회
SELECT * from emp2;
SELECT * FROM p_grade;

SELECT e.NAME, e.`POSITION`, e.PAY, p.s_pay, p.e_pay
FROM emp2 e LEFT JOIN p_grade p
ON e.`POSITION` = p.`position`
GROUP BY p.`position`;

#emp2, p_grade테이블을 이용하여 본인의 직급에 해당하는 최대 급여보다 많이 받는 직원의 
-- 이름, 직위, 급여, 같은 직급의 최소, 최대 급여 조회 
SELECT e.NAME, e.`POSITION`, e.PAY, p.s_pay, p.e_pay
FROM emp2 e LEFT JOIN p_grade p
ON e.`POSITION` = p.`position`
WHERE e.PAY > p.e_pay
GROUP BY p.`position`;

#emp2, p_grade 테이블을 이용하여 이름, 직급, 나이, 본인의 나이에 해당하는 예상 직급 조회
SELECT e.NAME, e.POSITION, format(DATEDIFF(CURDATE(), e.BIRTHDAY)/365, 0) AS 나이, p.`position`
FROM emp2 e LEFT JOIN p_grade p
ON format(DATEDIFF(CURDATE(), e.BIRTHDAY)/365, 0) BETWEEN p.s_age AND p.e_age   -- on 조건에 수식이 들어 갈 수 있음
ORDER BY 3 DESC;

#emp2, dept2 테이블을 이용하여 서울 지사에 근무하는 직원의 사번, 이름, 부서명 조회
SELECT e.EMPNO, e.NAME, d.DNAME
FROM emp2 e LEFT JOIN dept2 d
ON e.DEPTNO = d.DCODE
WHERE d.AREA = '서울지사';


