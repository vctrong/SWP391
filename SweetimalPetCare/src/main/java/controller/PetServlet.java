/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import daos.BreedDAO;
import daos.PetDAO;
import daos.SpeciesDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.Pet;
import model.PetBreed;
import model.PetSpecies;
import model.Users;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
@WebServlet(name = "PetServlet", urlPatterns = {"/pets"})
public class PetServlet extends HttpServlet {

    private final PetDAO petDAO = new PetDAO();
    private final SpeciesDAO speciesDAO = new SpeciesDAO();
    private final BreedDAO breedDAO = new BreedDAO();
    Users user = new Users();
    Pet pet = new Pet();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        user = getLoggedInUser(request, response);
        if (user == null) {
            return;
        }

        String action = request.getParameter("action");

// ✅ If no action but speciesId is present (means user changed species)
        if (action == null && request.getParameter("speciesId") != null) {
            action = "add";
        }
        try {
            if ("add".equalsIgnoreCase(action)) {
                List<PetSpecies> speciesList = speciesDAO.getAllSpecies();
                List<PetBreed> breedList;
                String speciesIdParam = request.getParameter("speciesId");
                if (speciesIdParam != null && !speciesIdParam.isEmpty()) {
                    int speciesId = Integer.parseInt(speciesIdParam);
                    breedList = breedDAO.getBreedsBySpecies(speciesId);
                } else {
                    breedList = breedDAO.getBreedsBySpecies(1); // default or empty list
                }
                request.setAttribute("speciesList", speciesList);
                request.setAttribute("breedList", breedList);
                request.getRequestDispatcher("/WEB-INF/pages/addpets.jsp").forward(request, response);
                return;
            }

            if ("edit".equalsIgnoreCase(action)) {
                showEditForm(request, response, user);
            } else {
                listPets(request, response, user);
            }
        } catch (Exception e) {
            throw new ServletException("Error in doGet", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users user = getLoggedInUser(request, response);
        if (user == null) {
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("add".equalsIgnoreCase(action)) {
                handleAdd(request, user);
            } else if ("update".equalsIgnoreCase(action)) {
                handleUpdate(request, user);
            } else if ("delete".equalsIgnoreCase(action)) {
                handleDelete(request, user);
            }
            response.sendRedirect(request.getContextPath() + "/pets");
        } catch (Exception e) {
            throw new ServletException("Error in doPost", e);
        }
    }

    // =============== Helpers ===============
    private Users getLoggedInUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
        }
        return user;
    }

    private void listPets(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception {
        List<Pet> pets = petDAO.getPetsByOwner(user.getId());
        List<PetSpecies> speciesList = speciesDAO.getAllSpecies();

        request.setAttribute("pets", pets);
        request.setAttribute("speciesList", speciesList);
        request.getRequestDispatcher("/WEB-INF/pages/pets.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception {
        long petId = Long.parseLong(request.getParameter("petId"));
        Pet pet = petDAO.getPetByIdAndOwner(petId, user.getId());

        // Always show all species
        List<PetSpecies> speciesList = speciesDAO.getAllSpecies();

        // If user changed species (reloaded form)
        String speciesIdStr = request.getParameter("speciesId");
        int speciesId;
        if (speciesIdStr != null && !speciesIdStr.isEmpty()) {
            speciesId = Integer.parseInt(speciesIdStr);
            pet.setSpeciesId(speciesId); // temporarily update species
        } else {
            speciesId = pet.getSpeciesId();
        }

        // Fetch corresponding breeds
        List<PetBreed> breedList = breedDAO.getBreedsBySpecies(speciesId);

        request.setAttribute("pet", pet);
        request.setAttribute("speciesList", speciesList);
        request.setAttribute("breedList", breedList);

        request.getRequestDispatcher("/WEB-INF/pages/editpets.jsp").forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, Users user) throws Exception {
        Pet p = buildPetFromRequest(request);
        p.setOwnerId(user.getId());
        petDAO.addPet(p);
    }

    private void handleUpdate(HttpServletRequest request, Users user) throws Exception {
        Pet p = buildPetFromRequest(request);
        p.setId((int) Long.parseLong(request.getParameter("petId")));
        p.setOwnerId(user.getId());
        petDAO.updatePet(p);
    }

    private void handleDelete(HttpServletRequest request, Users user) throws Exception {
        long petId = Long.parseLong(request.getParameter("petId"));
        petDAO.deletePet(petId, user.getId());
    }

    private Pet buildPetFromRequest(HttpServletRequest request) {
        Pet pet = new Pet(); // ✅ create a new pet instance

        String name = request.getParameter("name");
        int speciesId = Integer.parseInt(request.getParameter("speciesId"));

        // ✅ Breed may be optional
        String breedIdStr = request.getParameter("breedId");
        Integer breedId = null;
        if (breedIdStr != null && !breedIdStr.isEmpty()) {
            breedId = Integer.parseInt(breedIdStr);
        }

        String gender = request.getParameter("gender");

        String birthdateStr = request.getParameter("birthdate");
        LocalDate birthdate = (birthdateStr != null && !birthdateStr.isEmpty())
                ? LocalDate.parse(birthdateStr)
                : null;

        String weightStr = request.getParameter("weightKg");
        Double weight = (weightStr != null && !weightStr.isEmpty())
                ? Double.parseDouble(weightStr)
                : null;

        String color = request.getParameter("color");
        String notes = request.getParameter("notes");

        // ✅ assign values
        pet.setName(name);
        pet.setSpeciesId(speciesId);
        pet.setBreedId(breedId);
        pet.setGender(gender);
        pet.setBirthDate(birthdate);
        pet.setWeightKg(weight);
        pet.setColor(color);
        pet.setNotes(notes);

        System.out.println("Breed ID: " + breedId + ", Gender: " + gender + ", Weight: " + weight + ", Notes: " + notes);

        return pet;
    }

    @Override
    public String getServletInfo() {
        return "PetServlet - quản lý CRUD cho thú cưng";
    }
}
