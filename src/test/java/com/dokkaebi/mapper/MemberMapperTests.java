package com.dokkaebi.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.dokkaebi.domain.MemberVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
    "file:src/main/webapp/WEB-INF/spring/root-context.xml",
    "file:src/main/webapp/WEB-INF/spring/security-context.xml"
})
@Log4j
public class MemberMapperTests {

    @Autowired
    private MemberMapper mapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    public void testRead() {
        MemberVO vo = mapper.read("admin");
        log.info(vo);
        vo.getAuthList().forEach(auth -> log.info(auth));
    }

    @Test
    public void testPasswordMatches() {
        MemberVO vo = mapper.read("user1");
        log.info("matches: " + passwordEncoder.matches("1234", vo.getUserpw()));
    }

    @Test
    public void testDuplicateCheck() {
        log.info("admin count: " + mapper.countByUserid("admin"));
        log.info("email count: " + mapper.countByEmail("admin@dokkaebi.com"));
    }
}
