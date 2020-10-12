<%@ page import="chat.Message" %>
<%@ page import="java.util.LinkedList" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
    <head>
        <meta charset="utf-8" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/custom.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js" type=""></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.1/umd/popper.min.js" type=""></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" type=""></script>
        <script type="text/javascript" src="js/custom.js"></script>

        <title>JSP Chat Web App</title>
    </head>
    <body onload="scrollToBottom()">
        <div class="container mw-100">
            <%-- Title --%>
            <div class="row py-5 bg-info">
                <div class="col-12">
                    <h1 class="text-center text-white">JSP Chat Web App</h1>
                </div>
            </div>

            <%-- Alerts --%>
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-9 mt-2">
                        <%
                            String noMessageError = (String) session.getAttribute("noMessageError");
                            String nonValidReferrerError = (String) session.getAttribute("nonValidReferrerError");
                            if (noMessageError != null && noMessageError.equals("true")) {
                        %>
                            <div class="alert alert-danger text-center" role="alert">
                                Sorry, we could not get that 😔 Do not forget to include a message before submitting!
                            </div>
                        <% } else if (nonValidReferrerError != null && nonValidReferrerError.equals("true")) {
                        %>
                            <div class="alert alert-danger text-center" role="alert">
                                ERROR: Your request seems to be coming from a page other than /chat
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <%-- Chat window --%>
            <div class="row justify-content-center my-2">
                <div class="col-8">
                    <div id="chat-window" class="overflow-auto">
                        <table class="table table-striped">
                            <tbody>
                                <%
                                LinkedList<Message> chat = (LinkedList<Message>) request.getAttribute("chat");

                                    if (request.getAttribute("chat") != null) {
                                        for(Message message : chat) {
                                %>
                                    <tr>
                                        <td>
                                            <div class="container">
                                                <div class="row justify-content-between">
                                                    <div class="col-3">
                                                        <p class="font-weight-light"><%= message.getUser() %></p>
                                                    </div>
                                                    <div class="col-6">
                                                        <p class="font-italic text-right"><%= message.getTimestamp() %>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-12">
                                                        <p class="font-weight-normal text-wrap"><%= message.getMessage() %></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <%-- Form --%>
            <%
                String userId = (session.getAttribute("userId") == null) ? "" : (String) session.getAttribute("userId");
            %>
            <div class="row justify-content-center mt-2 mb-5">
                <div class="col-8">
                    <form action="chat" method="post">
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text">User</span>
                            </div>
                            <label for="user"></label>
                            <input type="text" class="form-control" name="user" id="user" value="<%= userId %>">
                        </div>
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Message</span>
                            </div>
                            <label for="message"></label>
                            <textarea class="form-control" name="message" id="message" rows="2" cols="30"></textarea>
                        </div>
                        <div class="text-center mt-2">
                            <input type="submit" class="btn btn-info" value="Send">
                        </div>
                    </form>
                </div>
            </div>
        </div>


    <form action="chat" method="get">
        <div>
            <label for="startDate">Start date:</label>
            <input type="datetime-local" name= "start" id="startDate" >
        </div>
        <div>
            <label for="endDate">End date:</label>
            <input type="datetime-local" name = "end" id="endDate" >
        </div>
        <div>
            <input type="submit" value="Filter">
        </div>
        
    </form>
    </body>
</html>
