package com.sih.crowdsource.service;

import com.sih.crowdsource.dto.request.ComplaintRequest;
import com.sih.crowdsource.dto.request.StatusUpdateRequest;
import com.sih.crowdsource.dto.response.ComplaintResponse;

import java.util.List;

public interface ComplaintService {

    ComplaintResponse createComplaint(ComplaintRequest request, String userEmail);

    ComplaintResponse updateStatus(Long complaintId, StatusUpdateRequest request);

    List<ComplaintResponse> getComplaintsByUser(String userEmail);

    List<ComplaintResponse> getAllComplaints();
}
