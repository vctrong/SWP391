/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos.admin;

import dto.ServiceForListPackageDTO;
import dto.serviceDTO;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.service.packageItem;
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

    public ArrayList<ServiceForListPackageDTO> getServiceForListPackage() {
        try {
            String qr = "select service_id, service_category_id, service_code, "
                    + "service_name, description, base_duration_min, current_price, status, created_at\n"
                    + "from services ";
            ArrayList<ServiceForListPackageDTO> temp = new ArrayList<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.add(new ServiceForListPackageDTO(rs.getLong(1), rs.getLong(2),
                        rs.getString(3), rs.getString(4), rs.getString(5), rs.getInt(6),
                        rs.getBigDecimal(7), rs.getString(8), rs.getDate(9)));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ArrayList<service> getServiceAdmin() {
        try {
            String qr = "select service_id as id, s.service_category_id, service_code as code, service_name as name, \n"
                    + "s.description, base_duration_min, current_price as price, status, created_at, sc.category_name, 'Service' as type\n"
                    + "from Services s \n"
                    + "join ServiceCategory sc on sc.service_category_id = s.service_category_id\n"
                    + "union all\n"
                    + "select sp.package_id as id, null as service_category_id, package_code as code, package_name as name,\n"
                    + "sp.description, coalesce(sum(s.base_duration_min*pi.quantity), 0) AS base_duration_min, package_price as price, sp.status, sp.created_at,\n"
                    + "'Package' as category_name, 'Package' as type\n"
                    + "from ServicePackage sp\n"
                    + "left join PackageItem pi on pi.package_id = sp.package_id\n"
                    + "left join Services s on pi.service_id = s.service_id\n"
                    + "GROUP BY sp.package_id, sp.package_code, sp.package_name, \n"
                    + "sp.description, sp.package_price, sp.status, sp.created_at";
            ArrayList<service> temp = new ArrayList<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.add(new service(rs.getLong(1), rs.getLong(2), rs.getString(3),
                        rs.getString(4), rs.getString(5), rs.getInt(6), rs.getBigDecimal(7),
                        rs.getString(8), rs.getDate(9), rs.getString(10), rs.getString(11)));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public servicePackage getPackageServiceByID(long id) {
        try {
            String qr = "select sp.package_id, package_code, package_name, "
                    + "sp.description, sp.status, package_price, sp.created_at, s.service_id, \n"
                    + "	s.service_name, pi.quantity, s.base_duration_min\n"
                    + "	from ServicePackage sp\n"
                    + "	left join PackageItem pi on pi.package_id = sp.package_id\n"
                    + "	left join Services s on pi.service_id = s.service_id\n"
                    + "	where sp.package_id = ?";
            servicePackage sp = null;
            PreparedStatement ps = getConnection().prepareStatement(qr);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                if (sp == null) {
                    sp = new servicePackage(rs.getLong(1), rs.getString(2),
                            rs.getString(3), rs.getString(4), rs.getString(5), rs.getBigDecimal(6), rs.getDate(7));
                    sp.setItem(new ArrayList<>());
                }
                serviceDTO item = new serviceDTO(rs.getLong(8), rs.getString(9), rs.getInt(10), rs.getInt(11));
                sp.getItem().add(item);
            }

            return sp;
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public service getServiceByID(long id) {
        try {
            String qr = "select service_id as id, s.service_category_id, service_code as code, service_name as name, \n"
                    + "s.description, base_duration_min, current_price as price, status, created_at, sc.category_name, 'Service' as type\n"
                    + "from Services s \n"
                    + "join ServiceCategory sc on sc.service_category_id = s.service_category_id\n"
                    + "where s.service_id = ?";
            Object[] params = {id};
            ResultSet rs = this.executeSelectQuery(qr, params);
            if (rs.next()) {
                return new service(rs.getLong(1), rs.getLong(2), rs.getString(3),
                        rs.getString(4), rs.getString(5), rs.getInt(6), rs.getBigDecimal(7),
                        rs.getString(8), rs.getDate(9), rs.getString(10), rs.getString(11));
            }
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
            ResultSet rs = this.executeSelectQuery(qr, params);
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return true;
    }

    public boolean exitsPackageCode(String code) {
        try {
            String qr = "SELECT COUNT(*) FROM ServicePackage WHERE package_code = ?";
            Object[] params = {code};
            ResultSet rs = this.executeSelectQuery(qr, params);
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return true;
    }

    public int createServiceCate(String cateName, String description) {
        try {
            String qr = "insert into ServiceCategory (category_name, description) values (?, ?)";
            Object[] params = {cateName, description};
            return this.executeQuery(qr, params);
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;

    }

    public int createServicePackage(String packagesCode, String name, String description, String status, BigDecimal price) {
        try {
            String qr = "insert into ServicePackage (package_code, package_name,"
                    + " description, status, package_price) values (?, ?, ?, ?, ?)";
            Object[] params = {packagesCode, name, description, status, price};
            return this.executeQuery(qr, params);
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int updateService(long cateID, String code, String name, String description,
            int duration, BigDecimal price, String status, long id) {
        try {
            String qr = "UPDATE Services\n"
                    + "SET\n"
                    + "    service_category_id = ?,\n"
                    + "    service_code = ?,\n"
                    + "    service_name = ?,\n"
                    + "    description = ?,\n"
                    + "    base_duration_min = ?,\n"
                    + "    current_price = ?,\n"
                    + "    status = ?\n"
                    + "WHERE service_id = ?;";
            Object[] params = {cateID, code, name, description, duration, price, status, id};
            return this.executeQuery(qr, params);
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int updatePackageService(long packageId, String name, BigDecimal price,
            String status, String description,
            List<packageItem> items) {
        Connection txConn = null;
        PreparedStatement ps = null;
        try {
            txConn = this.openNewConnection();
            txConn.setAutoCommit(false);
            String qrServicePackage = "UPDATE ServicePackage SET package_name = ?,\n"
                    + "package_price = ?, status = ?,\n"
                    + "description = ? WHERE package_id = ?";
            ps = txConn.prepareStatement(qrServicePackage);
            ps.setString(1, name);
            ps.setBigDecimal(2, price);
            ps.setString(3, status);
            ps.setString(4, description);
            ps.setLong(5, packageId);
            ps.executeUpdate();
            ps.close();

            String deletePackageItem = "DELETE FROM PackageItem WHERE package_id = ?";
            ps = txConn.prepareStatement(deletePackageItem);
            ps.setLong(1, packageId);
            ps.executeUpdate();
            ps.close();

            if (items != null && !items.isEmpty()) {
                String qrpackageItem = "INSERT INTO PackageItem (package_id, service_id, quantity) VALUES (?, ?, ?)";
                ps = txConn.prepareStatement(qrpackageItem);
                for (packageItem item : items) {
                    ps.setLong(1, item.getPackageId());
                    ps.setLong(2, item.getServiceId());
                    ps.setInt(3, item.getQuantity());
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            txConn.commit();
            return 1;
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
            if (txConn != null) {
                try {
                    txConn.rollback();
                } catch (SQLException e) {
                }
            }
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (txConn != null) {
                    txConn.close();
                }
            } catch (SQLException ex) {
            }
        }
        return 0;
    }

    public boolean checkBookingService(long id) {
        try {
            String qr = "SELECT TOP 1 1 \n"
                    + "FROM Booking AS B \n"
                    + "WHERE \n"
                    + "B.requested_date >= CAST(GETDATE() AS DATE) \n"
                    + "AND B.current_status IN ('PENDING', 'CONFIRMED', 'IN_PROGRESS') \n"
                    + "AND ( \n"
                    + "B.service_id = ?\n"
                    + "OR B.package_id IN (\n"
                    + "SELECT PI.package_id \n"
                    + "FROM PackageItem AS PI \n"
                    + "WHERE PI.service_id = ?\n"
                    + "));";
            Object[] param = {id, id};
            ResultSet rs = this.executeSelectQuery(qr, param);
            return rs.next();
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean checkBookingPackage(long id) {
        try {
            String qr = "select top 1 1 \n"
                    + "	from booking as b\n"
                    + "	where b.requested_date >= cast(GETDATE() as date)\n"
                    + "	and b.current_status in ('PENDING', 'CONFIRMED', 'IN_PROGRESS')\n"
                    + "	and b.package_id = ?";
            Object[] params = {id};
            ResultSet rs = this.executeSelectQuery(qr, params);
            return rs.next();
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public ArrayList<service> searchServices(String query, String filter) {
        try {
            ArrayList<service> temp = new ArrayList<>();
            String qr = "SELECT * FROM ( "
                    + "    select service_id as id, s.service_category_id, service_code as code, service_name as name, \n"
                    + "           s.description, base_duration_min, current_price as price, status, created_at, sc.category_name, 'Service' as type\n"
                    + "    from Services s \n"
                    + "    join ServiceCategory sc on sc.service_category_id = s.service_category_id\n"
                    + "    \n"
                    + "    union all\n"
                    + "    \n"
                    + "    select sp.package_id as id, null as service_category_id, package_code as code, package_name as name,\n"
                    + "           sp.description, coalesce(sum(s.base_duration_min*pi.quantity), 0) AS base_duration_min, package_price as price, sp.status, sp.created_at,\n"
                    + "           'Package' as category_name, 'Package' as type\n"
                    + "    from ServicePackage sp\n"
                    + "    left join PackageItem pi on pi.package_id = sp.package_id\n"
                    + "    left join Services s on pi.service_id = s.service_id\n"
                    + "    GROUP BY sp.package_id, sp.package_code, sp.package_name, \n"
                    + "             sp.description, sp.package_price, sp.status, sp.created_at\n"
                    + ") AS AllServices \n"
                    + "WHERE (AllServices.name LIKE ? OR AllServices.code LIKE ?) \n"
                    + "AND AllServices.type LIKE ?";
            String search = "%" + query + "%";
            String filterP = "all".equalsIgnoreCase(filter) ? "%%" : filter;
            Object[] params = {search, search, filterP};
            ResultSet rs = this.executeSelectQuery(qr, params);
            while (rs.next()) {
                temp.add(new service(rs.getLong(1), rs.getLong(2), rs.getString(3),
                        rs.getString(4), rs.getString(5), rs.getInt(6), rs.getBigDecimal(7),
                        rs.getString(8), rs.getDate(9), rs.getString(10), rs.getString(11)));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

}
