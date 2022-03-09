({
    handleMessage : function(component, event, helper) {

        //console.log('recieved published message in SideContainer');
        //console.log('event param: appStateMain is: ' + event.getParam("appStateMain"));
        //console.log('event param: appStateSide is: ' + event.getParam("appStateSide"));

        if(event.getParam('appStateSide')) // if our parameter from the message appStateSide is a value
        {
            // store it and evaluate what to change
            var appState = event.getParam('appStateSide');
            switch(appState)
            {
                case 'TwitterFeed':
                  component.set("v.isTwitter", true);
                  component.set("v.isDetails", false);
                  component.set("v.isNewsletter", false);
                break;
                case 'ProductDisplay': 
                  component.set("v.isTwitter", false);
                  component.set("v.isDetails", true);
                  component.set("v.isNewsletter", false);
                break;
                case 'Newsletter': 
                  component.set("v.isTwitter", false);
                  component.set("v.isDetails", false);
                  component.set("v.isNewsletter", true);
                break;
                default :                                   // if there is a value, but its not a valid value (currently not dynamic)
                  component.set("v.isTwitter", true);       // default to the twitter feed
                  component.set("v.isDetails", false);
                  component.set("v.isNewsletter", false);
            }
        }
    }
})