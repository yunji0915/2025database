SHOW USER;
SHOW CON_NAME;
--------------------------------------------------------
-- 1. 마스터 테이블
--------------------------------------------------------

CREATE TABLE SKIN_TYPE (
    skin_type_name VARCHAR2(30) PRIMARY KEY,
    description    VARCHAR2(200)
);

CREATE TABLE SKIN_CONCERN (
    concern_name VARCHAR2(30) PRIMARY KEY,
    description  VARCHAR2(200)
);

CREATE TABLE PERSONAL_COLOR (
    color_name  VARCHAR2(30) PRIMARY KEY,
    description VARCHAR2(200)
);

CREATE TABLE BRAND (
    brand_name  VARCHAR2(50) PRIMARY KEY,
    country     VARCHAR2(50),
    description VARCHAR2(200)
);

CREATE TABLE CATEGORY (
    category_code VARCHAR2(20) PRIMARY KEY,
    category_name VARCHAR2(50) NOT NULL
);

--------------------------------------------------------
-- 2. MEMBER
--------------------------------------------------------

CREATE TABLE MEMBER (
    login_id            VARCHAR2(50)  PRIMARY KEY,
    password            VARCHAR2(200) NOT NULL,
    name                VARCHAR2(50)  NOT NULL,
    gender              CHAR(1),
    phone               VARCHAR2(20),
    email               VARCHAR2(100),
    skin_type_name      VARCHAR2(30),
    concern_name        VARCHAR2(30),
    personal_color_name VARCHAR2(30),
    created_at          DATE          DEFAULT SYSDATE NOT NULL,
    status              CHAR(1)       DEFAULT 'A' NOT NULL,
    CONSTRAINT uq_member_email UNIQUE (email),
    CONSTRAINT ck_member_status CHECK (status IN ('A','D')),
    CONSTRAINT fk_member_skin_type
        FOREIGN KEY (skin_type_name)
        REFERENCES SKIN_TYPE (skin_type_name),
    CONSTRAINT fk_member_concern
        FOREIGN KEY (concern_name)
        REFERENCES SKIN_CONCERN (concern_name),
    CONSTRAINT fk_member_personal_color
        FOREIGN KEY (personal_color_name)
        REFERENCES PERSONAL_COLOR (color_name)
);

--------------------------------------------------------
-- 3. PRODUCT
--------------------------------------------------------

CREATE TABLE PRODUCT (
    product_code      VARCHAR2(30)  PRIMARY KEY,
    brand_name        VARCHAR2(50)  NOT NULL,
    category_code     VARCHAR2(20)  NOT NULL,
    product_name      VARCHAR2(100) NOT NULL,
    price             NUMBER(10,2)  NOT NULL,
    stock             NUMBER(10)    DEFAULT 0 NOT NULL,
    description       VARCHAR2(1000),
    image_url         VARCHAR2(200),
    created_at        DATE          DEFAULT SYSDATE NOT NULL,
    is_active         CHAR(1)       DEFAULT 'Y' NOT NULL,
    CONSTRAINT fk_product_brand
        FOREIGN KEY (brand_name)
        REFERENCES BRAND (brand_name),
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_code)
        REFERENCES CATEGORY (category_code),
    CONSTRAINT ck_product_is_active
        CHECK (is_active IN ('Y','N'))
);

--------------------------------------------------------
-- 4. PRODUCT_SKIN_TYPE (상품 - 피부 타입 M:N)
--------------------------------------------------------

CREATE TABLE PRODUCT_SKIN_TYPE (
    product_code   VARCHAR2(30) NOT NULL,
    skin_type_name VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_product_skin_type
        PRIMARY KEY (product_code, skin_type_name),
    CONSTRAINT fk_pst_product
        FOREIGN KEY (product_code)
        REFERENCES PRODUCT (product_code),
    CONSTRAINT fk_pst_skin_type
        FOREIGN KEY (skin_type_name)
        REFERENCES SKIN_TYPE (skin_type_name)
);

--------------------------------------------------------
-- 5. PRODUCT_SKIN_CONCERN (상품 - 피부 고민 M:N)
--------------------------------------------------------

CREATE TABLE PRODUCT_SKIN_CONCERN (
    product_code  VARCHAR2(30) NOT NULL,
    concern_name  VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_product_skin_concern
        PRIMARY KEY (product_code, concern_name),
    CONSTRAINT fk_psc_product
        FOREIGN KEY (product_code)
        REFERENCES PRODUCT (product_code),
    CONSTRAINT fk_psc_concern
        FOREIGN KEY (concern_name)
        REFERENCES SKIN_CONCERN (concern_name)
);

--------------------------------------------------------
-- 6. ORDERS
--------------------------------------------------------

CREATE TABLE ORDERS (
    order_no         VARCHAR2(30)  PRIMARY KEY,
    login_id         VARCHAR2(50)  NOT NULL,
    order_date       DATE          DEFAULT SYSDATE NOT NULL,
    status           VARCHAR2(20)  NOT NULL,
    total_amount     NUMBER(12,2)  NOT NULL,
    payment_method   VARCHAR2(20),
    shipping_address VARCHAR2(200),
    CONSTRAINT fk_orders_member
        FOREIGN KEY (login_id)
        REFERENCES MEMBER (login_id)
);

--------------------------------------------------------
-- 7. ORDER_ITEM
--------------------------------------------------------

CREATE TABLE ORDER_ITEM (
    order_no     VARCHAR2(30) NOT NULL,
    product_code VARCHAR2(30) NOT NULL,
    quantity     NUMBER(10)   NOT NULL,
    unit_price   NUMBER(10,2) NOT NULL,
    subtotal     NUMBER(12,2) NOT NULL,
    CONSTRAINT pk_order_item
        PRIMARY KEY (order_no, product_code),
    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_no)
        REFERENCES ORDERS (order_no),
    CONSTRAINT fk_order_item_product
        FOREIGN KEY (product_code)
        REFERENCES PRODUCT (product_code)
);

--------------------------------------------------------
-- 8. REVIEW
--------------------------------------------------------

CREATE TABLE REVIEW (
    login_id     VARCHAR2(50) NOT NULL,
    product_code VARCHAR2(30) NOT NULL,
    rating       NUMBER(1)    NOT NULL,
    content      VARCHAR2(1000),
    created_at   DATE         DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_review
        PRIMARY KEY (login_id, product_code),
    CONSTRAINT fk_review_member
        FOREIGN KEY (login_id)
        REFERENCES MEMBER (login_id),
    CONSTRAINT fk_review_product
        FOREIGN KEY (product_code)
        REFERENCES PRODUCT (product_code),
    CONSTRAINT ck_review_rating
        CHECK (rating BETWEEN 1 AND 5)
);

--------------------------------------------------------
-- 9. WISHLIST
--------------------------------------------------------

CREATE TABLE WISHLIST (
    login_id     VARCHAR2(50) NOT NULL,
    product_code VARCHAR2(30) NOT NULL,
    created_at   DATE         DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_wishlist
        PRIMARY KEY (login_id, product_code),
    CONSTRAINT fk_wishlist_member
        FOREIGN KEY (login_id)
        REFERENCES MEMBER (login_id),
    CONSTRAINT fk_wishlist_product
        FOREIGN KEY (product_code)
        REFERENCES PRODUCT (product_code)
);

------------------------------------------------------------
-- 1. 마스터 테이블: SKIN_TYPE / SKIN_CONCERN / PERSONAL_COLOR
------------------------------------------------------------

INSERT INTO skin_type (skin_type_name) VALUES ('OILY');
INSERT INTO skin_type (skin_type_name) VALUES ('DRY');
INSERT INTO skin_type (skin_type_name) VALUES ('COMBINATION');
INSERT INTO skin_type (skin_type_name) VALUES ('SENSITIVE');

INSERT INTO skin_concern (concern_name) VALUES ('ACNE');
INSERT INTO skin_concern (concern_name) VALUES ('REDNESS');
INSERT INTO skin_concern (concern_name) VALUES ('WRINKLE');

INSERT INTO personal_color (color_name) VALUES ('Spring Warm');
INSERT INTO personal_color (color_name) VALUES ('Summer Cool');
INSERT INTO personal_color (color_name) VALUES ('Autumn Warm');
INSERT INTO personal_color (color_name) VALUES ('Winter Cool');

------------------------------------------------------------
-- 2. 마스터 테이블: BRAND / CATEGORY
------------------------------------------------------------

INSERT INTO brand (brand_name) VALUES ('GlowUp');
INSERT INTO brand (brand_name) VALUES ('PureSkin');
INSERT INTO brand (brand_name) VALUES ('UrbanFace');

INSERT INTO category (category_code, category_name) VALUES ('CT01', 'Cleanser');
INSERT INTO category (category_code, category_name) VALUES ('CT02', 'Toner');
INSERT INTO category (category_code, category_name) VALUES ('CT03', 'Serum');
INSERT INTO category (category_code, category_name) VALUES ('CT04', 'Cream');
INSERT INTO category (category_code, category_name) VALUES ('CT05', 'Sunscreen');

------------------------------------------------------------
-- 3. MEMBER (회원) - user01, user02, user03 + TEST용 계정
------------------------------------------------------------

INSERT INTO MEMBER (
    login_id, password, name, gender,
    phone, email,
    skin_type_name, concern_name, personal_color_name,
    created_at, status
) VALUES (
    'user01', 'pw01', '김하늘', 'F',
    '010-1111-1111', 'sky01@example.com',
    'OILY', 'ACNE', 'Spring Warm',
    DATE '2025-01-05', 'A'
);

INSERT INTO MEMBER (
    login_id, password, name, gender,
    phone, email,
    skin_type_name, concern_name, personal_color_name,
    created_at, status
) VALUES (
    'user02', 'pw02', '이민수', 'M',
    '010-2222-2222', 'minsu02@example.com',
    'DRY', 'REDNESS', 'Summer Cool',
    DATE '2025-02-10', 'A'
);

INSERT INTO MEMBER (
    login_id, password, name, gender,
    phone, email,
    skin_type_name, concern_name, personal_color_name,
    created_at, status
) VALUES (
    'user03', 'pw03', '박소영', 'F',
    '010-3333-3333', 'soy03@example.com',
    'COMBINATION', 'WRINKLE', 'Autumn Warm',
    DATE '2024-12-20', 'A'
);

-- DELETE 29번용 TEST 계정들
INSERT INTO MEMBER (
    login_id, password, name, gender,
    phone, email,
    skin_type_name, concern_name, personal_color_name,
    created_at, status
) VALUES (
    'TEST001', 'test', '테스트계정1', 'F',
    '010-9999-0001', 'test001@example.com',
    'OILY', 'ACNE', 'Winter Cool',
    DATE '2025-01-01', 'A'
);

INSERT INTO MEMBER (
    login_id, password, name, gender,
    phone, email,
    skin_type_name, concern_name, personal_color_name,
    created_at, status
) VALUES (
    'TEST002', 'test', '테스트계정2', 'M',
    '010-9999-0002', 'test002@example.com',
    'DRY', 'REDNESS', 'Summer Cool',
    DATE '2025-01-02', 'D'
);

--------------------------------------------------------
-- 4. PRODUCT
--------------------------------------------------------

INSERT INTO PRODUCT (
    product_code, brand_name, category_code,
    product_name, price, stock,
    description, image_url,
    created_at, is_active
) VALUES (
    'P0001', 'GlowUp', 'CT01',
    'GlowUp AC Control Cleanser', 18000, 100,
    '지성·트러블 피부용 약산성 클렌저',
    'https://example.com/img/p0001.jpg',
    DATE '2024-03-01', 'Y'
);

INSERT INTO PRODUCT (
    product_code, brand_name, category_code,
    product_name, price, stock,
    description, image_url,
    created_at, is_active
) VALUES (
    'P0002', 'GlowUp', 'CT02',
    'GlowUp Deep Moist Toner', 22000, 80,
    '수분감 높은 보습 토너',
    'https://example.com/img/p0002.jpg',
    DATE '2023-11-15', 'Y'
);

INSERT INTO PRODUCT (
    product_code, brand_name, category_code,
    product_name, price, stock,
    description, image_url,
    created_at, is_active
) VALUES (
    'P0003', 'PureSkin', 'CT03',
    'PureSkin Soothing Serum', 35000, 50,
    '민감 피부용 진정 세럼',
    'https://example.com/img/p0003.jpg',
    DATE '2022-09-10', 'Y'  -- 2023년 이전 (UPDATE 24용)
);

INSERT INTO PRODUCT (
    product_code, brand_name, category_code,
    product_name, price, stock,
    description, image_url,
    created_at, is_active
) VALUES (
    'P0004', 'PureSkin', 'CT04',
    'PureSkin Barrier Cream', 28000, 60,
    '장벽 강화 크림',
    'https://example.com/img/p0004.jpg',
    DATE '2025-01-05', 'Y'
);

INSERT INTO PRODUCT (
    product_code, brand_name, category_code,
    product_name, price, stock,
    description, image_url,
    created_at, is_active
) VALUES (
    'P0005', 'UrbanFace', 'CT05',
    'UrbanFace Daily Sunscreen', 26000, 120,
    '백탁 없는 데일리 선크림',
    'https://example.com/img/p0005.jpg',
    DATE '2024-06-20', 'Y'
);

-- 주문도, 위시리스트도 한 번도 안 쓰이는 “고아 상품” (DELETE 30용)
INSERT INTO PRODUCT (
    product_code, brand_name, category_code,
    product_name, price, stock,
    description, image_url,
    created_at, is_active
) VALUES (
    'P0006', 'UrbanFace', 'CT03',
    'UrbanFace Test Only Serum', 15000, 10,
    '테스트용 고아 데이터',
    'https://example.com/img/p0006.jpg',
    DATE '2024-01-01', 'Y'
);

--------------------------------------------------------
-- 5. PRODUCT_SKIN_TYPE (상품 - 피부 타입 M:N)
--------------------------------------------------------

INSERT INTO PRODUCT_SKIN_TYPE (product_code, skin_type_name) VALUES ('P0001', 'OILY');
INSERT INTO PRODUCT_SKIN_TYPE (product_code, skin_type_name) VALUES ('P0002', 'OILY');
INSERT INTO PRODUCT_SKIN_TYPE (product_code, skin_type_name) VALUES ('P0003', 'DRY');
INSERT INTO PRODUCT_SKIN_TYPE (product_code, skin_type_name) VALUES ('P0004', 'COMBINATION');
INSERT INTO PRODUCT_SKIN_TYPE (product_code, skin_type_name) VALUES ('P0005', 'SENSITIVE');

--------------------------------------------------------
-- 6. PRODUCT_SKIN_CONCERN (상품 - 피부 고민 M:N)
--------------------------------------------------------

INSERT INTO PRODUCT_SKIN_CONCERN (product_code, concern_name) VALUES ('P0001', 'ACNE');
INSERT INTO PRODUCT_SKIN_CONCERN (product_code, concern_name) VALUES ('P0002', 'ACNE');
INSERT INTO PRODUCT_SKIN_CONCERN (product_code, concern_name) VALUES ('P0003', 'REDNESS');
INSERT INTO PRODUCT_SKIN_CONCERN (product_code, concern_name) VALUES ('P0004', 'WRINKLE');
INSERT INTO PRODUCT_SKIN_CONCERN (product_code, concern_name) VALUES ('P0005', 'ACNE');

--------------------------------------------------------
-- 7. ORDERS
--------------------------------------------------------

INSERT INTO ORDERS (
    order_no, login_id, order_date,
    status, total_amount, payment_method, shipping_address
) VALUES (
    'O20250001', 'user01', DATE '2025-03-01',
    'ORDERED', 58000, 'CARD', '서울시 강남구 테헤란로 1'
);

INSERT INTO ORDERS (
    order_no, login_id, order_date,
    status, total_amount, payment_method, shipping_address
) VALUES (
    'O20250002', 'user01', DATE '2025-03-10',
    'DELIVERED', 48000, 'CARD', '서울시 강남구 테헤란로 1'
);

INSERT INTO ORDERS (
    order_no, login_id, order_date,
    status, total_amount, payment_method, shipping_address
) VALUES (
    'O20250201', 'user02', DATE '2025-02-15',
    'DELIVERED', 26000, 'BANK', '서울시 마포구 합정동 10'
);

INSERT INTO ORDERS (
    order_no, login_id, order_date,
    status, total_amount, payment_method, shipping_address
) VALUES (
    'O20241201', 'user03', DATE '2024-12-28',
    'DELIVERED', 35000, 'CARD', '서울시 송파구 잠실동 20'
);

-- CANCELLED 주문 (DELETE 28, UPDATE 23 테스트용)
INSERT INTO ORDERS (
    order_no, login_id, order_date,
    status, total_amount, payment_method, shipping_address
) VALUES (
    'O20240099', 'user02', DATE '2024-11-30',
    'CANCELLED', 18000, 'CARD', '서울시 마포구 합정동 10'
);

--------------------------------------------------------
-- 8. ORDER_ITEM
-- subtotal = quantity * unit_price 로 맞춰 둠
--------------------------------------------------------

-- O20250001 : P0001 x 2, P0002 x 1   => 2*18000 + 1*22000 = 58000
INSERT INTO ORDER_ITEM (
    order_no, product_code, quantity, unit_price, subtotal
) VALUES (
    'O20250001', 'P0001', 2, 18000, 36000
);

INSERT INTO ORDER_ITEM (
    order_no, product_code, quantity, unit_price, subtotal
) VALUES (
    'O20250001', 'P0002', 1, 22000, 22000
);

-- O20250002 : P0004 x 1, P0001 x 1   => 1*28000 + 1*20000(가정) = 48000
INSERT INTO ORDER_ITEM (
    order_no, product_code, quantity, unit_price, subtotal
) VALUES (
    'O20250002', 'P0004', 1, 28000, 28000
);

INSERT INTO ORDER_ITEM (
    order_no, product_code, quantity, unit_price, subtotal
) VALUES (
    'O20250002', 'P0001', 1, 20000, 20000
);

-- O20250201 : P0005 x 1 => 26000
INSERT INTO ORDER_ITEM (
    order_no, product_code, quantity, unit_price, subtotal
) VALUES (
    'O20250201', 'P0005', 1, 26000, 26000
);

-- O20241201 : P0003 x 1 => 35000
INSERT INTO ORDER_ITEM (
    order_no, product_code, quantity, unit_price, subtotal
) VALUES (
    'O20241201', 'P0003', 1, 35000, 35000
);

-- CANCELLED 주문 O20240099 : P0001 x 1 => 18000
INSERT INTO ORDER_ITEM (
    order_no, product_code, quantity, unit_price, subtotal
) VALUES (
    'O20240099', 'P0001', 1, 18000, 18000
);

--------------------------------------------------------
-- 9. REVIEW
--------------------------------------------------------

INSERT INTO REVIEW (
    login_id, product_code, rating, content, created_at
) VALUES (
    'user01', 'P0001', 5, '트러블이 많이 줄었어요.', DATE '2025-03-05'
);

INSERT INTO REVIEW (
    login_id, product_code, rating, content, created_at
) VALUES (
    'user02', 'P0001', 4, '지성 피부에 잘 맞는 편입니다.', DATE '2025-03-08'
);

INSERT INTO REVIEW (
    login_id, product_code, rating, content, created_at
) VALUES (
    'user01', 'P0002', 3, '무난한 토너에요.', DATE '2025-03-12'
);

INSERT INTO REVIEW (
    login_id, product_code, rating, content, created_at
) VALUES (
    'user02', 'P0003', 2, '보습감이 생각보다 약해요.', DATE '2023-12-20'
);

-- 오래된 평점 1 (DELETE 27용)
INSERT INTO REVIEW (
    login_id, product_code, rating, content, created_at
) VALUES (
    'user03', 'P0003', 1, '저는 트러블이 더 올라왔어요.', DATE '2022-11-01'
);

INSERT INTO REVIEW (
    login_id, product_code, rating, content, created_at
) VALUES (
    'user03', 'P0004', 5, '장벽 크림으로 최고입니다.', DATE '2025-01-15'
);

INSERT INTO REVIEW (
    login_id, product_code, rating, content, created_at
) VALUES (
    'user01', 'P0005', 4, '백탁 없고 가벼워요.', DATE '2025-02-01'
);

--------------------------------------------------------
-- 10. WISHLIST
--------------------------------------------------------

-- DELETE 26에서 삭제할 대상: user01 + P0001
INSERT INTO WISHLIST (
    login_id, product_code, created_at
) VALUES (
    'user01', 'P0001', DATE '2025-02-20'
);

INSERT INTO WISHLIST (
    login_id, product_code, created_at
) VALUES (
    'user01', 'P0004', DATE '2025-02-25'
);

-- 주문은 한 번도 안 했지만 위시리스트에만 있는 상품: P0005 (SELECT 20용)
INSERT INTO WISHLIST (
    login_id, product_code, created_at
) VALUES (
    'user02', 'P0005', DATE '2025-02-18'
);

-- P0006은 일부러 아무 데서도 안 씀 (DELETE 30용 고아 상품)
COMMIT;

-- 1. 전체 회원 목록 조회하라. (가입일순)
SELECT login_id,
       name,
       gender,
       created_at,
       status
  FROM MEMBER
 ORDER BY created_at;
 
 -- 2. 피부 타입이 'OILY'인 회원 조회
SELECT login_id,
       name,
       skin_type_name
  FROM MEMBER
 WHERE skin_type_name = 'OILY';

-- 3. 특정 브랜드(GlowUp)의 상품 목록
SELECT product_code,
       product_name,
       price,
       stock
  FROM PRODUCT
 WHERE brand_name = 'GlowUp'
 ORDER BY price DESC;
 
 -- 4. 상품 + 브랜드 + 카테고리 함께 조회
 SELECT p.product_code,
       p.product_name,
       p.price,
       b.brand_name,
       c.category_name
  FROM PRODUCT p
  JOIN BRAND b
    ON p.brand_name = b.brand_name
  JOIN CATEGORY c
    ON p.category_code = c.category_code;
    
-- 5. 카테고리별 상품 개수
SELECT c.category_name,
       COUNT(*) AS product_count
  FROM PRODUCT p
  JOIN CATEGORY c
    ON p.category_code = c.category_code
 GROUP BY c.category_name
 ORDER BY product_count DESC;
 
 -- 6. 브랜드별 평균 가격이 30,000 이상인 브랜드
 SELECT b.brand_name,
       ROUND(AVG(p.price)) AS avg_price
  FROM PRODUCT p
  JOIN BRAND b
    ON p.brand_name = b.brand_name
 GROUP BY b.brand_name
HAVING AVG(p.price) >= 30000;

-- 7. 특정 회원(user01)의 주문 내역
SELECT o.order_no,
       o.order_date,
       o.status,
       o.total_amount
  FROM ORDERS o
 WHERE o.login_id = 'user01'
 ORDER BY o.order_date DESC;

-- 8. 특정 주문(O20250001)의 주문 상세 + 상품명
SELECT oi.order_no,
       oi.product_code,
       p.product_name,
       oi.quantity,
       oi.unit_price,
       oi.subtotal
  FROM ORDER_ITEM oi
  JOIN PRODUCT p
    ON oi.product_code = p.product_code
 WHERE oi.order_no = 'O20250001';
 
-- 9. 상품별 총 판매 수량
SELECT p.product_code,
       p.product_name,
       SUM(oi.quantity) AS total_qty
  FROM PRODUCT p
  JOIN ORDER_ITEM oi
    ON p.product_code = oi.product_code
 GROUP BY p.product_code, p.product_name
 ORDER BY total_qty DESC;

-- 10. 평균 평점이 4 이상인 상품
SELECT p.product_code,
       p.product_name,
       ROUND(AVG(r.rating), 2) AS avg_rating,
       COUNT(*) AS review_count
  FROM PRODUCT p
  JOIN REVIEW r
    ON p.product_code = r.product_code
 GROUP BY p.product_code, p.product_name
HAVING AVG(r.rating) >= 4;

-- 11. 위시리스트에 담긴 상품 목록 (회원 + 상품)
SELECT w.login_id,
       m.name,
       w.product_code,
       p.product_name,
       w.created_at
  FROM WISHLIST w
  JOIN MEMBER m
    ON w.login_id = m.login_id
  JOIN PRODUCT p
    ON w.product_code = p.product_code
 ORDER BY w.created_at DESC;

-- 12. 한 번도 주문되지 않은 상품
SELECT p.product_code,
       p.product_name
  FROM PRODUCT p
 WHERE NOT EXISTS (
           SELECT 1
             FROM ORDER_ITEM oi
            WHERE oi.product_code = p.product_code
       );

-- 13. 특정 피부 고민(ACNE)에 추천되는 상품 목록
SELECT p.product_code,
       p.product_name,
       psc.concern_name
  FROM PRODUCT p
  JOIN PRODUCT_SKIN_CONCERN psc
    ON p.product_code = psc.product_code
 WHERE psc.concern_name = 'ACNE';
 
-- 14. 퍼스널 컬러가 'Spring Warm'인 회원 목록
SELECT login_id,
       name,
       personal_color_name,
       created_at
  FROM MEMBER
 WHERE personal_color_name = 'Spring Warm';

-- 15. 2025년 이후 가입 + OILY 피부인 회원
SELECT login_id,
       name,
       skin_type_name,
       created_at
  FROM MEMBER
 WHERE created_at >= DATE '2025-01-01'
   AND skin_type_name = 'OILY';

-- 16. 최근 3개월 이내 주문한 회원과 주문 횟수
SELECT o.login_id,
       COUNT(*) AS order_count
  FROM ORDERS o
 WHERE o.order_date >= ADD_MONTHS(TRUNC(SYSDATE), -3)
 GROUP BY o.login_id
 ORDER BY order_count DESC;

-- 17. 주문 금액이 50,000 이상인 주문 + 회원 이름
SELECT o.order_no,
       o.total_amount,
       m.login_id,
       m.name
  FROM ORDERS o
  JOIN MEMBER m
    ON o.login_id = m.login_id
 WHERE o.total_amount >= 50000
 ORDER BY o.total_amount DESC;

-- 18. 리뷰를 한 번도 작성하지 않은 회원
SELECT m.login_id,
       m.name
  FROM MEMBER m
 WHERE NOT EXISTS (
           SELECT 1
             FROM REVIEW r
            WHERE r.login_id = m.login_id
       );

-- 19. 리뷰가 2개 이상 달린 “리뷰 많은 상품”
SELECT p.product_code,
       p.product_name,
       COUNT(*) AS review_count
  FROM PRODUCT p
  JOIN REVIEW r
    ON p.product_code = r.product_code
 GROUP BY p.product_code, p.product_name
HAVING COUNT(*) >= 2
 ORDER BY review_count DESC;

-- 20. 위시리스트에는 있지만 한 번도 주문되지 않은 상품
SELECT DISTINCT p.product_code,
       p.product_name
  FROM PRODUCT p
  JOIN WISHLIST w
    ON p.product_code = w.product_code
 WHERE NOT EXISTS (
           SELECT 1
             FROM ORDER_ITEM oi
            WHERE oi.product_code = p.product_code
       );
       
-- 21. user01의 피부 타입을 DRY로 변경
UPDATE MEMBER
   SET skin_type_name = 'DRY'
 WHERE login_id = 'user01';

-- 22. GlowUp 브랜드 상품 가격 10% 인상
UPDATE PRODUCT
   SET price = ROUND(price * 1.10)
 WHERE brand_name = 'GlowUp';

-- 23. 특정 주문 상태를 CANCELLED로 변경
UPDATE ORDERS
   SET status = 'CANCELLED'
 WHERE order_no = 'O20250001';

-- 24. 2023년 이전에 생성된 상품을 비활성화(is_active = 'N')
UPDATE PRODUCT
   SET is_active = 'N'
 WHERE created_at < DATE '2023-01-01';

-- 25. 평점 2 이하 리뷰에 “관리자 확인” 문구 추가
UPDATE REVIEW
   SET content = content || ' [관리자 확인 완료]'
 WHERE rating <= 2;

 -- 26. user01의 위시리스트에서 P0001만 삭제
 DELETE FROM WISHLIST
 WHERE login_id = 'user01'
   AND product_code = 'P0001';

-- 27. 2024-01-01 이전의 평점 1점 리뷰 삭제
DELETE FROM REVIEW
 WHERE rating = 1
   AND created_at < DATE '2024-01-01';

-- 28. 이미 취소된 주문의 주문 상세(ORDER_ITEM) 모두 삭제
DELETE FROM ORDER_ITEM
 WHERE order_no IN (
           SELECT order_no
             FROM ORDERS
            WHERE status = 'CANCELLED'
       );


-- 29. TEST로 시작하는 테스트 회원 모두 삭제
DELETE FROM MEMBER
 WHERE login_id LIKE 'TEST%';

-- 30. 주문·위시리스트 어디에도 쓰이지 않은 고아 상품 삭제
DELETE FROM PRODUCT p
 WHERE NOT EXISTS (
           SELECT 1
             FROM ORDER_ITEM oi
            WHERE oi.product_code = p.product_code
       )
   AND NOT EXISTS (
           SELECT 1
             FROM WISHLIST w
            WHERE w.product_code = p.product_code
       )
   AND NOT EXISTS (
           SELECT 1
             FROM REVIEW r
            WHERE r.product_code = p.product_code
       );

commit;



