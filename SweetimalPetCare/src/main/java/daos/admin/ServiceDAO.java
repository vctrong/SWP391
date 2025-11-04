/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos.admin;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.service.serviceCate;
import model.service.service;
import model.service.servicePackage;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class ServiceDAO extends db.DBContext {

    public ArrayList<serviceCate> getServiceCate() {
        try {
            String qr = "select  service_category_id, category_name, description\n"
                    + "from ServiceCategory";

            ArrayList<serviceCate> temp = new ArrayList<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.add(new serviceCate(rs.getLong(1), rs.getString(2), rs.getString(3)));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ArrayList<service> getServiceAdmin() {
        try {
            String qr = "select service_id, s.service_category_id, service_code, service_name,\n"
                    + "s.description, base_duration_min, current_price, status, created_at, sc.category_name\n"
                    + "from Services s \n"
                    + "join ServiceCategory sc on sc.service_category_id = s.service_category_id;";
            ArrayList<service> temp = new ArrayList<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.add(new service(rs.getLong(1), rs.getLong(2), rs.getString(3),
                        rs.getString(4), rs.getString(5), rs.getInt(6), rs.getBigDecimal(7),
                        rs.getString(8), rs.getDate(9), rs.getString(10)));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ArrayList<servicePackage> getPackageService() {
        try {
            String qr = "select package_id, package_code, package_name, description, status, package_price, created_at\n"
                    + "from ServicePackage";
            ArrayList<servicePackage> temp = new ArrayList<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.add(new servicePackage(rs.getLong(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getBigDecimal(6), rs.getDate(7)));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public int createService(long serviceCateID, String code, String name,
            String description, int duration, BigDecimal price, String status) {
        try {
            String qr = "insert into Services (service_category_id, service_code, service_name, description,\n"
                    + "base_duration_min, current_price, status) values (?, ?, ?, ?, ?, ?, ?);";
            Object[] params = {serviceCateID, code, name, description, duration, price, status};
            return this.executeQuery(qr, params);
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public boolean exitsServiceCode(String code) {
        try {
            String qr = "SELECT COUNT(*) FROM Services WHERE service_code = ?";
            Object[] params = {code};
            return this.executeQuery(qr, params) > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

}
