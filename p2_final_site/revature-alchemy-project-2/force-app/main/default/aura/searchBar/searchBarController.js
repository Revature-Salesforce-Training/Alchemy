({
    doSearchJS: function(component, event, helper) {
        var myEvent = component.getEvent("doSearchEvent");          // component has registered event called doSearchevent. want to grab and store
        var myInput= component.find('searchInput').getElement();    // our textbox, find it via aura id and store the DOM element itself. 
        myEvent.setParams({"searchKey": myInput.value});            // set the event's attribute to our input value
        //console.log('inside SearchBarController searchKey is: ');
        //console.log(myEvent.getParam('searchKey'));
        
        // fire the event
        myEvent.fire();
        //console.log(myInput);
    }
})