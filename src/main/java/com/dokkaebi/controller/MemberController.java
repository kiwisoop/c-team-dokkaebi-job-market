package com.dokkaebi.controller;

import java.util.Collections;
import java.util.Map;
import java.util.regex.Pattern;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dokkaebi.domain.MemberVO;
import com.dokkaebi.service.MemberService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/member/*")
@AllArgsConstructor
public class MemberController {

    private static final Pattern ID_PATTERN = Pattern.compile("^[A-Za-z0-9]{4,20}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Pattern SPECIAL_PATTERN = Pattern.compile("[^A-Za-z0-9\\s]");

    private MemberService service;

    @GetMapping("/login")
    public void login(@RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout, Model model) {
        if (error != null) {
            model.addAttribute("loginError", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }
        if (logout != null) {
            model.addAttribute("logoutMsg", "로그아웃 되었습니다.");
        }
    }

    @GetMapping("/signup")
    public void signup() {

    }

    @PostMapping("/signup")
    public String signup(MemberVO member, Model model, RedirectAttributes rttr) {
        log.info("signup: " + member.getUserid());

        // 서버 측 검증 (화면 검증은 우회 가능하므로 동일 규칙을 한 번 더 확인)
        String err = validate(member);
        if (err == null) {
            try {
                service.register(member);
            } catch (IllegalArgumentException e) {
                err = e.getMessage();
            }
        }

        if (err != null) {
            member.setUserpw(null);
            model.addAttribute("member", member);
            model.addAttribute("signupError", err);
            return "member/signup";
        }

        rttr.addFlashAttribute("signupDone", "회원가입이 완료되었습니다. 로그인해 주세요.");
        return "redirect:/member/login";
    }

    @GetMapping("/idCheck")
    @ResponseBody
    public Map<String, Boolean> idCheck(@RequestParam("userid") String userid) {
        boolean ok = ID_PATTERN.matcher(userid).matches() && service.isUseridAvailable(userid);
        return Collections.singletonMap("available", ok);
    }

    // 접근 거부 시 원래 요청 메서드(POST 포함) 그대로 forward 되므로 모든 메서드 허용
    @RequestMapping("/accessError")
    public void accessError() {

    }

    private String validate(MemberVO m) {
        if (m.getUserid() == null || !ID_PATTERN.matcher(m.getUserid()).matches()) {
            return "아이디는 영문·숫자 4~20자로 입력해 주세요.";
        }
        String pw = m.getUserpw();
        if (pw == null || pw.length() < 8 || pw.length() > 50) {
            return "비밀번호는 8자리 이상 50자 이하여야 합니다.";
        }
        if (!SPECIAL_PATTERN.matcher(pw).find()) {
            return "비밀번호에 특수문자를 1개 이상 포함해 주세요.";
        }
        if (m.getUsername() == null || m.getUsername().trim().length() < 2 || m.getUsername().trim().length() > 20) {
            return "이름을 2자 이상 20자 이하로 입력해 주세요.";
        }
        m.setUsername(m.getUsername().trim());
        if (m.getEmail() == null || m.getEmail().length() > 60 || !EMAIL_PATTERN.matcher(m.getEmail().trim()).matches()) {
            return "올바른 이메일 형식이 아닙니다.";
        }
        m.setEmail(m.getEmail().trim());
        return null;
    }
}
