package com.Civic.Crowd_Source.Module;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Admin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int Id;
    @Column(nullable = false)
    private String adminName;

    @Column(nullable = false)
    private String state;

    @Column(nullable = false)
    private String district;

    @Column(nullable = false)
    private String department;

    @Column(nullable = false)
    private String password;

}
