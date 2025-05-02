/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.entity;

import lombok.*;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductSize {
    private Integer productSizeId;
    private Integer productId;
    private String size; 
    private Integer stock;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}