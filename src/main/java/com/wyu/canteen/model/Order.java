package com.wyu.canteen.model;

import java.util.ArrayList;
import java.util.List;

/** 订单 */
public class Order {
    private int orderId;
    private int userId;
    private String realName;
    private String phone;
    private String workstation;
    private String orderDate;
    private String orderTime;
    private double totalPrice;
    private String status;
    private List<OrderItem> items = new ArrayList<>();

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getRealName() { return realName; }
    public void setRealName(String realName) { this.realName = realName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getWorkstation() { return workstation; }
    public void setWorkstation(String workstation) { this.workstation = workstation; }
    public String getOrderDate() { return orderDate; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }
    public String getOrderTime() { return orderTime; }
    public void setOrderTime(String orderTime) { this.orderTime = orderTime; }
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
}
