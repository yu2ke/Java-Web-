package com.wyu.canteen.model;

/** 系统用户(员工) */
public class User {
    private int userId;
    private String username;
    private String realName;
    private String phone;
    private String workstation;
    private int roleId;
    private String roleName;
    private String deptName;
    private boolean active = true;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getRealName() { return realName; }
    public void setRealName(String realName) { this.realName = realName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getWorkstation() { return workstation; }
    public void setWorkstation(String workstation) { this.workstation = workstation; }
    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    /** 餐厅经理(角色1) 视为管理员 */
    public boolean isManager() { return roleId == 1; }
}
