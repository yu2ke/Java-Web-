package com.wyu.canteen.model;

/** 菜单中的菜品(快照) */
public class MenuItem {
    private int itemId;
    private int menuId;
    private String dishName;
    private String classify;
    private String photo;
    private String unit;
    private double price;

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public int getMenuId() { return menuId; }
    public void setMenuId(int menuId) { this.menuId = menuId; }
    public String getDishName() { return dishName; }
    public void setDishName(String dishName) { this.dishName = dishName; }
    public String getClassify() { return classify; }
    public void setClassify(String classify) { this.classify = classify; }
    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
