package com.sih.crowdsource.repository;

import com.sih.crowdsource.entity.Attachment;
import com.sih.crowdsource.entity.Complaint;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AttachmentRepository extends JpaRepository<Attachment, Long> {

    List<Attachment> findByComplaint(Complaint complaint);
}
