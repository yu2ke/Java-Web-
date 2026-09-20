package com.wyu.canteen.model;

/** 菜单 */
public class Menu {
    private int menuId;
    private String menuName;
    private boolean current;

    public int getMenuId() { return menuId; }
    public void setMenuId(int menuId) { this.menuId = menuId; }
    public String getMenuName() { return menuName; }
    public void setMenuName(String menuName) { this.menuName = menuName; }
    public boolean isCurrent() { return current; }
    public void setCurrent(boolean current) { this.current = current; }
}
