package com.swp391.entity;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Order {
    private Integer orderId;
    private Integer userId;
    private String status; // pending, accepted, cancelled, completed
    private BigDecimal total;
    private String shippingAddress;
    private String paymentMethod;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String email;
    private String fullname;
    private String phone;
}
