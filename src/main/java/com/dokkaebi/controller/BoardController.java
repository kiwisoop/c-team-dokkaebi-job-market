package com.dokkaebi.controller;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dokkaebi.domain.BoardVO;
import com.dokkaebi.domain.Criteria;
import com.dokkaebi.domain.PageDTO;
import com.dokkaebi.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

    private BoardService service;
    
    @GetMapping("/list")
    public void list(Criteria cri, Model model) {
        log.info("list: " + cri);
        
        model.addAttribute("list", service.getList(cri));
        
        int total = service.getTotal(cri);
        log.info("total: " + total);
        
        model.addAttribute("pageMaker", new PageDTO(cri, total));
    }
    
    @GetMapping("/register")
    @PreAuthorize("isAuthenticated()")
    public void register() {
        
    }
    
    @PostMapping("/register")
    @PreAuthorize("isAuthenticated()")
    public String register(BoardVO board, Authentication auth, RedirectAttributes rttr) {
        // 작성자는 폼 값이 아니라 로그인 사용자로 고정 (위조 방지)
        board.setWriter(auth.getName());
        log.info("register: " + board);
        
        service.register(board);
        
        rttr.addFlashAttribute("result", board.getBno());
        
        return "redirect:/board/list";
    }
    
    @GetMapping("/get")
    public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
        log.info("/get");
        
        model.addAttribute("board", service.get(bno));
    }
    
    @GetMapping("/modify")
    @PreAuthorize("isAuthenticated()")
    public void modifyForm(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri,
            Authentication auth, Model model) {
        log.info("/modify");
        
        BoardVO board = service.get(bno);
        checkOwner(board, auth);
        model.addAttribute("board", board);
    }
    
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/modify")
    public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, Authentication auth, RedirectAttributes rttr) {
        log.info("modify: " + board);
        
        // 작성자 검증은 폼 값이 아니라 DB에 저장된 작성자 기준
        checkOwner(service.get(board.getBno()), auth);
        
        if (service.modify(board)) {
            rttr.addFlashAttribute("result", "success");
        }
        
        rttr.addAttribute("pageNum", cri.getPageNum());
        rttr.addAttribute("amount", cri.getAmount());
        rttr.addAttribute("type", cri.getType());
        rttr.addAttribute("keyword", cri.getKeyword());
        
        return "redirect:/board/list";
    }
    
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/remove")
    public String remove(@RequestParam("bno") Long bno, 
            @ModelAttribute("cri") Criteria cri, Authentication auth, RedirectAttributes rttr) {
        log.info("remove..." + bno);
        
        checkOwner(service.get(bno), auth);
        
        if (service.remove(bno)) {
            rttr.addFlashAttribute("result", "success");
        }
        
        rttr.addAttribute("pageNum", cri.getPageNum());
        rttr.addAttribute("amount", cri.getAmount());
        rttr.addAttribute("type", cri.getType());
        rttr.addAttribute("keyword", cri.getKeyword());
        
        return "redirect:/board/list";
    }
    
    private void checkOwner(BoardVO board, Authentication auth) {
        boolean admin = auth.getAuthorities().stream()
                .anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));
        if (board == null || !(admin || auth.getName().equals(board.getWriter()))) {
            throw new AccessDeniedException("게시글에 대한 권한이 없습니다.");
        }
    }
}
