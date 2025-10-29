package controller;

import daos.NewsDAO;
import daos.NewsDAO.Source;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.NewsItem;

@WebServlet(name = "newsServlet", urlPatterns = {"/news"})
public class newsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String source = "petcarevn";
        int pageSize = 8; 
        int totalFetch = 20; 

        String pageStr = request.getParameter("page");
        int page = 1;
        try { if (pageStr != null) page = Math.max(1, Integer.parseInt(pageStr)); } catch (NumberFormatException ignored) {}

        NewsDAO dao = new NewsDAO();
        List<NewsItem> all = dao.getNews(source, null, totalFetch);

        int totalItems = all.size();
        int totalPages = (int) Math.ceil(totalItems / (double) pageSize);
        // If user requests an invalid page (<=0 or > totalPages), default to page 1
        if (totalPages <= 0) {
            page = 1;
        } else if (page < 1 || page > totalPages) {
            page = 1;
        }

        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<NewsItem> items = new java.util.ArrayList<NewsItem>();
        if (fromIndex < toIndex) items = all.subList(fromIndex, toIndex);

        request.setAttribute("items", items);
        request.setAttribute("activeSource", source);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalItems", totalItems);
        request.getRequestDispatcher("WEB-INF/pages/news.jsp").forward(request, response);
    }
}
