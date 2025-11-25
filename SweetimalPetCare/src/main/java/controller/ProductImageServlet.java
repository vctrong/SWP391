/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;

/**
 * 
 * @author Pham Nguyen Xuan Mai - CE190106
 */
@WebServlet(name="ProductImageServlet", urlPatterns={"/uploads/*", "/images/*"})
public class ProductImageServlet extends HttpServlet {
    private static final String IMAGE_DIR = "D:/SWP391_project/SWP391/products_img";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Resolve requested file path in a robust, platform-independent way
        // We prefer to use request.getPathInfo() because the servlet is mapped to "/images/*" and "/uploads/*"
        String requestedPath = request.getPathInfo(); // expected e.g. /ganadorchickern.jpg
        if (requestedPath == null || requestedPath.trim().isEmpty() || "/".equals(requestedPath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Normalize: remove any leading slashes so File(parent, child) treats child as relative to parent.
        String relativePath = requestedPath.replaceAll("^/+", "");

        // Security: reject obvious path traversal attempts
        if (relativePath.contains("..") || relativePath.contains("../") || relativePath.contains("..\\")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        File file = new File(IMAGE_DIR, relativePath);

        // If file not found or not readable, add a debug header and return 404 with small text
        if (!file.exists() || file.isDirectory() || !file.canRead()) {
            // Avoid exposing server file system paths or printing them to stdout in production.
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.setContentType("text/plain; charset=UTF-8");
            String body = "Image not found.";
            response.setContentLength(body.getBytes("UTF-8").length);
            try (OutputStream out = response.getOutputStream()) {
                out.write(body.getBytes("UTF-8"));
            }
            return;
        }

        // Try to determine mime type; fall back to Files.probeContentType and finally to octet-stream
        String mime = getServletContext().getMimeType(file.getName());
        if (mime == null) {
            try {
                mime = java.nio.file.Files.probeContentType(file.toPath());
            } catch (IOException ex) {
                mime = null;
            }
        }
        if (mime == null) mime = "application/octet-stream";

        // Set caching headers so browsers can reuse images between navigations.
        // Public cache for 7 days (adjust if you prefer shorter TTL during development).
        response.setHeader("Cache-Control", "public, max-age=604800");
        response.setDateHeader("Expires", System.currentTimeMillis() + 604800L * 1000L);
        response.setDateHeader("Last-Modified", file.lastModified());
        response.setContentType(mime);
        response.setContentLengthLong(file.length());

        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
