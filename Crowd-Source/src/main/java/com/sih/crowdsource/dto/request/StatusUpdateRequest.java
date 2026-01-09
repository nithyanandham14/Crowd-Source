package com.sih.crowdsource.dto.request;

import com.sih.crowdsource.enums.ComplaintState;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StatusUpdateRequest {

    private ComplaintState status;
}
