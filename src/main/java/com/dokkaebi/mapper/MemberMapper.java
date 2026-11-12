package com.dokkaebi.mapper;

import org.apache.ibatis.annotations.Param;

import com.dokkaebi.domain.AuthVO;
import com.dokkaebi.domain.MemberVO;

public interface MemberMapper {

    public MemberVO read(String userid);

    public int insert(MemberVO member);

    public int insertAuth(AuthVO auth);

    public int countByUserid(@Param("userid") String userid);

    public int countByEmail(@Param("email") String email);
}
