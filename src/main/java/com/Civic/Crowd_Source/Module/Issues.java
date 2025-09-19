package com.Civic.Crowd_Source.Module;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Issues {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int IssuesNo;
    private String reporter;
    private String Description;
    private String Address;
    private String status;
    private String Title;
    private LocalDate Stdate;

    //Variable to Store the multimedia
//    private MultipartFile voiceMsg;
//    private MultipartFile video;
//    private MultipartFile image;

    //MultimediaPath
    private String imagePath;
    private String voiceMsgPath;
    private String videoPath;

    //variable to Store the Location Details
    private Double latitude;
    private Double longitude;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

}
