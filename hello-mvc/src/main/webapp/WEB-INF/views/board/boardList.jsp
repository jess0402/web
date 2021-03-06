<%@page import="java.util.List"%>
<%@page import="board.model.dto.BoardExt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<% 
	List<BoardExt> list = (List<BoardExt>) request.getAttribute("list");
%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/board.css" />
<section id="board-container">
	<h2>게시판 </h2>
<% if(loginMember != null){ %> <!-- header.jsp에 loginMember가 있기 때문에 가져다 쓸 수 있음. -->
	<input 
		type="button" value="글쓰기" id="btn-add" 
		onclick="location.href='<%= request.getContextPath() %>/board/boardEnroll';" />
<% } %>	
	<table id="tbl-board">
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>첨부파일</th><%--첨부파일이 있는 경우 /images/file.png 표시 width:16px --%>
				<th>조회수</th>
			</tr>
		</thead>
		<tbody>
<%
	if(list == null || list.isEmpty()){
%>
		<tr>
			<td colspan="6"> 조회된 정보가 없습니다.</td>
		</tr>
<%
	} else {
		for(BoardExt board : list){
%>
			<tr>
				<td><%= board.getNo() %></td>
				<td>
					<a href="<%= request.getContextPath() %>/board/boardView?no=<%= board.getNo() %>"><%= board.getTitle() %></a>
					
					<% if(board.getCommentCount() > 0){ %>
						(<%= board.getCommentCount() %>)
					<% } %>
				</td>
				<td><%= board.getMemberId() %></td>
				<td><%= board.getRegDate() %></td>
				<td>
		<% if(board.getAttachCount() > 0) { %>					
					<img src="<%= request.getContextPath() %>/images/file.png" alt="" />
		<% } %>					
				</td>
				<td><%= board.getReadCount() %></td>
			</tr>
<% 	
		}
	} 
%>
		</tbody>
	</table>

	<div id='pageBar'><%= request.getAttribute("pagebar") %></div>
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
