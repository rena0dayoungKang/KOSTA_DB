-- ----------------------------------------------------------------------------------------
-- 문자열 함수 
-- ----------------------------------------------------------------------------------------
#concat : 문자열을 이을 때 사용하는 함수 
#SIMITH(CLERK) 으로 조회하기 
SELECT CONCAT(ename, '(',job,')') AS "Name And Job" FROM emp; -- 알리아스에 띄어쓰기가 있을때만 큰따옴표
SELECT ename 이름, hiredate AS "입     사     일" FROM emp;  -- 알리아스에 띄어쓰기를 안쓰는게 좋다.

#Smith's sal is $800으로 출력
SELECT CONCAT(ename, '''s sal is $', sal) from emp;

#format : #,###,###.##(숫자형 데이터의 포맷 지정하여 문자열로 변경)
SELECT FORMAT(250500.1254, 2); -- 소숫점 둘째자리까지 반올림하여 표현
SELECT FORMAT(1000,3); -- 소숫점 셋째자리까지 표현
-- SELECT FORMAT(1000);  -- error
SELECT FORMAT(1000,0);

#emp 테이블에서 sal을 3자리당 , 를 넣어서 조회
SELECT empno, ename, FORMAT(sal,0) FROM emp ORDER BY sal;


#insert : 문자열 내의 지정된 위치에 특정 문자 수 만큼 문자열을 변경한다
SELECT INSERT('http://naver.com', 8, 5, 'kosta'); -- 8번째부터 5개의 글자를 지정된 문자열로 변경, 1번부터시작

#student 테이블에서 주민번호 뒤 7자리를 *******로 대체하여 조회(학번, 이름, 주민번호, 학년)
SELECT studno, NAME, insert(jumin, 7, 7, '*******') AS jumin, grade FROM student;

#gogak 테이블의 고객번호, 이름 조회 (단, 이름은 가운데 글자를 *로 대체)
SELECT gno, insert(gname, 2,1, '*') AS gname FROM gogak; 

#instr : 문자열 내에서 특정 문자의 위치를 구한다
SELECT INSTR('http://naver.com', '.'); 

#student 테이블의 전화번호에서 ) 괄호의 위치 구하기
SELECT INSTR(tel, ')') FROM student;

#substr : 문자열 내에서 부분 문자열 추출
SELECT SUBSTR('http://naver.com', 8, 5);  -- (문자열, 시작위치, 길이)
SELECT SUBSTR('http://naver.com', 8);
SELECT SUBSTR('http://naver.com', 1, 4);

#student 테이블의 전화번호에서 지역번호 출력
SELECT SUBSTR(tel,1,INSTR(tel, ')')-1) AS region FROM student;

#student 테이블의 전화번호 국번 출력
SELECT SUBSTR(tel, INSTR(tel, ')') +1, (INSTR(tel, '-' )-1) - (INSTR(tel, ')'))) as 국번 FROM student;

#student 테이블에서 주민번호 상에서 9월생 인 학생의 학번, 이름, 주민번호 조회 
SELECT studno, NAME, jumin FROM student WHERE SUBSTR(jumin, 3, 2) = 09;
SELECT studno, NAME, jumin FROM student WHERE substring(jumin, 3, 2) = 09; -- SUBSTRING으로 해도 결과는 같음

#Length : 문자열의 바이트 수 구하기 (영문 한글자 : 1byte, 한글 한글자 : 3byte)
SELECT LENGTH('stiven'); -- 6byte
SELECT LENGTH('스티븐'); -- 9byte

#professor 테이블에서 email의 바이트 수 
SELECT LENGTH(email) as emailByte FROM professor;

#professor 테이블의 email에서 @ 뒤부터 글자의 길이(byte)를 출력
SELECT email, length(SUBSTR( email, INSTR(email, '@')+1,  length(email) )) as hostLength FROM professor;

SELECT email, 
		SUBSTR(email, INSTR(email, '@') + 1) AS eserver, 
		LENGTH(SUBSTR(email, INSTR(email, '@') + 1)) AS length
FROM professor;

#char_length : 문자열의 글자 수 구하기 
SELECT CHAR_LENGTH('stiven'), CHAR_LENGTH('스티븐');

#professor 테이블에서 email의 이메일 서버를 kosta.com으로 변경하여 조회
SELECT INSERT(email, INSTR(email, '@') + 1, LENGTH(email), 'kosta.com') FROM professor; -- 이렇게 하면 kosta.com뒤에 아이디 길이 만큼의 공백이 생긴다
SELECT INSERT (email, INSTR(email, '@') + 1, LENGTH(SUBSTR(email, INSTR(email,'@')+1)), 'kosta.com') FROM professor;

#SELECT rpad(INSERT(email, INSTR(email, '@') + 1, LENGTH(email), 'kosta.com') , 20, '#') FROM professor; -- 이렇게 하면 kosta.com뒤에 아이디 길이 만큼의 공백이 생긴다
#SELECT rpad(INSERT (email, INSTR(email, '@') + 1, LENGTH(SUBSTR(email, INSTR(email,'@')+1)), 'kosta.com'), 20, '#') FROM professor;

#LOWER(=LCASE) : 데이터를 소문자로 변경하여 조회 
SELECT LOWER('Abc'), LCASE('ABc'), UPPER('Abc'), UCASE('Abc');

#TRIM : 앞 뒤 공백 제거 
SELECT LENGTH('  test  '), LENGTH(TRIM('  test  '));
SELECT LENGTH('  t  e  s  t  '), LENGTH(TRIM('  t  e  s  t  '));  -- 데이터 사이사이의 공백은 제거되지 않음

#LTRIM : 왼쪽 공백 제거 
SELECT LENGTH('  test  '), LENGTH(LTRIM('  test  '));

#RTRIM : 오른쪽 공백 제거 
SELECT LENGTH('  test  '), LENGTH(RTRIM('  test  '));

#LPAD : 왼쪽을 특정 문자로 채워 넣기 
SELECT LPAD(email, 20, '#') FROM professor;
SELECT LPAD(email, 20, '123456789') FROM professor;

#RPAD : 오른쪽을 특정 문자로 채워 넣기 
SELECT RPAD(email, 20, '#') FROM professor;

SELECT ASCII('a');


-- -----------------------------------------------------------------------------------------
-- 날짜 함수 
-- -----------------------------------------------------------------------------------------
#CURDATE, CURRENT_DATE
SELECT CURDATE(), CURRENT_DATE();
-- SELECT CURDATE()+1, CURRENT_DATE()+1;

#ADDDATE, DATE_ADD : 연, 월, 일을 더하거나 뺀다.  -- 1970년 1월1일을 기준으로 한다. 밀리세컨드 단위 (long데이터타입)
SELECT ADDDATE(CURDATE(), INTERVAL-1 YEAR);
SELECT ADDDATE(CURDATE(), INTERVAL-1 month);
SELECT ADDDATE(CURDATE(), INTERVAL-1 DAY);
SELECT ADDDATE(CURDATE(), INTERVAL+1 DAY);
SELECT ADDDATE(CURDATE(), -1);   -- 연월일을 명시적으로 지정하지 않으면 기본값은 day이다. 

SELECT ADDDATE(ADDDATE(ADDDATE(CURDATE(), INTERVAL-1 YEAR), INTERVAL-1 MONTH), INTERVAL-1 DAY);

#emp 테이블에서 각 직원의 입사일과 10년 기념일을 조회 
SELECT hiredate, ADDDATE(hiredate, INTERVAL + 10 YEAR) AS 10주년 FROM emp;

#CURTIME, CURRENT_TIME
SELECT CURTIME(), CURRENT_TIME();
SELECT CURTIME(), ADDTIME(CURTIME(), '1:10:5');  -- 1시간 10분 5초 더한 것

#NOW() : 현재 날짜 & 시간
SELECT NOW();
SELECT NOW(), ADDTIME(NOW(), '2 1:10:5');  -- 2일, 1시간 10분 5초 더한 것 

#DATEDIFF : 날짜 간격 계산 
#emp테이블에서 각 직원의 입사 일수 조회
SELECT hiredate, DATEDIFF(CURDATE(), hiredate) as 일수 FROM emp;   
SELECT DATEDIFF(CURDATE(), 19700101); 

#student 테이블에서 학생들의 학번, 이름, 생일, 태어난 일수 조회 
SELECT studno, NAME, birthday, DATEDIFF(CURDATE(), birthday) AS 일수 FROM student;

#student 테이블에서 학생들의 학번, 이름, 생일, 나이 조회 
SELECT studno, NAME, birthday, format(DATEDIFF(CURDATE(), birthday)/365, 0) AS age FROM student;

#emp 테이블에서 각 직원의 사번, 이름, 입사일, 연차 조회 
SELECT 
		empno, 
		ename, 
		hiredate, 
		format(DATEDIFF(CURDATE(), hiredate)/365 +1, 0) AS 연차 
FROM emp
ORDER BY 4 desc;

#date_format : 날짜 형식 지정 
SELECT DATE_FORMAT('2024-07-29', '%M %D %Y'); 
SELECT NOW(), DATE_FORMAT(NOW(), '%c %d %y %l : %i : %s %a'); 
-- 월 : %M (February), %b (Feb), %m (02), %c (2)
-- 연 : %Y (2024), %y (24)
-- 일 : %d (05), %c (7), %D (7th)
-- 요일 : %W (Monday), %a (Mon)
-- 시간 : %H (16), %l (4)
-- %r : hh:mm:ss AM,PM
-- 분 : %i;
-- 초 : %s

#DATE_SUB : 날짜 빼기 
SELECT CURDATE(), DATE_SUB(CURDATE(), INTERVAL 10 DAY); -- sub이기 때문에 마이너스 안붙임

#DATE_ADD : 날짜 더하기 
SELECT CURDATE(), DATE_ADD(CURDATE(), INTERVAL 10 DAY);
SELECT CURDATE(), DATE_ADD(CURDATE(), INTERVAL -10 DAY); --빼기와 같은 효과

#DAY, DAYOFMONTH : 날짜에서 일 추출 
SELECT CURDATE(), DAY(CURDATE()), DAYOFMONTH(CURDATE());  

#emp2 테이블에서 생일이 15일인 사람의 사번, 이름, 생일 조회
SELECT empno, NAME, birthday FROM emp2 WHERE DAY(birthday) = '15';
SELECT empno, NAME, birthday FROM emp2 WHERE DAY(birthday) = 15;

#MONTH, YEAR : 날짜에서 월, 연 추출 
SELECT CURDATE(), MONTH(CURDATE()), YEAR(CURDATE());

#student 테이블에서 이번달 생일인 사람의 학번, 이름, 학년, 생일 조회
SELECT studno, NAME, grade, birthday FROM student WHERE MONTH(birthday) = MONTH(CURDATE());

#HOUR, MINUTE, SECOND : 시간에서 시, 분, 초 추출
SELECT NOW(), HOUR(NOW()), MINUTE(NOW()), SECOND(NOW());
SELECT curtime(), HOUR(curtime()), MINUTE(curtime()), SECOND(curtime());

#DAYNAME, DAYOFWEEK(요일을 숫자로 표시 1:일요일) : 날짜에서 요일 추출 
SELECT CURDATE(), DAYNAME(CURDATE()), DAYOFWEEK(CURDATE());

#professor 테이블에서 금요일에 입사한 교수번호, 이름, 입사일 조회 
SELECT profno, NAME, hiredate FROM professor WHERE DAYOFWEEK(hiredate) = 6;

#str_to_date : 문자열을 날짜 타입으로 변환
SELECT DAYNAME(STR_TO_DATE('1987-01-30', '%Y-%m-%d'));
SELECT DAYNAME('1987-01-30');

#EXTRACT 
SELECT CURDATE(), EXTRACT(MONTH FROM CURDATE()) AS MONTH;
SELECT CURDATE(), EXTRACT(YEAR FROM CURDATE()) AS YEAR;
SELECT CURDATE(), EXTRACT(DAY FROM CURDATE()) AS DAY;
SELECT CURDATE(), EXTRACT(WEEK FROM '2024-12-31') AS WEEK; -- 1년 중에 몇번째 주인가
SELECT CURDATE(), EXTRACT(QUARTER FROM CURDATE()) AS QUARTER;  -- 분기 
SELECT CURDATE(), EXTRACT(YEAR_MONTH FROM CURDATE()) AS "YEAR_MONTH"; 
SELECT CURDATE(), EXTRACT(HOUR FROM CURTIME()) AS HOUR; 
SELECT CURDATE(), EXTRACT(minute FROM CURTIME()) AS MINUTE; 
SELECT CURDATE(), EXTRACT(second FROM CURTIME()) AS SECOND; 

#emp 테이블에서 1사분기에 입사한 직원의 사번, 이름, 입사일 조회 
SELECT empno, ename, hiredate FROM emp WHERE EXTRACT(QUARTER FROM hiredate) = 1;

#emp 테이블에서 모든 직원의 사번, 이름, 입사일, 입사분기 조회 
SELECT empno, ename, hiredate, EXTRACT(QUARTER FROM hiredate) AS 입사분기 FROM emp ORDER BY 4;

#TIME_TO_SEC : 시간을 초로 변환 (0시를 기준으로 하는 초단위)
SELECT CURTIME(), TIME_TO_SEC(CURTIME());

#TIMEDIFF
SELECT CURTIME(), TIMEDIFF(CURTIME(), '09:00:00');

-- -----------------------------------------------------------------------------------------
-- 숫자 함수 
-- -----------------------------------------------------------------------------------------
#count(*) , count(empno) : 조건에 만족하는 레코드 (행) 수 
SELECT COUNT(*) FROM emp;
SELECT COUNT(empno) FROM emp;  
SELECT COUNT(comm) FROM emp; -- 컬럼에 해당하는 값이 null이면 count에서 제외된다. 

#student 테이블에서 4학년인 학생의 수 
SELECT COUNT(*) FROM student WHERE grade = 4;
-- SELECT COUNT(grade) FROM student WHERE grade = 4;

#student 테이블에서 부전공을 선택한 학생의 수 
SELECT COUNT(deptno2) FROM student; -- 심플한게 성능이 좋다
SELECT COUNT(*) FROM student WHERE deptno2 IS NOT NULL;

#sum(컬럼명) : 해당 컬럼의 합 
SELECT SUM(sal) FROM emp;
SELECT SUM(comm) FROM emp;
SELECT SUM(sal), SUM(comm), SUM(sal) + SUM(comm) FROM emp; -- null이 있어도 sum함수에서 자동처리해줌

#professor 테이블에서 학과번호가 101인 교수들의 급여와 보너스의 총합 조회
SELECT SUM(pay), SUM(bonus), SUM(pay)+SUM(bonus) from professor WHERE deptno = 101;
SELECT SUM(pay), SUM(bonus), SUM(pay + ifnull(bonus,0)) from professor WHERE deptno = 101; -- 이럴땐 ifnull처리해줘야한다.

#AVG(컬럼명) : 해당 컬럼의 평균
SELECT SUM(sal), COUNT(*), SUM(sal)/COUNT(*) , AVG(Sal) FROM emp;

#emp 테이블에서 comm의 평균 구하기 
SELECT SUM(comm), COUNT(*), SUM(comm)/COUNT(*) , AVG(comm) FROM emp;  -- null이 들어간 데이터는 평균에서 제외되버림
SELECT AVG(ifnull(comm,0)) FROM emp; -- ifnull로 해서 count를 세어주고 평균을 구해야 한다. 

#professor 테이블에서 교수들의 교수번호, 이름, 월급여, 보너스, 연봉 조회 (연봉 : 12 * pay + bonus) 
SELECT profno, NAME, pay, bonus, (12*pay + ifnull(bonus,0)) AS 연봉 FROM professor;

#MAX(컬럼명) : 컬럼에서 가장 큰 값
SELECT MAX(sal) FROM emp;

#MIN(컬럼명) : 컬럼에서 가장 작은 값
SELECT min(sal) FROM emp;

#group by 
SELECT deptno, COUNT(*) FROM emp GROUP BY deptno; -- 부서번호 별로 그룹화 해서 부서별 count를 수행
SELECT deptno, sum(sal), avg(sal) FROM emp GROUP BY deptno;
SELECT deptno, avg(sal) FROM emp GROUP BY deptno;
SELECT deptno, min(sal), MAX(sal) FROM emp GROUP BY deptno;

#student테이블에서 학년별 평균 키 조회 (학년, 평균키)
SELECT grade, AVG(height) as average FROM student GROUP BY grade;
SELECT studno, grade, min(height), max(height) FROM student GROUP BY grade; 
	-- min, max인 사람이 여러명있을 수 있다.
	-- maria DB는 어떻게든 출력해주는데 oracle에서는 에러가 난다. 
	-- group by grade 컬럼으로 했으면, select 문 안에 grade만 있도록 해야 한다. 

SELECT deptno as NO, COUNT(*) FROM emp GROUP BY NO;  -- group by에 alias 기준으로 그룹화 해도 된다.

SELECT deptno, job, COUNT(*), SUM(sal) FROM emp GROUP BY deptno, job;  -- deptno, job이 같은 것을 하나로 그룹화

#having : 그룹핑 한 것에 대한 조건 
#emp 테이블에서 평균 급여가 2000 이상인 부서의 부서번호, 평균급여 조회 
SELECT deptno, AVG(sal) FROM emp GROUP BY deptno HAVING avg(sal) >= 2000;

#student 테이블에서 각 학과와 학년별 평균 몸무게가 50이상인 학생의 학과, 학년 몸무게 조회
SELECT deptno1, grade, avg(weight) FROM student GROUP BY deptno1, grade HAVING AVG(weight) >= 50 ORDER BY grade;

SELECT deptno1, grade, COUNT(*), AVG(ifnull(weight,0))
FROM student
GROUP BY deptno1, grade
HAVING AVG(ifnull(weight,0)) >= 50
ORDER BY deptno1, grade;




