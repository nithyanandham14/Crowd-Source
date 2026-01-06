package com.Civic.Crowd_Source.Module;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int UserId;
    @Column(unique = true,nullable = false)
    private String userName;
    @Column(nullable = false)
    private String password;
    @Column(unique = true,nullable = false)
    private String mobileNumber;


}
