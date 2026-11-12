package com.dokkaebi.security;

import java.util.stream.Collectors;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import com.dokkaebi.domain.MemberVO;

import lombok.Getter;

@Getter
public class CustomUser extends User {

    private static final long serialVersionUID = 1L;

    private MemberVO member;

    public CustomUser(MemberVO vo) {
        super(vo.getUserid(), vo.getUserpw(), vo.isEnabled(), true, true, true,
                vo.getAuthList().stream()
                    .map(auth -> new SimpleGrantedAuthority(auth.getAuth()))
                    .collect(Collectors.toList()));
        this.member = vo;
    }
}
