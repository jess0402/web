<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Mybatis실습 - selectList</title>
<style>
div#student-container{text-align:center;}
table.tbl-student{margin:0 auto;border:1px solid; border-collapse:collapse;}
table.tbl-student th,table.tbl-student td{
	border:1px solid;
	padding:5px;
}
</style>
</head>
<body>
<div id="student-container">
	<h2>selectList</h2>
	<p>SqlSession의 selectList메소드를 호출해서 List&lt;Student>를 리턴받음.</p>
	<table class="tbl-student">
		<thead>
			<tr>
				<th>학번</th>
				<th>이름</th>
				<th>전화번호</th>
				<th>등록일</th>
				<th>수정일</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${studentList}" var="student">
				<tr>
					<td>${student.no}</td> <!-- getNo -> no -->
					<td>${student.name}</td> <!-- getName -> name -->
					<td>${student.tel}</td> <!-- getTel -> tel -->
					<td>
						<!-- getCreatedAt -> createdAt -->
						<fmt:formatDate value="${student.createdAt}" pattern="yy-MM-dd HH:mm"/>
					</td> 
					<td>
						<!-- getUpdatedAt -> updateAt -->
						<!-- java.time.LocalDateTime -> java.util.Date로 변환 -->
						<fmt:parseDate value="${student.updatedAt}" pattern="yy-MM-dd'T'HH:mm" var="updatedAt"/>
						<fmt:formatDate value="${updatedAt}" pattern="yy-MM-dd HH:mm"/>
					</td> 
				</tr>
			</c:forEach>
		</tbody>
	</table>
	
	<hr />
	<p>SqlSession의 selectList메소드를 호출해서 List&lt;Map&lt;String,Object>>를 리턴받음.</p>
	<table class="tbl-student">
		<thead>
			<tr>
				<th>학번</th>
				<th>이름</th>
				<th>전화번호</th>
				<th>등록일</th>
				<th>수정일</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${studentMapList}" var="student">
				<tr>
					<td>${student.no}</td> <!-- getNo -> no -->
					<td>${student.name}</td> <!-- getName -> name -->
					<td>${student.tel}</td> <!-- getTel -> tel -->
					<td>
						<!-- getCreatedAt -> createdAt -->
						<fmt:formatDate value="${student.createdAt}" pattern="yy-MM-dd HH:mm"/>
					</td> 
					<td>
						<!-- getUpdatedAt -> updateAt -->
						<!-- java.time.LocalDateTime -> java.util.Date로 변환하는 과정이 필요 없음. -->
						<%-- <fmt:parseDate value="${student.updatedAt}" pattern="yy-MM-dd HH:mm:ss.S" var="updatedAt"/> --%>
						<fmt:formatDate value="${student.updatedAt}" pattern="yy-MM-dd HH:mm"/>
					</td> 
				</tr>
			</c:forEach>
		</tbody>
	</table>
	
</div>
	
	
</body>
</html>
