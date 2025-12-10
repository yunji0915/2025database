# 💄 화장품 쇼핑몰 DB 설계 프로젝트

본 프로젝트는 **화장품 쇼핑몰 시스템을 위한 관계형 데이터베이스 설계 및 SQL 실습 프로젝트**입니다.  
Oracle DB를 기반으로 테이블 설계, 무결성 제약조건 설정, 테스트 데이터 삽입,  
그리고 **SELECT / UPDATE / DELETE 중심의 DML 30문제 실습**까지 완료한 프로젝트입니다.

---

## ✅ 사용 기술

- DBMS: **Oracle Database**
- Tool: **SQL Developer**
- SQL: DDL / DML
- Version Control: **Git & GitHub**

---

## ✅ 데이터베이스 환경

- 멀티 테넌트 구조(CDB + PDB)
- 사용 PDB: `EMPPDB`
- 프로젝트 계정: `COSMETIC`
- 접속 방식: **Service Name 기반 접속**

---

## ✅ 테이블 구성

### 📌 마스터 테이블 (5개)
- `SKIN_TYPE` : 피부 타입
- `SKIN_CONCERN` : 피부 고민
- `PERSONAL_COLOR` : 퍼스널 컬러
- `BRAND` : 브랜드
- `CATEGORY` : 상품 카테고리

### 📌 핵심 테이블 (4개)
- `MEMBER` : 회원 정보
- `PRODUCT` : 상품 정보
- `ORDERS` : 주문 정보
- `ORDER_ITEM` : 주문 상세

### 📌 교차 테이블 (2개)
- `PRODUCT_SKIN_TYPE` : 상품 - 피부타입 (M:N)
- `PRODUCT_SKIN_CONCERN` : 상품 - 피부고민 (M:N)

### 📌 부가 테이블 (2개)
- `REVIEW` : 상품 리뷰
- `WISHLIST` : 위시리스트

➡️ **총 13개 테이블로 구성됨**

---

## ✅ 설계 특징

- 모든 테이블은 **제3정규형(3NF) 만족**
- 모든 데이터는 **PK / FK 기반 참조 무결성 유지**
- 다대다(M:N) 관계는 **교차 테이블로 분리**
- 상태 값(`status`, `is_active` 등)은 **CHECK 제약조건 적용**
- 이메일(`email`)은 **UNIQUE 제약조건 적용**

---

## ✅ SQL 구성 파일

| 파일명 | 설명 |
|--------|------|
| `DDL.sql` | 전체 테이블 생성 스크립트 |
| `DML.sql` | INSERT, SELECT, UPDATE, DELETE 실습 SQL 30문제 |
| `README.md` | 프로젝트 설명 문서 |

---

## ✅ DML 실습 구성 (총 30문제)

- SELECT : 20문제  
- UPDATE : 5문제  
- DELETE : 5문제  

각 문제는 다음 항목을 모두 포함합니다.

- 문제 설명
- SQL 문장
- 실제 실행 결과(SQL Developer 실행)
- 결과 해석

---

## ✅ 실행 순서

1. `DDL.sql` 실행 → 전체 테이블 생성
2. 마스터 테이블 데이터 INSERT
3. `DML.sql` 실행 → 테스트 데이터 삽입 및 SQL 실습
4. GitHub 업로드 및 보고서 작성

---

## ✅ 프로젝트 목적

- 관계형 데이터베이스 구조에 대한 이해
- PK / FK 기반 무결성 제약 실습
- 실제 서비스(쇼핑몰) 기준 테이블 설계 경험
- 실무형 SQL(DML) 작성 능력 향상

