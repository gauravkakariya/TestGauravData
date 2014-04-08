trigger PartnerEntityShareWithChannelManager on Account (after update) 
{
 PartnerEntityShare objPartnerEntityShare = new PartnerEntityShare();
 
 if(Trigger.isAfter && Trigger.isUpdate)
 {
     //Share Business partner entities with Channel manger of Entity(Gold partenr license holder Manager)
     //objPartnerEntityShare.onAfterUpdate(Trigger.new);
 } 
}