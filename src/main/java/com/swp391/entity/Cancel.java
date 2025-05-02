package com.swp391.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Cancel {

    private Integer cancelId;
    private Integer orderId;
    private Integer userId;
    private String cancelledBy;
    private String cancelReason;
    private String status;
    private BigDecimal total;
    private String shippingAddress;
    private String paymentMethod;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String email;
    private String fullname;
    private String phone;

}