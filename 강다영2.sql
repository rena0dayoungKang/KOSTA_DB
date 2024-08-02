-- 1. 아래 요구사항에 맞는 SQL문을 작성 하시오.
-- 제품이 생산된 공장위치가 "SEOUL"인 제품 중 판매점에 재고가 없는 상품을 출력한다.
-- 조건: 
-- 1) 재고가 없는 조건은 재고 수량이 0이거나 null을 의미한다.
-- 2) null인 경우 0 으로 표시한다.

SELECT p.PDNAME AS '제품카테고리', 
		 p.PDSUBNAME AS '제품명',
		 f.FACNAME AS '공장명',
		 e.STONAME AS '판매점명',
		 ifnull(k.stamount,0) AS '판매점재고수량'
FROM product p JOIN factory f
using(factno)
JOIN stock k
USING(pdno)
JOIN store e
USING(stono)
WHERE f.FACLOC = 'seoul' AND k.stamount = 0 OR k.stamount IS NULL;  -- (정렬...해야하는데..)


-- 2. 제품카테고리가 “TV”인 제품 중 가장 싼 것보다 비싸고
-- 제품카테고리가 “CELLPHONE”인 제품 중 가장 비싼 제품보다 싼 모든 제품을 출력한다.
-- 조건:
-- 1) UNION을 사용하지 않고 하나의 쿼리 문장으로 작성 한다.
-- 2) 제품원가를 기준으로 한다.

SELECT MIN(pdcost) FROM product WHERE pdname = 'tv';
SELECT Max(pdcost) FROM product WHERE pdname = 'cellphone';

SELECT pdsubname, pdcost, pdprice
FROM product
WHERE pdcost > (SELECT MIN(pdcost) FROM product WHERE pdname = 'tv') 
AND pdcost < (SELECT Max(pdcost) FROM product WHERE pdname = 'cellphone')
ORDER BY pdprice DESC;



-- 3. 공장 위치가 ‘CHANGWON’에서 생산된 제품들에 결함이 발견되어 생산된 모든 제품을 폐기 하고자 한다. 
-- 신규 테이블을 만들어 폐기 되는 모든 데이터를 관리하고자 한다.
CREATE TABLE discarded_product (
	pdno INT PRIMARY KEY, 
	pdname VARCHAR(10),
	pdsubname VARCHAR(10),
	factno VARCHAR(5),
	pddate DATE,
	pdcost INT,
	pdprice INT,
	pdamount INT,
	discarde_date DATE,
	FOREIGN KEY(factno) REFERENCES factory(factno)
);

-- 4. PRODUCT 테이블에서 폐기 되는 제품정보들을 모두 조회 하여 DISCARDED_PRODUCT 테이블로 INSERT한다.
-- 단, 트랜잭션 처리를 반드시 한다.
-- 조건:
-- 1) 폐기 날짜는 현재 시스템 날짜로 한다.
START TRANSACTION;

INSERT INTO discarded_product
SELECT p.*, CURDATE()
FROM factory f JOIN product p
ON f.FACTNO = p.FACTNO
WHERE facloc = 'changwon';


ROLLBACK;
COMMIT;

-- 5. [문제 4]에서 폐기된 제품을 PRODUCT 테이블에서 모두 삭제 한다. 단, 트랜잭션 처리를 반드시 한다.
START TRANSACTION;
DELETE FROM product WHERE pdno IN (SELECT pdno FROM discarded_product);

ROLLBACK;
COMMIT;

