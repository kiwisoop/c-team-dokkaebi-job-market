package com.dokkaebi.security;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import com.dokkaebi.domain.MemberVO;
import com.dokkaebi.mapper.MemberMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
@AllArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private MemberMapper memberMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.warn("load user by username: " + username);

        MemberVO vo = memberMapper.read(username);
        if (vo == null) {
            throw new UsernameNotFoundException(username);
        }
        return new CustomUser(vo);
    }
}
