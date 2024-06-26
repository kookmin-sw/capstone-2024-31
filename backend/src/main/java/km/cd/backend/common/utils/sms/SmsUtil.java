package km.cd.backend.common.utils.sms;

import jakarta.annotation.PostConstruct;
import km.cd.backend.challenge.domain.Participant;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class SmsUtil {
    
    @Value("${coolsms.api.key}")
    private String apiKey;
    
    @Value("${coolsms.api.secret}")
    private String apiSecretKey;
    
    @Value("${coolsms.caller}")
    private String caller;
    private DefaultMessageService messageService;
    
    @PostConstruct
    private void init(){
        this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecretKey, "https://api.coolsms.co.kr");
    }
    
    public SingleMessageSentResponse sendCertificateSMS(String to, String verificationCode) {
        Message message = new Message();
        
        message.setFrom(caller);
        message.setTo(to.replaceAll("-",""));
        message.setText("[루틴업]\n아래의 인증번호를 입력해주세요\n" + verificationCode);
        
        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
        return response;
    }
    
    public SingleMessageSentResponse sendResult(Participant participant, String challengeName, String userName, boolean isSuccess) {
        Message message = new Message();
        message.setFrom(caller);
        message.setTo(participant.getReceiverNumber());
        
        if (isSuccess) {
            message.setText(ResultMessage.getSuccessMessage(challengeName, participant.getTargetName(), userName, participant.getDetermination()));
        } else {
            message.setText(ResultMessage.getFailureMessage(challengeName, participant.getTargetName(), userName, participant.getDetermination()));
        }
        
        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
        return response;
    }
    
    
}
