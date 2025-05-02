/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.entity;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List; // Thêm import

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Product {

    private Integer productId;
    private Integer categoryId;
    private String name;
    private String description;
    private BigDecimal price;
    // private Integer stock; // <<< BỎ Thuộc tính này
    private String image;
    private Boolean status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Quan hệ với Category và ProductSize
    private Category category;
    private List<ProductSize> sizes; // <<< THÊM: Danh sách các size của sản phẩm

    // Getters và Setters (Lombok @Data đã xử lý, nhưng để rõ ràng bạn có thể giữ lại)
    // Bỏ getter/setter cho stock
    // Thêm getter/setter cho sizes
    public List<ProductSize> getSizes() {
        return sizes;
    }

    public void setSizes(List<ProductSize> sizes) {
        this.sizes = sizes;
    }
    // Các getter/setter khác giữ nguyên...

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    // public Integer getStock() { return stock; } << BỎ
    // public void setStock(Integer stock) { this.stock = stock; } << BỎ

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
}
