/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.entity;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderItem {

    private Integer orderItemId;
    private Integer orderId;
    private Integer productId;
    private Integer productSizeId; // <<< THÊM: ID của size sản phẩm được đặt
    private Integer quantity;
    private BigDecimal price; // Giá tại thời điểm đặt hàng
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Quan hệ
    private Product product;
    private ProductSize productSize; // <<< THÊM: Thông tin size cụ thể (tùy chọn, có thể lấy qua productSizeId)
}
