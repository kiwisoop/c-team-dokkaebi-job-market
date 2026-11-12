package com.dokkaebi.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dokkaebi.domain.AuthVO;
import com.dokkaebi.domain.MemberVO;
import com.dokkaebi.mapper.MemberMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class MemberServiceImpl implements MemberService {

    private MemberMapper mapper;
    private PasswordEncoder passwordEncoder;

    @Transactional
    @Override
    public void register(MemberVO member) {
        log.info("register member: " + member.getUserid());

        if (!isUseridAvailable(member.getUserid())) {
            throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
        }
        if (!isEmailAvailable(member.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        member.setUserpw(passwordEncoder.encode(member.getUserpw()));
        mapper.insert(member);

        AuthVO auth = new AuthVO();
        auth.setUserid(member.getUserid());
        auth.setAuth("ROLE_MEMBER");
        mapper.insertAuth(auth);
    }

    @Override
    public boolean isUseridAvailable(String userid) {
        return mapper.countByUserid(userid) == 0;
    }

    @Override
    public boolean isEmailAvailable(String email) {
        return mapper.countByEmail(email) == 0;
    }
}
