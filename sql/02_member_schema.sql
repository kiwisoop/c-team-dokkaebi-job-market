-- ============================================
-- Member Schema for Dokkaebi Job Market
-- Execute with book_ex user (after 01_board_schema.sql)
-- Version: 1.0 (Login / Signup)
-- ============================================

-- Member table
CREATE TABLE tbl_member (
    userid      VARCHAR2(20)     PRIMARY KEY,
    userpw      VARCHAR2(100)    NOT NULL,
    username    VARCHAR2(50)     NOT NULL,
    email       VARCHAR2(100)    NOT NULL,
    enabled     CHAR(1)          DEFAULT '1' NOT NULL,
    regdate     DATE             DEFAULT SYSDATE,
    updatedate  DATE             DEFAULT SYSDATE,
    CONSTRAINT uk_member_email UNIQUE (email)
);

-- Member authority table
CREATE TABLE tbl_member_auth (
    userid  VARCHAR2(20)  NOT NULL,
    auth    VARCHAR2(50)  NOT NULL,
    CONSTRAINT pk_member_auth PRIMARY KEY (userid, auth),
    CONSTRAINT fk_member_auth FOREIGN KEY (userid) REFERENCES tbl_member(userid)
);

-- Sample accounts (password: 1234, BCrypt hash)
INSERT INTO tbl_member (userid, userpw, username, email)
VALUES ('admin', '$2a$10$yE5NUBr.BpsJR0R2g8SUJOnqnCRtiJwN2nYnbhMHt42mijOOZGBky', '관리자', 'admin@dokkaebi.com');

INSERT INTO tbl_member (userid, userpw, username, email)
VALUES ('user1', '$2a$10$yE5NUBr.BpsJR0R2g8SUJOnqnCRtiJwN2nYnbhMHt42mijOOZGBky', '사용자1', 'user1@dokkaebi.com');

INSERT INTO tbl_member_auth (userid, auth) VALUES ('admin', 'ROLE_ADMIN');
INSERT INTO tbl_member_auth (userid, auth) VALUES ('admin', 'ROLE_MEMBER');
INSERT INTO tbl_member_auth (userid, auth) VALUES ('user1', 'ROLE_MEMBER');

COMMIT;
