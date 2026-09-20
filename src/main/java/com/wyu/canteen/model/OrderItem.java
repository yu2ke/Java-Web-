package com.wyu.canteen.model;

/** 订单明细(快照) */
public class OrderItem {
    private String dishName;
    private String unit;
    private double quantity;
    private double price;
    private double amount;

    public String getDishName() { return dishName; }
    public void setDishName(String dishName) { this.dishName = dishName; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public double getQuantity() { return quantity; }
    public void setQuantity(double quantity) { this.quantity = quantity; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
}
