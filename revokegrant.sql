-- ----------------------------------------------------------------------------
-- 계정관리 : root만 가능 
-- ----------------------------------------------------------------------------
CREATE user kosta IDENTIFIED BY '7564';  -- localhost는 db가 깔려있는 컴퓨터에서만 접속이 가능하다는 뜻
CREATE user 'test'@'%' IDENTIFIED BY '7564';  -- test 이름의 계정은 어떤 pc에서도 db서버에 접속 가능
-- 계정생성 (username: test , % : 모든 IP에서 접근 가능)
ALTER user test IDENTIFIED BY '1234';

-- test 계정에 testdb24 select, insert, update 권한 부여 
GRANT SELECT,INSERT,UPDATE ON testdb24.* TO 'test';

-- test 계정에 testdb24의 모든 권한 부여
GRANT ALL PRIVILEGES ON testdb24.`*` TO 'test';

-- test 계정에 모든 데이터베이스의 모든 권한 부여
GRANT ALL PRIVILEGES ON *.* TO 'test';   -- root의 권한과 같다

-- 부여된 권한 확인
SHOW GRANTS FOR 'test';
-- Grankt Usage on *.* To 'test' : Usage 권한 지정자는 권한 없음을 나타냄
-- 권한은 없지만 계정은 있음을 의미 

-- test 계정에서 update 권한 제거 
REVOKE UPDATE ON testdb24.* FROM 'test';

-- test 계정에서 모든 권한 제거 
REVOKE ALL PRIVILEGES ON testdb24.* FROM 'test';
REVOKE ALL PRIVILEGES ON *.* FROM 'test';

CREATE user 'kosta'@'%' IDENTIFIED BY '7564'; -- 계정생성 

-- ----------------------------------------------------------------------------
-- test 계정에서 확인 - 
-- ----------------------------------------------------------------------------
SELECT * FROM emp; -- success
DELETE FROM dept WHERE id = 40; -- error : delte권한 없기 때문 
INSERT INTO dept VALUES (50, 'sales', 'seoul'); -- success

DROP user test;
DROP user kosta;

