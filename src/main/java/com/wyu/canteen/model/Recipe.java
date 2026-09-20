package com.wyu.canteen.model;

/** 食谱中的菜品 */
public class Recipe {
    private int recipeId;
    private String name;
    private String classify;
    private String photo;
    private String unit;
    private double price;

    public int getRecipeId() { return recipeId; }
    public void setRecipeId(int recipeId) { this.recipeId = recipeId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getClassify() { return classify; }
    public void setClassify(String classify) { this.classify = classify; }
    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
