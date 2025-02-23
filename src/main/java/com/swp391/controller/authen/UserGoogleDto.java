package com.swp391.controller.authen;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserGoogleDto {

    private String id;

    private String email;

    private boolean verified_email;

    private String name;

    private String given_name;

    private String family_name;

    private String picture;

}
