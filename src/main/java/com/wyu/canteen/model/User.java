package com.wyu.canteen.model;

import java.util.Map;

/** 系统用户(员工) */
public class User {

    /**
     * 各功能路径允许访问的角色 ID。
     * 前缀更长者优先(如 /order/list 先于 /order)；未列入的路径对所有已登录用户开放。
     * 菜单显示和 LoginFilter 的权限校验共用这张表。
     */
    private static final Map<String, int[]> ACCESS = Map.ofEntries(
            Map.entry("/recipe", new int[]{1, 2}),
            Map.entry("/menu", new int[]{1, 2}),
            Map.entry("/order/list", new int[]{1, 2, 3}),
            Map.entry("/order", new int[]{1, 2, 3, 4, 5}),
            Map.entry("/blanket", new int[]{1, 2}),
            Map.entry("/pack", new int[]{1, 2, 3}),
            Map.entry("/stats", new int[]{1, 4, 5}),
            Map.entry("/stats/all", new int[]{1, 4}),   // 虚拟路径：全公司统计内容，仅经理与财务可见
            Map.entry("/export", new int[]{1, 4, 5}),
            Map.entry("/user", new int[]{1}),
            Map.entry("/config", new int[]{1}));

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

    /** 当前用户能否访问该路径 */
    public boolean canAccess(String path) {
        String matched = null;
        for (String key : ACCESS.keySet()) {
            if ((path.equals(key) || path.startsWith(key + "/"))
                    && (matched == null || key.length() > matched.length())) {
                matched = key;
            }
        }
        if (matched == null) return true;
        for (int role : ACCESS.get(matched)) {
            if (role == roleId) return true;
        }
        return false;
    }
}
