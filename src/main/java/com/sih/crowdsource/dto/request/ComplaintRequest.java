package com.sih.crowdsource.dto.request;

import com.sih.crowdsource.enums.ComplaintPriority;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ComplaintRequest {

    private String title;
    private String description;
    private String location;
    private ComplaintPriority priority;
    private Long departmentId;
}
