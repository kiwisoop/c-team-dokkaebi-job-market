# c-team-dokkaebi-job-market

도깨비 구인구직 프로젝트 (Spring MVC 5.2.7 + MyBatis + Oracle XE, JDK 8, Tomcat 8.5/9).

## 개발환경
- JDK 1.8, STS 3.x(Lombok 설치), Tomcat 8.5/9 (Context Path `/`), Oracle XE (`localhost:1521:XE`)
- DB 계정: `sql/00_create_user.sql` 실행 (book_ex / book_ex)
- 테이블 생성: `book_ex`로 `sql/01_board_schema.sql` → `sql/02_member_schema.sql` 순서로 실행
- DB 접속 정보: `src/main/resources/db.properties.example`을 `db.properties`로 복사 후 환경에 맞게 수정 (`db.properties`는 git 제외)
- 업로드 임시 폴더 `C:\upload\temp` 생성

## 시작
1. STS → Import → Existing Maven Projects
2. Maven → Update Project
3. `DataSourceTests` 실행으로 DB 연결 확인
4. Tomcat 실행 후 http://localhost:8080/ 확인

## 구조
`com.dokkaebi.{controller,domain,mapper,service}`, 매퍼 XML은 `src/main/resources/com/dokkaebi/mapper/`

## 회원 (로그인/회원가입)
- 화면: 로그인 `/member/login`, 회원가입 `/member/signup`, 로그아웃 `POST /logout`
- 인증: Spring Security + DB(`tbl_member`, `tbl_member_auth`), 비밀번호는 BCrypt 해시로 저장
- 가입 규칙: 아이디 영문·숫자 4~20자 / 비밀번호 8자 이상 + 특수문자 1개 이상 / 이름 2자 이상 / 이메일 형식 (서버에서도 동일하게 검증)
- 권한: `ROLE_MEMBER`(가입 시 기본), `ROLE_ADMIN`
- 게시판 연동: 글 작성자는 로그인 사용자로 고정, 수정·삭제는 작성자 본인 또는 관리자만 가능
- 테스트 계정 (`02_member_schema.sql` 시드): `admin` / `1234` (관리자), `user1` / `1234` (일반)
