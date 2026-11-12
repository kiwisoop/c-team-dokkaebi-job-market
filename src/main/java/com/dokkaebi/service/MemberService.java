package com.dokkaebi.service;

import com.dokkaebi.domain.MemberVO;

public interface MemberService {

    /** 회원가입. 아이디/이메일 중복 시 IllegalArgumentException */
    public void register(MemberVO member);

    public boolean isUseridAvailable(String userid);

    public boolean isEmailAvailable(String email);
}
