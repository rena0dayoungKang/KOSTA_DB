-- --------------------------------------------------------------------------
-- constraint : 제약조건 
-- --------------------------------------------------------------------------
-- not null, unique, primary key, forien key, check
-- --------------------------------------------------------------------------

CREATE TABLE temp (
	id INT PRIMARY KEY, -- 동일한 데이터 허용하지 않고, null 값도 허용하지 않음 (unique & not null)
	NAME VARCHAR(30) NOT NULL -- null값을 허용하지 않음 		
);
testdb24
INSERT INTO temp values('1001', 'temp1'); 
#INSERT INTO temp values('1001', 'temp1'); -- id값이 동일한 값이 있기 때문에 에러 
#INSERT INTO temp values('1001', 'temp2'); -- id값이 동일한 값이 있기 때문에 에러 primary key error

#INSERT INTO temp (NAME) VALUES ('temp3'); -- id값이 null 허용안됨
#INSERT INTO temp VALUES (NULL, 'temp3'); -- id값이 null 허용안됨

#INSERT INTO temp (id) VALUES ('1003'); -- name값은 null을 허용안함
#INSERT INTO temp VALUES ('1003', null); -- name값은 null을 허용안함

-- unique
CREATE TABLE temp2 (
	email VARCHAR(60) unique
); 

INSERT INTO temp2 VALUES ('hong@kosta.org');
INSERT INTO temp2 VALUES (NULL); -- null 허용
#INSERT INTO temp2 VALUES ('hong@kosta.org'); -- unique 에러, 중복값 허용하지 않는다

-- check
CREATE TABLE temp3 (
	NAME VARCHAR(20) NOT NULL, 
	age INT DEFAULT 1 CHECK (age > 0)	-- 기본값 1, 값의 범위 제한
);

INSERT INTO temp3 (NAME) VALUES ('hong'); -- age값이 안들어갈때는 1의 기본값을 가진다. + age는 양수
INSERT INTO temp3 (NAME, age) VALUES ('song', 20);
INSERT INTO temp3 (NAME, age) VALUES ('gong', -1);   -- check error : age 범위 벗어남 

-- auto_increment , primary key
DROP TABLE article;
CREATE TABLE article (
	num INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(50) NOT NULL, 
	content VARCHAR(1000), 
	writer VARCHAR(30));
	
INSERT INTO article (title, content) VALUES ('제목1', '내용1');
SELECT * FROM article;

INSERT INTO article (title, content, writer) VALUES ('제목2','내용2','hong');

-- forign key 
DROP TABLE user;
DROP TABLE article;

CREATE TABLE user (
	id VARCHAR(20) PRIMARY KEY, 
	NAME VARCHAR(50) NOT NULL); 
	
	
-- 제약조건 방식 1
CREATE TABLE article (
	num INT AUTO_INCREMENT PRIMARY KEY, 
	title VARCHAR(100) NOT NULL, 
	content VARCHAR(1000), 
	writer VARCHAR(20) REFERENCES user(id) -- user 테이블에 존재하는 id 값만 삽입 가능 
	);
	
INSERT INTO article (title, content, writer) VALUES('제목1', '내용1', 'hong'); -- hong이 user테이블에 존재하지 않기 때문에 error
INSERT INTO article (title, content, writer) VALUES('제목1', '내용1', NULL);  -- success

INSERT INTO user (id, NAME) VALUES ('hong', '홍길동'); -- forign key : null값 허용 
INSERT INTO article (title, content, writer) VALUES('제목1', '내용1', 'hong'); -- success

DELETE FROM user WHERE id = 'hong'; -- user 테이블의 id중 hong을 article테이블에서 참조하고 있기 때문에 삭제 불가 
INSERT INTO user (id, NAME) VALUES ('song', '송길동');
DELETE FROM user WHERE id = 'song'; -- 참조하는게 없으므로 삭제 가능 


-- 제약조건 방식 2
DROP TABLE article;
CREATE TABLE article (
	num INT AUTO_INCREMENT, 
	title VARCHAR(100) NOT NULL,
	content VARCHAR(1000), 
	writer VARCHAR(20), 
	PRIMARY KEY (num),
	FOREIGN KEY(writer) references user(id)
);

-- 제약조건 방식 3
DROP TABLE article;
CREATE TABLE article (
	num INT,
	title VARCHAR(100) NOT NULL,
	content VARCHAR(1000),
	writer VARCHAR(20)
);

ALTER TABLE article ADD PRIMARY KEY(num);  -- primary key 객체 생성 
ALTER TABLE article DROP PRIMARY KEY;  -- primary key 객체 삭제 

ALTER TABLE article ADD CONSTRAINT article_pk PRIMARY KEY(num);
ALTER TABLE article ADD CONSTRAINT article_fk FOREIGN KEY(writer) REFERENCES user(id);

-- ----------------------------------------------------------------------------------------------
-- constraint 외부에서 작성 
-- ----------------------------------------------------------------------------------------------
CREATE TABLE dept3 (
	dcode VARCHAR(6) PRIMARY KEY, 
	dname VARCHAR(30) NOT NULL, 
	pdept VARCHAR(16),
	AREA VARCHAR(26)
);

CREATE TABLE tcons (
	NO INT,					-- primary key
	NAME VARCHAR(20),		-- not null
	jumin VARCHAR(12),	-- not null, unique
	AREA INT, 				-- check 1,2,3,4
	deptno VARCHAR(6)		-- foreign key
);

-- primary key : pk_tcons_no
ALTER TABLE tcons ADD CONSTRAINT pk_tcons_no PRIMARY KEY(NO);
-- not null : name
ALTER TABLE tcons MODIFY COLUMN NAME VARCHAR(20) NOT NULL;
-- not null : jumin
ALTER TABLE tcons MODIFY COLUMN jumin VARCHAR(12) NOT NULL;
-- unique : uk_tcons_jumin
ALTER TABLE tcons ADD CONSTRAINT uk_tcons_jumin UNIQUE KEY(jumin);
-- check
ALTER TABLE tcons ADD CONSTRAINT ck_tcons_area CHECK (AREA IN (1,2,3,4));
-- foreign key 
ALTER TABLE tcons ADD CONSTRAINT fk_tcons_deptno FOREIGN KEY(deptno) REFERENCES dept3(dcode);

-- constraint 삭제 
alter TABLE tcons DROP PRIMARY KEY;
ALTER TABLE tcons DROP FOREIGN KEY fk_tcons_deptno;
ALTER TABLE tcons DROP constraint ck_tcons_area;
ALTER TABLE tcons DROP constraint uk_tcons_jumin;


