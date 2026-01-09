package com.sih.crowdsource.controller;

import com.sih.crowdsource.dto.request.ComplaintRequest;
import com.sih.crowdsource.dto.request.StatusUpdateRequest;
import com.sih.crowdsource.dto.response.ComplaintResponse;
import com.sih.crowdsource.service.ComplaintService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/complaints")
@RequiredArgsConstructor
public class ComplaintController {

    private final ComplaintService complaintService;

    @PostMapping
    public ResponseEntity<ComplaintResponse> createComplaint(
            @RequestBody ComplaintRequest request,
            Authentication authentication) {

        return ResponseEntity.ok(
                complaintService.createComplaint(
                        request,
                        authentication.getName()
                )
        );
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<ComplaintResponse> updateStatus(
            @PathVariable Long id,
            @RequestBody StatusUpdateRequest request) {

        return ResponseEntity.ok(
                complaintService.updateStatus(id, request)
        );
    }

    @GetMapping("/my")
    public ResponseEntity<List<ComplaintResponse>> myComplaints(
            Authentication authentication) {

        return ResponseEntity.ok(
                complaintService.getComplaintsByUser(
                        authentication.getName()
                )
        );
    }

    @GetMapping
    public ResponseEntity<List<ComplaintResponse>> allComplaints() {
        return ResponseEntity.ok(
                complaintService.getAllComplaints()
        );
    }
}
