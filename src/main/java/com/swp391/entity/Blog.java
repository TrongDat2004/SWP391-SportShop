/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.entity;

import lombok.*;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Blog {

    private int blogId;
    private String title;
    private String content;
    private int authorId;
    private String status;
    private Date createdAt;
    private Date updatedAt;
    private String image;
}
