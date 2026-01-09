package com.sih.crowdsource.mapper;

import com.sih.crowdsource.dto.response.ComplaintResponse;
import com.sih.crowdsource.entity.Complaint;

public class ComplaintMapper {

    private ComplaintMapper() {
        // prevent object creation
    }

    public static ComplaintResponse toComplaintResponse(Complaint complaint) {
        if (complaint == null) {
            return null;
        }

        return ComplaintResponse.builder()
                .id(complaint.getId())
                .title(complaint.getTitle())
                .description(complaint.getDescription())
                .location(complaint.getLocation())
                .status(complaint.getStatus())
                .createdAt(complaint.getCreatedAt())
                .departmentName(
                        complaint.getDepartment() != null
                                ? complaint.getDepartment().getName()
                                : null
                )
                .build();
    }
}
