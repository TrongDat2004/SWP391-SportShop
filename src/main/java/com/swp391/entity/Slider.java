/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.entity;

import java.sql.Timestamp;

/**
 *
 * @author $ LienXuanThinh - CE182117
 */
public class Slider {

    private int bannerId;
    private String name;
    private String imageUrl;
    private Integer productId;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Slider() {
        
    }

    public Slider(int bannerId, String name, String imageUrl, Integer productId, boolean status) {
        this.bannerId = bannerId;
        this.name = name;
        this.imageUrl = imageUrl;
        this.productId = productId;
        this.status = status;
    }

    public int getBannerId() {
        return bannerId;
    }

    public void setBannerId(int bannerId) {
        this.bannerId = bannerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

}
