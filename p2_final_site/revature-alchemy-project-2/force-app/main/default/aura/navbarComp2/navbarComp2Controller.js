({
    // called whenever the search bar's button fires a doSearch event
    handleSearch : function(component, event, helper) {

        //console.log('recieved Search Event in navbarComp2');
        //console.log('searchKey is: ' + event.getParam("searchKey"));
        
        // take the input value from the fired doSearch event, and publish it along with an appState change
        const payload = {
            searchKey: event.getParam("searchKey"),
            appStateMain: 'Catalogue'
        };

        component.find("BigBrotherAppChannel").publish(payload);
    },

    // called whenever a nav button fires a navButtonEvent event
    handleNavChange : function(component, event, helper) {

        //console.log('recieved Nav Button event in navbarComp2');
        //console.log('button State is: ' + event.getParam("buttonState"));

        // take the button state passed by event and store it
        var btnState = event.getParam("buttonState");

        const payload = {
            appStateMain: null,
            appStateSide: null
        };

        if(btnState === "TwitterFeed" || btnState === "Newsletter")
        {
            payload.appStateSide = btnState;
        }
        else
        {
            payload.appStateMain = btnState;
        }
        
        component.find("BigBrotherAppChannel").publish(payload);
    }
})