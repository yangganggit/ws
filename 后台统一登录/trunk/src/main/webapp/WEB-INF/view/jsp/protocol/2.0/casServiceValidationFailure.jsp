<%@ page session="false" language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cas:serviceResponse xmlns:cas='http://www.yale.edu/tp/cas'>
	<cas:authenticationFailure code='${code}'>
		${fn:escapeXml(description)}
	</cas:authenticationFailure>
</cas:serviceResponse>