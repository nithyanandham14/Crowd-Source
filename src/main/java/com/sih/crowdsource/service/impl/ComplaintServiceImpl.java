package com.sih.crowdsource.service.impl;

import com.sih.crowdsource.dto.request.ComplaintRequest;
import com.sih.crowdsource.dto.request.StatusUpdateRequest;
import com.sih.crowdsource.dto.response.ComplaintResponse;
import com.sih.crowdsource.entity.Complaint;
import com.sih.crowdsource.entity.Department;
import com.sih.crowdsource.entity.User;
import com.sih.crowdsource.enums.ComplaintState;
import com.sih.crowdsource.mapper.ComplaintMapper;
import com.sih.crowdsource.repository.ComplaintRepository;
import com.sih.crowdsource.repository.DepartmentRepository;
import com.sih.crowdsource.repository.UserRepository;
import com.sih.crowdsource.service.ComplaintService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ComplaintServiceImpl implements ComplaintService {

    private final ComplaintRepository complaintRepository;
    private final UserRepository userRepository;
    private final DepartmentRepository departmentRepository;

    @Override
    public ComplaintResponse createComplaint(ComplaintRequest request, String userEmail) {

        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Department department = departmentRepository.findById(request.getDepartmentId())
                .orElseThrow(() -> new RuntimeException("Department not found"));

        Complaint complaint = Complaint.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .location(request.getLocation())
                .status(ComplaintState.OPEN)
                .createdAt(LocalDateTime.now())
                .createdBy(user)
                .department(department)
                .build();

        return ComplaintMapper.toComplaintResponse(
                complaintRepository.save(complaint)
        );
    }

    @Override
    public ComplaintResponse updateStatus(Long complaintId, StatusUpdateRequest request) {

        Complaint complaint = complaintRepository.findById(complaintId)
                .orElseThrow(() -> new RuntimeException("Complaint not found"));

        complaint.setStatus(request.getStatus());

        return ComplaintMapper.toComplaintResponse(
                complaintRepository.save(complaint)
        );
    }

    @Override
    public List<ComplaintResponse> getComplaintsByUser(String userEmail) {

        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return complaintRepository.findByCreatedBy(user)
                .stream()
                .map(ComplaintMapper::toComplaintResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<ComplaintResponse> getAllComplaints() {
        return complaintRepository.findAll()
                .stream()
                .map(ComplaintMapper::toComplaintResponse)
                .collect(Collectors.toList());
    }
}
