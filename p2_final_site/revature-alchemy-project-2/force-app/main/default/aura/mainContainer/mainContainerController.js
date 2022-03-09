({
    handleMessage : function(component, event, helper) {

        //console.log('recieved published message in mainContainer');
        //console.log('event param: appStateMain is: ' + event.getParam("appStateMain"));
        //console.log('event param: appStateSide is: ' + event.getParam("appStateSide"));
            
        if(event.getParam('orderId'))
        {
            console.log('order Id received from payload');
            var currentOrderId = event.getParam('orderId');
            component.set("v.orderId", currentOrderId);
        }

        if(event.getParam('appStateMain'))
        {

            var appState = event.getParam('appStateMain');
            switch(appState)
            {
                case 'HomePage': 
                component.set("v.isHome", true);
                component.set("v.isCatalogue", false);
                component.set("v.isCart", false);
                break;

                case 'Catalogue':
                component.set("v.isHome", false);
                component.set("v.isCatalogue", true);
                component.set("v.isCart", false);
                break;

                case 'DisplayCart': 
                //component.set("v.orderId", 'a028c00000WAqWFAA1');
                component.set("v.isHome", false);
                component.set("v.isCatalogue", false);
                component.set("v.isCart", true);
                break;
            }
        }
    },
})