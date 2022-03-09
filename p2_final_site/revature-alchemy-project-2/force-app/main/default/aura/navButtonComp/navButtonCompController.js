({
    buttonClickJS: function(component, event, helper) {
        var myEvent = component.getEvent("doButtonEvent");
        myEvent.setParams({"buttonState":event.target.value});
        //console.log(event.target.value);
        //console.log('event param is: ' + myEvent.getParam("buttonState"));
        console.log('firing event from navButtonComp');
        myEvent.fire();
    }    
})