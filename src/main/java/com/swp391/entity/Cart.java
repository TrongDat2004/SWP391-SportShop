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
public class Cart { // Đổi tên class từ CartItem nếu cần, nhưng Cart có vẻ đúng hơn cho 1 entry

    private Integer cartEntryId;
    private Integer userId;
    private Integer productId;
    private Integer productSizeId; // <<< THÊM: ID của size sản phẩm trong giỏ
    private Integer quantity;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Quan hệ
    private Product product;
    private ProductSize productSize; // <<< THÊM: Thông tin size cụ thể (tùy chọn)
}
