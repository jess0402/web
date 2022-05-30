package board.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.FileRenamePolicy;

import board.model.dto.Attachment;
import board.model.dto.BoardExt;
import board.model.service.BoardService;
import common.HelloMvcFileRenamePolicy;

/**
 * GET - 글쓰기 폼을 요청
 * POST - 게시글 DB 등록 요청
 *  => 이래서 두 개가 필요한 것.
 */
@WebServlet("/board/boardEnroll")
public class BoardEnrollServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BoardService boardService = new BoardService();
	
	/**
	 * 게시글 쓰기 폼 요청
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/views/board/boardEnroll.jsp")
			.forward(request, response);
	}

	/**
	 * 게시글 등록 요청
	 * 	- 게시글 등록시 /board/boardList로 리다이렉트
	 * 	
	 * 파일 업로드 절차
	 * (파일 업로드 하려면 cos.jar를 다운받아서 WEB-INF/lib 하위에 위치시키기)
	 * 	1. 제출폼에 enctype="multipart/form-data" <- 작성했는지 확인
	 * 	2. MultipartRequest 객체 생성 - 파일 저장 완료
	 * 		- a. HttpServletRequest
	 * 		- b. saveDirectory (저장경로)
	 * 		- c. maxPostSize (최대 업로드 크기)
	 * 		- d. encoding (인코딩 방식)
	 * 		- e. FileRenamePolicy 객체
	 * 	3. 실제 사용자 입력값 처리 - HttpServletRequest가 아닌 MultiplartRequest에서 값을 가져와야 함. 
	 * 	4. 업무로직 처리 - db board, attachment 레코드 등록
	 * 	5. redirect
	 * 
	 *
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			// 1번은 boardEnroll.jsp에서 하고 옴. 
			
			// 2. MultipartRequest 객체 생성
			
			// 2-b. 파일저장경로
			// C:\\Workspaces\\Servlet_JSP_workspace\\hello-mvc\\src\\main\\webapp\\upload\\board
			ServletContext application = getServletContext();
			String webRoot = application.getRealPath("/");
			// File.separator = 운영체제별 경로구분자 (window: \, mac/linux: /)
			String saveDirectory = webRoot + "upload" + File.separator + "board";
			System.out.println("saveDirectory = " + saveDirectory);
			
			// 2-c. 최대파일크기 10MB
			int maxPostSize = 1024 * 1024 * 10; 
			// 1024(1키로바이트) -> 1024 * 1024 (1메가바이트) -> 1024 * 1024 * 10 (10메가바이트)
			
			// 2-d. 인코딩
			String encoding = "utf-8";
			
			// 2-e. 파일명 재지정 정책 객체
			// DefaultFileRenamePolicy = 업로드한 파일명이 중복되었을 때 numbering 처리함.
//			FileRenamePolicy policy = new DefaultFileRenamePolicy();
			FileRenamePolicy policy = new HelloMvcFileRenamePolicy();
			MultipartRequest multiReq = 
					new MultipartRequest(request, saveDirectory, maxPostSize, encoding, policy);
			
			// 3. 사용자 입력값 처리
			String title = multiReq.getParameter("title");
			String memberId = multiReq.getParameter("writer");
			String content = multiReq.getParameter("content");
			// dto 객체 생성
			BoardExt board = new BoardExt();
			board.setTitle(title);
			board.setMemberId(memberId);
			board.setContent(content);
			
			File upFile1 = multiReq.getFile("upFile1");
			File upFile2 = multiReq.getFile("upFile2");
			
			// 첨부한 파일이 하나라도 있는 경우 실행
			if(upFile1 != null || upFile2 != null) {
				List<Attachment> attachments = new ArrayList<>();
				
				if(upFile1 != null) {
					attachments.add(getAttachment(multiReq, "upFile1"));
				}
				if(upFile2 != null) {
					attachments.add(getAttachment(multiReq, "upFile2"));
				}
				
				board.setAttachments(attachments);
			}
			
			// 4. 업무로직
			// 실제 db에 insert하기
			int result = boardService.insertBoard(board);
			
			// 5. redirect
	        response.sendRedirect(request.getContextPath() + "/board/boardView?no=" + board.getNo());
		
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		

	}

	private Attachment getAttachment(MultipartRequest multiReq, String name) {
		Attachment attach = new Attachment();
		String originalFilename = multiReq.getOriginalFileName(name); // 업로드한 파일명
		String renamedFilename = multiReq.getFilesystemName(name);    // 저장된 파일명
		attach.setOriginalFilename(originalFilename);
		attach.setRenamedFilename(renamedFilename);
		return attach;
	}

}
