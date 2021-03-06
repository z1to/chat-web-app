import chat.ChatManager;
import chat.Message;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDateTime;
import java.util.LinkedList;

@WebServlet(name = "ChatServlet")
public class ChatServlet extends HttpServlet {
    private ChatManager chatManager;

    public void init(ServletConfig config) {
        chatManager = new ChatManager();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getHeader("referer") == null) {
            request.setAttribute("nonValidReferrerError", "true");
        }
        else {
            // Get session
            HttpSession session = request.getSession(true);

            // Initialize Message properties
            String message = request.getParameter("message");
            String user = request.getParameter("user");

            // Create new Message and save it
            Message newMessage = chatManager.postMessage(user, message);

            // If message parameter missing
            // NOTE: Could be improved by having a NoMessageError subclass of Message for better error handling
            String noMessageError = (newMessage == null) ? "true" : "false";

            // Update attributes
            session.setAttribute("userId", user);
            session.setAttribute("noMessageError", noMessageError);
            request.setAttribute("nonValidReferrerError", "false");
            LinkedList<Message> chat = chatManager.ListMessages(null, null);
            session.setAttribute("chat", chat);
        }

        response.sendRedirect("/chat_web_app_war/chat");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dateStart = request.getParameter("from");
        String dateEnd = request.getParameter("to");
        LocalDateTime start = null;
        LocalDateTime end = null;

        if (request.getHeader("referer") == null) {
            request.setAttribute("nonValidReferrerError", "true");
        } else {
            // Parse String into LocalDateTime
            if (dateStart != null && dateStart.length() > 0) {
                start = LocalDateTime.parse(dateStart);
            }
            if (dateEnd != null && dateEnd.length() > 0) {
                end = LocalDateTime.parse(dateEnd);
            }

            if (request.getParameter("format") != null && request.getParameter("format").equals("Download as TXT")) {
                response.setContentType("text/plain");
                response.setHeader("Content-Disposition", "attachment; filename=\"chat.txt\"");
                response.setHeader("Expires", String.valueOf(LocalDateTime.now().plusDays(1)));

                try {
                    OutputStream outputStream = response.getOutputStream();

                    for (Message message : chatManager.getChat()) {
                        String mStr = message.getUser() + " - " + message.getMessage() + " - " + message.getTimestamp() + "\n";
                        outputStream.write(mStr.getBytes());
                    }

                    outputStream.flush();
                    outputStream.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (request.getParameter("format") != null && request.getParameter("format").equals("Download as XML")) {
                response.setContentType("text/xml");
                response.setHeader("Content-Disposition", "attachment; filename=\"chat.xml\"");
                response.setHeader("Expires", String.valueOf(LocalDateTime.now().plusDays(1)));

                try {
                    OutputStream outputStream = response.getOutputStream();
                    String xmlHeading = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
                    outputStream.write(xmlHeading.getBytes());

                    for (Message message : chatManager.getChat()) {
                        String mStr = "<chat>\n" + "\t<user>"+ message.getUser() +
                                "</user>\n" + "\t<message>"+ message.getMessage() +
                                "</message>\n" + "\t<timestamp>"+ message.getTimestamp() +
                                "</timestamp>\n" + "</chat>\n";
                        outputStream.write(mStr.getBytes());
                    }

                    outputStream.flush();
                    outputStream.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }

            } else if (request.getParameter("delete") != null) {
                chatManager.clearChat(start, end);
            }

            request.setAttribute("nonValidReferrerError", "false");
        }

        LinkedList<Message> chat = chatManager.ListMessages(start, end);
        request.setAttribute("chat", chat);

        RequestDispatcher rd = request.getRequestDispatcher("Chat.jsp");
        rd.forward(request, response);
    }
}
